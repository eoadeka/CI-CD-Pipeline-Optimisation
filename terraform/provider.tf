terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
    }
  }

  backend "s3" {
    bucket = "cicdpo-terraform-state"
    key = "state/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    dynamodb_table = "cicdpo-terraform-state"
  }
}

provider "aws" {
  region = "eu-west-2"
}