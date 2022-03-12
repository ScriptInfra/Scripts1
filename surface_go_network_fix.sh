#!/usr/bin/sh


######################################################################################## 

#Script Name: surface_go_network_fix.sh

#Description: This script can be leveraged to revert to the functional wireless firmware

########################################################################################

 

#Revert from backup
sudo cp /usr/lib/firmware/ath10k/QCA6174/hw2.1/board.bin_working_backup /usr/lib/firmware/ath10k/QCA6174/hw2.1/board.bin 
sudo cp /usr/lib/firmware/ath10k/QCA6174/hw3.0/board.bin_working_backup /usr/lib/firmware/ath10k/QCA6174/hw3.0/board.bin
