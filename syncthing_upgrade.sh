#!/bin/sh

###############################################################
#
# Script Name: syncthing_upgrade.sh
#
# Description: This script will automatically upgrade syncthing
#
###############################################################


# Gracefully stop the syncthing service
systemctl stop syncthing@syncthing.service

cd /home/syncthing
curl -s https://api.github.com/repos/syncthing/syncthing/releases/latest | grep browser_download_url | grep linux-amd64 | cut -d '"' -f 4 | wget -qi -
tar xvf syncthing-linux-amd64*.tar.gz
