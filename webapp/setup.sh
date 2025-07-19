#!/bin/bash

echo "Updating package lists and upgrading the system"
sudo apt update -y && sudo apt upgrade -y
 

echo "Installing Node.js and npm"
sudo apt install -y nodejs npm

echo "Installing MySQL Server"
sudo apt install -y mysql-server unzip

set -a 
source .env
set +a  

sudo mysql -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;"


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
 

echo "Creating Linux group and user..."
sudo groupadd -f $APP_GROUP
sudo useradd -m -g $APP_GROUP -s /bin/bash $APP_USER

echo "Extracting application to $APP_DIR..."
sudo mkdir -p $APP_DIR
sudo unzip -o $ZIP_FILE -d $APP_DIR
 
echo "Setting permissions..."
sudo chown -R $APP_USER:$APP_GROUP $APP_DIR
sudo chmod -R 755 $APP_DIR
 

echo "Moving .env"
cd $APP_DIR/webapp-main/
mv ../.env .env
echo "Installing application dependencies..."
sudo npm install
 
echo "Installing Jest & Supertest..."
sudo npm install --save-dev jest supertest

sudo npm test
 
echo "Starting the application..."
sudo npm run start