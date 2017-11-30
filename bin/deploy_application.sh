#!/usr/bin/env bash

environment="$1"

function local {
    echo "Deploying to local environment"
    create_local_swarm
    deploy_to_local_swarm
}

function create_local_swarm {
    echo "Creating local Docker Swarm"
    docker-machine create -d hyperv manager
    docker-machine create -d hyperv worker1
    docker-machine create -d hyperv worker2

    docker-machine ssh manager "docker swarm init \
        --listen-addr $(docker-machine ip manager) \
        --advertise-addr $(docker-machine ip manager)"

    export worker_token=$(docker-machine ssh manager "docker swarm \
        join-token worker -q")

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
}

function deploy_to_local_swarm {


}
function server {
    echo "Deploying to AWS $environment environment"
    #    scp -i akka_boot.pem ../docker-compose.yml ubuntu@dev_swarm_manager:/home/ubuntu/
    #    ssh -i akka_boot.pem ubuntu@dev_swarm_manager 'sudo docker stack deploy -c docker-compose.yml akka-boot'
}

if [ -z $environment ]; then
    echo "Environment argument is required";
elif [ "local" = $environment ]; then
    local;
else
    server;
fi;

