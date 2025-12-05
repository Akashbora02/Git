resource "aws_instance" "webserver" {
  ami                    = var.webserver_ami
  instance_type          = var.webserver_instance_type
  key_name               = var.webserver_key_name
  vpc_security_group_ids = [var.webserver_vpc_security_group_ids] #, aws_security_group.webserver_sg.id , data.aws_security_group.webserver_my_sg.id
  #  count                   = var.webserver_count
  disable_api_termination = var.webserver_disable_api_termination

user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl enable httpd
              sudo systemctl start httpd
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
                  <h1>🚀 Hello from EC2 + Nginx!</h1>
                  <p>This page is served by <b>Nginx</b> running on an Amazon EC2 instance.</p>
              </body>
              </html>
              HTML
          EOF
}

#resource "aws_security_group" "webserver_sg" {
#  ingress {
#    from_port   = 0
#    to_port     = 65535
#    protocol    = "TCP"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#}