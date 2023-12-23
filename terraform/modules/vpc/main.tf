module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "5.4.0"
    
    name = "cicdpo-${var.environ}-vpc"

    cidr = var.vpc_cidr

    azs = var.azs

    enable_nat_gateway = true
    single_nat_gateway = true
    one_nat_gateway_per_az = false

    public_subnets = var.public_subnets
    private_subnets = var.private_subnets

    public_subnet_tags = {
      Name = "VPC Public Subnet - ${var.environ}"
    }

    private_subnet_tags = {
      Name = "VPC Private Subnet - ${var.environ}"
    }


    tags = {
      Name = "cicdpo-${var.environ}-vpc"
      Project = "cicdpo.io"
      Environment = var.environ
      Terraform = true
    }
}