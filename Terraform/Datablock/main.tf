resource "aws_instance" "webserver" {
  ami                    = var.webserver_ami
  instance_type          = var.webserver_instance_type
  key_name               = var.webserver_key_name
  vpc_security_group_ids = [var.webserver_vpc_security_group_ids] #, aws_security_group.webserver_sg.id , data.aws_security_group.webserver_my_sg.id
  #  count                   = var.webserver_count
  disable_api_termination = var.webserver_disable_api_termination

  user_data = <<-EOF
              file("${path.module}/user_data.sh")
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl enable nginx
              sudo systemctl start nginx
              cat <<HTML > /var/www/html/index.html
              <!DOCTYPE html>
              <html>
              <head>
                <title>My Custom Terraform Page</title>
                <style>
                  body {
                    font-family: Arial, sans-serif;
                    background: #f4f4f4;
                    text-align: center;
                    padding: 50px;
                  }
                  .container {
                    background: white;
                    padding: 30px;
                    border-radius: 10px;
                    box-shadow: 0 0 10px rgba(0,0,0,0.1);
                    display: inline-block;
                  }
                  h1 {
                    color: #333;
                  }
                  p {
                    color: #555;
                  }
                </style>
              </head>
              <body>
                <div class="container">
                  <h1>Welcome to My Custom Web Page!</h1>
                  <p>This page was deployed automatically using Terraform 🚀</p>
                </div>
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