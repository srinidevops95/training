provider "aws" {
        region="us-east-2"
}

####################
#     VPC
####################

resource "aws_vpc" "main_vpc" {
  cidr_block       = var.VPC_CIDR
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "demo-vpc"
  }
}

#################
### public subnet
#################
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.SUBNET_CIDR1
  availability_zone = var.SUBNET_AZ1

  tags = {
    Name = "demo-pub1"
  }
}

#####################
# Public subnet2
####################
### public subnet
resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.SUBNET_CIDR2
  availability_zone = var.SUBNET_AZ2

  tags = {
    Name = "demo-pub2"
  }
}


##################
### private subnet
##################
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.SUBNET_CIDR3
  availability_zone = var.SUBNET_AZ1

  tags = {
    Name = "demo-pri1"
  }
}


##################
#  private subnet2
##################
### public subnet
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.SUBNET_CIDR4
  availability_zone = var.SUBNET_AZ2

  tags = {
    Name = "demo-pri2"
  }
}


#########
## IGW
########
resource "aws_internet_gateway" "igw_demo" {

 vpc_id   = aws_vpc.main_vpc.id

tags = {
    Name = "demo-igw"
  }
}



####################
# Public Route Table
###################
resource "aws_route_table" "rt_public" {


 vpc_id   = aws_vpc.main_vpc.id


tags = {
    Name = "demo-pub-rt"
  }
}

#####################
# private route table
#####################
resource "aws_route_table" "rt_private" {


 vpc_id   = aws_vpc.main_vpc.id


tags = {
    Name = "demo-pri-rt"
  }
}


######################
# route table association public
######################
resource "aws_route_table_association" "asso_public1" {


  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.rt_public.id
}

###### Association public subnet2
resource "aws_route_table_association" "asso_public2" {


  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.rt_public.id
}

###igw routing
resource "aws_route" "route1" {
      
  
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = var.CIDR_ALL
  gateway_id             = aws_internet_gateway.igw_demo.id
}





################################
# route table association private1
################################
resource "aws_route_table_association" "asso_private1" {


  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.rt_private .id
}


############ Association private subnet2
resource "aws_route_table_association" "asso_private2" {


  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.rt_private .id
}





################
## NAT
################

resource "aws_eip" "nat_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw_demo]
}


# Private NAT
resource "aws_nat_gateway" "nat_demo" {
  allocation_id     = aws_eip.nat_eip.id
  subnet_id         = aws_subnet.public_subnet2.id
  depends_on        = [aws_internet_gateway.igw_demo]
tags = {
    Name = "demo_nat"
  }
}




####### nat routing
resource "aws_route" "nat_route" {
      
  
  route_table_id         = aws_route_table.rt_private.id
  destination_cidr_block = var.CIDR_ALL
  nat_gateway_id          = aws_nat_gateway.nat_demo.id
}





#########################################
#                 ECR
#########################################
resource "aws_ecr_repository" "my_repo" {
  name                 = var.repo_name
  image_tag_mutability = "MUTABLE"
}


#######
resource "aws_ecr_lifecycle_policy" "my_repo_policy" {
  repository = aws_ecr_repository.my_repo.name

  policy = jsonencode({
   rules = [{
     rulePriority = 1
     description  = "keep last 10 images"
     action       = {
       type = "expire"
     }
     selection     = {
       tagStatus   = "any"
       countType   = "imageCountMoreThan"
       countNumber = 10
     }
   }]
  })
}


###############
# ECS Cluster
###############
resource "aws_ecs_cluster" "my-cluster" {
  name = var.cluster_name
}

###########################
# ECS Task
###########################

resource "aws_ecs_task_definition" "my_first_task" {
  family                   = "my-first-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "my-first-task",
      "image": "srinivas295/demo-nodejs",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256        # Specifying the CPU our container requires
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}


############################
# ECS Task Execution role
############################

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

###############################
# ECS Service
###############################

resource "aws_ecs_service" "my_first_service" {
  name            = var.ecs_service                    # Naming our first service
  cluster         = aws_ecs_cluster.my-cluster.id             # Referencing our created Cluster
  task_definition = aws_ecs_task_definition.my_first_task.arn # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 1 # Setting the number of containers to 3

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.my_first_task.family
    container_port   = var.container_port # Specifying the container port
  }

  network_configuration {
    subnets          = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = [aws_security_group.service_security_group.id] # Setting the security group
  }
}

#########################
# ECS SG
#########################

resource "aws_security_group" "service_security_group" {
  vpc_id        = aws_vpc.main_vpc.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = [aws_security_group.load_balancer_security_group.id]
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}

###########################
# ECS ALB
###########################

resource "aws_alb" "application_load_balancer" {
  name               = var.alb_name
  load_balancer_type = "application"
  subnets = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  security_groups = [aws_security_group.load_balancer_security_group.id]
}


##################################################
# Creating a security group for the load balancer
##################################################
resource "aws_security_group" "load_balancer_security_group" {
  vpc_id        = aws_vpc.main_vpc.id
  ingress {
    from_port   = var.http_port # Allowing traffic in from port 80
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  egress {
    from_port   = 0 # Allowing any incoming port
    to_port     = 0 # Allowing any outgoing port
    protocol    = "-1" # Allowing any outgoing protocol
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
  }
}


######################
# alb target
######################

resource "aws_lb_target_group" "target_group" {
  name        = var.tg_name
  port        = var.http_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main_vpc.id
  health_check {
    matcher = "200,301,302"
    path = "/"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

############################
# ASG
############################

resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.my-cluster.name}/${aws_ecs_service.my_first_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


