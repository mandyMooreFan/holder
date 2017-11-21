#
# Bastion SSH Server
#

resource "aws_autoscaling_group" "bastion" {
  launch_configuration = "${aws_launch_configuration.bastion.id}"
  min_size = 1
  max_size = 1
  desired_capacity = 1
  health_check_type = "EC2"

  vpc_zone_identifier = [
    "${aws_subnet.subnet_1_public.id}",
    "${aws_subnet.subnet_2_public.id}",
    "${aws_subnet.subnet_3_public.id}"]

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "${var.application_name}_${var.environment_name}_bastion"
  }

  tag {
    key = "application_name"
    propagate_at_launch = true
    value = "${var.application_name}"
  }

  tag {
    key = "environment_name"
    propagate_at_launch = true
    value = "${var.environment_name}"
  }
}

resource "aws_launch_configuration" "bastion" {
  name_prefix = "${var.application_name}_${var.environment_name}_bastion_"
  image_id = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = "${var.bastion_key_name}"

  security_groups = [
    "${aws_security_group.ntp.id}",
    "${aws_security_group.bastion.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "bastion" {
  vpc_id = "${aws_vpc.vpc.id}"
  description = "Allow external SSH access"
  name = "${var.application_name}_${var.environment_name}_bastion"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "10.0.0.0/8"]
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_bastion"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }

}

resource "aws_security_group" "ssh" {
  vpc_id = "${aws_vpc.vpc.id}"
  description = "Allows SSH access among instances inside this security group"
  name = "${var.application_name}_${var.environment_name}_ssh"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = [
      "${aws_security_group.bastion.id}"]
  }

  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [
      "${aws_security_group.bastion.id}"]
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_ssh"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }

}