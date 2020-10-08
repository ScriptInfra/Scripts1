#!/bin/sh


########################################################################################################################################################################

#Script Name: reboot.sh 

#Description: This script will stop the Folding@Home service, and check if there are users on the KF2 server.
#KF2 aut-reboot logic has been removed. The concern is that Tripwire may update the server logic, and the script string will no longer correctly query user count

########################################################################################################################################################################


#Confirm user is running as root
if [ `whoami` != 'root' ]
	then
	  echo "You must be root to run this script. This script will now exit."
	  exit
fi


#Confirm user wants to reboot system
hostname=$(hostname)
echo
while true; do
    read -p "Are you sure you want to reboot $hostname? (y/n): " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo; echo "This script will now exit."; echo; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


#Confirm user has gracefully stopped the KF2 server
echo
while true; do
    read -p "Have you gracefully stopped the KF2 server? (y/n): " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo; echo "This script will now exit."; echo; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done


#define and cleanup reboot log
#rm /var/log/reboot_logs/reboot_log_$(date +\%m.\%d.\%Y).txt
touch /var/log/reboot_logs/reboot_log_$(date +\%m.\%d.\%Y).txt
log=/var/log/reboot_logs/reboot_log_$(date +\%m.\%d.\%Y).txt


#sleep for consumption
sleep 2


#Prompt that reboot script is running
echo | tee -a "$log"
echo "##############################" | tee -a "$log"
echo | tee -a "$log"
echo "### Starting system reboot ###" | tee -a "$log"
echo | tee -a "$log"
echo "##############################" | tee -a "$log"


#sleep for consumption
sleep 2


#Stop Folding@Home service
echo | tee -a "$log"
echo | tee -a "$log"
echo "Attempting to stop Folding@Home client..." | tee -a "$log"
echo | tee -a "$log"
/etc/rc.d/init.d/FAHClient stop


#Add wait to allow FAHClient to stop
sleep 3


#Confirm Folding@Home service is stopped
fah_status=$(/etc/rc.d/init.d/FAHClient status)

echo "Folding@Home Status:" $fah_status | tee -a "$log"
echo | tee -a "$log"

if [ "$fah_status" == "fahclient is not running" ]; then
	echo "SUCCESS: fahclient stopped gracefully" | tee -a "$log"
	continue
else
	echo "fahclient did not stop gracefully, this script will now exit" | tee -a "$log"
	exit
fi


#sleep for consumption
sleep 2


#Start KF2 logic
#echo | tee -a "$log"
#echo "------------------------------------------------------------" | tee -a "$log"
#echo | tee -a "$log"
#echo "Checking if there are possible active users on KF2 game server..." | tee -a "$log"
#echo | tee -a "$log"


#Check if there are any users on the KF2 server
#kf_check=$(tail -3000 /home/steam/Steam/Killing_Floor_2/KFGame/Logs/Launch.log | grep "GetLivingPlayerCount" | wc -l)
#
#if [ "$kf_check" -eq 0 ]; then
#	echo "SUCCESS: No active users found" | tee -a "$log"
#        continue
#else
#        echo "ACTION REQUIRED: Possible users were identified. Manually check to confirm there are no active users on the KF2 server. This script will now exit" | tee -a "$log"
#	echo | tee -a "$log"
#	cat | tee -a "$log"
#        exit
#fi


#sleep for consumption
sleep 2


#Email user log file
echo | tee -a "$log"
echo "------------------------------------------------------------" | tee -a "$log"
echo | tee -a "$log"
echo "Sending log file to AndrewBatchelor5@Gmail.com..." | tee -a "$log"
echo | tee -a "$log"


#sleep for consumption
sleep 3


#Perform reboot
echo | tee -a "$log"
echo "The system will now reboot" | tee -a "$log"

#cat "$log" | mailx -s "RHELInfra Reboot Log" andrewbatchelor5@gmail.com

#reboot
