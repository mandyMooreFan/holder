#!/usr/bin/env bash

SWARM_MANAGER=$(aws ssm get-parameter \
    --region ${aws_region} \
    --name /${application_name}/${environment_name}/swarm/managers/ip_address \
    --query "Parameter.Value" \
    --output text)

TOKEN=$(aws ssm get-parameter \
    --region ${aws_region} \
    --name /${application_name}/${environment_name}/swarm/managers/worker_token \
    --query "Parameter.Value" \
    --output text)

sudo docker swarm join --token $TOKEN $SWARM_MANAGER:2377

sudo docker login -u ${docker_username} -p ${docker_password}