#!/usr/bin/env bash

chmod 700 /home/ubuntu/akka_boot.pem

sudo scp -o StrictHostKeyChecking=no \
    -o NoHostAuthenticationForLocalhost=yes \
    -o UserKnownHostsFile=/dev/null \
    -i /home/ubuntu/akka_boot.pem \
    ubuntu@${swarm_manager_private_ip}:/home/ubuntu/token /home/ubuntu/token

sudo docker swarm join --token $(cat /home/ubuntu/token) ${swarm_manager_private_ip}:2377