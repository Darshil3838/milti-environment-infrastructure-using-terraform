


#Add Output variables for vpc 
output "vpc_id" {
  value = aws_vpc.main_prod.id
}

#Add output variables for private_subnet_dev
output "private_subnet_prod" {
  value = aws_subnet.private_subnet_prod[*].id
}

#Add output variables for private_subnet_dev
output "private_ip" {
  value = var.private_cidr
}

#add output variables for private_cider
output "prod_vpc" {
  value = var.vpc_cidr
}
