terraform {
  backend "s3" {
    bucket = "wp-maica1-tfstate"
    key    = "terraform.tfstate"
    encrypt = true
    region = "sa-east-1"

    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"

  }
}