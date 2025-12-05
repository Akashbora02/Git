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
                  <title>EC2 Server Ready</title>
                  <style>
                      body {
                          background: linear-gradient(to bottom right, #4facfe, #00f2fe);
                          font-family: 'Segoe UI', sans-serif;
                          text-align: center;
                          color: white;
                          padding-top: 80px;
                      }
                      .fade {
                          animation: fadeIn 2s ease-in-out forwards;
                          opacity: 0;
                      }
                      @keyframes fadeIn {
                          to { opacity: 1; }
                      }
                  </style>
              </head>
              <body>
                  <h1 class="fade">✔ EC2 Web Server Deployed</h1>
                  <p class="fade" style="animation-delay: 0.5s;">
                      Provisioned automatically using Terraform + user_data
                  </p>
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