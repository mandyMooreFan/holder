#!/usr/bin/env bash

# This is to prevent path mangling in Windows. It should have no effect on Linux or Mac.
# https://stackoverflow.com/questions/7250130/how-to-stop-mingw-and-msys-from-mangling-path-names-given-at-the-command-line
export MSYS_NO_PATHCONV=1

ENVIRONMENT_NAME="$1"

if [ -z "${APPLICATION_NAME}" ]; then
    echo "You must set the APPLICATION_NAME environment variable."
    exit 0;
fi

if [ -z "${ENVIRONMENT_NAME}" ]; then
    echo "WARNING: You have not set the ENVIRONMENT_NAME environment variable. Defaulting to dev."
    ENVIRONMENT_NAME=dev
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )"

KEY_PAIR_NAME="${APPLICATION_NAME}_${ENVIRONMENT_NAME}"

OS=${OSTYPE//[0-9.-]*/}

case "$OS" in
  darwin)
    echo "Mac detected"
    ;;

  msys)
    echo "Windows git bash detected"
    ;;

  linux)
    echo "Linux detected"
    ;;
  *)

  echo "Unknown Operating system $OSTYPE"
  exit 1
esac

function deploy_to_local_machine {
    echo "Deploying to local environment"
    create_local_swarm
    build_projects
    build_images
    deploy_to_local_swarm
}

function create_windows_swarm {
    docker-machine create -d hyperv --hyperv-virtual-switch akka-boot manager
    docker-machine create -d hyperv --hyperv-virtual-switch akka-boot worker1
    docker-machine create -d hyperv --hyperv-virtual-switch akka-boot worker2
}

function create_local_swarm {
    echo "Checking for existing swarm"

    STATUS=`docker-machine status manager`

    if [ "Running" = ${STATUS} ]; then
        echo "Existing swarm found"
    else
        echo "Existing swarm not found"
        echo "Creating new swarm"

        case "$OS" in
          msys)
            create_windows_swarm
            ;;
          *)

          echo "Unsupported Operating system $OSTYPE"
          exit 1
        esac

        docker-machine ssh manager "docker swarm init \
            --listen-addr $(docker-machine ip manager) \
            --advertise-addr $(docker-machine ip manager)"

        export worker_token=$(docker-machine ssh manager "docker swarm join-token worker -q")

        docker-machine ssh worker1 "docker swarm join \
            --token=${worker_token} \
            --listen-addr $(docker-machine ip worker1) \
            --advertise-addr $(docker-machine ip worker1) \
            $(docker-machine ip manager)"

        docker-machine ssh worker2 "docker swarm join \
            --token=${worker_token} \
            --listen-addr $(docker-machine ip worker2) \
            --advertise-addr $(docker-machine ip worker2) \
            $(docker-machine ip manager)"

        echo "Docker Swarm created"
        docker-machine ls
    fi
}

function build_projects {
    echo "Building fat jars"
    echo "${HOME}"
    docker run -it \
        -v "${HOME}/.sbt:/root/.sbt" \
        -v "${HOME}/.m2/:/root/.m2" \
        -v "${HOME}/.ivy2/:/root/.ivy2" \
        -v "${PROJECT_DIR}:/root/src" \
        -w /root/src \
        hseeberger/scala-sbt sbt assembly
}

function build_images {
    echo "Building updated images"
    docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
    docker-compose build
    docker-compose push
}

function deploy_to_local_swarm {
    echo "Deploying $APPLICATION_NAME to Local Docker Swarm from $PROJECT_DIR"

    docker-machine scp "localhost:$DIR/../docker-compose.yml" manager:/home/docker/
    docker-machine ssh manager "docker stack deploy -c docker-compose.yml $APPLICATION_NAME"

    printf "\n****************************************\n"
    echo "$APPLICATION_NAME deployment is complete"
    echo "$APPLICATION_NAME deployed to following instances"

    printf "\n\n"
    docker-machine ls

    printf "\n\n"
    docker-machine ssh manager "docker service ls"
}

function deploy_to_aws_swarm {
    KEY="${PROJECT_DIR}/deployment/.terraform/${KEY_PAIR_NAME}"

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
            > ${KEY}

    BASTION=$(docker run \
        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
        -it cgswong/aws aws ec2 describe-instances \
        --region us-east-1 \
        --filters \
            "Name=tag:Name,Values=${APPLICATION_NAME}_${ENVIRONMENT_NAME}_bastion" \
            "Name=instance-state-name,Values=running" \
        --query "Reservations[*].Instances[*].[PublicIpAddress]" \
        --output=text)
    echo "Connecting to Bastion: ${BASTION}"

    SWARM_MANAGER=$(docker run \
        -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
        -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
        -it cgswong/aws aws ec2 describe-instances \
        --region us-east-1 \
        --filters \
            "Name=tag:Name,Values=${APPLICATION_NAME}_${ENVIRONMENT_NAME}_swarm_manager" \
            "Name=instance-state-name,Values=running" \
        --query "Reservations[*].Instances[*].[PrivateIpAddress]" \
        --output=text)
    echo "Connecting to Swarm Manager: ${SWARM_MANAGER}"

    PROXY="ProxyCommand ssh -i $PROJECT_DIR/deployment/.terraform/$KEY_PAIR_NAME ubuntu@$BASTION nc $SWARM_MANAGER 22"

    scp -i "${KEY}" -o "${PROXY}" \
        ${PROJECT_DIR}/docker-compose.yml ubuntu@${SWARM_MANAGER}:/home/ubuntu/

    ssh -i "${KEY}" -o "${PROXY}" \
        -t ubuntu@${SWARM_MANAGER} "sudo docker stack deploy -c docker-compose.yml ${APPLICATION_NAME}"

    ssh -i "${KEY}" -o "${PROXY}" \
        -t ubuntu@${SWARM_MANAGER} 'sudo docker service ls'
}

function deploy_to_aws {
    if [ -z "${AWS_ACCESS_KEY_ID}" ]; then
        echo "You must set the AWS_ACCESS_KEY_ID environment variable."
        exit 0;
    fi

    if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then
        echo "You must set the AWS_SECRET_ACCESS_KEY environment variable."
        exit 0;
    fi

    echo "Deploying $APPLICATION_NAME to AWS $ENVIRONMENT_NAME Docker Swarm from $PROJECT_DIR"

    build_projects
    build_images
    deploy_to_aws_swarm
}

if [ -z ${ENVIRONMENT_NAME} ]; then
    echo "Environment argument is required";
elif [ "local" = ${ENVIRONMENT_NAME} ]; then
     deploy_to_local_machine;
else
     deploy_to_aws;
fi;