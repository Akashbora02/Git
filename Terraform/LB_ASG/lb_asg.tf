data "aws_vpc" "default" {
  default = true
}
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_internet_gateway" "default_igw" {
  filter {
    name = "igw-id"
    values = [ data.aws_vpc.default.id ]
  }
}
#resource "aws_internet_gateway" "default_igw" {
  #vpc_id = data.aws_vpc.default.id

  #tags = {
  #  Name = "default-igw"
 # }
#}

resource "aws_route_table" "public_rt" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default_igw.id
  }

  tags = {
    Name = "public_rt"
  }
}

resource "aws_route_table_association" "my-rta" {
  for_each       = toset(data.aws_subnets.default.ids)
  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "my-sg" {
  name   = "my-sg"
  vpc_id = data.aws_vpc.default.id

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

resource "aws_lb" "my-lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my-sg.id]
  subnets            = data.aws_subnets.default.ids
}

resource "aws_lb_target_group" "my-lb-tg" {
  name     = "my-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.my-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-lb-tg.arn
  }
}


resource "aws_launch_template" "my_temp" {
  name_prefix   = "my-temp"
  image_id      = "ami-0fa3fe0fa7920f68e"
  instance_type = "t2.micro"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.my-sg.id]
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
  vpc_zone_identifier       = data.aws_subnets.default.ids
  target_group_arns         = [aws_lb_target_group.my-lb-tg.arn]
  health_check_grace_period = 120
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.my_temp.id
    version = "$Latest"
  }
}


output "alb_dns_name" {
  value = aws_lb.my-lb.dns_name
}