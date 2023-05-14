resource "aws_vpc" "VPC-estudos-Maica1" {
  cidr_block = var.vpc_cidr_block
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.aws_region}a"
}
