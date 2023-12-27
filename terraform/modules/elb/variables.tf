variable "azs" {
  type = list(string)
}

variable "environ" {
  type = string
  description = "Infrastructure environment"
}

variable "security_groups" {
  type = list(string)
  default = [ "172.16.0.0/24", "172.16.1.0/24" ]
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
  description = "VPC id"
}

