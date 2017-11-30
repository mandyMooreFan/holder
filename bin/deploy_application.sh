#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

APPLICATION_NAME=${PWD##*/}

ENVIRONMENT="$1"

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
    build_images
    deploy_to_local_swarm
}

function create_local_swarm {
    echo "Checking for existing swarm"

    STATUS=`docker-machine status manager`

    if [ "Running" = ${STATUS} ]; then
        echo "Existing swarm found"

    else
        echo "Existing swarm not found"
        echo "Creating new swarm"

        docker-machine create -d hyperv manager
        docker-machine create -d hyperv worker1
        docker-machine create -d hyperv worker2

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
    echo "Deploying to AWS $ENVIRONMENT environment"
    scp -i akka_boot.pem ../docker-compose.yml ubuntu@dev_swarm_manager:/home/ubuntu/
    ssh -i akka_boot.pem ubuntu@dev_swarm_manager 'sudo docker stack deploy -c docker-compose.yml akka-boot'
}

if [ -z ${ENVIRONMENT} ]; then
    echo "Environment argument is required";
elif [ "local" = ${ENVIRONMENT} ]; then
    deploy_to_local_machine;
else
    deploy_to_aws;
fi;