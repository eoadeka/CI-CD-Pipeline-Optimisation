resource "random_shuffle" "subnets" {
  input = var.subnets
  result_count = 1
}

module "ec2_instance" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "5.5.0"

    name = "cicdpo-${var.environ}-web"

    ami = var.instance_ami
    instance_type = var.instance_type
    
    subnet_id = random_shuffle.subnets.result[0]
    vpc_security_group_ids = var.security_groups

    tags = merge(
        {
        Name = "cicdpo-${var.environ}-web"
        Project = var.project
        Environment = var.environ
        Terraform = true
        },
        var.tags
    )
}

resource "aws_eip" "cicdpo_ip" {
    lifecycle {
      prevent_destroy = true
    }

    tags = {
        Name = "cicdpo-${var.environ}-eip"
        Project = var.project
        Environment = var.environ
    }
}

resource "aws_eip_association" "cicdpo_ip_assoc" {
    count = (var.create_eip) ? 1 : 0

    instance_id = module.ec2-instance[0].id
    allocation_id = aws_eip.cicdpo_ip[0].id
}