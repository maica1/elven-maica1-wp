terraform {
  backend "s3" {
    bucket = "wp-maica1-tfstate"
    key    = "terraform.tfstate"
    encrypt = true
    region = "sa-east-1"

#   CREDENTIALS PASSE FROM ENV VARS
#    access_key =
#    secret_key = 
  }
}
