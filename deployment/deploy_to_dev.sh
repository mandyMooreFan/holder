#!/usr/bin/env bash

docker run -machine-readable -i -t -v $(pwd):/app/ -w /app/ hashicorp/packer:light build docker.json | tee .terraform/build.log

AMI = egrep -m1 -oe 'ami-{16}' ./terraform/build.log

docker run -i -t -v $(pwd):/app/ -w /app/ hashicorp/terraform:light init

docker run -i -t -v $(pwd):/app/ -w /app/ hashicorp/terraform:light plan