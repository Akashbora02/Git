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
