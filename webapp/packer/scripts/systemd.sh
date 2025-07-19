#!/bin/bash

sudo mv /tmp/webapp.service /etc/systemd/system/webapp.service
echo "successfully moved service file to /etc directory.."
sudo chown -R csye6225:csye6225 /etc/systemd/system/webapp.service

pwd

echo "executing systemctl commands.."

sudo systemctl daemon-reload
sudo systemctl enable webapp.service
sudo systemctl start webapp.service