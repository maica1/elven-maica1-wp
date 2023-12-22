resource "aws_vpc" "VPC-estudos-Maica1" {
  cidr_block = var.vpc_cidr_block
  # ipv6_cidr_block = "something/64"
  tags = {
    Name = "VPC-estudos-Maica1"
    cost = "free"
  }
}

resource "aws_subnet" "vpc_sn_pub_az_a" {
  vpc_id     = aws_vpc.VPC-estudos-Maica1.id
  cidr_block = var.vpc_subnet_priv_az_a_cidr
  # ipv6_cidr_block = something/64
  map_public_ip_on_launch = true
  availability_zone = var.aws_region

  enable_dns64 = true
  enable_resource_name_dns_a_record_on_launch = true
  enable_resource_name_dns_aaaa_record_on_launch = true
  tags = {
    Name = "Pub-AZ-A"
  }
}
resource "aws_subnet" "vpc_sn_pub_az_b" {
  vpc_id     = aws_vpc.VPC-estudos-Maica1.id
  cidr_block = var.vpc_subnet_priv_az_b_cidr
  # ipv6_cidr_block = something/64
  map_public_ip_on_launch = true
  availability_zone = var.aws_region

  enable_dns64 = true
  enable_resource_name_dns_a_record_on_launch = true
  enable_resource_name_dns_aaaa_record_on_launch = true

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

resource "aws_internet_gateway" "InternetGW-Estudos-Maica1" {
  vpc_id = aws_vpc.VPC-estudos-Maica1.id

  tags = {
    Name = "InternetGW-Estudos-Maica1"
  }
}

resource "aws_nat_gateway" "NatGW-Estudos-Maica1" {
  # Still need to create this aws_eip
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.vpc_sn_pub_az_a.id

  tags = {
    Name = "NatGW-Estudos-Maica1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.example]
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.VPC-estudos-Maica1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.InternetGW-Estudos-Maica1.id
  }

  # route {
  #   ipv6_cidr_block        = "::/0"
  #   gateway_id = aws_internet_gateway.InternetGW-Estudos-Maica1.id
  # }

  tags = {
    Name = "example"
  }
}