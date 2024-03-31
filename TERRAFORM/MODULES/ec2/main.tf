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

  provisioner "remote-exec" {
  inline = [
    "sudo yum install -y amazon-efs-utils",
    "sudo mkdir -p /uploads && chown -R ec2-user:nginx /uploads",
    "sudo mount -t efs ${var.efs_id}:/ /uploads || true",
  ]
}

connection {
  type        = "ssh"
  user        = "ec2-user"  # Update with your SSH username
  # private_key = file("path/to/your/private_key.pem")  # Update with the path to your SSH private key
  agent = true
  host        = self.public_ip
}
}
