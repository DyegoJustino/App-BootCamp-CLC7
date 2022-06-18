terraform {
  backend "s3" {
    bucket = "infra-remote-state-bootcamp-clc7"
    key    = "app-terraform.tfstate"
    region = "us-east-1"
  }
}
