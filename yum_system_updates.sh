#!/bin/sh

###########################################################################################

#Script Name: yum_system_updates.sh

#Description: This script updates yum packages and sends the updated package list to email.

###########################################################################################


#Define variables
email=$(cat /git/Scripts/email.txt)
log=/var/log/yum_update_$(date +\%m.\%d.\%Y).txt

#Run system update
yum upgrade -y > $log

#Send system update log to email
cat "$log" | mailx -s "cloud1 Yum Updates for $(date +\%m.\%d.\%Y)" "$email"
