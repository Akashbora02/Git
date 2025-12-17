#!/bin/bash
set -e
apt update -y
apt install -y git mysql-server

cd /opt/

git clone https://github.com/Akashbora02/Git.git
cd /home/ubuntu/opt/Git/studentapp/

chmod 700 docker-install.sh
sh docker-install.sh

cd ..
docker compose up -d