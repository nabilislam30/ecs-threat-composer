variable "aws_region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Name used for project resources"
  type        = string
  default     = "threat-composer"
}

variable "domain_name" {
  description = "Root domain name"
  type        = string
  default     = "nabilstack.com"
}

variable "subdomain" {
  description = "Subdomain used for the application"
  type        = string
  default     = "tm"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "container_port" {
  description = "Port exposed by the application container"
  type        = number
  default     = 80
}

variable "task_cpu" {
  description = "CPU units allocated to the ECS task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory allocated to the ECS task in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}