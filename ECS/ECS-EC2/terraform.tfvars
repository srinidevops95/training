##########################
#   VPC variables
##########################
VPC_CIDR	= "10.0.0.0/16"

SUBNET_CIDR1	= "10.0.0.0/18"

SUBNET_CIDR2	= "10.0.64.0/18"

SUBNET_CIDR3	= "10.0.128.0/18"

SUBNET_CIDR4	= "10.0.192.0/18"

SUBNET_AZ1	= "us-east-2a"

SUBNET_AZ2	= "us-east-2b"

CIDR_ALL	= "0.0.0.0/0"



AWS_REGION	= "us-east-2"


#######################
# ECS
#######################
cluster_name	= "my-cluster"

capacity_provider_name	= "capacity-provider-test"

ecs_family		= "web-family"

network_mode		= "bridge"

ecs_service		= "web-servcies"

desired_count		= 1

container_name		= "mydemo-ecs-ec2"

container_port		= 3000

ecs_launch_type		= "EC2"

CW_log_group_name	= "/ecs/frontend-container"

#########################
# ALB
######################### 
alb_name		= "test-ecs-lb"
alb_type		= "application"
lb_sg			= "ecs-lb-sg"
tg_name			= "masha-target-group"
http_port		= 80
protocol		= "HTTP"
tg_type			= "instance"



instance-role	= "ecs-instance-role-test-web"



###### ASG ###########
asg_sg			= "allow-all-ec2"
asg_launch_name		= "test_ecs"
key_name		= "my-demo"
instance_type		= "t2.micro"
asg_group_name		= "test-asg"
min_instances		= 1
max_instances		= 1
desired_instances	= 1
grace_period		= 300
health_check_type	= "ELB"
