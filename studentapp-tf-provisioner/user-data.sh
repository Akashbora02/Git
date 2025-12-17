#!/bin/bash
exec > /var/log/user-data.log 2>&1

sudo apt update -y
sudo apt install -y git mysql-server
