#!/bin/sh

########################################################################################################################################################################

#Script Name: syncthing_upgrader.sh

#Description: This script will automatically upgrade syncthing

########################################################################################################################################################################


# Gracefully stop the syncthing service
systemctl stop syncthing@syncthing.service

# :
