resource "aws_elb" "swarm_http" {
  name = "${replace(var.application_name, "_", "-")}-${var.environment_name}-swarm-http"
  cross_zone_load_balancing = true
  idle_timeout = 60
  connection_draining = true
  connection_draining_timeout = 300

  subnets = [
    "${aws_subnet.subnet_1_public.id}",
    "${aws_subnet.subnet_2_public.id}",
    "${aws_subnet.subnet_3_public.id}"]

  security_groups = [
    "${aws_security_group.swarm_elb.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 30
    timeout = 3
    target = "HTTP:8080/dashboard/"
  }

  access_logs {
    bucket = "${var.logs_bucket}"
    bucket_prefix = "${var.application_name}/${var.environment_name}/elbs/swarm"
    interval = 5
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_swarm_http"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }

  depends_on = [
    "aws_s3_bucket.logs"]
}

resource "aws_security_group" "swarm_elb" {
  vpc_id = "${aws_vpc.vpc.id}"
  description = "Allow the Swarm ELB to serve HTTP traffic"
  name = "${var.application_name}_${var.environment_name}_swarm_http"

  # Allow inbound HTTP traffic from the public internet
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # Allow HTTP traffic to be forwarded to the Docker Swarm
  egress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    security_groups = [
      "${aws_security_group.swarm_node.id}"]
  }

  # Allow inbound HTTPS traffic from the public internet
  ingress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  # Allow HTTPS traffic to be forwarded to the Docker Swarm
  egress {
    from_port = 443
    protocol = "tcp"
    to_port = 443
    security_groups = [
      "${aws_security_group.swarm_node.id}"]
  }

  # Allow HTTP traffic to the health check
  egress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    security_groups = [
      "${aws_security_group.swarm_node.id}"]
  }

  tags {
    Name = "${var.application_name}_${var.environment_name}_swarm_http"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }

}

resource "aws_instance" "swarm_manager" {
  ami = "${data.aws_ami.swarm.id}"
  instance_type = "${var.swarm_manager_instance_type}"
  subnet_id = "${aws_subnet.subnet_1_private.id}"
  user_data = "${data.template_file.swarm_manager_user_data.rendered}"
  key_name = "${var.key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.loggly.id}",
    "${aws_security_group.ntp.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.swarm_node.id}"]

  tags {
    Name = "${var.application_name}_${var.environment_name}_swarm_manager_${count.index}"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

data "aws_ami" "swarm" {
  most_recent = true

  filter {
    name = "name"
    values = [
      "${var.application_name}_docker_swarm*"]
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "self"]
}

data "template_file" "swarm_manager_user_data" {
  template = "${file("docker_swarm_manager.sh")}"

  vars {
    docker_username = "${var.docker_username}"
    docker_password = "${var.docker_password}"
  }
}

resource "aws_autoscaling_group" "swarm_workers" {
  name = "${var.application_name}_${var.environment_name}_swarm_workers"
  launch_configuration = "${var.environment_name == "dev" ? aws_launch_configuration.swarm_worker_dev.name : aws_launch_configuration.swarm_worker_prod.name}"
  min_size = 1
  max_size = 3
  desired_capacity = 2
  load_balancers = [
    "${aws_elb.swarm_http.id}"]

  vpc_zone_identifier = [
    "${aws_subnet.subnet_1_private.id}",
    "${aws_subnet.subnet_2_private.id}",
    "${aws_subnet.subnet_3_private.id}"]

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "${var.application_name}_${var.environment_name}_swarm_worker"
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

resource "aws_launch_configuration" "swarm_worker_dev" {
  name_prefix = "${var.application_name}_${var.environment_name}_swarm_worker_"
  image_id = "${data.aws_ami.swarm.id}"
  instance_type = "${var.swarm_node_instance_type}"
  user_data = "${data.template_file.swarm_worker_user_data.rendered}"
  key_name = "${var.key_name}"
  spot_price = "0.13"

  security_groups = [
    "${aws_security_group.loggly.id}",
    "${aws_security_group.ntp.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.swarm_node.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "swarm_worker_prod" {
  name_prefix = "${var.application_name}_${var.environment_name}_swarm_worker_"
  image_id = "${data.aws_ami.swarm.id}"
  instance_type = "${var.swarm_node_instance_type}"
  user_data = "${data.template_file.swarm_worker_user_data.rendered}"
  key_name = "${var.key_name}"

  security_groups = [
    "${aws_security_group.loggly.id}",
    "${aws_security_group.ntp.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.swarm_node.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "swarm_worker_user_data" {
  template = "${file("docker_swarm_worker.sh")}"

  vars {
    docker_username = "${var.docker_username}"
    docker_password = "${var.docker_password}"
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

# Allow internal SSH traffic. In particular to retrieve the Swarm TOKEN.
resource "aws_security_group_rule" "swarm_ssh_in" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "ingress"
  from_port = 22
  protocol = "tcp"
  to_port = 22
  self = true
}

# Allow internal SSH traffic. In particular to retrieve the Swarm TOKEN.
resource "aws_security_group_rule" "swarm_ssh_out" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "egress"
  from_port = 22
  protocol = "tcp"
  to_port = 22
  self = true
}

# Allow inbound HTTP trafic from the ELB. This is how content actually gets served.
resource "aws_security_group_rule" "swarm_http" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "ingress"
  from_port = 80
  protocol = "tcp"
  to_port = 80
  source_security_group_id = "${aws_security_group.swarm_elb.id}"
}

# Allow inbound HTTPS traffic from the ELB. This is how content actually gets served.
resource "aws_security_group_rule" "swarm_https" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "ingress"
  from_port = 443
  protocol = "tcp"
  to_port = 443
  source_security_group_id = "${aws_security_group.swarm_elb.id}"
}

# Allow internal Docker traffic
resource "aws_security_group_rule" "swarm_docker_in" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "ingress"
  from_port = 2377
  protocol = "tcp"
  to_port = 2377
  self = true
}

# Allow internal Docker traffic
resource "aws_security_group_rule" "swarm_docker_out" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "egress"
  from_port = 2377
  protocol = "tcp"
  to_port = 2377
  self = true
}

# Allow internal Docker mesh network traffic
resource "aws_security_group_rule" "swarm_mesh_discovery_in" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "ingress"
  from_port = 7946
  protocol = "all"
  to_port = 7946
  self = true
}

# Allow internal Docker mesh network traffic
resource "aws_security_group_rule" "swarm_mesh_discovery_out" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "egress"
  from_port = 7946
  protocol = "all"
  to_port = 7946
  self = true
}

# Allow internal Docker mesh network traffic
resource "aws_security_group_rule" "swarm_container_ingress_in" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "ingress"
  from_port = 4789
  protocol = "udp"
  to_port = 4789
  self = true
}

# Allow internal Docker mesh network traffic
resource "aws_security_group_rule" "swarm_container_ingress_out" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "egress"
  from_port = 4789
  protocol = "udp"
  to_port = 4789
  self = true
}

# Allow inbound HTTP traffic from the ELB. This is how the Traefik console gets served.
resource "aws_security_group_rule" "swarm_traefik" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "ingress"
  from_port = 8080
  protocol = "tcp"
  to_port = 8080
  source_security_group_id = "${aws_security_group.swarm_elb.id}"
}

# Allow outbound HTTPS traffic so the Manager can reach the Docker Registry.
resource "aws_security_group_rule" "swarm_docker_registry" {
  security_group_id = "${aws_security_group.swarm_node.id}"
  type = "egress"
  from_port = 443
  protocol = "tcp"
  to_port = 443
  cidr_blocks = [
    "0.0.0.0/0"]
}