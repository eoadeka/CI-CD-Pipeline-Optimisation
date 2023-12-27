terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.60.0"
    }
  }

  backend "s3" {
    bucket = "cicdpo-stag-tf-state-bucket"
    key = "multi-env/staging/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    dynamodb_table = "cicdpo-stag-tf-state"
    profile = "default"
  }
}

provider "aws" {
  region = "eu-west-2"
}


resource "aws_s3_bucket" "stag-backend-bucket" {
  bucket = var.backend_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}