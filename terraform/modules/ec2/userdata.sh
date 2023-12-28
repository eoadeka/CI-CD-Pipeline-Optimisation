#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
    sleep 1
done   

# Update all packages
sudo yum update -y

# Install new packages
sudo yum install -y httpd git python3 python3-pip python3-devel virtualenv
sudo python3 --version
sudo systemctl enable httpd
git clone https://github.com/ella-adeka/CI-CD-Pipeline-Optimisation.git /var/www/html/web/my_app/
sudo systemctl start httpd
sudo cd my_app/
sudo python3 -m pip install -r requirements.txt
export FLASK_APP = app.py
flask run --host=0.0.0.0
