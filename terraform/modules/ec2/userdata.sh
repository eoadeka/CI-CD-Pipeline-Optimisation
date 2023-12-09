#!/bin/bash
sudo yum update -y
sudo yum update -y httpd
sudo yum update -y git
sudo systemctl enable httpd
sudo git clone https://github.com/ella-adeka/CI-CD-Pipeline-Optimisation.git /var/www/html/web/
sudo systemctl start httpd
