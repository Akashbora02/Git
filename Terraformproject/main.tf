resource "aws_instance" "webserver" {
  ami                    = var.webserver_ami
  instance_type          = var.webserver_instance_type
  key_name               = var.webserver_key_name
  vpc_security_group_ids = [var.webserver_vpc_security_group_ids]
  # count                   = var.webserver_count
  disable_api_termination = var.webserver_disable_api_termination
user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
              git clone https://github.com/Akashbora02/Git.git
              cd Git/studentapp/

              chmod 700 docker-install.sh
              sh docker-install.sh
              cd ..
              docker compose up -d
              cat <<HTML > /var/www/html/index.html
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Welcome to My EC2 httpd Server</title>
                  <style>
                      body {
                          background-color: #f4f4f9;
                          font-family: Arial, sans-serif;
                          text-align: center;
                          padding: 50px;
                      }
                      h1 {
                          color: #2e86c1;
                      }
                      p {
                          font-size: 18px;
                          color: #555;
                      }
                  </style>
              </head>
              <body>
                  <h1>🚀 Hello from EC2 + Httpd!</h1>
                  <p>This page is served by <b>Httpd</b> running on an Amazon EC2 instance.</p>
              </body>
              </html>
              HTML
            EOF
}

output "webserver_publicip" {
  value = aws_instance.webserver.public_ip
}