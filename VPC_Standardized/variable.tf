variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "public_private_subnets" {
  default = 3
}

variable "enable_HA_for_NAT" {
  default = true
}

variable "public_subnet_cidr" {
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidr" {
  default = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
}