data "aws_ami" "myami" {
    most_recent = true
    owners      = ["813592692089"] # Canonical
      filter {
        name   = "name"
        values = ["al2023-ami-2023.9.20251117.1-kernel-6.1-x86_64"]
      }
      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
}

data "aws_security_group" "webserver_my_sg" {
  name = "launch-wizard-4"
}