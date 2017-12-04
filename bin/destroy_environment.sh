#!/usr/bin/env bash

# This is to prevent path mangling in Windows. It should have no effect on Linux or Mac.
# https://stackoverflow.com/questions/7250130/how-to-stop-mingw-and-msys-from-mangling-path-names-given-at-the-command-line
export MSYS_NO_PATHCONV=1

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )"

DEPLOYMENT_DIR="${PROJECT_DIR}/deployment/"

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

docker run -i \
    -v "$PROJECT_DIR:/app/" \
    -w /app/deployment/ \
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
    -e TF_VAR_application_name=${APPLICATION_NAME} \
    -e TF_VAR_docker_username=${DOCKER_USERNAME} \
    -e TF_VAR_docker_password=${DOCKER_PASSWORD} \
    -e TF_VAR_logs_bucket=${LOGS_BUCKET} \
    -t hashicorp/terraform:light destroy