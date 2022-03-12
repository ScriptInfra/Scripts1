#!/bin/sh

########################################################################################################################################################################

#Script Name: services_filesystem_status.sh

#Description: This script can be run prior to a reboot in order to gather the following stats: mounted filesystems, running services

########################################################################################################################################################################


email=$(cat /git/Scripts/email.txt)


# Create log file variable
log=pre_reboot_check_log_$(date +\%m.\%d.\%Y_backup).txt


#Confirm user is running as root
if [ `whoami` != 'root' ]
        then
          echo "You must be root to run this script. This script will now exit."
          exit
fi


# Sleep for consumption
sleep .5


# Prompt that service status is being gathered
echo | tee -a "$log"
echo "#####################################" | tee -a "$log"
echo | tee -a "$log"
echo "### Starting Service Status Check ###" | tee -a "$log"
echo | tee -a "$log"
echo "#####################################" | tee -a "$log"


# Sleep for consumption
sleep 1


# Identify OS versioning
OS_version=$(grep 6 /etc/system-release | awk '{print $3}' | cut -c 1; grep 7 /etc/system-release | awk '{print $3}' | cut -c 1)

if [ "$OS_version" == 6 ]; then
	service --status-all | tee -a "$log"
	echo
	echo
	echo
else
	systemctl list-units --type service --all | tee -a "$log"
	echo
	echo
	echo
fi


# Prompt that mounted filesystem status is being gathered
echo | tee -a "$log"
echo "################################################" | tee -a "$log"
echo | tee -a "$log"
echo "### Starting Mounted Filesystem Status Check ###" | tee -a "$log"
echo | tee -a "$log"
echo "################################################" | tee -a "$log"


# Sleep for consumption
sleep 1


df -h | tee -a "$log"
echo | tee -a "$log"
echo | tee -a "$log"
echo | tee -a "$log"


# Prompt user if they would like to receive email report
hostname=$(hostname)
execution=$(date)


while true; do
	read -p "Would you like to receive a copy of this report via email? (y/n) " yn
	case $yn in
		[Yy]* ) echo "Sending report to "$email"..."; cat "$log" | mailx -s "Pre-reboot" "$email"; break;;
		[Nn]* ) echo "No email will be sent..."; break;;
		* ) echo "Please answer yes or no.";;
	esac
done


# Cleanup run log file
rm pre_reboot_check_log_$(date +\%m.\%d.\%Y_backup).txt
