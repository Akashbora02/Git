resource "aws_instance" "webserver" {
  ami                     = var.webserver_ami
  instance_type           = var.webserver_instance_type
  key_name                = var.webserver_key_name
  vpc_security_group_ids  = [var.webserver_vpc_security_group_ids , aws_security_group.webserver_sg.id]
#  count                   = var.webserver_count
  disable_api_termination = var.webserver_disable_api_termination
}

resource "aws_security_group" "webserver_sg" {
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]
    } 
}