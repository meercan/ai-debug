#!/bin/bash
sudo apt update -y
echo "Installing docker related dependencies"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
echo "Installing docker"
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo docker --version