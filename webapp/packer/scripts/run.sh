#!/bin/bash

sudo apt install unzip
sudo mv /tmp/webapp-fork.zip /opt/webapp/webapp-fork.zip
echo "moved zip file to to /opt.."

echo ""
sudo unzip /opt/webapp/webapp-fork.zip -d /opt/webapp/
echo "unzip complete.."

echo "moving contents to /opt/webapp.."
sudo mv /opt/webapp/webapp-fork/* /opt/webapp/
sudo mv /opt/webapp/webapp-fork/.* /opt/webapp/ 2>/dev/null
sudo rmdir /opt/webapp/webapp-fork

echo "entering /opt/webapp.."
cd /opt/webapp || return
echo "inside /opt/webapp"
pwd
echo "running npm install.."
sudo npm install

echo "displaying contents of webapp.."
ls -al /opt/webapp

echo "changing ownership of websapp.."
sudo chown -R csye6225:csye6225 /opt/webapp