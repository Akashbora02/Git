#!/bin/bash
exec > /var/log/user-data.log 2>&1

sudo apt update -y
sudo apt install -y git mysql-server

cd /opt/

sudo git clone https://github.com/Akashbora02/Git.git
cd /opt/Git/studentapp/

chmod 700 docker-install.sh
sh docker-install.sh

cd ..
docker compose up -d

until mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "SELECT 1;" 2>/dev/null
do
  echo "Waiting for MySQL to be ready..."
  sleep 10
done

sudo mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" <<SQL
CREATE DATABASE IF NOT EXISTS studentapp;
USE studentapp;
CREATE TABLE IF NOT EXISTS students (
  student_id INT NOT NULL AUTO_INCREMENT,
  student_name VARCHAR(100) NOT NULL,
  student_addr VARCHAR(100) NOT NULL,
  student_age VARCHAR(3) NOT NULL,
  student_qual VARCHAR(20) NOT NULL,
  student_percent VARCHAR(10) NOT NULL,
  student_year_passed VARCHAR(10) NOT NULL,
  PRIMARY KEY (student_id)
);
SQL

CONTEXT_FILE="/opt/Git/studentapp/context.xml"
sudo sed -i "s|DB_HOST_PLACEHOLDER|$DB_HOST|g" "$CONTEXT_FILE"
echo "User data script completed successfully!"
echo "$DB_HOST , $DB_USER , $DB_PASS"