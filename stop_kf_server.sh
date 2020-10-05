#!/usr/bin/sh

########################################################


#Script Name: stop_kf_server.sh

#Description: This script can be leveraged to stop the KF2 Server


########################################################

#Display currently running KF2 server processes
echo
echo "Currently running KF2 processes:"
echo
ps -ef | grep -i kf


#Sleep for consumption
sleep 2


# Stop any running KF servers
pkill KF
