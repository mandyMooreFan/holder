::docker run -i ^
::    -v %cd%:/app/ ^
::    -w /app/ ^
::    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
::    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
::    -e APPLICATION_NAME=%APPLICATION_NAME% ^
::    -e LOGGLY_TOKEN=%LOGGLY_TOKEN% ^
::   -t hashicorp/packer:light build bastion.json

::docker run -i ^
::    -v %cd%:/app/ ^
::    -w /app/ ^
::    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
::    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
::    -e APPLICATION_NAME=%APPLICATION_NAME% ^
::    -e LOGGLY_TOKEN=%LOGGLY_TOKEN% ^
::    -e SWARM_KEY=%SWARM_KEY% ^
::    -t hashicorp/packer:light build docker.json

docker run -i ^
    -v %cd%:/app/ ^
    -w /app/ ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -t hashicorp/terraform:light init

docker run -i ^
    -v %cd%:/app/ ^
    -w /app/ ^
    -e AWS_ACCESS_KEY_ID=%AWS_ACCESS_KEY_ID% ^
    -e AWS_SECRET_ACCESS_KEY=%AWS_SECRET_ACCESS_KEY% ^
    -e TF_VAR_application_name=%APPLICATION_NAME% ^
    -e TF_VAR_docker_username=%DOCKER_USERNAME% ^
    -e TF_VAR_docker_password=%DOCKER_PASSWORD% ^
    -e TF_VAR_logs_bucket=%LOGS_BUCKET% ^
    -t hashicorp/terraform:light apply