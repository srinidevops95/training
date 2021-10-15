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

##################
#
# SG variable definition
#
##################

variable "ssh_port" {
    description = "SSH port"
    default     = 22
}

variable "http_port" {
   description = "http port"
   default     = 80
}

variable "https_port" {
   description = "https port"
   default     = 443
}

variable "all_cidr" {
   description = "cidr open for all traffic"
   type        = string
   default     = "0.0.0.0/0"
}

variable "repo_name" {
   description = "ECR repo name"
   type        = string
   default     = "my-ecs-repo"
}

variable "cluster_name" {
   description = "ECR cluster name"
   type        = string
}



variable "desire_memory" {
   description = "require task memory"
   type        = string
}

variable "desire_cpu" {
   description = "require task cpu"
   type        = string
}

variable "ecs_service" {
   description = "ECS service name"
   type        = string
}

variable "alb_name" {
   description = "ECS alb"
   type        = string
}

variable "tg_name" {
   description = "target group name"
   type        = string
}

variable "container_port" {
   description = "ecs container port"
   type        = string
}

