terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.60.0"
    }
  }

  backend "s3" {
    bucket = "cicdpo-dev-tf-state-bucket"
    key = "multi-env/dev/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    dynamodb_table = "cicdpo-dev-tf-state"
    profile = "development"
  }
}

provider "aws" {
  region = "eu-west-2"
}


resource "aws_s3_bucket" "dev-backend-bucket" {
  bucket = "cicdpo-dev-tf-state-bucket"

  # lifecycle {
  #   prevent_destroy = true
  # }
}