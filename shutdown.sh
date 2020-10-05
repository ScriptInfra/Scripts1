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


#define shutdown log variable
touch /var/log/shutdown_logs/shutdown_log_$(date +\%m.\%d.\%Y).txt
log=/var/log/shutdown_logs/shutdown_log_$(date +\%m.\%d.\%Y).txt


#confirm user really wants to shutdown system
hostname=$(hostname)
while true; do
    read -p "Are you sure you want to shutdown $hostname? " yn
    case $yn in
        [Yy]* ) continue; break;;
        [Nn]* ) echo "This script will now exit"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


#Prompt that shutdown script is running
echo | tee -a "$log"
echo "##############################" | tee -a "$log"
echo | tee -a "$log"
echo "### Starting system shutdown ###" | tee -a "$log"
echo | tee -a "$log"
echo "##############################" | tee -a "$log"

