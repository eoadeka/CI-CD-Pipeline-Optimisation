resource "aws_s3_bucket" "tfstate" {
  bucket = "cicdpo-terraform-state"
}

resource "aws_s3_bucket_acl" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  acl = private
}
# https://earthly.dev/blog/terraform-state-bucket/

resource "aws_dynamodb_table" "tfstate" {
  name = "cicdpo-terraform-state"
  read_capacity = 20
  write_capacity = 20
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
    }
  }

  backend "s3" {
    bucket = "cicdpo-terraform-state"
    key = "multi-environment/staging/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    dynamodb_table = "cicdpo-terraform-state"
  }
}

provider "aws" {
  region = "eu-west-2"
}