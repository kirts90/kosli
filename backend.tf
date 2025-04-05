terraform {
  backend "s3" {
    bucket = "kosli-bucket"
    key    = "terraform.tfstate"
    region = "eu-west-2"
  }
}