variable "aws_access_key" {
  type = "string"
  default = "AKIAIE4EEVHETKPHDWLQ"
}

variable "aws_secret_key" {
  type = "string"
  default = "cAtCHekek9XfOQ3i5ZKEwfH/oUk6s1JnWQVcZ4j6"
}

variable "aws_region" {
  type = "string"
  default = "us-east-1"
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

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.aws_region}"
}

variable "application_name" {
  type = "string"
  default = "akka_boot"
}

variable "environment_name" {
  type = "string"
  default = "dev"
}

variable "key_name" {
  type = "string"
  default = "akka_boot"
}

variable "bastion_key_name" {
  type = "string"
  default = "akka_boot"
}

variable "swarm_key_name" {
  type = "string"
  default = "akka_boot"
}

variable "swarm_ami" {
  type = "string"
}

variable "swarm_instance_type" {
  type = "string"
  default = "t2.medium"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "099720109477"]

}