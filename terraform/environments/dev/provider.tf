terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
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