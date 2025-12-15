provider "aws" {
  profile = "test"
  region  = "us-east-1"
  shared_credentials_files = [ "/home/akash/.aws/credentials" ]
}

/* terraform {
  backend "s3" {
    bucket = "dynamob61-43vd24"
    key = "terraform-tfstate"
#    dynamodb_table = "b61"
    use_lockfile = true
    region = "us-east-1"
    profile = "test"
    shared_credentials_files = [ "/home/akash/.aws/credentials" ]
  }
}*/