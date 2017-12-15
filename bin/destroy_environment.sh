#!/usr/bin/env bash

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

KEY_PAIR_NAME="${APPLICATION_NAME}_${ENVIRONMENT_NAME}"

TERRAFORM_STATE=".terraform/${ENVIRONMENT_NAME}.tfstate"

echo "Terraform state saved in $TERRAFORM_STATE"

docker run -i \
    -v "$PROJECT_DIR:/app/" \
    -w /app/deployment/ \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -e TF_VAR_aws_account_id=${AWS_ACCOUNT_ID} \
    -e TF_VAR_application_name=${APPLICATION_NAME} \
    -e TF_VAR_environment_name=${ENVIRONMENT_NAME} \
    -e TF_VAR_docker_username=${DOCKER_USERNAME} \
    -e TF_VAR_docker_password=${DOCKER_PASSWORD} \
    -e TF_VAR_logs_bucket=${LOGS_BUCKET} \
    -e TF_VAR_key_name=${KEY_PAIR_NAME} \
    -t hashicorp/terraform:light destroy -refresh=true -state=${TERRAFORM_STATE}