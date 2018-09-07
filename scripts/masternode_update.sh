#!/bin/bash

clear
cd ~
echo "███████████████████████████████████████████████████████████████████████████████"
echo "███████████████████░░   ░▒█████████████████████████▓░    ░▒████████████████████"
echo "██████████████████▓░      ░▓██████████████████████▒      ░░████████████████████"
echo "██████████████████▓░        ▒███████████████████▓░       ░▓████████████████████"
echo "██████████████████▓░         ░▓████████████████▒       ░░██████████████████████"
echo "██████████████████▓░     ░     ░▒███████████▓░      ░▒█████████████████████████"
echo "██████████████████▓░     ░░      ░▓████████▒       ░▓██████████████████████████"
echo "██████████████████▓░     ░▓█▓░      ░▒█▓░        ░░████████████████████████████"
echo "██████████████████▓░     ░▓███▒      ░░░      ░░▓██████████████████████████████"
echo "██████████████████▓░     ░▓████▒             ░▓████████████████████████████████"
echo "██████████████████▓░     ░▓█████▓░          ░██████████████████████████████████"
echo "██████████████████▓░     ░▓███████▒       ░▓███████████████████████████████████"
echo "██████████████████▓░     ░▓████████▓░   ░▒█████████████████████████████████████"
echo "██████████████████▓░     ░▓███████████▓▓███████████████████████████████████████"
echo "██████████████████▓░     ░▓████████████████████████████████████████████████████"
echo "██████████████████▓░     ░▓██████████████████████████▓▓▓▓▓█████████████████████"
echo "██████████████████▓░     ░▓█████████████████████████▓▓▓▓▓▓▓████████████████████"
echo "███████████████████▒     ▒███████████████████████████▓▓▓▓▓█████████████████████"
echo "█████████████████████▓▓▓███████████████████████████████████████████████████████"
echo "Masternode Updater"
echo && echo && echo
sleep 2

echo "Stopping Motion..."
motion-cli -datadir=/root/.motioncore stop

# Check if is root
if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

#Download pre-compiled motion and run
mkdir motion 
mkdir motion/src
cd motion/src
rm -rf ./motion-v*
#Select OS architecture
    if [ `getconf LONG_BIT` = "64" ]
        then
          DOWNLOADLINK=$(curl -s https://api.github.com/repos/motioncrypto/motion/releases/latest | grep browser_download_url | grep lin-64bits | cut -d '"' -f 4)
          wget $DOWNLOADLINK
          unzip motion-v*
    else
      DOWNLOADLINK=$(curl -s https://api.github.com/repos/motioncrypto/motion/releases/latest | grep browser_download_url | grep lin-64bits | cut -d '"' -f 4)
      wget $DOWNLOADLINK
      unzip motion-v*
    fi
chmod +x motiond
chmod +x motion-cli
chmod +x motion-tx

# Move binaries do lib folder
sudo mv motion-cli /usr/bin/motion-cli
sudo mv motion-tx /usr/bin/motion-tx
sudo mv motiond /usr/bin/motiond

#run daemon
motiond -daemon -datadir=/root/.motioncore

TOTALBLOCKS=$(curl https://explorer.motionproject.org/api/getblockcount)

sleep 10

# cd to motion-cli for final, no real need to run cli with commands as service when you can just cd there
echo && echo "Motion Masternode Update Complete!"
echo && echo "Now we will wait until the node get full sync."

COUNTER=0
while [ $COUNTER -lt $TOTALBLOCKS ]; do
    echo The current progress is $COUNTER/$TOTALBLOCKS
    let COUNTER=$(motion-cli -datadir=/root/.motioncore getblockcount)
    sleep 5
done
echo "Sync complete"

echo && echo "If everything is fine, you just need to start ALIAS on your local wallet and enjoy your earnings."
echo && echo
