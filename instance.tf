resource "aws_instance" "example" {
  ami           = "ami-0c94855ba95c71c99" # replace with your desired AMI ID
  instance_type = "t2.micro"
  key_name      = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.example.id]

  tags = {
    Name = "example"
  }
}

