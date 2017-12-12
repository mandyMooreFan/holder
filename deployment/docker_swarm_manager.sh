#!/usr/bin/env bash

sudo docker login -u ${docker_username} -p ${docker_password}
sudo docker swarm init
sudo docker swarm join-token --quiet worker > /home/ubuntu/token