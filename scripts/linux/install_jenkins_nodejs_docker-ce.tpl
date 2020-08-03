#!/bin/sh
# Set timezone to Singapore
sudo timedatectl set-timezone Asia/Singapore

# Set timesync using chrony
echo "server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4" >> /etc/chrony.conf
sudo service chronyd start
sudo unlink /etc/localtime
sudo ln -s /usr/share/zoneinfo/Singapore /etc/localtime

#Set OS hostname
sudo hostnamectl set-hostname ${hostname}

# Enable RedHat Extra Repository for Docker
sudo yum-config-manager --enable rhui-rhel-7-server-rhui-extras-rpms
# Add repo for docker community version
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum-config-manager --enable https://download.docker.com/linux/centos/docker-ce.repo

# Install docker community version engine (It will automatically include the packages docker-ce-cli & containerd.io)
sudo yum -y install docker-ce
# Start & Enable docker 
sudo systemctl start docker
sudo systemctl enable docker

# Install Jenkins Server
sudo yum install -y java-1.8.0-openjdk-devel
sudo yum install -y wget
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install -y jenkins
sudo usermod -a -G docker jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins


# Install Node JS
curl -sL https://rpm.nodesource.com/setup_12.x | bash -
sudo yum install -y nodejs

# Install Git command to clone github repositories
sudo yum install -y git

# Shutdown EC2 once installation completes
sudo shutdown now -h

# End