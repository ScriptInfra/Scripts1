#!/bin/sh -x

########################################################################################################################################################################

#Script Name: kernel_check.sh

#Description: This script will check if the system is on the latest kernel available

########################################################################################################################################################################

# Define variables
rm /var/log/kernel_check_log_$(date +\%m.\%d.\%Y).txt
touch /var/log/kernel_check_log_$(date +\%m.\%d.\%Y).txt
log=/var/log/kernel_check_log_$(date +\%m.\%d.\%Y).txt

latest_kernel_version=$(rpm -q --last kernel | perl -pe 's/^kernel-(\S+).*/$1/' | head -n1 | cut -c 1-15 | tr -d - | tr -d .)
current_kernel_version=$(uname -r | cut -c 1-15 | tr -d - | tr -d .)

# Check if server is running on the latest kernel available
if [ "$latest_kernel_version" -gt "$current_kernel_version" ]; then
	echo "System is not on the latest kernel version. Please reboot the server to pick up the latest kernel." > "$log"
	cat "$log" | mailx -s "RHELInfra Kernel Check" andrewbatchelor5@gmail.com
	exit
fi
