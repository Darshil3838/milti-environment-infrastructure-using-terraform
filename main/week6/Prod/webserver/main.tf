#  Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for AMI id
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}



# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}



# Use remote state to retrieve the data
data "terraform_remote_state" "network_prod1" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "acs730-prod-drdobariya"            // Bucket from where to GET Terraform State
    key    = "prod-networking/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                         // Region where bucket created
  }
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


# Create webserver 1
resource "aws_instance" "wsp1" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key_prod.key_name
  subnet_id                   = data.terraform_remote_state.network_prod1.outputs.private_subnet_prod[0]
  security_groups             = [aws_security_group.prod_sg.id]
  associate_public_ip_address = false


  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.prefix_main}_wsp1"
    }
  )
}



# Create webserver 1
resource "aws_instance" "wsp2" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key_prod.key_name
  subnet_id                   = data.terraform_remote_state.network_prod1.outputs.private_subnet_prod[1]
  security_groups             = [aws_security_group.prod_sg.id]
  associate_public_ip_address = false


  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.prefix_main}_wsp2"
    }
  )
}





# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key_prod" {
  key_name   = local.prefix_main
  public_key = file("${local.prefix_main}.pub")
}


# create ecurity Group For ws1 and ws2 
resource "aws_security_group" "prod_sg" {
  name        = "allow_http_ssh1"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.network_prod1.outputs.vpc_id



  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]

    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.prefix_main}_prod_sg"
    }
  )
}



