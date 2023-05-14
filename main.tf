data "external" "provisioner_public_ip" {
  program = ["sh", "-c", "curl -s ifconfig.io/ip"]
}

