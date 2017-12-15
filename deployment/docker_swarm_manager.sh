#!/usr/bin/env bash

sudo docker login -u ${docker_username} -p ${docker_password}
sudo docker swarm init

aws ssm put-parameter \
    --region ${aws_region} \
    --name /${application_name}/${environment_name}/swarm/managers/ip_address \
    --overwrite \
    --type String \
    --value $(curl http://169.254.169.254/latest/meta-data/local-ipv4)

aws ssm put-parameter \
    --region ${aws_region} \
    --name /${application_name}/${environment_name}/swarm/managers/worker_token \
    --overwrite \
    --type String \
    --value $(sudo docker swarm join-token --quiet worker)

aws ssm put-parameter \
    --region ${aws_region} \
    --name /${application_name}/${environment_name}/swarm/managers/manager_token \
    --overwrite \
    --type String \
    --value $(sudo docker swarm join-token --quiet manager)
