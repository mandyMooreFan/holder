resource "aws_instance" "swarm_manager" {
  ami = "${var.swarm_ami}"
  instance_type = "${var.swarm_instance_type}"
  subnet_id = "${aws_subnet.subnet_1_private.id}"
  user_data = "${data.template_file.swarm_manager_user_data.rendered}"
  key_name = "${var.swarm_key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.ntp.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.swarm_manager.id}"]

  tags {
    Name = "${var.application_name}_${var.environment_name}_swarm_manager_${count.index}"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

data "template_file" "swarm_manager_user_data" {
  template = "${file("docker_swarm_manager.sh")}"
}

resource "aws_security_group" "swarm_manager" {
  vpc_id = "${aws_vpc.vpc.id}"
  description = "Allow external SSH access"
  name = "${var.application_name}_${var.environment_name}_swarm_manager"

  # Allow SSH to retrieve the Swarm TOKEN
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = [
      "${aws_security_group.swarm_node.id}"]
  }

  egress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    security_groups = [
      "${aws_security_group.swarm_node.id}"]
  }

  ingress {
    from_port = 2377
    protocol = "tcp"
    to_port = 2377
    security_groups = [
      "${aws_security_group.swarm_node.id}"]
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_swarm_manager"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }

}

resource "aws_autoscaling_group" "swarm_node" {
  launch_configuration = "${aws_launch_configuration.swarm_node.name}"
  min_size = 1
  max_size = 3
  desired_capacity = 2
  name = "${var.application_name}_${var.environment_name}_swarm_node"

  vpc_zone_identifier = [
    "${aws_subnet.subnet_1_private.id}",
    "${aws_subnet.subnet_2_private.id}",
    "${aws_subnet.subnet_3_private.id}"]

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "${var.application_name}_${var.environment_name}_swarm_node"
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

resource "aws_launch_configuration" "swarm_node" {
  name_prefix = "${var.application_name}_${var.environment_name}_swarm_node_"
  image_id = "${var.swarm_ami}"
  instance_type = "${var.swarm_instance_type}"
  user_data = "${data.template_file.swarm_node_user_data.rendered}"
  key_name = "${var.swarm_key_name}"

  security_groups = [
    "${aws_security_group.ntp.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.swarm_node.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "swarm_node_user_data" {
  template = "${file("docker_swarm_node.sh")}"

  vars {
    swarm_manager_private_ip = "${aws_instance.swarm_manager.private_ip}"
  }
}

resource "aws_security_group" "swarm_node" {
  vpc_id = "${aws_vpc.vpc.id}"
  description = "Allow external SSH access"
  name = "${var.application_name}_${var.environment_name}_swarm_node"

  tags {
    Name = "${var.application_name}_${var.environment_name}_swarm_node"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }

}

resource "aws_security_group_rule" "swarm_node_ssh" {
  security_group_id = "${aws_security_group.swarm_node.id}"

  type = "egress"
  from_port = 22
  protocol = "tcp"
  to_port = 22
  source_security_group_id = "${aws_security_group.swarm_manager.id}"
}

resource "aws_security_group_rule" "swarm_node_docker" {
  security_group_id = "${aws_security_group.swarm_node.id}"

  type = "egress"
  from_port = 2377
  protocol = "tcp"
  to_port = 2377

  source_security_group_id = "${aws_security_group.swarm_manager.id}"
}