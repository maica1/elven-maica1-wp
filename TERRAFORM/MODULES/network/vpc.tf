module "vpc" {
  
  source = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  name = "vpc-wp-maica1"
  azs  = ["${var.aws_region}a","${var.aws_region}b"]
  
  cidr            = var.vpc_cidr_block
  # enable_ipv6     = true
  enable_dns_hostnames = true
  enable_dns_support =  true

  public_subnets  = [var.vpc_subnet_pub_az_a_cidr,var.vpc_subnet_pub_az_b_cidr]
  # public_subnet_assign_ipv6_address_on_creation = true
  public_subnet_suffix = "sn_pub_az"
  # public_subnet_enable_dns64 = false
  # public_subnet_names = ["sn_pub_az_a","sn_pub_az_b"]
  
  private_subnets = [var.vpc_subnet_priv_az_a_cidr,var.vpc_subnet_priv_az_b_cidr]
  # private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_suffix = "sn_priv_az"
  # private_subnet_enable_dns64 = false
  # private_subnet_names = ["sn_priv_az_a","sn_priv_az_b"]
  
  create_igw              = true
  igw_tags                = { Name = "wp-maica1_igw" }
  enable_nat_gateway      = true
  nat_gateway_tags        = { Name = "wp-maica1_natgw" }
  single_nat_gateway      = true
  one_nat_gateway_per_az  = true


  default_security_group_name = "wp-maica1-default-sg"
   
  tags = {
    project = "wp-Maica1"
    cost = "free"
  }
}

# resource "aws_subnet" "vpc_sn_pub_az_a" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.vpc_subnet_priv_az_a_cidr
#   # ipv6_cidr_block = something/64
#   map_public_ip_on_launch = true
#   availability_zone = var.aws_region
#   enable_dns64 = true
#   enable_resource_name_dns_a_record_on_launch = true
#   enable_resource_name_dns_aaaa_record_on_launch = true
#   tags = {
#     Name = "SN-Pub-AZ-A"
#     cost = "free"
#   }
# }
# resource "aws_subnet" "vpc_sn_pub_az_b" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.vpc_subnet_priv_az_b_cidr
#   # ipv6_cidr_block = something/64
#   map_public_ip_on_launch = true
#   availability_zone = var.aws_region

#   enable_dns64 = true
#   enable_resource_name_dns_a_record_on_launch = true
#   enable_resource_name_dns_aaaa_record_on_launch = true

#   tags = {
#     Name = "SN-Pub-AZ-B"
#     cost = "free"
#   }
# }

# resource "aws_subnet" "vpc_subnet_priv_az_a" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.vpc_subnet_pub_az_a_cidr
#   availability_zone = var.aws_region

#   tags = {
#     Name = "SN-Priv-AZ-A"
#     cost = "free"
#   }
# }
# resource "aws_subnet" "vpc_subnet_priv_az_b" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = var.vpc_subnet_pub_az_b_cidr
#   availability_zone = var.aws_region

#   tags = {
#     Name = "SN-Priv-AZ-B"
#     cost = "free"
#   }
# }

# resource "aws_internet_gateway" "InternetGW-Estudos-Maica1" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "InternetGW-Estudos-Maica1"
#   }
# }

# resource "aws_nat_gateway" "NatGW-Estudos-Maica1" {
#   # Still need to create this aws_eip
#   allocation_id = aws_eip.example.id
#   subnet_id     = aws_subnet.vpc_sn_pub_az_a.id

#   tags = {
#     Name = "NatGW-Estudos-Maica1"
#   }

#   # To ensure proper ordering, it is recommended to add an explicit dependency
#   # on the Internet Gateway for the VPC.
#   depends_on = [aws_internet_gateway.example]
# }


# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.InternetGW-Estudos-Maica1.id
#   }

#   # route {
#   #   ipv6_cidr_block        = "::/0"
#   #   gateway_id = aws_internet_gateway.InternetGW-Estudos-Maica1.id
#   # }

#   tags = {
#     Name = "example"
#   }
# }


# output "public_subnet_ids" {
#   value = aws_subnet.public[*].id
# }