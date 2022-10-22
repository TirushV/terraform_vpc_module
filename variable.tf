variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "aws_region" {
  default = "ap-south-1"
}

variable "public_subnet_1_cidr" {
  default = "10.0.0.0/24"
}

variable "public_subnet_2_cidr" {
  default = "10.0.1.0/24"
}

variable "public_subnet_3_cidr" {
  default = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  default = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  default = "10.0.4.0/24"
}

variable "private_subnet_3_cidr" {
  default = "10.0.5.0/24"
}

variable "three_public_private_subnets" {
  default = false
}
