resource "aws_ecs_cluster" "web-cluster" {
  name               = var.cluster_name
  capacity_providers = [aws_ecs_capacity_provider.test.name]
  tags = {
    "env"       = "dev"
  }
}

resource "aws_ecs_capacity_provider" "test" {
  name = var.capacity_provider_name
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg.arn
    #managed_termination_protection = "ENABLED"

    managed_scaling {
      status          = "ENABLED"
      target_capacity = 85
    }
  }
}

# update file container-def, so it's pulling image from ecr
resource "aws_ecs_task_definition" "task-definition-test" {
  family                = var.ecs_family
  container_definitions = file("./container-def.json")
  network_mode          = var.network_mode
  tags = {
    "env"       = "dev"
  }
}

resource "aws_ecs_service" "service" {
  name            = var.ecs_service
  cluster         = aws_ecs_cluster.web-cluster.id
  task_definition = aws_ecs_task_definition.task-definition-test.arn
  desired_count   = var.desired_count
  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }
  launch_type = var.ecs_launch_type
  depends_on  = [aws_lb_listener.web-listener]
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = var.CW_log_group_name
  tags = {
    "env"       = "dev"
  }
}
