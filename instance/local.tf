locals {
  user_data = <<EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install openjdk-11-jre-headless -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key |sudo gpg --dearmor -o /usr/share/keyrings/jenkins.gpg
sudo sh -c 'echo deb [signed-by=/usr/share/keyrings/jenkins.gpg] http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins -y
sudo jenkins --version
systemctl start jenkins
systemctl enable jenkins
EOF
}
