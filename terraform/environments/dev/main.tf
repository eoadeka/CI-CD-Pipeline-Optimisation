locals {
  instance_type = "t2.micro"
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

# #   owners = ["099720109477"] # Canonical
# }

data "aws_ami" "amazon-linux-2" {
 most_recent = true


 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

module "ec2" {
  source = "../../modules/ec2"

  environ = var.environ
  instance_ami = data.aws_ami.amazon-linux-2.id
  instance_type = local.instance_type
  subnets = module.vpc.vpc_public_subnets
  security_groups = [module.vpc.security_group_public] 
  create_eip = true
  key_pair = "cicdpo-${var.environ}-key"

  tags = {
    Name = "cicdpo-dev-web"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  environ = var.environ
  vpc_cidr = "10.0.0.0/17"

  azs = [ "eu-west-2a", "eu-west-2b" ]
  public_subnets = slice(cidrsubnets("10.0.0.0/16", 4, 4, 4, 4, 4, 4), 0, 3)
  private_subnets = slice(cidrsubnets("10.0.0.0/16", 4, 4, 4, 4, 4, 4), 3, 6)
}

# module "s3" {
#   source = "../../modules/s3"
#   environ = var.environ
# }