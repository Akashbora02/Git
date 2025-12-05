data "aws_ami" "my_ami" {
    most_recent = true
      owners      = ["813592692089"] # Canonical
      filter {
        name   = "name"
        values = ["Amazon Linux 2023 AMI 2023.9.20251117.1 x86_64 HVM kernel-6.1"]
      }
      filter {
        name   = "virtualization-type"
        values = ["hvm"]
      }
}

data "aws_security_group" "webserver_my_sg" {
  name = "launch-wizard-4"
}