variable "aws_region" {
  default = "us-east-1"
}
variable "vpc_cidr_block" {
}
variable "vpc_subnet_pub_az_a_cidr" {
}
variable "vpc_subnet_pub_az_b_cidr" {
}
variable "vpc_subnet_priv_az_a_cidr" {
}
variable "vpc_subnet_priv_az_b_cidr" {
}
variable "ssh_key_name" {
}
variable "aws_access_key" {
}
variable "aws_secret_key" {
}
variable "ec2_instance_count" {
  default = 1
}
variable "ec2_ami" {
  default = "ami-0424a16d0e63b113b"
}

variable "certificate_arn" {
  
}
