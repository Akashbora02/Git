resource "aws_instance" "webserver" {
  ami                    = var.webserver_ami
  instance_type          = var.webserver_instance_type
  key_name               = var.webserver_key_name
  vpc_security_group_ids = [var.webserver_vpc_security_group_ids]
  disable_api_termination = var.webserver_disable_api_termination
}

resource "aws_dynamodb_table" "my-table" {
    name = "ab"
    hash_key = "LockID"
    stream_enabled = true
    stream_view_type = "NEW_AND_OLD_IMAGES"

    attribute {
      name = "LockID"
      type = S
    }
}

resource "aws_s3_bucket" "my-s3" {
  bucket = "dynamodb_s3_bucket"
}

resource "aws_s3_bucket_versioning" "version" {
    bucket = aws_s3_bucket.my-s3.id
    versioning_configuration {
        status = "Enable"
    }
}