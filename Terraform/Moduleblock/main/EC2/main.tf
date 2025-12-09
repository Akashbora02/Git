resource "aws_instance" "webserver" {
  ami                     = var.webserver_ami
  instance_type           = var.webserver_instance_type
  key_name                = var.webserver_key_name
  subnet_id               = var.webserver_subnetA
  vpc_security_group_ids  = [var.webserver_sg]
  disable_api_termination = var.webserver_disable_api_termination
      user_data = <<-EOF
                    #!/bin/bash
                    sudo apt update -y
                    sudo apt install -y nginx
                    sudo systemctl enable nginx
                    sudo systemctl start nginx
                    cat <<HTML > /var/www/html/index.html
                    <html lang="en">
                    <body>
                    </body>
                    <h1>Welcome to my page</h1>
                    </html>
                    HTML
                EOF
}