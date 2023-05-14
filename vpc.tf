resource "aws_vpc" "VPC-estudos-Maica1" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "VPC-estudos-Maica1"
    cost = "free"
  }
}

resource "aws_subnet" "vpc_sn_pub_az_a" {
  vpc_id     = aws_vpc.VPC-estudos-Maica1.id
  cidr_block = var.vpc_subnet_priv_az_a_cidr
  availability_zone = var.aws_region

  tags = {
    Name = "Pub-AZ-A"
  }
}
resource "aws_subnet" "vpc_sn_pub_az_b" {
  vpc_id     = aws_vpc.VPC-estudos-Maica1.id
  cidr_block = var.vpc_subnet_priv_az_b_cidr
  availability_zone = var.aws_region

  tags = {
    Name = "Pub-AZ-B"
  }
}

resource "aws_subnet" "vpc_subnet_priv_az_a" {
  vpc_id     = aws_vpc.VPC-estudos-Maica1.id
  cidr_block = var.vpc_subnet_pub_az_a_cidr
  availability_zone = var.aws_region

  tags = {
    Name = "Priv-AZ-A"
  }
}
resource "aws_subnet" "vpc_subnet_priv_az_b" {
  vpc_id     = aws_vpc.VPC-estudos-Maica1.id
  cidr_block = var.vpc_subnet_pub_az_b_cidr
  availability_zone = var.aws_region

  tags = {
    Name = "Priv-AZ-B"
  }
}
