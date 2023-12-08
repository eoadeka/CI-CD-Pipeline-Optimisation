variable "environ" {
  type = string
  description = "Infrastructure environment"
}

variable "project" {
  type = string
  default = "cicdpo.io"
}

variable "public_subnets" {
  type = list(string)
  description = "public subnets"
}

variable "private_subnets" {
  type = list(string)
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
}

