#!/usr/bin/env bash

function local {
    echo "Hello Local"

}

function server {
    echo "Deploying to AWS $environment environment"
    #    scp -i akka_boot.pem ../docker-compose.yml ubuntu@dev_swarm_manager:/home/ubuntu/
    #    ssh -i akka_boot.pem ubuntu@dev_swarm_manager 'sudo docker stack deploy -c docker-compose.yml akka-boot'
}

environment="$1"

if [ -z $environment ]; then
    echo "Environment argument is required";
elif [ "local" = $environment ]; then
    local;
else
    server;
fi;