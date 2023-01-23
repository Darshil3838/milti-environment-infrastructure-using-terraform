# module to deploy basic networing 
module "vpc" {
  source       = "/home/ec2-user/environment/main/Modules/aws_network"
  env          = var.env
  vpc_cidr     = var.vpc_cidr
  private_cidr = var.private_subnet_cidrs_dev
  public_cidr  = var.public_subnet_cidrs_dev
  prefix       = var.prefix
  default_tags = var.default_tags




}