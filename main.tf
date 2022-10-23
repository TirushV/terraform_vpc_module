module "vpc" {
  source                       = "./vpc"
  three_public_private_subnets = var.three_public_private_subnets
  enable_HA_for_NAT            = var.enable_HA_for_NAT

  vpc_cidr              = var.vpc_cidr
  public_subnet_1_cidr  = var.public_subnet_1_cidr
  public_subnet_2_cidr  = var.public_subnet_2_cidr
  public_subnet_3_cidr  = var.public_subnet_3_cidr
  private_subnet_1_cidr = var.private_subnet_1_cidr
  private_subnet_2_cidr = var.private_subnet_2_cidr
  private_subnet_3_cidr = var.private_subnet_3_cidr
}

module "ecs" {
  source = "./ecs"

  vpc_id = module.vpc.aws_vpc_id

  environment = var.environment
  name        = var.name

  container_name  = var.container_name
  container_image = var.container_image
  container_port  = var.container_port
  public_subnets  = [module.vpc.public_subnet1, module.vpc.public_subnet2]
  private_subnets = [module.vpc.private_subnet1, module.vpc.private_subnet2]
}