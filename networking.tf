locals {
  availability_zones = ["${var.region}a", "${var.region}b"]
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr

  azs             = local.availability_zones
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr

  enable_nat_gateway = false
  enable_vpn_gateway = false
 
}

/*




resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.eks_name}-vpc"
    Terraform = "true"
    Environment = "dev"
  }

}

resource "aws_subnet" "public-subnets" {
  vpc_id     = aws_vpc.main.id

  count = length(var.public_subnets_cidr)
  cidr_block = element(var.public_subnets_cidr, count.index)

  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${element(var.availability_zones, count.index)}-public-subnet"
  }
}

resource "aws_subnet" "private-subnets" {
  vpc_id     = aws_vpc.main.id

  count = length(var.private_subnets_cidr)
  cidr_block = element(var.private_subnets_cidr, count.index)

  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "${element(var.availability_zones, count.index)}-private-subnet"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "private-route-table"
  }
}



resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

*/