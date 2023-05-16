#!/usr/bin/sh

#wget install/update script
wget https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh
chmod +x Joplin_install_and_update.sh

#run the install/update script
./Joplin_install_and_update.sh --prerelease

#cleanup the install/update script
rm -f Joplin_install_and_update.sh 
