resource "aws_instance" "this" {
  count                       = var.ec2_instance_count
  ami                         = var.ec2_ami
  instance_type               = var.ec2_instance_type
  subnet_id                   = var.subnet_id[count.index]
  vpc_security_group_ids      = var.security_group
  key_name                    = "elven-blog-key"
  associate_public_ip_address = true


  tags = {
    Name    = "${var.ec2_instance_name}-${count.index + 1}"
    env     = "study"
    cost    = "free-tier"
    project = "wp-Maica1"
  }
}
// Define other EC2 instance settings here

# output "ec2_instance_ids" {
#   value = aws_instance[*].public_ip
# }