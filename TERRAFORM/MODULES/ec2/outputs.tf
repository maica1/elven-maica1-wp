output "public_ip" {
  value = aws_instance.this[*].public_ip
}
output "id" {
  value = aws_instance.this.*.id
}
output "hosts" {
  value = aws_instance.this.*.tags.Name
}
output "public_dns" {
  value = aws_instance.this.*.public_dns
}
output "private_dns" {
  value = aws_instance.this.*.private_dns
}