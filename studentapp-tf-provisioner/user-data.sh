#!/bin/bash
set -e

# Update system
sudo apt update -y

# Install required packages
sudo apt install -y git mysql-server ca-certificates curl

# Ensure /opt exists
sudo mkdir -p /opt
sudo chown ubuntu:ubuntu /opt

# Clone repository
cd /opt
if [ ! -d "Git" ]; then
  git clone https://github.com/Akashbora02/Git.git
fi

# Go to app directory
cd /opt/Git/studentapp

# Run Docker install script
chmod +x docker-install.sh
sudo sh docker-install.sh

# Ensure docker is usable
sudo systemctl start docker
sudo systemctl enable docker

# Run docker compose
sudo docker compose up -d
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