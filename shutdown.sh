#!/bin/sh


########################################################################################################################################################################
#
# Script Name: shutdown.sh
#
# Description: This script will stop the Folding@Home service, and check if there are users on the KF2 server. If there are no users, the server will shutdown
#
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
echo
while true; do
    read -p "Are you sure you want to shutdown $hostname? " yn
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


#Prompt that shutdown script is running
echo | tee -a "$log"
echo "##############################" | tee -a "$log"
echo | tee -a "$log"
echo "### Starting system shutdown ###" | tee -a "$log"
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

#if [ "$kf_check" -eq 0 ]; then
#        echo "SUCCESS: No active users found" | tee -a "$log"
#        continue
#else
#        echo "ACTION REQUIRED: Possible users were identified. Manually check to confirm there are no active users on the KF2 server. This script will now exit" | tee -a "$log"
#        echo | tee -a "$log"
#        cat | tee -a "$log"
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


#Shutdown the system
echo | tee -a "$log"
echo "The system will now shutdown" | tee -a "$log"

#cat "$log" | mailx -s "cloud1 Reboot Log" andrewbatchelor5@gmail.com

shutdown now
