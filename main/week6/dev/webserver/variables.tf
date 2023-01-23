# add type of instance
variable "instance_type" {
  default = {
    "test"    = "t3.micro"
    "staging" = "t2.micro"
    "dev"     = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Default tags
variable "default_tags" {
  default = {
    "Owner" = "DArshil"
    "App"   = "Web"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"

}



# availability zones
variable "az" {
  default     = ["us-east-1b", "us-east-1c"]
  type        = list(string)
  description = "availability zones"
}


# Prefix
variable "prefix" {
  default     = "Assignment1"
  type        = string
  description = "Name prefix"
}

# Variable for Current Environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Environment"
}




