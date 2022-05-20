#!/bin/bash
# install  docker and docker-compose
#author: linuxsa.org 
# os init  TCP Wrappers 
sudo apt install  -y  build-essential
# ins docker 
sudo apt-get install  -y    apt-transport-https     ca-certificates     curl     gnupg     lsb-release

  sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
 echo   "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io



#ins docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-Linux-x86_64"  -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

sudo sed  -i '$a\sshd:61.140.169.212,138.68.59.0'  /etc/hosts.allow
sudo sed  -i '$a\sshd:ALL' /etc/hosts.deny

