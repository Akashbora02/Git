resource "aws_instance" "webserver" {
  ami                     = var.webserver_ami
  instance_type           = var.webserver_instance_type
  key_name                = var.webserver_key_name
  subnet_id               = var.webserver_subnetA
  vpc_security_group_ids  = [var.webserver_sg]
  disable_api_termination = var.webserver_disable_api_termination
user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install -y nginx -y
sudo systemctl enable nginx
sudo systemctl start nginx

cat <<HTML >/var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to My EC2 nginx Server</title>
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
<h1>🚀 Hello from EC2 + nginx!</h1>
<p>This page is served by <b>nginx</b> running on an Amazon EC2 instance.</p>
</body>
</html>
HTML
EOF
}