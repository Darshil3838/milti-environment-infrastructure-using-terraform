# Default tags
variable "default_tags" {
  default = {
    "Owner" = "DArshil"
    "App"   = "Network"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "Assignment1"
  description = "Name prefix"
}


# Provision private subnets in  nonprod vpc
variable "private_subnet_cidrs_dev" {
  default     = ["10.1.3.0/24", "10.1.4.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}

# Provision public subnets in nonprod vpc
variable "public_subnet_cidrs_dev" {
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}


# vpc cide  range for vpc nonprod
variable "vpc_cidr" {
  default     = "10.1.0.0/16"
  type        = string
  description = "VPC to host static web site"
}

# Variable for current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Environment"
}

