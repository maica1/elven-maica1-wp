# module "s3_backend" {
#   source = "./MODULES/s3"

# }
module "main_vpc" {
  source  = "./MODULES/network"
  aws_region      = var.aws_region
  vpc_cidr_block  = var.vpc_cidr_block
  vpc_subnet_pub_az_a_cidr  = var.vpc_subnet_pub_az_a_cidr
  vpc_subnet_pub_az_b_cidr  = var.vpc_subnet_pub_az_b_cidr 
  vpc_subnet_priv_az_a_cidr = var.vpc_subnet_priv_az_a_cidr
  vpc_subnet_priv_az_b_cidr = var.vpc_subnet_priv_az_b_cidr

}

data "external" "my_ip" {
  program = ["sh", "-c", "curl -s https://api.myip.com"]
}

resource "aws_security_group" "ws_sg" {
  name        = "ws_sg"
  description = "allow web traffic and ssh  to ws"
  vpc_id      = module.main_vpc.vpc_id

  tags = {
    Name = "Webservers security group"
    project = "wp-Maica1"
    env     = "study"
    cost    = "free"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ws-rules" {
  count = length(var.ws_sg_ports)
  security_group_id = aws_security_group.ws_sg.id
  from_port = var.ws_sg_ports[count.index]
  to_port = var.ws_sg_ports[count.index]
  ip_protocol = "tcp"
  cidr_ipv4 = var.ws_sg_ports[count.index] == "22" ? "${data.external.my_ip.result.ip}/32" : "0.0.0.0/0" 
}

# module "web_server" {
#   source      = "./MODULES/ec2"
#   aws_region  = var.aws_region
#   ec2_ami     = var.ec2_ami
#   subnet_id   = module.main_vpc.public_subnets
#   ec2_instance_count = var.ec2_instance_count
#   security_group = [aws_security_group.ws_sg.id]
# }