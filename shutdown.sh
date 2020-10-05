#!/bin/sh


########################################################################################################################################################################

#Script Name: shutdown.sh

#Description: This script will stop the Folding@Home service, and check if there are users on the KF2 server. If there are no users, the server will shutdown

########################################################################################################################################################################


#Confirm user is running as root
if [ `whoami` != 'root' ]
        then
          echo "You must be root to run this script. This script will now exit."
          exit
fi

