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
sudo apt-get update -y

# Install docker-ce:
sudo apt-get install docker-ce -y

# Install docker-compose
# Download
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
# Apply permissions
sudo chmod +x /usr/local/bin/docker-compose

# Clone DeviceHive git repo:
git clone https://github.com/devicehive/devicehive-docker.git

cd devicehive-docker/rdbms-image/

# Deploy DeviceHive to docker
sudo docker-compose -f docker-compose.yml \
	-f dh_plugin.yml -f mqtt-brokers.yml \
	-f monitoring.yml -f cadvisor.yml \
	-f devicehive-metrics.yml up -d

# Deploy Portainer for easiest container management
sudo docker run -d -p 9000:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

# Deploy Node-Red
sudo docker run -d -p 1880:1880 --restart=always --name Node-Red nodered/node-red-docker

# Deploy Swagger Editor
sudo docker run -d -p 1000:8080 --restart=always swaggerapi/swagger-editor
