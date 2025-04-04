#!/bin/bash
set -e 

echo "Updating Packages"
sudo yum update -y

# Completely remove the app directory to start fresh
APP_DIR="/home/ec2-user/myapp"
if [ -d "$APP_DIR" ]; then
    echo "Removing existing app directory for fresh installation..."
    sudo rm -rf "$APP_DIR"
fi

# Create fresh directory
mkdir -p "$APP_DIR"
echo "Created fresh $APP_DIR directory."

# # Install NVM if not installed
# if [ ! -d "/home/ec2-user/.nvm" ]; then
#     echo "Installing NVM..."
#     sudo -u ec2-user bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash'
# fi

# Install Node.js
# curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
# yum install -y nodejs 

# Install dependencies
cd /home/ec2-user/myapp

# Load NVM for the ec2-user
export NVM_DIR="/home/ec2-user/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Install Node.js 23
echo "Installing Node.js 23..."
nvm install 23
nvm use 23
nvm alias default 23

# Update npm
npm install -g npm@latest

# npm cache clean --force
# rm -rf node_modules package-lock.json
# npm install

# # Make sure scripts are executable
# chmod +x /home/ec2-user/myapp/scripts/*.sh || echo "No scripts to make executable yet"

# Install MongoDB
echo "[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/8.0/aarch64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org-8.0.repo

sudo yum install -y mongodb-org --enablerepo=mongodb-org-8.0
# sudo systemctl start mongod
# npm start

echo "BeforeInstall script completed successfully."