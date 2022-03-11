#!/usr/bin/sh

########################################################################## 


#Script Name: start_kf_server.sh 

#Description: This script can be leveraged to cleanly start the KF2 Server


########################################################################## 

# Enter screen session and start killing floor server

screen -d -m -t KF2_Server /steam/KF2/Binaries/Win64/KFGameSteamServer.bin.x86_64 KF-ZedLanding?Game=KFGameContent.KFGameInfo_Endless
