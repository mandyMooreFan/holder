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

resource "aws_autoscaling_group" "swarm_managers" {
  name = "${var.application_name}_${var.environment_name}_swarm_managers"
  launch_configuration = "${var.environment_name == "dev" ? aws_launch_configuration.swarm_manager_dev.name : aws_launch_configuration.swarm_manager_prod.name}"
  min_size = 1
  max_size = 1
  desired_capacity = 1
  load_balancers = [
    "${aws_elb.swarm_http.id}"]

  vpc_zone_identifier = [
    "${aws_subnet.subnet_1_private.id}",
    "${aws_subnet.subnet_2_private.id}",
    "${aws_subnet.subnet_3_private.id}"]

  tag {
    key = "Name"
    propagate_at_launch = true
    value = "${var.application_name}_${var.environment_name}_swarm_manager"
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

resource "aws_launch_configuration" "swarm_manager_dev" {
  name_prefix = "${var.application_name}_${var.environment_name}_swarm_manager_"
  image_id = "${data.aws_ami.swarm.id}"
  instance_type = "${var.swarm_node_instance_type}"
  user_data = "${data.template_file.swarm_manager_user_data.rendered}"
  key_name = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.swarm_manager.id}"

  # Run spot instances in dev
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

resource "aws_launch_configuration" "swarm_manager_prod" {
  name_prefix = "${var.application_name}_${var.environment_name}_swarm_manager_"
  image_id = "${data.aws_ami.swarm.id}"
  instance_type = "${var.swarm_node_instance_type}"
  user_data = "${data.template_file.swarm_manager_user_data.rendered}"
  key_name = "${var.key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.swarm_manager.id}"

  security_groups = [
    "${aws_security_group.loggly.id}",
    "${aws_security_group.ntp.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.swarm_node.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "swarm_manager" {
  name = "${var.application_name}_${var.environment_name}_swarm_manager"
  role = "${aws_iam_role.swarm_manager.id}"
}

resource "aws_iam_role" "swarm_manager" {
  name = "${var.application_name}_${var.environment_name}_swarm_manager"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "swarm_manager_ssm" {
  role = "${aws_iam_role.swarm_manager.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:DescribeParameters",
        "ssm:PutParameter",
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:DeleteParameter"
      ],
      "Resource": "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${var.application_name}/${var.environment_name}/swarm/*"
    }
  ]
}
EOF
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
    aws_region = "${var.aws_region}"
    docker_username = "${var.docker_username}"
    docker_password = "${var.docker_password}"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
  }
}

resource "aws_autoscaling_group" "swarm_workers" {
  depends_on = ["aws_autoscaling_group.swarm_managers"]

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
  iam_instance_profile = "${aws_iam_instance_profile.swarm_worker.id}"

  # Run spot instances in dev
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
  iam_instance_profile = "${aws_iam_instance_profile.swarm_worker.id}"

  security_groups = [
    "${aws_security_group.loggly.id}",
    "${aws_security_group.ntp.id}",
    "${aws_security_group.ssh.id}",
    "${aws_security_group.swarm_node.id}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "swarm_worker" {
  name = "${var.application_name}_${var.environment_name}_swarm_worker"
  role = "${aws_iam_role.swarm_worker.id}"
}

resource "aws_iam_role" "swarm_worker" {
  name = "${var.application_name}_${var.environment_name}_swarm_worker"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "swarm_worker_ssm" {
  role = "${aws_iam_role.swarm_worker.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter"
      ],
      "Resource": ["arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${var.application_name}/${var.environment_name}/swarm/managers/*"]
    }
  ]
}
EOF
}

data "template_file" "swarm_worker_user_data" {
  template = "${file("docker_swarm_worker.sh")}"

  vars {
    aws_region = "${var.aws_region}"
    docker_username = "${var.docker_username}"
    docker_password = "${var.docker_password}"
    application_name = "${var.application_name}"
    environment_name = "${var.environment_name}"
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