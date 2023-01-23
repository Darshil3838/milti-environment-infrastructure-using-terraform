# Default tags
variable "default_tags" {
  default = { }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
default = "Assignment1"
  type        = string
  description = "Name prefix"
  
}

# Provision public subnets in vpc nonprod
variable "private_cidr" {

  type        = list(string)
  description = "Private Subnet CIDRs"
}

# Provision public subnets in vpc nonprod
variable "public_cidr" {

  type        = list(string)
  description = "public Subnet CIDRs"
  
}


# vpc cide  range for vpc nonprod
variable "vpc_cidr" {

  type        = string
  description = "VPC to host static web site"
}


# variable for current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}



# availability zones
variable "az" {
  default     = ["us-east-1b", "us-east-1c"]
  type        = list(string)
  description = "availability zones"
}


