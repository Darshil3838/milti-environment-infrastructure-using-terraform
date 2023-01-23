
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
data "terraform_remote_state" "network_dev" {
  backend = "s3"
  config = {
    bucket = "acs730-${var.env}-drdobariya"
    key    = "${var.env}-networking/terraform.tfstate"
    region = "us-east-1"
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
resource "aws_instance" "ws1" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network_dev.outputs.private_subnet_dev[0]
  security_groups             = [aws_security_group.sg_web.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl", {
    env    = upper(var.env),
    prefix = upper(var.prefix)
    }

  )

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.prefix_main}_ws1"
    }
  )
}

#create webserver 2 
resource "aws_instance" "ws2" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network_dev.outputs.private_subnet_dev[1]
  security_groups             = [aws_security_group.sg_web.id]
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl", {
    env    = upper(var.env),
    prefix = upper(local.prefix)
    }

  )

  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.prefix_main}_ws2"
    }
  )
}


# Adding SSH key to Amazon EC2
resource "aws_key_pair" "web_key" {
  key_name   = local.prefix_main
  public_key = file("${local.prefix_main}.pub")
}


# Security Group For ws1 and ws2
resource "aws_security_group" "sg_web" {
  name        = "webserver traffic"
  description = "webserver traffic"
  vpc_id      = data.terraform_remote_state.network_dev.outputs.vpc_id

  ingress {
    description      = "HTTP from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups  = [aws_security_group.sg_b.id]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    security_groups  = [aws_security_group.sg_b.id]
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
      "Name" = "${local.prefix_main}_sg_web"
    }
  )
}




# Create Bastion Server
resource "aws_instance" "b_server" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = data.terraform_remote_state.network_dev.outputs.public_subnet_dev[1]
  security_groups             = [aws_security_group.sg_b.id]
  associate_public_ip_address = true


  root_block_device {
    encrypted = var.env == "prod" ? true : false
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.prefix_main}_b_server"
    }
  )
}


# Security Group for bastian serevr
resource "aws_security_group" "sg_b" {
  name        = "bastian traffic"
  description = "bastian traffic"
  vpc_id      = data.terraform_remote_state.network_dev.outputs.vpc_id


  ingress {
    description      = "SSH from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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
      "Name" = "${local.prefix_main}_sg_b"
    }
  )
}
