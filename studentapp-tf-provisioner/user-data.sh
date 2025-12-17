#!/bin/bash
sudo apt update -y
sudo apt install -y git mysql-server

cd /opt/

sudo git clone https://github.com/Akashbora02/Git.git
cd /opt/Git/studentapp/

chmod 700 docker-install.sh
sh docker-install.sh

cd ..
docker compose up -d