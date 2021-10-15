variable "AWS_REGION" {
	description	=  "AWS deployment REGION"
        type		=   string
	default		= ""
}


variable "repo_name" {
   description = "ECR repo name"
   type        = string
   default     = "my-ecs-repo"
}


