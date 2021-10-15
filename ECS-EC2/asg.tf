data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami*amazon-ecs-optimized"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon", "self"]
}

resource "aws_security_group" "ec2-sg" {
  name        = var.asg_sg
  description = "allow all"
  vpc_id      = aws_vpc.main_vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DEMO-ASG-SG"
  }
}

resource "aws_launch_configuration" "lc" {
  name          = var.asg_launch_name
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile        = aws_iam_instance_profile.ecs_service_role.name
  key_name                    = var.key_name
  security_groups             = [aws_security_group.ec2-sg.id]
  associate_public_ip_address = true
  user_data                   = <<EOF
#! /bin/bash
sudo apt-get update
sudo echo "ECS_CLUSTER=${var.cluster_name}" >> /etc/ecs/ecs.config
EOF
}

resource "aws_autoscaling_group" "asg" {
  name                      = var.asg_group_name
  launch_configuration      = aws_launch_configuration.lc.name
  min_size                  = var.min_instances
  max_size                  = var.max_instances
  desired_capacity          = var.desired_instances
  health_check_type         = var.health_check_type
  health_check_grace_period = var.grace_period
  vpc_zone_identifier       = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

  target_group_arns     = [aws_lb_target_group.lb_target_group.arn]
  protect_from_scale_in = true
}
