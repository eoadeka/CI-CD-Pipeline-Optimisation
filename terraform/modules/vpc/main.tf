module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    version = "2.77.0"
    
    name = "cicdpo-${var.environ}-vpc"

    cidr = var.vpc_cidr

    azs = var.azs

    enable_nat_gateway = true
    single_nat_gateway = true
    one_nat_gateway_per_az = false

    public_subnets = var.public_subnets
    private_subnets = var.private_subnets

    tags = {
      Name = "cicdpo-${var.environ}-vpc"
      Project = "cicdpo.io"
      Environment = var.environ
      Terraform = true
    }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id = aws_vpc.cicdpo_vpc.id
  availability_zone = each.key

  cidr_block = cidrsubnet(aws_vpc.cicdpo_vpc.cidr_block, 4, each.value)

  tags = {
        Name = "cicdpo-${var.environ}-public-subnet"
        Project = "cicdpo.io"
        Environment = var.environ
        Terraform = true
        Subnet = "${each.key}-${each.value}"
    }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.cicdpo_vpc.id
  availability_zone = each.key

  cidr_block = cidrsubnet(aws_vpc.cicdpo_vpc.cidr_block, 4, each.value)

  tags = {
    Name = "cicdpo-${var.environ}-private-subnet"
    Project = "cicdpo.io"
    Environment = var.environ
    Terraform = true
    Subnet = "${each.key}-${each.value}"
}
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.cicdpo_vpc.id

    tags = {
        Name = "cicdpo-${var.environ}-igw"
        Project = "cicdpo.io"
        Environment = var.environ
        Terraform = true
        VPC = aws_vpc.cicdpo_vpc.id
    }
}

resource "aws_eip" "nat" {
  tags = {
        Name = "cicdpo-${var.environ}-eip"
        Project = "cicdpo.io"
        Environment = var.environ
        Terraform = true
        VPC = aws_vpc.cicdpo_vpc.id
    }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public[element(keys(aws_subnet.public), 0)].id

  tags = {
        Name = "cicdpo-${var.environ}-nat"
        Project = "cicdpo.io"
        Environment = var.environ
        Terraform = true
        VPC = aws_vpc.cicdpo_vpc.id
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.cicdpo_vpc.id
    tags = {
        Name = "cicdpo-${var.environ}-public-route-table"
        Project = "cicdpo.io"
        Environment = var.environ
        Terraform = true
        VPC = aws_vpc.cicdpo_vpc.id
    }
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.cicdpo_vpc.id
    tags = {
        Name = "cicdpo-${var.environ}-private-route-table"
        Project = "cicdpo.io"
        Environment = var.environ
        Terraform = true
        VPC = aws_vpc.cicdpo_vpc.id
    }
}

resource "aws_route" "public" {
  route_table_id = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id = aws_subnet.public[each.key].id

  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id = aws_subnet.private[each.key].id

  route_table_id = aws_route_table.private.id
}