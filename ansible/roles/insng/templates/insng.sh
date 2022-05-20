#!/bin/bash
#
sudo mkdir -p /data/docker-ng
sudo cp  /tmp/docker-compose.yml  /data/docker-ng/
 cd  /data/docker-ng   &&  sudo docker-compose up -d 
