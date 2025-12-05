data "aws_ami" "my_ami" {
    most_recent = true
    owners      = ["813592692089"] # Canonical
      filter {
        name   = "name"
        values = ["ami-0fa3fe0fa7920f68e"]
      }
      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
}

data "aws_security_group" "webserver_my_sg" {
  name = "launch-wizard-4"
}