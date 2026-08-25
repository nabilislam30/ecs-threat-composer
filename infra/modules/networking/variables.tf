variable "project_name" {
  description = "Name used for networking resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  type        = string
}

variable "availability_zone_1" {
  description = "Availability Zone for public subnet 1"
  type        = string
}

variable "availability_zone_2" {
  description = "Availability Zone for public subnet 2"
  type        = string
}