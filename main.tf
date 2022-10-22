module "vpc" {
  source                       = "./vpc"
  three_public_private_subnets = var.three_public_private_subnets
  enable_HA_for_NAT = var.enable_HA_for_NAT
  
  public_subnet_1_cidr         = var.public_subnet_1_cidr
  public_subnet_2_cidr         = var.public_subnet_2_cidr
  public_subnet_3_cidr         = var.public_subnet_3_cidr
  private_subnet_1_cidr        = var.private_subnet_1_cidr
  private_subnet_2_cidr        = var.private_subnet_2_cidr
  private_subnet_3_cidr        = var.private_subnet_3_cidr
}

