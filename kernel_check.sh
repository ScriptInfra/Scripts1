#!/bin/sh

#####################################################################################
#
# Script Name: kernel_check.sh
#
# Description: This script will check if the system is on the latest kernel available
#
#####################################################################################



# Clear screen

clear



# Define variables

hostname=$(hostname)
email=$(cat /git/Scripts/email.txt)


latest_kernel_version=$(rpm -q --last kernel | perl -pe 's/^kernel-(\S+).*/$1/' | head -n1 | cut -c 1-11 | tr -d - | tr -d .)
current_kernel_version=$(uname -r | cut -c 1-11 | tr -d - | tr -d .)

# Check if server is running on the latest kernel available

if [ "$latest_kernel_version" -gt "$current_kernel_version" ]
then
	echo "$hostname is not running on the latest kernel version. Please reboot the server to pick up the latest kernel."
	echo "$hostname is not running on the latest kernel version. Please reboot the server to pick up the latest kernel." | mailx -s "$hostname Kernel Check" "$email"
 else
	echo ""
	echo "$hostname is running on the latest kernel version."
	echo ""
	exit
fi
