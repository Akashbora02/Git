data "aws_vpc" "default-vpc" {
  default = true
}

data "aws_subnets" "default-subnets" {
  filter {
    name   = "vpc_id"
    values = [data.aws_vpc.default-vpc.id]
  }
}

resource "aws_internet_gateway" "my_IGW" {
  vpc_id = data.aws_vpc.default-vpc.id

  tags = {
    Name = "my_IGW"
  }
}

resource "aws_route_table" "my_rt" {
  vpc_id = data.aws_vpc.default-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_IGW.id
  }

  tags = {
    Name = "my_rt"
  }
}

resource "aws_route_table_association" "my_rta" {
  for_each       = toset(data.aws_subnets.default-subnets.ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.my_rt.id
}


resource "aws_security_group" "my_sg" {
  name   = "my-sg"
  vpc_id = data.aws_vpc.default-vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "Allow TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = data.aws_subnets.default-subnets.ids
}

resource "aws_lb_target_group" "my_lb_tg" {
  name     = "my-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default-vpc.id
}

resource "aws_lb_listener" "my_listener" {
  load_balancer_arn = aws_lb_target_group.my_lb_tg.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_lb_tg.arn
  }
}


resource "aws_launch_template" "my_temp" {
  name_prefix   = "my-temp"
  image_id      = "ami-0fa3fe0fa7920f68e"
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.my_sg.id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
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
  )
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 2
  vpc_zone_identifier       = data.aws_subnets.default-subnets.ids
  target_group_arns         = [aws_route_table.my_rt.arn]
  health_check_grace_period = 120
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.my_temp.id
    version = "$Latest"
  }
}


output "alb_dns_name" {
  value = aws_lb.my_lb.dns_name
}