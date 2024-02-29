# module "s3_backend" {
#   source = "./MODULES/s3"

# }

module "main_vpc" {
  source = "./MODULES/network"
}
# data "external" "provisioner_public_ip" {
#   program = ["sh", "-c", "curl -s ifconfig.io/ip"]
# }