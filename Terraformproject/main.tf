resource "aws_db_instance" "my_db" {
  allocated_storage    = 10
  db_name              = var.aws_db_instance_db_name
  engine               = var.aws_db_instance_engine
  engine_version       = var.aws_db_instance_engine_version
  identifier           = var.aws_db_instance_identifier
  instance_class       = var.aws_db_instance_instance_class
  username             = var.aws_db_instance_username
  password             = var.aws_db_instance_password
  parameter_group_name = var.aws_db_instance_parameter_group_name
  publicly_accessible  = true
  db_subnet_group_name = aws_db_subnet_group.db_subnets.id
  vpc_security_group_ids = [var.webserver_vpc_security_group_ids]
  skip_final_snapshot  = true
}
resource "aws_db_subnet_group" "db_subnets" {
  name       = "rds-subnet-group"
  subnet_ids = ["subnet-0482a37ccc012331b", "subnet-0ec5c308d2f01e209", "subnet-0aad31b4c64afe074", "subnet-0c64b5c0a24ba3dac", "subnet-047a1f39a17928bfd", "subnet-0b790024640f0ad48"]
  tags = {
    Name = "MyDBSubnetGroup"
  }
}
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
              sudo yum install mysql-client-8.0 -y
              git clone https://github.com/Akashbora02/Git.git
              cd Git/studentapp/

              chmod 700 docker-install.sh
              sh docker-install.sh
              cd ..
              docker compose up -d
              DB_ENDPOINT = "${aws_db_instance.mysql.address}"
              DB_USER = "admin"
              DB_PASS = "${var.aws_db_instance_password}"
              mysql -h $DB_ENDPOINT -u $DB_USER -p$DB_PASS -e "CREATE DATABASE studentapp;"
              mysql -h $DB_ENDPOINT -u $DB_USER -p$DB_PASS studentapp <<SQL
              CREATE TABLE if not exists students(student_id INT NOT NULL AUTO_INCREMENT,  
              student_name VARCHAR(100) NOT NULL,  
              student_addr VARCHAR(100) NOT NULL,   
              student_age VARCHAR(3) NOT NULL,      
              student_qual VARCHAR(20) NOT NULL,     
              student_percent VARCHAR(10) NOT NULL,   
              student_year_passed VARCHAR(10) NOT NULL,  
              PRIMARY KEY (student_id)  
            );
            SQL
            EOF
}


output "webserver_publicip" {
  value = aws_instance.webserver.public_ip
}

output "my_db_arn" {
  value = aws_db_instance.my_db.address
}