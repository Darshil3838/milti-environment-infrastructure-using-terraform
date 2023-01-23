
#Add Output variables for vpc 
output "vpc_id" {
  value = module.vpc.vpc_id
}

#Add output variables for private_subnet_dev
output "private_subnet_dev" {
  value = module.vpc.private_subnet_dev
}

#Add output variables for private_subnet_dev
output "public_subnet_dev" {
  value = module.vpc.public_subnet_dev
}



#add output variables for aws_eip
output "aws_eip" {
  value = module.vpc.aws_eip
}



#add output variables for private_cider
output "private_cidr" {
  value = module.vpc.private_cidr
}

#add output variables for public_cider
output "public_cidr" {
  value = module.vpc.public_cidr
}



#add output variables for nat 
output "aws_nat_gateway" {
  value = module.vpc.nat_gateway_id
}
# add output variables for aws_internet_gateway
output "aws_internet_gateway" {
  value = module.vpc.aws_internet_gateway
}




#add output variables for public route table
output "public_route_table_dev" {
  value = module.vpc.public_route_table_dev
}




#add output variables for public route table 
output "private_route_table_dev" {
  value = module.vpc.private_route_table_dev
}

