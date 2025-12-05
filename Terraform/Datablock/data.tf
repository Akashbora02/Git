data "aws_ami" "myami" {
    most_recent = true
    owners      = ["amazon"] # Canonical
      filter {
        name   = "name"
        values = ["al2023-ami-*-x86_64"]
      }
      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
}

data "aws_security_group" "webserver_my_sg" {
  name = "launch-wizard-4"
}

data "aws_instance" "webserver_instance_id" {
  instance_id = "i-0fcd3c3638039f3ec"
}