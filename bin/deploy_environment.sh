#!/usr/bin/env bash

echo "Starting deployment"

# This is to prevent path mangling in Windows. It should have no effect on Linux or Mac.
# https://stackoverflow.com/questions/7250130/how-to-stop-mingw-and-msys-from-mangling-path-names-given-at-the-command-line
export MSYS_NO_PATHCONV=1

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )"

DEPLOYMENT_DIR="${PROJECT_DIR}/deployment/"

if [ -z "${AWS_ACCOUNT_ID}" ]; then
    echo "You must set the AWS_ACCOUNT_ID environment variable."
    exit 0;
fi

if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
    echo "You must set the AWS_ACCESS_KEY_ID environment variable."
    exit 0;
fi

if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
    echo "You must set the AWS_SECRET_ACCESS_KEY environment variable."
    exit 0;
fi

if [ -z "${APPLICATION_NAME}" ]; then
    echo "You must set the APPLICATION_NAME environment variable."
    exit 0;
fi

if [ -z "${ENVIRONMENT_NAME}" ]; then
    echo "WARNING: You have not set the ENVIRONMENT_NAME environment variable. Defaulting to dev."
    ENVIRONMENT_NAME=dev
fi

if [ -z "${DOCKER_USERNAME}" ]; then
    echo "You must set the DOCKER_USERNAME environment variable."
    exit 0;
fi

if [ -z "${DOCKER_PASSWORD}" ]; then
    echo "You must set the DOCKER_PASSWORD environment variable."
    exit 0;
fi

if [ -z "${LOGS_BUCKET}" ]; then
    echo "You must set the LOGS_BUCKET environment variable."
    exit 0;
fi

if [ -z "${LOGGLY_TOKEN}" ]; then
    echo "WARNING: You have not set the LOGGLY_TOKEN environment variable. Logging to Loggly isn't going to work."
fi

function get_or_create_key_pair {
    # Generate a key pair. We need this file inside the Docker AMI so we can't generate it in
    # the Terraform deployment.
    KEY_PAIR_NAME="${APPLICATION_NAME}_${ENVIRONMENT_NAME}"
    PRIVATE_KEY="${PROJECT_DIR}/deployment/.terraform/${KEY_PAIR_NAME}"

    echo "Checking AWS parameter store for Docker private key"

    docker run \
        -v "${PROJECT_DIR}:/app/" \
        -w /app/deployment/.terraform/ \
        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
        -it cgswong/aws aws ssm get-parameter \
            --region us-east-1 \
            --name /${APPLICATION_NAME}/${ENVIRONMENT_NAME}/swarm/admin/private_key \
            --with-decryption \
            --query "Parameter.Value" \
            --output text \
            > ${PRIVATE_KEY}

    if grep -q ParameterNotFound "$PRIVATE_KEY"; then
        echo "Private key not found. Generating a new key pair"
        rm ${PRIVATE_KEY}
        ssh-keygen -t rsa -f ${PRIVATE_KEY} -N ''

        echo "Key pair generated. Registering $KEY_PAIR_NAME with AWS"

        docker run \
            -v "${PROJECT_DIR}:/app/" \
            -w /app/deployment/.terraform/ \
            -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
            -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
            -it cgswong/aws aws ec2 import-key-pair \
                --region us-east-1 \
                --key-name "${KEY_PAIR_NAME}" \
                --public-key-material file:///app/deployment/.terraform/${KEY_PAIR_NAME}.pub

        echo "Key pair $KEY_PAIR_NAME registered with AWS. Saving to AWS parameter store"

        docker run \
            -v "${PROJECT_DIR}:/app/" \
            -w /app/deployment/.terraform/ \
            -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
            -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
            -it cgswong/aws aws ssm put-parameter \
                --region us-east-1 \
                --name /${APPLICATION_NAME}/${ENVIRONMENT_NAME}/swarm/admin/private_key \
                --type SecureString \
                --value "$(< ${PRIVATE_KEY})"

        echo "Key pair $KEY_PAIR_NAME saved to /${APPLICATION_NAME}/${ENVIRONMENT_NAME}/swarm/admin/private_key"
    else
        echo "Private key found"
    fi
}

function create_s3_bucket {
    BUCKET_EXISTS=$(docker run \
        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
        -it cgswong/aws aws s3api head-bucket \
            --region us-east-1 \
            --bucket ${LOGS_BUCKET})

    if [ -z "${BUCKET_EXISTS}" ]; then
        echo "Bucket ${LOGS_BUCKET} already exists"
    else
        echo "Bucket ${LOGS_BUCKET} does not exist. Creating."

        docker run \
            -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
            -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
            -it cgswong/aws aws s3api create-bucket \
                --region us-east-1 \
                --acl private \
                --bucket ${LOGS_BUCKET}

        echo "Bucket ${LOGS_BUCKET} created."
    fi
}

function build_bastion_ami {
    echo "Building bastion AMI"
    docker run \
        -v "${PROJECT_DIR}:/app/" \
        -w /app/deployment/ \
        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
        -e APPLICATION_NAME=${APPLICATION_NAME} \
        -e LOGGLY_TOKEN=${LOGGLY_TOKEN} \
        -it hashicorp/packer:light build bastion.json
}

function build_docker_ami {
    echo "Building Docker AMI"
    docker run \
        -v "$PROJECT_DIR:/app/" \
        -w /app/deployment/ \
        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
        -e APPLICATION_NAME=${APPLICATION_NAME} \
        -e LOGGLY_TOKEN=${LOGGLY_TOKEN} \
        -e SWARM_KEY=${KEY_PAIR_NAME} \
        -it hashicorp/packer:light build docker.json
}

function apply_terraform {
    echo "Applying Terraform"
    docker run \
        -v "$PROJECT_DIR:/app/" \
        -w /app/deployment/ \
        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
        -it hashicorp/terraform:light init \
            -backend-config="bucket=$LOGS_BUCKET" \
            -backend-config="key=$APPLICATION_NAME/$ENVIRONMENT_NAME/terraform.tfstate" \
            -backend-config="region=us-east-1"

    TERRAFORM_STATE=".terraform/${ENVIRONMENT_NAME}.tfstate"
    echo "Terraform state saved in $TERRAFORM_STATE"

    docker run \
        -v "$PROJECT_DIR:/app/" \
        -w /app/deployment/ \
        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
        -e TF_VAR_aws_account_id=${AWS_ACCOUNT_ID} \
        -e TF_VAR_application_name=${APPLICATION_NAME} \
        -e TF_VAR_environment_name=${ENVIRONMENT_NAME} \
        -e TF_VAR_key_name=${KEY_PAIR_NAME} \
        -e TF_VAR_docker_username=${DOCKER_USERNAME} \
        -e TF_VAR_docker_password=${DOCKER_PASSWORD} \
        -e TF_VAR_logs_bucket=${LOGS_BUCKET} \
        -it hashicorp/terraform:light apply -auto-approve -refresh=true -state=${TERRAFORM_STATE}
}

echo "Deploying $APPLICATION_NAME $ENVIRONMENT_NAME environment from $PROJECT_DIR"
mkdir -p "${PROJECT_DIR}/deployment/.terraform"

get_or_create_key_pair
create_s3_bucket
build_bastion_ami
build_docker_ami
apply_terraform