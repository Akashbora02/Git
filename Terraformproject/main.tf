resource "aws_instance" "webserver" {
  ami                    = var.webserver_ami
  instance_type          = var.webserver_instance_type
  key_name               = var.webserver_key_name
  vpc_security_group_ids = [var.webserver_vpc_security_group_ids]
  # count                   = var.webserver_count
  disable_api_termination = var.webserver_disable_api_termination
  user_data               = <<-EOF
  #!/bin/bash
     apt update -y
     mkdir opt
     cd opt/
     git clone https://github.com/Akashbora02/Git.git
     cd opt/Git/studentapp/

     chmod 700 docker-install.sh
     sh docker-install.sh
     cd ..
     docker compose up -d
  EOF
}

output "webserver_publicip" {
  value = aws_instance.webserver.public_ip
}