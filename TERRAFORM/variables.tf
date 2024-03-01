variable "aws_region" {
  default = "sa-east-1"
}

variable "vpc_cidr_block" {
  default = "10.18.0.0/16"
}
variable "vpc_subnet_pub_az_a_cidr" {
  default = "10.18.1.0/24"
}   
variable "vpc_subnet_pub_az_b_cidr" {
  default = "10.18.3.0/24"
}   
variable "vpc_subnet_priv_az_a_cidr" {
  default = "10.18.0.0/24"
}   
variable "vpc_subnet_priv_az_b_cidr" {
  default = "10.18.2.0/24"
}   

variable "ssh_key_name" {
  default = "New windows key"
}
variable "aws_access_key"{
}
variable "aws_secret_key"{

}

variable "ec2_instance_count" {
  default = 2
}

variable "ec2_ami" {
  default = "ami-0424a16d0e63b113b"
}

variable "ws_sg_ports" {
  type = list
  default = ["22","80","443"]
}
# variable "provisioner_public_ip" {
# }
