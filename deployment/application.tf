terraform {
  backend "s3" {
  }
}

variable "aws_account_id" {
  type = "string"
}

variable "aws_region" {
  type = "string"
  default = "us-east-1"
}

provider "aws" {
  region = "${var.aws_region}"
}

variable "az_1" {
  type = "string"
  default = "us-east-1a"
}

variable "az_2" {
  type = "string"
  default = "us-east-1b"
}

variable "az_3" {
  type = "string"
  default = "us-east-1c"
}

variable "application_name" {
  type = "string"
}

variable "environment_name" {
  type = "string"
}

variable "logs_bucket" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "bastion_instance_type" {
  type = "string"
  default = "t2.micro"
}

variable "swarm_manager_instance_type" {
  type = "string"
  default = "r4.large"
}

variable "swarm_node_instance_type" {
  type = "string"
  default = "r4.large"
}

variable "docker_username" {
  type = "string"
  description = "Username for Docker Hub"
}

variable "docker_password" {
  type = "string"
  description = "Password for Docker Hub"
}

resource "aws_s3_bucket" "logs" {
  bucket = "${var.logs_bucket}"
  acl = "private"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["s3:PutObject"],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.logs_bucket}/${var.application_name}/${var.environment_name}/elbs/AWSLogs/${var.aws_account_id}/*",
      "Principal": {
        "AWS": ["127311923021"]
      }
    }
  ]
}
EOF
}