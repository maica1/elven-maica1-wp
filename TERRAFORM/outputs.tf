output "aws_public_ip" {
  value = aws_instance.example.public_ip
}
output "provisioner_ip_address" {
  value = data.external.provisioner_public_ip
}
