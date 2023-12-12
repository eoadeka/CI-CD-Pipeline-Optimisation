variable "azs" {
  type = list(string)
}

variable "environ" {
  type = string
  description = "Infrastructure environment"
}

variable "security_groups" {
  type = list(string)
  default = []
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
  description = "VPC id"
}

