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
                sudo apt install -y httpd
                sudo systemctl enable httpd
                sudo systemctl start httpd
                cat <<HTML > /var/www/html/index.html
                <!DOCTYPE html>
                <html lang="en">
                <head>
                    <meta charset="UTF-8">
                    <title>EC2 Default Web Page</title>
                    <style>
                        body {
                            background-color: #f2f2f2;
                            font-family: Arial, sans-serif;
                            margin: 0;
                            padding: 0;
                            text-align: center;
                        }
                        .container {
                            margin-top: 10%;
                            background: white;
                            padding: 40px;
                            width: 60%;
                            margin-left: auto;
                            margin-right: auto;
                            border-radius: 12px;
                            box-shadow: 0 0 15px rgba(0,0,0,0.1);
                        }
                        h1 {
                            color: #FF9900;
                            font-size: 36px;
                            margin-bottom: 10px;
                        }
                        p {
                            font-size: 18px;
                            color: #333;
                        }
                        .footer {
                            margin-top: 20px;
                            font-size: 14px;
                            color: #777;
                        }
                    </style>
                </head>
                <body>
                    <div class="container">
                        <h1>Welcome to Your Amazon EC2 Instance</h1>
                        <p>If you are seeing this page, your EC2 web server is running successfully!</p>
                        <p>This HTML page was created using the EC2 User Data script.</p>
                        <hr>
                        <div class="footer">Amazon EC2 | User Data Demo Page</div>
                    </div>
                </body>
                </html>
                HTML
            EOF
}