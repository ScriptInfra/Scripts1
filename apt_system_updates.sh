#!/bin/sh

########################################################################################################################################################################

#Script Name: apt_upgrade.sh

#Description: This script upgrades apt packages and sends the upgraded package list to email.

########################################################################################################################################################################

#Define system log
log=/var/log/apt_upgrade_$(date +\%m.\%d.\%Y).txt

#Run system upgrade
apt upgrade -y > $log

#Send system upgrade log to email
cat "$log" | mailx -s "System Update Status" andrewbatchelor5@gmail.com
