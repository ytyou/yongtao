#!/bin/bash

# setup docker repository
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# verify that the key fingerprint is
#
# 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
#
# $ sudo apt-key fingerprint 0EBFCD88
# pub   4096R/0EBFCD88 2017-02-22
#       Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
# uid                  Docker Release (CE deb) <docker@docker.com>
# sub   4096R/F273FCD8 2017-02-22
#

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# install docker
sudo apt-get update
sudo apt-get install docker-ce

# Or, if you want to install a specific version of docker,
apt-cache madison docker-ce
sudo apt-get install docker-ce=<VERSION>

# verify installation
sudo docker run hello-world


# To uninstall docker,
sudo apt-get purge docker-ce
sudo rm -rf /var/lib/docker
