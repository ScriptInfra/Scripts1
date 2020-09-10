#!/bin/sh

########################################################################################################################################################################

#Script Name: yum_system_updates.sh

#Description: This script updates yum packages and sends the updated package list to email.

########################################################################################################################################################################

#Define update log
log=/var/log/yum_update_$(date +\%m.\%d.\%Y).txt

#Run system update
yum upgrade -y > $log

#Send system update log to email
cat "$log" | mailx -s "RHEL System Update Status for $(date +\%m.\%d.\%Y)" andrewbatchelor5@gmail.com
