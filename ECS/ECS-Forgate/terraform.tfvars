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


########################
########variable values
########################

cluster_name            = "my-cluster"
#task_name               = "my-first-task"
#image                   = "srinivas295/demo-nodejs"
#ecs-service-name        = "my_first_service"
#alb-name                = " my-demo-alb"
http_port               = 80
container_port		= 3000
desire_memory		= 512
desire_cpu		= 128
ecs_service		= "my-first-service"
alb_name		= "test-lb-tf"
tg_name			= "target-group"
