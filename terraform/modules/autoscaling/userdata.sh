#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
    sleep 1
done   

# Update all packages
sudo yum update -y

# Install new packages
sudo yum install -y httpd git python3 python3-pip python3-devel virtualenv

# Verify python installation by checking version
sudo python3 --version

# Enable and start Apache (httpd)
sudo systemctl enable httpd
sudo systemctl start httpd

# Clone Github repository
sudo git clone https://github.com/ella-adeka/CI-CD-Pipeline-Optimisation.git /var/www/html/web/

# Navigate to app directory
sudo cd /var/www/html/web/my_app/

# Create virtual environment and install dependencies
sudo python3 -m venv venv
source venv/bin/activate
sudo python3 -m pip install -r requirements.txt

# Export flask app environment variable
export FLASK_APP = app.py

# Run the Flask app
flask run --host=0.0.0.0 --port=5000
