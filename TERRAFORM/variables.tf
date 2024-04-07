variable "aws_region" {
  default = "us-east-1"
}
variable "ec2_instance_type" {
  default = "t2.micro"
  type    = string
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
  type    = number
  default = 1
}
variable "ec2_ami" {
  default = "ami-0424a16d0e63b113b"
}
variable "certificate_arn" {
  type    = string
  default = null
}
variable "efs_creation_token" {
  type    = string
  default = null
}
variable "efs_id" {
  type    = string
  default = null
}
variable "memcached_port" {
  type    = number
  default = 11211
}
variable "memcached_node_size" {
  type    = string
  default = "cache.t2.micro"
}
variable "memcached_n_nodes" {
  type    = number
  default = 2
}
variable "memcached_parameter_group_name" {
  type    = string
  default = "default.memcached1.6"
}
