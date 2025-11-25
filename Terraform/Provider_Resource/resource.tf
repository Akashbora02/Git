resource "aws_instance" "demo_tf" {
  instance_type          = "t2.micro"
  ami                    = "ami-0fa3fe0fa7920f68e"
  key_name               = "30july"
  vpc_security_group_ids = ["sg-0bbfe8e7d4bf3c179"]
}