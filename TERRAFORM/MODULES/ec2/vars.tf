variable "aws_region" {
  type        = string
  description = "Aws region code"
}

variable "ec2_instance_count" {
  type        = number
  description = "Number of ec2 instances"
}

variable "ec2_ami" {
  type        = string
  description = "image id"
}

variable "ec2_instance_type" {
  default = "t2.micro"
  type    = string
}

variable "ec2_instance_name" {
  default = "ec2"
  type    = string
}
variable "security_group" {
  type    = list(any)
  default = null
}
variable "subnet_id" {}

variable "efs_id" {
  type    = string
  default = null
}

