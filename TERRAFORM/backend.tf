terraform {
  backend "s3" {
    bucket = "my-bucket"
    key    = "terraform.tfstate"
    encrypt = true
    region = "sa-east-1"

  }
}