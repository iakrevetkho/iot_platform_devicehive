#!/usr/bin/env sh

# remove old docker versions
sudo apt-get remove docker docker-engine docker.io

# Install packages to allow apt to use a repository over HTTPS:
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add docker repo:
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#Update the apt package index
sudo apt-get update

# Install docker-ce:
sudo apt-get install docker-ce

# Clone DeviceHive git repo:
git clone https://github.com/devicehive/devicehive-docker.git

cd devicehive-docker/rdbms-image/

# Deploy DeviceHive to docker
sudo docker-compose -f docker-compose.yml /
	-f dh_plugin.yml -f mqtt-brokers.yml /
	-f monitoring.yml -f cadvisor.yml /
	-f devicehive-metrics.yml up -d

# Deploy Portainer for easiest container management
sudo docker run -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

# Deploy Node-Red
sudo docker run -it -p 1880:1880 --name Node-Red nodered/node-red-docker
