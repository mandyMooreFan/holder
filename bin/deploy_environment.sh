#!/usr/bin/env bash

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )"

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

echo "Deploying $APPLICATION_NAME from $PROJECT_DIR"

docker run \
    -v "C://Users//mfoody//IdeaProjects//akka-boot-starter//:/app/" \
    -w /app/ \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -e APPLICATION_NAME=${APPLICATION_NAME} \
    -e LOGGLY_TOKEN=${LOGGLY_TOKEN} \
    -it hashicorp/packer:light build bastion.json

docker run \
    -v "$PROJECT_DIR:/app/" \
    -w /app/ \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -e APPLICATION_NAME=${APPLICATION_NAME} \
    -e LOGGLY_TOKEN=${LOGGLY_TOKEN} \
    -e SWARM_KEY=${SWARM_KEY} \
    -it hashicorp/packer:light build docker.json

docker run \
    -v "$PROJECT_DIR:/app/" \
    -w /app/ \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -it hashicorp/terraform:light init

docker run \
    -v "$PROJECT_DIR:/app/" \
    -w /app/ \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -e TF_VAR_application_name=${APPLICATION_NAME} \
    -e TF_VAR_docker_username=${DOCKER_USERNAME} \
    -e TF_VAR_docker_password=${DOCKER_PASSWORD} \
    -e TF_VAR_logs_bucket=${LOGS_BUCKET} \
    -it hashicorp/terraform:light apply