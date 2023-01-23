# Default tags
variable "default_tags" {
  default = {
    "Owner" = "DArshil"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  default     = "Assignment1"
  type        = string
  description = "Name prefix"
}

# Provision public subnets in vpc prod
variable "private_cidr" {
  default     = ["10.100.3.0/24", "10.100.4.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}


# availability zones
variable "az" {
  default     = ["us-east-1b", "us-east-1c"]
  type        = list(string)
  description = "availability zones"
}




# vpc cide  range for vpc prod
variable "vpc_cidr" {
  default     = "10.100.0.0/16"
  type        = string
  description = "VPC to host static web site"
}

#  Variable for current environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Environment"
}

