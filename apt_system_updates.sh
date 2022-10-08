#!/bin/sh

##############################################################################################
#
# Script Name: apt_upgrade.sh
#
# Description: This script upgrades apt packages and sends the upgraded package list to email.
#
##############################################################################################


# Variables
log=/var/log/apt_upgrade_$(date +\%c).txt
email=$(cat /home/git/scripts/email.txt)


# Run system upgrade
apt upgrade -y > $log


# Send system upgrade log to email
cat "$log" | mailx -s "Ubuntu System Update Status for $(date +\%c)" $email
