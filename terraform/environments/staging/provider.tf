terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>3.0"
    }
  }

  backend "s3" {
    bucket = "cicdpo-stag-tf-state-bucket"
    key = "multi-env/staging/terraform.tfstate"
    region = "eu-west-2"
    encrypt = true
    dynamodb_table = "cicdpo-stag-tf-state"
    profile = "staging"
  }
}