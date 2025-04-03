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


# echo "Checking for Homebrew Installation..."
# if ! command -v brew &>/dev/null; then
#     echo "Installing Homebrew as ec2-user..."
#     sudo -u ec2-user /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
#     # Add Homebrew to PATH for the current session
#     echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/ec2-user/.bashrc
#     eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# else
#     echo "Homebrew is already installed."
# fi

# Install NVM if not installed
if [ ! -d "/home/ec2-user/.nvm" ]; then
    echo "Installing NVM..."
    sudo -u ec2-user bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash'
fi

# Make sure scripts are executable
chmod +x /home/ec2-user/myapp/scripts/*.sh || echo "No scripts to make executable yet"

# Install MongoDB
echo "[mongodb-org-8.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2023/mongodb-org/8.0/aarch64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org-8.0.repo

sudo yum install -y mongodb-org --enablerepo=mongodb-org-8.0
sudo systemctl start mongod

echo "BeforeInstall script completed successfully."