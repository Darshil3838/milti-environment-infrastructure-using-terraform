#Define the provider
provider "aws" {
  alias  = "central"
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}


# Local variables
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  prefix_main  = "${local.prefix}-${var.env}"
}

module "globalvars" {
  source = "/home/ec2-user/environment/main/Modules/globalvars"
}


# Create a new VPCmain for prod
resource "aws_vpc" "main_prod" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = merge(
    var.default_tags, {
      Name = "${local.prefix_main}_vpc"
    }
  )
}

# Add provisioning of the private subnetin the  prod VPC 
resource "aws_subnet" "private_subnet_prod" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.main_prod.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = var.az[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.prefix_main}_Prod_private_${count.index}"
    }
  )
}
