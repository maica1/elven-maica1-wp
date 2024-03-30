output "db_instance_ip" {
  value = module.db.db_instance_address[*]
}