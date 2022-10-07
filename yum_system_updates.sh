#!/bin/sh

###########################################################################################

#Script Name: yum_system_updates.sh

#Description: This script updates yum packages and sends the updated package list to email.

###########################################################################################



# Clear screen for consumption

clear



# Define variables

email=$(cat /home/git/scripts/email.txt)
log=/var/log/yum_logs/yum_update_$(date +\%c).txt



# Run system update
yum upgrade -y > $log



# Send system update log to email
cat "$log" | mailx -s "cloud1 Yum Updates for $(date +\%c)" "$email"
