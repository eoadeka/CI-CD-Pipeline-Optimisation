resource "random_shuffle" "subnets" {
  input = var.subnets
  result_count = 1
}

resource "tls_private_key" "tls-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "key-pair" {
  depends_on = [ tls_private_key.tls-key ]
  key_name = var.key_pair
  public_key = tls_private_key.tls-key.public_key_openssh
}

module "ec2_instance" {
    source = "terraform-aws-modules/ec2-instance/aws"
    version = "5.5.0"

    name = "cicdpo-${var.environ}-web"

    ami = var.instance_ami
    instance_type = var.instance_type
    
    subnet_id = random_shuffle.subnets.result[0]
    vpc_security_group_ids = var.security_groups

    user_data = "${file("${path.module}/userdata.sh")}"
    key_name = aws_key_pair.key-pair.key_name

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
    # lifecycle {
    #   prevent_destroy = true
    # }

    tags = {
        Name = "cicdpo-${var.environ}-eip"
        Project = var.project
        Environment = var.environ
    }
}

resource "aws_eip_association" "cicdpo_ip_assoc" {
    count = (var.create_eip) ? 1 : 0

    # instance_id = module.ec2_instance[0].id
    instance_id = module.ec2_instance.id
    allocation_id = aws_eip.cicdpo_ip.id
}