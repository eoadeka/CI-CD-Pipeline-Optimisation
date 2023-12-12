variable "environ" {
  type = string
  description = "Infrastructure environment"
}

variable "ami" {
  type = string
  description = "AMI of EC2 instance"
}

variable "instance_type" {
  type = string
  description = "Instance type of EC2 instance"
}

variable "security_groups" {
    type = list(string)
    default = []
}

variable "target_group_arns" {
    type = list(string)
    default = []
}

# variable "network_interfaces" {
#   type = map(string)
# }

variable "desired_capacity" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "vpc_zone_identifier" {
  type = list(string)
  default = []
}

