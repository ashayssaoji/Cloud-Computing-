#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export CHECKPOINT_DISABLE=1

# Update and upgrade packages
sudo apt-get update -y
echo "[completed update…]"

sudo apt-get upgrade -y
echo "[completed upgrade…]"

# Install necessary packages
sudo apt install -y nodejs npm mysql-server unzip
echo "[completed installing node, npm, and MySQL…]"

# Start and enable MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql
echo "[started and enabled MySQL service…]"

# Load environment variables
set -a 
source .env
set +a  

# Setup MySQL database and user
sudo mysql -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"
echo "[Database '${DB_NAME}' created if it didn't exist…]"

# Check if the user already exists
USER_EXISTS=$(sudo mysql -e "SELECT User FROM mysql.user WHERE User='${DB_USER}';" | grep "${DB_USER}")

if [ -z "$USER_EXISTS" ]; then
    echo "Creating MySQL user '${DB_USER}'..."
    sudo mysql -e "
    CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';
    FLUSH PRIVILEGES;"
    echo "MySQL user '${DB_USER}' created and granted privileges on '${DB_NAME}'."
else
    echo "MySQL user '${DB_USER}' already exists. Skipping user creation."
fi

# Clean up package cache
sudo apt-get clean
echo "[Setup completed successfully!]"
