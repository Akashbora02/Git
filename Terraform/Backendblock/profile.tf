provider "aws" {
  profile = "configs"
  region  = "us-east-1"
  shared_credentials_files = [ "/home/akash/.aws/credentials" ]
}

terraform {
  backend "s3" {
    bucket = "bucketb61ab"
    key = "terraform-tfstate"
    dynamodb_table = "b61"
    region = "us-east-1"
    profile = "configs"
    shared_credentials_files = [ "/home/akash/.aws/credentials" ]
  }
}