#!/bin/bash 
sudo su
yum update -y
yum -y install httpd.x86_64
echo "Hello World from $(hostname -f)" > /var/www/html/index.html
sudo systemctl enable httpd
sudo systemctl start httpd