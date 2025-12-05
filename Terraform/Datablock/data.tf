data "aws_ami" "myami" {
  name_regex = "ami-0fa3fe0fa7920f68e"
}
data "aws_security_group" "webserver_my_sg" {
  name = "launch-wizard-4"
}