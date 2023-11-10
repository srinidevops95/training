variable "AWS_REGION" {
	description	=  "AWS deployment REGION"
        type		=   string
	default		= ""
}



variable "VPC_CIDR" {
	description	=  "VPC CIDR range"
        type		=   string
	default		= ""
}



variable "SUBNET_CIDR1" {
	description	=  "subnet1 CIDR"
        type		=   string
	default		= ""
}

variable "SUBNET_CIDR2" {
	description	=  "subnet2 CIDR"
        type		=   string
	default		= ""
}


variable "SUBNET_CIDR3" {
	description	=  "subnet3 CIDR"
        type		=   string
	default		= ""
}

variable "SUBNET_CIDR4" {
	description	=  "subnet4 CIDR"
        type		=   string
	default		= ""
}

variable "SUBNET_AZ1" {
	description	=  "subnet AZ1"
        type		=   string
	default		= ""
}


variable "SUBNET_AZ2" {
	description	=  "subnet AZ2"
        type		=   string
	default		= ""
}



variable "CIDR_ALL" {
	description	=  "destination CIDR range for IGW & NAT routing"
        type		=   string
	default		= ""
}

###########ECS###################

variable "cluster_name" {
        description     =  "name of the cluster"
        type            =   string
        default         = ""
}


variable "key_name" {
        description     =  "ssh key pair"
        type            =   string
        default         = ""
}

variable "instance-role" {
        description     =  "ecs role name"
        type            =   string
        default         = ""
}

variable "capacity_provider_name" {
        description     =  "ecs capacity provider name"
        type            =   string
        default         = ""
}

variable "ecs_family" {
        description     =  "ecs family type"
        type            =   string
        default         = ""
}

variable "network_mode" {
        description     =  "ecs network mode"
        type            =   string
        default         = ""
}

variable "ecs_service" {
        description     =  "ecs service name"
        type            =   string
        default         = ""
}

variable "desired_count" {
        description     =  "task desired count"
}

variable "container_name" {
        description     =  "ecs container name"
        type            =   string
        default         = ""
}

variable "container_port" {
        description     =  "ecs container port"
}

variable "ecs_launch_type" {
        description     =  "ecs launch type"
        type            =   string
        default         = "EC2"
}

variable "CW_log_group_name" {
        description     =  "Cloudwatch LOG group for ecs "
        type            =   string
        default         = ""
}


########## ALB #################
variable "alb_name" {
        description     =  "Load balancer name "
        type            =   string
        default         = ""
}

variable "alb_type" {
        description     =  "Type of Loadbalancer"
        type            =   string
        default         = ""
}

variable "lb_sg" {
        description     =  "Load balancer SG"
        type            =   string
        default         = ""
}

variable "tg_name" {
        description     =  "Target Group Name"
        type            =   string
        default         = ""
}

variable "http_port" {
        description     =  "http port"
}

variable "protocol" {
        description     =  "Protocol"
        type            =   string
        default         = ""
}

variable "tg_type" {
        description     =  "Target Group type"
        type            =   string
        default         = ""
}



############ ASG ##############
variable "asg_sg" {
        description     =  "Autoscaling SG"
        type            =   string
        default         = ""
}

variable "asg_launch_name" {
        description     =  "Name of the launch configuration"
        type            =   string
        default         = ""
}

variable "instance_type" {
        description     =  "Instanc Type"
        type            =   string
        default         = ""
}

variable "asg_group_name" {
        description     =  "Name of the Autoscaling Group"
        type            =   string
        default         = ""
}

variable "min_instances" {
        description     =  "Minimum number of instance in ASG"
}

variable "max_instances" {
        description     =  "Maximum number of instances in ASG"
}

variable "desired_instances" {
        description     =  "Desired number of instances in ASG"
}

variable "grace_period" {
        description     =  "ASG grace period"
}

variable "health_check_type" {
        description     =  "ASG health check type"
        type            =   string
        default         = ""
}




