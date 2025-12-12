provider "aws" {
  profile = "configs"
  region  = "us-east-1"
  shared_credentials_files = [ "/home/akash/.aws/credentials" ]
}

terraform {
  backend "s3" {
    bucket = "dynamodb_s3_bucket"
    key = "terraform-tfstate"
    dynamodb_table = "ab"
    region = "us-east-1"
    profile = "configs"
    shared_credentials_files = [ "/home/akash/.aws/credentials" ]
  }
}