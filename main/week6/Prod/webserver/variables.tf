# add type of instance
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "test"    = "t3.micro"
    "staging" = "t2.micro"
    "dev"     = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}



# Variable for Current Environment 
variable "env" {
  default     = "prod"
  type        = string
  description = "Environment"
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


#prefix
variable "prefix" {
  default     = "Assignment1"
  type        = string
  description = "Name Prefix"
}




# availability zones
variable "az" {
  default     = ["us-east-1b", "us-east-1c"]
  type        = list(string)
  description = "availability zones"
}


