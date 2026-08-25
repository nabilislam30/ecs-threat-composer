terraform {
  backend "s3" {
    bucket  = "threat-composer-tfstate-058264496251"
    key     = "threat-composer/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}