#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )"/../ && pwd )"

APPLICATION_NAME=${PWD##*/}

ENVIRONMENT_NAME="$1"

OS=${OSTYPE//[0-9.-]*/}

echo "Deploying $APPLICATION_NAME to $ENVIRONMENT_NAME from $PROJECT_DIR"

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
    docker run -it \
        -v "${HOME}/.sbt":/root/.sbt \
        -v "${HOME}/.m2":/root/.m2 \
        -v "${HOME}/.ivy2":/root/.ivy2 \
        -v "${PROJECT_DIR}":/root/src \
        -w /root/src \
        hseeberger/scala-sbt sbt assembly
}

function build_images {
    echo "Building updated images"
    docker-compose build
    docker-compose push
}

function deploy_to_local_swarm {
    echo "Deploying $APPLICATION_NAME to Docker Swarm"

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

function deploy_to_aws {
    echo "Deploying to AWS $ENVIRONMENT_NAME environment"
    scp  ${PROJECT_DIR}/docker-compose.yml dev_manager:/home/ubuntu/
    ssh dev_manager 'sudo docker stack deploy -c docker-compose.yml akka-boot'
    ssh dev_manager 'sudo docker service ls'
}

if [ -z ${ENVIRONMENT_NAME} ]; then
    echo "Environment argument is required";
elif [ "local" = ${ENVIRONMENT_NAME} ]; then
     deploy_to_local_machine;
else
     deploy_to_aws;
fi;