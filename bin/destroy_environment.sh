#!/usr/bin/env bash

docker run -i ^
    -v "${pwd}":/app/ ^
    -w /app/ ^
    -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} ^
    -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} ^
    -e TF_VAR_application_name=${APPLICATION_NAME} ^
    -e TF_VAR_docker_username=${DOCKER_USERNAME} ^
    -e TF_VAR_docker_password=${DOCKER_PASSWORD} ^
    -e TF_VAR_logs_bucket=${LOGS_BUCKET} ^
    -t hashicorp/terraform:light destroy