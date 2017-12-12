#
# VPC
#

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags {
    Name = "${var.application_name}_${var.environment_name}_vpc"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.application_name}_${var.environment_name}_vpc"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gateway.id}"
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_public"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

#
# AZ 1
#

resource "aws_subnet" "subnet_1_private" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.az_1}"
  cidr_block = "10.0.0.0/19"

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_1_private"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_nat_gateway" "subnet_1_public" {
  subnet_id = "${aws_subnet.subnet_1_public.id}"
  allocation_id = "${aws_eip.subnet_1_nat.id}"

  depends_on = [
    "aws_internet_gateway.gateway"]

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_1"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_eip" "subnet_1_nat" {
  vpc = true
  depends_on = [
    "aws_internet_gateway.gateway"]
}

resource "aws_route_table" "subnet_1_private" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.subnet_1_public.id}"
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_1_private"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "subnet_1_private" {
  subnet_id = "${aws_subnet.subnet_1_private.id}"
  route_table_id = "${aws_route_table.subnet_1_private.id}"
}

resource "aws_subnet" "subnet_1_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.az_1}"
  cidr_block = "10.0.32.0/20"
  map_public_ip_on_launch = "true"

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_1_public"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "subnet_1_public" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${aws_subnet.subnet_1_public.id}"
}

#
# AZ 2
#

resource "aws_subnet" "subnet_2_private" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.az_2}"
  cidr_block = "10.0.64.0/19"

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_2_private"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_nat_gateway" "subnet_2_public" {
  subnet_id = "${aws_subnet.subnet_2_public.id}"
  allocation_id = "${aws_eip.subnet_2_nat.id}"

  depends_on = [
    "aws_internet_gateway.gateway"]

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_2"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_eip" "subnet_2_nat" {
  vpc = true
  depends_on = [
    "aws_internet_gateway.gateway"]
}

resource "aws_route_table" "subnet_2_private" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.subnet_2_public.id}"
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_2_private"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "subnet_2_private" {
  subnet_id = "${aws_subnet.subnet_2_private.id}"
  route_table_id = "${aws_route_table.subnet_2_private.id}"
}

resource "aws_subnet" "subnet_2_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.az_2}"
  cidr_block = "10.0.96.0/20"
  map_public_ip_on_launch = "true"

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_2_public"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "subnet_2_public" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${aws_subnet.subnet_2_public.id}"
}

#
# AZ 3
#

resource "aws_subnet" "subnet_3_private" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.az_3}"
  cidr_block = "10.0.128.0/19"

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_3_private"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_nat_gateway" "subnet_3_public" {
  subnet_id = "${aws_subnet.subnet_3_public.id}"
  allocation_id = "${aws_eip.subnet_3_nat.id}"

  depends_on = [
    "aws_internet_gateway.gateway"]

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_3"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_eip" "subnet_3_nat" {
  vpc = true
  depends_on = [
    "aws_internet_gateway.gateway"]
}

resource "aws_route_table" "subnet_3_private" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.subnet_3_public.id}"
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_3_private"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "subnet_3_private" {
  subnet_id = "${aws_subnet.subnet_3_private.id}"
  route_table_id = "${aws_route_table.subnet_3_private.id}"
}

resource "aws_subnet" "subnet_3_public" {
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${var.az_3}"
  cidr_block = "10.0.160.0/20"
  map_public_ip_on_launch = "true"

  tags {
    Name = "${var.application_name}_${var.environment_name}_subnet_3_public"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_route_table_association" "subnet_3_public" {
  route_table_id = "${aws_route_table.public.id}"
  subnet_id = "${aws_subnet.subnet_3_public.id}"
}

resource "aws_security_group" "loggly" {
  vpc_id = "${aws_vpc.vpc.id}"
  description = "Allow access to Loggly"
  name = "${var.application_name}_${var.environment_name}_loggly"

  egress {
    from_port = 6514
    protocol = "tcp"
    to_port = 6514
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_loggly"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_security_group" "ntp" {
  vpc_id = "${aws_vpc.vpc.id}"
  description = "Allow access to external NTP servers"
  name = "${var.application_name}_${var.environment_name}_ntp"

  egress {
    from_port = 123
    protocol = "udp"
    to_port = 123
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_ntp"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}