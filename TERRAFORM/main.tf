# module "s3_backend" {
#   source = "./MODULES/s3"

# }

# CREATE MAIN VPC
module "main_vpc" {
  source                    = "./MODULES/network"
  aws_region                = var.aws_region
  vpc_cidr_block            = var.vpc_cidr_block
  vpc_subnet_pub_az_a_cidr  = var.vpc_subnet_pub_az_a_cidr
  vpc_subnet_pub_az_b_cidr  = var.vpc_subnet_pub_az_b_cidr
  vpc_subnet_priv_az_a_cidr = var.vpc_subnet_priv_az_a_cidr
  vpc_subnet_priv_az_b_cidr = var.vpc_subnet_priv_az_b_cidr

}
# GET MY PUBLIC IP SO I CAN CREATE SG RULES WITH IT
data "external" "my_ip" {
  program = ["sh", "-c", "curl -s https://api.myip.com"]
}
# CREATES SG FOR HM, THEN CREATES INGRESS AND EGRESS RULES
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

locals {
  hm_rules = [
    { port = "9100", target = "${aws_security_group.hm_sg.id}" },
    { port = "9090", target = "${data.external.my_ip.result.ip}/32" },
    { port = "3000", target = "0.0.0.0/0" },
    { port = "22", target = "${data.external.my_ip.result.ip}/32" }
  ]
}

resource "aws_vpc_security_group_ingress_rule" "hm-irules" {
  count                        = length(local.hm_rules)
  security_group_id            = aws_security_group.hm_sg.id
  from_port                    = local.hm_rules[count.index].port
  to_port                      = local.hm_rules[count.index].port
  ip_protocol                  = "tcp"
  cidr_ipv4                    = length(regexall("\\d/[0-9]{1,2}$", local.hm_rules[count.index].target)) > 0 ? local.hm_rules[count.index].target : null
  referenced_security_group_id = length(regexall("\\d/[0-9]{1,2}$", local.hm_rules[count.index].target)) > 0 ? null : local.hm_rules[count.index].target
}
resource "aws_vpc_security_group_egress_rule" "hm-erules" {
  security_group_id = aws_security_group.hm_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "ansible_group" "hm" {
  name = "hm"
}
resource "aws_instance" "hm" {
  ami                    = var.ec2_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = module.main_vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.hm_sg.id]

  key_name                    = var.ssh_key_name
  associate_public_ip_address = true

  tags = {
    Name    = "hm-1"
    env     = "study"
    cost    = "free-tier"
    project = "wp-Maica1"
  }
}

resource "ansible_host" "hm" {
  name   = aws_instance.hm.public_dns
  groups = ["hm"]
}
resource "aws_security_group" "memcache_sg" {
  name        = "memcache_sg"
  description = "Security group for memcached cluster"
  vpc_id      = module.main_vpc.vpc_id

  ingress {
    from_port       = var.memcached_port
    to_port         = var.memcached_port
    protocol        = "tcp"
    security_groups = [aws_security_group.ws_sg.id]
  }
  ingress {
    from_port       = var.memcached_port
    to_port         = var.memcached_port
    protocol        = "udp"
    security_groups = [aws_security_group.ws_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_elasticache_subnet_group" "memcache-wp" {
  name       = "cache-subnets"
  subnet_ids = module.main_vpc.private_subnets
}
resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "wordpress-memcached"
  engine               = "memcached"
  node_type            = var.memcached_node_size
  num_cache_nodes      = var.memcached_n_nodes
  az_mode              = "cross-az"
  parameter_group_name = var.memcached_parameter_group_name
  security_group_ids   = [aws_security_group.memcache_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.memcache-wp.name
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

locals {
  ws_sg_ports = [
    { port = "22", target = "${data.external.my_ip.result.ip}/32" },
    { port = "80", target = "0.0.0.0/0" },
    { port = "9100", target = "${aws_security_group.hm_sg.id}" },
    { port = "9115", target = "${aws_security_group.hm_sg.id}" },
    { port = "9113", target = "${aws_security_group.hm_sg.id}" },
    { port = "443", target = "0.0.0.0/0" },
    { port = "2049", target = "${aws_security_group.efs_sg.id}" }

  ]
}
resource "aws_vpc_security_group_ingress_rule" "ws-irules" {
  count                        = length(local.ws_sg_ports)
  security_group_id            = aws_security_group.ws_sg.id
  from_port                    = local.ws_sg_ports[count.index].port
  to_port                      = local.ws_sg_ports[count.index].port
  ip_protocol                  = "tcp"
  cidr_ipv4                    = length(regexall("\\d/[0-9]{1,2}$", local.ws_sg_ports[count.index].target)) > 0 ? local.ws_sg_ports[count.index].target : null
  referenced_security_group_id = length(regexall("\\d/[0-9]{1,2}$", local.ws_sg_ports[count.index].target)) > 0 ? null : local.ws_sg_ports[count.index].target
}

resource "aws_vpc_security_group_egress_rule" "ws-erules" {
  security_group_id = aws_security_group.ws_sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Security group for EFS mount targets"
  vpc_id      = module.main_vpc.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ws_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_efs_file_system" "efs" {
  creation_token   = var.efs_creation_token
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = false

  tags = {
    Name = "wordpress-efs"
  }
}

resource "aws_efs_mount_target" "mount_target" {
  count           = length(module.main_vpc.private_subnets)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = module.main_vpc.private_subnets[count.index]
  security_groups = [aws_security_group.efs_sg.id]
}
resource "ansible_group" "web_servers" {
  name = "web_servers"
}
resource "aws_instance" "ws" {
  count                       = var.ec2_instance_count
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  subnet_id                   = module.main_vpc.public_subnets[count.index]
  vpc_security_group_ids      = [aws_security_group.ws_sg.id]
  key_name                    = var.ssh_key_name
  associate_public_ip_address = true

  tags = {
    Name    = "ws-${count.index + 1}"
    env     = "study"
    cost    = "free-tier"
    project = "wp-Maica1"
  }

  depends_on = [
    aws_efs_mount_target.mount_target
  ]
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -q -y amazon-efs-utils && echo 'pass' || true",
      "sudo mkdir -p /uploads && sudo chown -R ec2-user:ec2-user /uploads && echo '${aws_efs_file_system.efs.id}' || true",
      "sudo mount -t efs ${aws_efs_file_system.efs.id}:/ /uploads  && echo 'pass' ",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    agent       = true
    private_key = file("${path.module}/id_rsa")
    host        = self.public_ip
  }
}

resource "ansible_host" "ws" {
  count  = var.ec2_instance_count
  name   = aws_instance.ws[count.index].public_dns
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
  name       = join(".", [split(".", aws_instance.ws[count.index].private_dns)[0], "maica1.site"])
  type       = "A"
  ttl        = 300
  records    = [aws_instance.ws[count.index].public_ip]
  depends_on = [aws_route53_zone.main]
}

# Create a security group for the ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = module.main_vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "ALB security group"
    project = "wp-Maica1"
    env     = "study"
  }
}

# Create a target group for the ALB
resource "aws_lb_target_group" "wordpress_target_group" {
  name        = "wordpress-target-group"
  port        = 443
  protocol    = "HTTPS"
  target_type = "instance"
  vpc_id      = module.main_vpc.vpc_id
}

# Create a listener for the ALB
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  }
}

# Create the ALB
resource "aws_lb" "alb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = module.main_vpc.public_subnets
}

resource "aws_lb_target_group_attachment" "wordpress_instances_attachment" {
  count            = var.ec2_instance_count
  target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  target_id        = aws_instance.ws[count.index].id
  port             = 443
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
