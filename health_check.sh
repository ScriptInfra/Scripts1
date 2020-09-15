#!/bin/sh

########################################################################################################################################################################

#Script Name: health_check.sh

#Description: This script queries if the following services are running: Syncthing, Folding@Home, KF2 server, Firewall

########################################################################################################################################################################


#Confirm user is running as root
if [ `whoami` != 'root' ]
        then
          echo "You must be root to run this script. This script will now exit."
          exit
fi


#define and cleanup health check log
rm /var/log/health_check_logs/health_check_log_$(date +\%m.\%d.\%Y).txt
touch /var/log/health_check_logs/health_check_log_$(date +\%m.\%d.\%Y).txt
log=/var/log/health_check_logs/health_check_log_$(date +\%m.\%d.\%Y).txt


#Clear screen for consumption
clear


#Prompt that health check script is running
echo | tee -a "$log"
echo "####################################" | tee -a "$log"
echo | tee -a "$log"
echo "### Starting system health check ###" | tee -a "$log"
echo | tee -a "$log"
echo "####################################" | tee -a "$log"


#Prompt user that script is checking Syncthing service status
echo | tee -a "$log"
echo "Checking Syncthing service status..." | tee -a "$log"


#Check if Syncthing service is running
syncthing_status=$(systemctl status syncthing@syncthing.service | grep Active)
syncthing_status_logic=$(systemctl status syncthing@syncthing.service | grep running | wc -l)

echo | tee -a "$log"
echo "Syncthing status:" $syncthing_status | tee -a "$log"
echo | tee -a "$log"

if [ "$syncthing_status_logic" == "1" ]; then
        echo "SUCCESS: Syncthing is running" | tee -a "$log"
        continue
        echo | tee -a "$log"
else
        echo "WARNING: Syncthing is not in a running state" | tee -a "$log"
        echo | tee -a "$log"
        cat "$log" | mailx -s "WARNING: Syncthing is not in a running state" andrewbatchelor5@gmail.com
        echo "Sending Syncthing status alert to AndrewBatchelor5@Gmail.com..." | tee -a "$log"
        echo | tee -a "$log"
fi


#Prompt user that script is checking Folding@Home service status
echo | tee -a "$log"
echo "------------------------------------------------------------" | tee -a "$log"
echo | tee -a "$log"
echo "Checking Folding@Home service status..." | tee -a "$log"


#Check if Folding@Home service is running
fah_status=$(/etc/rc.d/init.d/FAHClient status)
fah_status_logic=$(/etc/rc.d/init.d/FAHClient status | grep PID | wc -l)

echo | tee -a "$log"
echo "Folding@Home Status:" $fah_status | tee -a "$log"
echo | tee -a "$log"

if [ "$fah_status_logic" == "1" ]; then
        echo "SUCCESS: fahclient is running" | tee -a "$log"
        continue
	echo | tee -a "$log"
else
        echo "WARNING: Folding@Home is not in a running state" | tee -a "$log"
	echo | tee -a "$log"
	cat "$log" | mailx -s "WARNING: Folding@Home is not in a running state" andrewbatchelor5@gmail.com
	echo "Sending Folding@Home status alert to AndrewBatchelor5@Gmail.com..." | tee -a "$log"
	echo | tee -a "$log"
fi

#Start Folding@Home Service if it is not in a running state
if [ "$fah_status_logic" != "1" ]; then
	/etc/rc.d/init.d/FAHClient start
	echo "Folding@Home service has been started."
fi


#Start KF2 logic
echo | tee -a "$log"
echo "------------------------------------------------------------" | tee -a "$log"
echo | tee -a "$log"
echo "Checking KF2 server process and web status..." | tee -a "$log"
echo | tee -a "$log"


kf_process_status=$(ps -ef | grep -i kf | wc -l)

if [ "$kf_process_status" == 3 ]; then
        echo "SUCCESS: KF2 process is in a running state" | tee -a "$log"
	continue
        echo | tee -a "$log"
else
        echo "WARNING: KF2 process in not in a running state" | tee -a "$log"
        echo | tee -a "$log"
        cat "$log" | mailx -s "WARNING: KF2 process is not in a running state" andrewbatchelor5@gmail.com
        echo "Sending KF2 process status alert to AndrewBatchelor5@Gmail.com..." | tee -a "$log"
        echo | tee -a "$log"
fi

kf_web_status=$(curl -Is http://192.168.1.3:8080/ServerAdmin/current/info | grep -i "Content-Type: text/html" | awk '{print $1}')

if [ "$kf_web_status" == Content-Type: ]; then
	echo "SUCCESS: KF2 web test successfull" | tee -a "$log"
	continue
	echo | tee -a "$log"
else
	echo "WARNING: KF2 web test failed" | tee -a "$log"
	cat "$log" | mailx -s "WARNING: KF2 web test failed" andrewbatchelor5@gmail.com
	echo | tee -a "$log"
        echo "Sending KF2 web status alert to AndrewBatchelor5@Gmail.com..." | tee -a "$log"
        echo | tee -a "$log"
fi


echo | tee -a "$log"
echo "------------------------------------------------------------" | tee -a "$log"
echo | tee -a "$log"
echo "Checking Firewall service status..." | tee -a "$log"


#Check if Firewall service is running
firewall_status=$(systemctl status firewalld | grep Active)
firewall_status_logic=$(systemctl status firewalld | grep running | wc -l)

echo | tee -a "$log"
echo "Firewall status:" $firewall_status | tee -a "$log"
echo | tee -a "$log"

if [ "$firewall_status_logic" == "1" ]; then
        echo "SUCCESS: Firewall is running" | tee -a "$log"
        continue
        echo | tee -a "$log"
	echo | tee -a "$log"
else
        echo "WARNING: Firewall is not in a running state" | tee -a "$log"
        echo | tee -a "$log"
        cat "$log" | mailx -s "WARNING: Firewall is not in a running state" andrewbatchelor5@gmail.com
        echo "Sending Firewall status alert to AndrewBatchelor5@Gmail.com..." | tee -a "$log"
        echo | tee -a "$log"
	echo | tee -a "$log"
fi



#Prompt user that script is checking cpu temp
echo "------------------------------------------------------------" | tee -a "$log"
echo | tee -a "$log"
echo "Checking CPU temp..." | tee -a "$log"
echo | tee -a "$log"


#Check CPU temp
cpu_temp=$(sensors | grep Package | awk '{print $4}' | cut -c 2-3)

if [ $cpu_temp -lt 85 ]; then
	echo "SUCCESS: CPU temp within operating threshold" | tee -a $"log"
	echo | tee -a "$log"
        echo | tee -a "$log"
else
	echo "WARNING: CPU Temp over 85 degrees" | tee -a "$log"
	echo | tee -a "$log"
        cat "$log" | mailx -s "WARNING: CPU temp is above 85 degrees" andrewbatchelor5@gmail.com
        echo "Sending CPU temp alert to AndrewBatchelor5@Gmail.com..." | tee -a "$log"
        echo | tee -a "$log"
	echo | tee -a "$log"
fi
