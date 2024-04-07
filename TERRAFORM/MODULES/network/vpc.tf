module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.2"

  name = "vpc-wp-maica1"
  azs  = ["${var.aws_region}a", "${var.aws_region}c"]

  cidr = var.vpc_cidr_block
  # enable_ipv6     = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnets          = [var.vpc_subnet_pub_az_a_cidr, var.vpc_subnet_pub_az_b_cidr]
  map_public_ip_on_launch = true
  # public_subnet_assign_ipv6_address_on_creation = true
  public_subnet_suffix = "sn_pub_az"
  # public_subnet_enable_dns64 = false
  # public_subnet_names = ["sn_pub_az_a","sn_pub_az_b"]

  private_subnets = [var.vpc_subnet_priv_az_a_cidr, var.vpc_subnet_priv_az_b_cidr]
  # private_subnet_assign_ipv6_address_on_creation = true
  private_subnet_suffix = "sn_priv_az"
  # private_subnet_enable_dns64 = false
  # private_subnet_names = ["sn_priv_az_a","sn_priv_az_b"]
  # database_subnets_cidr_blocks    = [var.vpc_subnet_priv_az_b_cidr]


  create_igw             = true
  igw_tags               = { Name = "wp-maica1_igw" }
  enable_nat_gateway     = true
  nat_gateway_tags       = { Name = "wp-maica1_natgw" }
  single_nat_gateway     = true
  one_nat_gateway_per_az = true


  default_security_group_name = "wp-maica1-default-sg"

  tags = {
    project = "wp-Maica1"
    env     = "study"
    cost    = "free"
  }
}