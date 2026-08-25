variable "project_name" {
  description = "Name used for security group resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}

variable "container_port" {
  description = "Port exposed by the ECS container"
  type        = number
}