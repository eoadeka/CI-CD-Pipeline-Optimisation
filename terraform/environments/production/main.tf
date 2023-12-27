locals {
  instance_type = "t2.micro"
}

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
  instance_ami =  data.aws_ami.amazon-linux-2.id
  instance_type = local.instance_type
  subnets = module.vpc.vpc_public_subnets
  security_groups = [module.vpc.security_group_public]
  create_eip = true
  key_pair = "cicdpo-${var.environ}-key"

  tags = {
    Name = "cicdpo-production-web"
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

module "autoscaling" {
  source = "../../modules/autoscaling"

  environ = var.environ

  ami = data.aws_ami.amazon-linux-2.id
  instance_type = local.instance_type

  max_size = 3
  min_size = 3
  desired_capacity = 3
  vpc_zone_identifier = module.vpc.vpc_private_subnets
  target_group_arns = [module.alb.aws_lb_target_group_arn ]
  # vpc_zone_identifier = [ for i in module.vpc.vpc_private_subnets[*] : i.private_subnets  ] 
  # target_group_arns = [ module.elb.target_group_arns ]

  security_groups = [module.vpc.security_group_public]
}

module "alb" {
  source = "../../modules/elb"

  environ = var.environ
  azs = [ "eu-west-2a", "eu-west-2b" ]

  security_groups    = [module.vpc.security_group_public]
  subnets            = module.vpc.vpc_public_subnets

  vpc_id = module.vpc.vpc_id

}

