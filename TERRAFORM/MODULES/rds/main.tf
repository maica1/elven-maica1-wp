module "db" {
  source = "terraform-aws-modules/rds/aws"

  subnet_ids                  = var.database_subnets
  identifier                  = var.rds_instance_name
  family                      = "${var.db_engine}${var.db_version}"
  engine                      = var.db_engine
  engine_version              = var.db_version
  instance_class              = var.instance_class
  allocated_storage           = var.db_size
  storage_type                = var.storage_type
  db_name                     = var.db_name
  username                    = var.db_username
  password                    = var.db_password
  port                        = var.db_port
  manage_master_user_password = false
  create_db_option_group      = false

  # vpc_security_group_ids = ["sg-12345678"]

  monitoring_interval       = "30"
  monitoring_role_name      = "MyRDSMonitoringRole"
  create_monitoring_role    = true
  create_db_parameter_group = false

  create_db_subnet_group = true
  vpc_security_group_ids = var.security_group_ids

  multi_az = var.multi_az

  # deletion_protection = true
  skip_final_snapshot = true

  tags = {
    project = "wp-Maica1"
    env     = "study"
    cost    = "free"
  }

  #   parameters = [
  #   {
  #     name  = "character_set_client"
  #     value = "utf8mb4"
  #   },
  #   {
  #     name  = "character_set_server"
  #     value = "utf8mb4"
  #   }
  # ]
}