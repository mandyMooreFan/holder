#!/usr/bin/env bash

sudo docker swarm init
sudo docker swarm join-token --quiet worker > /home/ubuntu/token