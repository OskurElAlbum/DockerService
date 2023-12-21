#!/bin/bash

# File use to download docker and docker compose on the machine

echo "1 - Installation of the prerequisites to download docker and docker compose"
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release

sudo apt install apt-transport-https ca-certificates curl software-properties-common

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update


echo "2 - Installation of docker and docker compose"

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose docker-compose-plugin

docker --version
docker compose


echo "3 - Modify permissions to use docker commands without being root"
sudo usermod -aG docker $USER


echo "4 - Restart docker services"
sudo systemctl restart docker