
#Add Output variables for vpc
output "vpc_id" {
  value = aws_vpc.main.id
}

#Add output variables for private_subnet_dev
output "private_subnet_dev" {
  value = aws_subnet.private_subnet_dev[*].id
}


#Add output variables for [public_subnet_dev]
output "public_subnet_dev" {
  value = aws_subnet.public_subnet_dev[*].id
}



#add output variables for nat 
output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}

# add output variables for aws_internet_gateway
output "aws_internet_gateway" {
  value = aws_internet_gateway.i_gw.id
}




 
#add output variables for aws_eip
output "aws_eip" {
  value = aws_eip.nat_eip.id
}




#add output variables for public route table
output "public_route_table_dev" {
  value = aws_route_table.private_route_table_dev.id
}


# Output variables forprivate route table
output "private_route_table_dev" {
  value = aws_route_table.private_route_table_dev.id
}




#add output variables for public_cider
output "public_cidr" {
  value = var.public_cidr
}
#add output variables for public_cider
output "private_cidr" {
  value = var.private_cidr
}