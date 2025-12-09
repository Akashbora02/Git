resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "my_subnetA" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.vpc_subnetA
  map_public_ip_on_launch = var.public_ip
}

#resource "aws_internet_gateway" "my_IGW" {
#  vpc_id = aws_vpc.my_vpc.id
#}

#resource "aws_route_table" "public_rt" {
#vpc_id = aws_vpc.my_vpc.id
#route {
#cidr_block = "0.0.0.0/0"
#gateway_id = aws_internet_gateway.my_IGW.id
#}
#}

#resource "aws_route_table_association" "public_assoc" {
#subnet_id = aws_subnet.my_subnetA.id
#route_table_id = aws_route_table.public_rt.id
#}
resource "aws_security_group" "webserver_sg" {
  vpc_id = aws_vpc.my_vpc.id

ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}