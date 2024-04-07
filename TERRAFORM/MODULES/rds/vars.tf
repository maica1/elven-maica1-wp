variable "database_subnets" {
  default = null
}
variable "rds_instance_name" {
  default = null
}

variable "instance_class" {
  default = "db.t3.micro"
}
variable "db_size" {
  default = 20
}
variable "storage_type" {
  default = "gp3"
}
variable "db_engine" {
  default = "mysql"
}
variable "db_version" {
  default = "5.7"
}

variable "db_port" {
  default = 3306
}
variable "db_name" {
  default = "wordpress"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default   = "Elfos123!"
  sensitive = true
}

variable "multi_az" {
  default = false
}

variable "security_group_ids" {

}