provider "aws" {
  profile = "configs"
  region  = "us-east-1"
  shared_credentials_files = [ "/home/akash/.aws/credentials" ]
}

terraform {
  backend "s3" {
    bucket = "dynamob61-43vd234"
    key = "terraform-tfstate"
#    dynamodb_table = "b61"
    use_lockfile = true
    region = "us-east-1"
    profile = "configs"
    shared_credentials_files = [ "/home/akash/.aws/credentials" ]
  }
}