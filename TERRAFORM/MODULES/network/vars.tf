# VPC

variable "aws_region" {
  # default = null
}
variable "vpc_cidr_block" {
  default = null
}
variable "vpc_subnet_pub_az_a_cidr" {
  default = null
}
variable "vpc_subnet_pub_az_b_cidr" {
  default = null
}
variable "vpc_subnet_priv_az_a_cidr" {
  default = null
}
variable "vpc_subnet_priv_az_b_cidr" {
  default = null
}