#!/bin/bash

VAGRANT_HOST_DIR=/mnt/host_machine

########################
# Git  
########################
sudo apt-get -y install git

########################
# Jenkins & Java
########################
echo "Installing Jenkins and Java"
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update > /dev/null 2>&1
sudo apt-get -y install default-jdk jenkins > /dev/null 2>&1
echo "Installing Jenkins default user and config"
sudo cp $VAGRANT_HOST_DIR/JenkinsConfig/config.xml /var/lib/jenkins/
sudo mkdir -p /var/lib/jenkins/users/admin
sudo cp $VAGRANT_HOST_DIR/JenkinsConfig/users/admin/config.xml /var/lib/jenkins/users/admin/
sudo chown -R jenkins:jenkins /var/lib/jenkins/users/

########################
# Node & npm
########################
echo "Installing Node & npm"
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get -y install nodejs
sudo apt-get -y install npm


# ########################
# # Gradle
# ########################
sudo apt-get -y install openjdk-8-jdk unzip
wget https://services.gradle.org/distributions/gradle-5.0-bin.zip -P /tmp
sudo mkdir /opt/gradle
sudo unzip -d /opt/gradle /tmp/gradle-*.zip
sudo cp $VAGRANT_HOST_DIR/Gradle/gradle.sh /etc/profile.d
sudo chmod +x /etc/profile.d/gradle.sh
source /etc/profile.d/gradle.sh

# ########################
# # Docker
# ########################
 echo "Installing Docker"
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
 sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
 sudo apt-get update
 sudo apt-get -y install docker-ce
 sudo systemctl enable docker
 sudo usermod -aG docker ${USER}
 sudo usermod -aG docker jenkins
 sudo usermod -aG docker ubuntu

# ########################
# # nginx
# ########################
echo "Installing nginx"
sudo apt-get -y install nginx > /dev/null 2>&1
sudo service nginx start

# ########################
# # Configuring nginx
# ########################
echo "Configuring nginx"
cd /etc/nginx/sites-available
sudo rm default ../sites-enabled/default
sudo cp /mnt/host_machine/VirtualHost/jenkins /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/jenkins /etc/nginx/sites-enabled/
sudo service nginx restart
sudo service jenkins restart

# ########################
# # Tested keys
# ########################

########################
# Sshpass  
########################
sudo apt-get -y install sshpass

echo "Success"
