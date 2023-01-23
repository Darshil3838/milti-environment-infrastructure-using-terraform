
#  Define the provider
provider "aws" {
  region = "us-east-1"
}



# Use remote state to retrieve the data from non prod
data "terraform_remote_state" "dev_vpc" {
  backend = "s3"
  config = {
    bucket = "acs730-dev-drdobariya"            // Bucket where to SAVE Terraform State
    key    = "dev-networking/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                        // Region where bucket is created
  }
}




# Use remote state to retrieve the data from prod
data "terraform_remote_state" "prod_vpc" {
  backend = "s3"
  config = {
    bucket = "acs730-prod-drdobariya"            // Bucket where to SAVE Terraform State
    key    = "prod-networking/terraform.tfstate" // Object name in the bucket to SAVE Terraform State
    region = "us-east-1"                         // Region where bucket is created
  }
}



#create a vpc connection
resource "aws_vpc_peering_connection" "vpc_peer" {
  peer_vpc_id = data.terraform_remote_state.prod_vpc.outputs.vpc_id
  vpc_id      = data.terraform_remote_state.dev_vpc.outputs.vpc_id
  auto_accept = true

  tags = {
    Name = "vpv to vpv connection"
  }
}




#create a vpc connection
resource "aws_vpc_peering_connection_options" "peer_connection" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer.id


  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}





#create a rout table 
resource "aws_route_table" "route_non" {
  vpc_id = data.terraform_remote_state.dev_vpc.outputs.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.terraform_remote_state.dev_vpc.outputs.aws_internet_gateway
  }
  route {
    cidr_block                = data.terraform_remote_state.prod_vpc.outputs.prod_vpc
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer.id
  }
  depends_on = [aws_vpc_peering_connection.vpc_peer]
  tags = {
    Name = "route_non"
  }
}





#creat a rout table
resource "aws_route_table" "rout_prod" {
  vpc_id = data.terraform_remote_state.prod_vpc.outputs.vpc_id
  route {
    cidr_block                = "10.1.2.0/24"
    vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peer.id
  }
  depends_on = [aws_vpc_peering_connection.vpc_peer]
  tags = {
    Name = "rout_prod"
  }
}




# create association of route table    
resource "aws_route_table_association" "route_non_asso" {
  route_table_id = aws_route_table.route_non.id
  subnet_id      = data.terraform_remote_state.dev_vpc.outputs.public_subnet_dev[1]
}


# create association of route table 
resource "aws_route_table_association" "rout_prod_asso" {
  count          = length(data.terraform_remote_state.prod_vpc.outputs.private_subnet_prod)
  route_table_id = aws_route_table.rout_prod.id
  subnet_id      = data.terraform_remote_state.prod_vpc.outputs.private_subnet_prod[count.index]
}

