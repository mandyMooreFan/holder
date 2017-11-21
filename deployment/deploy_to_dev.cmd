docker run -i -t -v %cd%:/app/ -w /app/ hashicorp/terraform:light init

docker run -i -t -v %cd%:/app/ -w /app/ hashicorp/terraform:light apply -var "swarm_ami=ami-a8e861d2"