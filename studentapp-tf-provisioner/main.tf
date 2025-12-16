data "aws_vpc" "db_vpc" {
  default = true
}
resource "aws_db_subnet_group" "db_subnets" {
  depends_on = [ data.aws_vpc.db_vpc ]
  name       = "rds-subnet-group"
  subnet_ids = [ data.aws_vpc.db_vpc.id ]
  tags = {
    Name = "MyDBSubnetGroup"
  }
}
resource "aws_db_instance" "my_db" {
  depends_on = [ aws_db_subnet_group.db_subnets ]
  allocated_storage      = 20
  db_name                = var.aws_db_instance_db_name
  engine                 = var.aws_db_instance_engine
  engine_version         = var.aws_db_instance_engine_version
  identifier             = var.aws_db_instance_identifier
  instance_class         = var.aws_db_instance_instance_class
  username               = var.aws_db_instance_username
  password               = var.aws_db_instance_password
  publicly_accessible    = false
  parameter_group_name   = var.aws_db_instance_parameter_group_name
  db_subnet_group_name   = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids = var.webserver_vpc_security_group_id
  skip_final_snapshot    = true
}
resource "aws_instance" "webserver" {
  depends_on = [ aws_db_instance.my_db ]
  ami                    = var.webserver_ami
  instance_type          = var.webserver_instance_type
  key_name               = var.webserver_key_name
  vpc_security_group_ids = var.webserver_vpc_security_group_id
  disable_api_termination = var.webserver_disable_api_termination

  provisioner "file" {
    source = "user-data.sh"
    destination = "/home/ubuntu/opt/user-data.sh"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public_ip.txt"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("${path.module}/tf.pem")
    host = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [ 
    "chmod 700 user-data.sh",
    "sh user-data.sh"
    ]
  }
}


output "my_db_arn" {
  value = aws_db_instance.my_db.address
}

