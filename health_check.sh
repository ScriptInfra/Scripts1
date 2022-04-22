#!/bin/sh

###########################################################################################################
#
# Script Name: health_check.sh
#
# Description: This script queries if the following services are running: Syncthing, Folding@Home, Firewall
#
###########################################################################################################



# Clear screen

clear



email=$(cat /git/Scripts/email.txt)

# Confirm user is running as root

if [ `whoami` != 'root' ]
        then
          echo "You must be root to run this script. This script will now exit."
          exit
fi



# Clear screen for consumption

clear



# Prompt that health check script is running

echo ""
echo "################################"
echo "#                              #" 
echo "# Starting System Health Check #"
echo "#                              #"
echo "################################"


# Prompt user that script is checking Syncthing service status

echo ""
echo ""
echo "Checking Syncthing service status..."



# Check if Syncthing service is running

syncthing_status=$(systemctl status syncthing@syncthing | grep Active)
syncthing_status_logic=$(systemctl status syncthing@syncthing | grep running | wc -l)

echo ""
echo "Syncthing status:" $syncthing_status
echo ""

if [ "$syncthing_status_logic" == "1" ]
then
        echo "SUCCESS: Syncthing is running"
        continue
        echo ""
else
        echo "WARNING: Syncthing is not in a running state"
        echo ""
        echo "WARNING: Syncthing is not in a running state" | mailx -s "WARNING: Syncthing is not in a running state" "$email"
        echo "Sending Syncthing status alert to "$email"..."
        echo ""
fi



# Prompt user that script is checking Folding@Home service status

echo ""
echo "------------------------------------------------------------"
echo ""
echo "Checking Folding@Home service status..."



# Check if Folding@Home service is running

fah_status=$(systemctl status fahclient | grep -i running)
fah_status_logic=$(systemctl status fahclient | grep -i 'running' | wc -l)

echo ""
echo "Folding@Home Status:" $fah_status
echo ""

if [ "$fah_status_logic" == "1" ]; then
        echo "SUCCESS: fahclient is running"
        continue
	echo ""
else
        echo "WARNING: Folding@Home is not in a running state"
	echo ""
	cat "WARNING: Folding@Home is not in a running state" | mailx -s "WARNING: Folding@Home is not in a running state" "$email"
	echo "Sending Folding@Home status alert to "$email"..."
	echo ""
fi



# Start Folding@Home Service if it is not in a running state

if [ "$fah_status_logic" != "1" ]; then
	systemctl start fahclient
	echo "Folding@Home service has been started."
fi



# Start KF2 logic

#echo | tee -a "$log"
#echo "------------------------------------------------------------" | tee -a "$log"
#echo | tee -a "$log"
#echo "Checking KF2 server process and web status..." | tee -a "$log"
#echo | tee -a "$log"


#kf_process_status=$(ps -ef | grep -i kf | wc -l)

#if [ "$kf_process_status" == 3 ]; then
#        echo "SUCCESS: KF2 process is in a running state" | tee -a "$log"
#	continue
#        echo | tee -a "$log"
#else
#        echo "WARNING: KF2 process in not in a running state" | tee -a "$log"
#        echo | tee -a "$log"
#        cat "$log" | mailx -s "WARNING: KF2 process is not in a running state" "$email"
#        echo "Sending KF2 process status alert to "$email"..." | tee -a "$log"
#        echo | tee -a "$log"
#fi

#kf_web_status=$(curl -Is http://192.168.1.3:8080/ServerAdmin/current/info | grep -i "Content-Type: text/html" | awk '{print $1}')

#if [ "$kf_web_status" == Content-Type: ]; then
#	echo "SUCCESS: KF2 web test successfull" | tee -a "$log"
#	continue
#	echo | tee -a "$log"
#else
#	echo "WARNING: KF2 web test failed" | tee -a "$log"
#	cat "$log" | mailx -s "WARNING: KF2 web test failed" "$email"
#	echo | tee -a "$log"
#        echo "Sending KF2 web status alert to "$email"..." | tee -a "$log"
#        echo | tee -a "$log"
#fi


echo ""
echo "------------------------------------------------------------"
echo ""
echo "Checking Firewall service status..."



# Check if Firewall service is running

firewall_status=$(systemctl status firewalld | grep Active)
firewall_status_logic=$(systemctl status firewalld | grep running | wc -l)

echo ""
echo "Firewall status:" $firewall_status
echo ""

if [ "$firewall_status_logic" == "1" ]; then
        echo "SUCCESS: Firewall is running"
        continue
        echo ""
	echo ""
else
        echo "WARNING: Firewall is not in a running state"
        echo ""
        cat "WARNING: Firewall is not in a running state" | mailx -s "WARNING: Firewall is not in a running state" "$email"
        echo "Sending Firewall status alert to $"email"..."
        echo ""
	echo ""
fi



# Prompt user that script is checking cpu temp

echo "------------------------------------------------------------"
echo ""
echo "Checking CPU temp..."
echo ""



# Check CPU temp

cpu_temp=$(sensors | grep Package | awk '{print $4}' | cut -c 2-3)

if [ $cpu_temp -lt 80 ]; then
	echo "SUCCESS: CPU temp within operating threshold"
	echo ""
        echo ""
else
	echo "WARNING: CPU Temp over 80 degrees"
	echo ""
        cat "WARNING: CPU Temp over 80 degrees" | mailx -s "WARNING: CPU temp is above 85 degrees" "$email"
        echo "Sending CPU temp alert to "$email"..."
        echo ""
	echo ""
fi
