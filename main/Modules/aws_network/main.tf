#  Define the provider
provider "aws" {
  region = "us-east-1"
}

#  Data source for availability zones in us-east-1
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



# Create a new VPC main for nonprod
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags = merge(
    local.default_tags, {
      Name = "${local.prefix_main}_vpc"
    }
  )
}



# Add provisioning of the private subnetin the non prod VPC 
resource "aws_subnet" "private_subnet_dev" {
  count             = length(var.private_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = var.az[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.prefix_main}_private-subnet_${count.index}"
    }
  )
}




# Add provisioning of the public subnetin the non prod VPC 
resource "aws_subnet" "public_subnet_dev" {
  count             = length(var.public_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = var.az[count.index]
  tags = merge(
    local.default_tags, {
      Name = "${local.prefix_main}_public-subnet_${count.index}"
    }
  )
}



# Create Internet Gateway
resource "aws_internet_gateway" "i_gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags,
    {
      "Name" = "${local.prefix_main}_i_gw"
    }
  )
}





# Create elastic IP for nat geteway
resource "aws_eip" "nat_eip" {
  vpc   = true
  tags = {
    Name = "${local.prefix_main}_natgw"
  }
depends_on = [aws_internet_gateway.i_gw]
}






# Create nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_dev[0].id

  tags = merge(
    local.default_tags, {
      Name = "${local.prefix_main}_nat_gw"
    }
  )


}



#create a private route table for prod vpc 
resource "aws_route_table" "private_route_table_dev" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
   tags = merge(
    local.default_tags, {
      Name = "${local.prefix_main}_private_route_table_dev"
    }
  )
}




#create a public route table for prod vpc 
resource "aws_route_table" "public_route_table_dev" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i_gw.id
  }
  tags = {
    Name = "${local.prefix_main}_public_route_table_dev"
  }
}





# Association of private route table
resource "aws_route_table_association" "private_route_table_ass_dev" {
  count          = length(aws_subnet.private_subnet_dev[*].id)
  route_table_id = aws_route_table.private_route_table_dev.id
  subnet_id      = aws_subnet.private_subnet_dev[count.index].id
}





# Association of the Public route table
resource "aws_route_table_association" "public_route_table_ass_dev" {
  route_table_id = aws_route_table.public_route_table_dev.id
  subnet_id      = aws_subnet.public_subnet_dev[0].id
}

