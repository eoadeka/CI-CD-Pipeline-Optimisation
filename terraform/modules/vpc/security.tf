resource "aws_security_group" "public" {
  name = "cicdpo-${var.environ}-public-sg"
  description = "Public internet access"
  vpc_id = module.vpc.vpc_id

    ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

  tags = {
    Name = "cicdpo-${var.environ}-public-sg"
    Project = "cicdpo.io"
    Environment = var.environ
    Terraform = true
    VPC = module.vpc.vpc_id
  }
}

resource "aws_security_group" "private" {
  name = "cicdpo-${var.environ}-private-sg"
  description = "Private internet access"
  vpc_id = module.vpc.vpc_id

  ingress {
        description = "HTTPS"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

  tags = {
    Name = "cicdpo-${var.environ}-private-sg"
    Project = "cicdpo.io"
    Environment = var.environ
    Terraform = true
    VPC = module.vpc.vpc_id
  }
}