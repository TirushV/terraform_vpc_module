output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.aws_vpc_id
}

# VPC Private Subnets
output "public_subnet_1" {
  description = "List of IDs of private subnets"
  value       = module.vpc.public_subnet1
}

output "alb" {
  value = module.ecs.alb_hostname
}