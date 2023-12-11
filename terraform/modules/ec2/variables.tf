variable "environ" {
  type = string
  description = "Infrastructure environment"
}

variable "project" {
  type = string
  default = "cicdpo.io"
}

variable "tags" {
    type = map(string)
    default = {}
    description = "..."
}

variable "create_eip" {
  type = bool
  default = false
  description = "create EIP or not?"
}

variable "instance_ami" {
  type = string
  description = "AMI of EC2 instance"
}

variable "instance_type" {
  type = string
  description = "Instance type of EC2 instance"
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
    type = list(string)
  default = []
}