# module "s3_backend" {
#   source = "./MODULES/s3"

# }
module "main_vpc" {
  source                    = "./MODULES/network"
  aws_region                = var.aws_region
  vpc_cidr_block            = var.vpc_cidr_block
  vpc_subnet_pub_az_a_cidr  = var.vpc_subnet_pub_az_a_cidr
  vpc_subnet_pub_az_b_cidr  = var.vpc_subnet_pub_az_b_cidr
  vpc_subnet_priv_az_a_cidr = var.vpc_subnet_priv_az_a_cidr
  vpc_subnet_priv_az_b_cidr = var.vpc_subnet_priv_az_b_cidr

}

data "external" "my_ip" {
  program = ["sh", "-c", "curl -s https://api.myip.com"]
}
resource "aws_security_group" "hm_sg" {
  name        = "hm_sg"
  description = "allow web traffic and ssh  to hm"
  vpc_id      = module.main_vpc.vpc_id

  tags = {
    Name    = "Health monitor security group"
    project = "wp-Maica1"
    env     = "study"
    cost    = "free"
  }
}

resource "aws_vpc_security_group_ingress_rule" "hm-irules" {
  count             = length(var.hm_sg_ports)
  security_group_id = aws_security_group.hm_sg.id
  from_port         = var.hm_sg_ports[count.index]
  to_port           = var.hm_sg_ports[count.index]
  ip_protocol       = "tcp"
  cidr_ipv4         = var.hm_sg_ports[count.index] == "22" || var.hm_sg_ports[count.index] =="9090" ? "${data.external.my_ip.result.ip}/32" : null
  referenced_security_group_id =  var.hm_sg_ports[count.index] == "9100" ? aws_security_group.hm_sg.id : null
}
resource "aws_vpc_security_group_egress_rule" "hm-erules" {
  security_group_id = aws_security_group.hm_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "ansible_group" "hm" {
  name = "hm"
}
module "healthmonitor" {
  source             = "./MODULES/healthmonitor"
  ec2_instance_name = "hm"
  aws_region         = var.aws_region
  ec2_ami            = var.ec2_ami
  subnet_id          = module.main_vpc.public_subnets
  ec2_instance_count = 1
  security_group     = [aws_security_group.hm_sg.id]
}

resource "ansible_host" "hm" {
  count = 1
  name   = module.healthmonitor.public_dns[count.index]
  groups = ["hm"]
}
resource "aws_security_group" "ws_sg" {
  name        = "ws_sg"
  description = "allow web traffic and ssh  to ws"
  vpc_id      = module.main_vpc.vpc_id

  tags = {
    Name    = "Webservers security group"
    project = "wp-Maica1"
    env     = "study"
    cost    = "free"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ws-irules" {
  count             = length(var.ws_sg_ports)
  security_group_id = aws_security_group.ws_sg.id
  from_port         = var.ws_sg_ports[count.index]
  to_port           = var.ws_sg_ports[count.index]
  ip_protocol       = "tcp"
  cidr_ipv4         = var.ws_sg_ports[count.index] == "22" ? "${data.external.my_ip.result.ip}/32" : "0.0.0.0/0"
}
resource "aws_vpc_security_group_egress_rule" "ws-erules" {
  security_group_id = aws_security_group.ws_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "ansible_group" "web_servers" {
  name = "web_servers"
}

module "web_server" {
  source             = "./MODULES/ec2"
  aws_region         = var.aws_region
  ec2_ami            = var.ec2_ami
  subnet_id          = module.main_vpc.public_subnets
  ec2_instance_name = "ws"
  ec2_instance_count = var.ec2_instance_count
  security_group     = [aws_security_group.ws_sg.id]
}

resource "ansible_host" "ws" {
  count = var.ec2_instance_count
  name   = module.web_server.public_dns[count.index]
  groups = ["web_servers"]
}

resource "aws_route53_zone" "main" {
  name = "maica1.site"

  tags = {
    project = "wp-maica1"
    env     = "study"
  }
}

resource "aws_route53_record" "www" {
  count      = var.ec2_instance_count
  zone_id    = aws_route53_zone.main.zone_id
  name       = join(".", [split(".", module.web_server.private_dns[count.index])[0], "maica1.site"])
  type       = "A"
  ttl        = 300
  records    = [module.web_server.public_ip[count.index]]
  depends_on = [aws_route53_zone.main]
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "allow mysql traffic"
  vpc_id      = module.main_vpc.vpc_id

  tags = {
    Name    = "Database security group"
    project = "wp-Maica1"
    env     = "study"
    cost    = "free"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db-irules" {
  security_group_id            = aws_security_group.db_sg.id
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
  referenced_security_group_id = aws_security_group.ws_sg.id
}

# resource "aws_vpc_security_group_ingress_rule" "db-icmp" {
#   security_group_id = aws_security_group.db_sg.id
#   from_port = 0
#   to_port = 8
#   ip_protocol = "icmp"
#   referenced_security_group_id = aws_security_group.ws_sg.id
# }

module "db" {
  source = "./MODULES/rds"

  database_subnets   = module.main_vpc.private_subnets
  rds_instance_name  = "wp-db-maica1"
  db_engine          = "mysql"
  db_version         = "8.0.35"
  security_group_ids = [aws_security_group.db_sg.id]
  db_username        = "admin"
  db_name            = "blog"
  storage_type       = "gp2"
}
