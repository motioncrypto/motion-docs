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
echo && echo && echo
sleep 2

# Check if is root
if [ "$(whoami)" != "root" ]; then
  echo "Script must be run as user: root"
  exit -1
fi

# Check for systemd
systemctl --version >/dev/null 2>&1 || { echo "systemd is required. Are you using Ubuntu 16.04 (Xenial)?"  >&2; exit 1; }

# Gather input from user
KEY=$1
if [ "$KEY" == "" ]; then
    echo "Enter your Masternode Private Key"
    read -e -p "(e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h) : " KEY
    if [[ "$KEY" == "" ]]; then
        echo "WARNING: No private key entered, exiting!!!"
        echo && exit
    fi
fi
IP=$(curl http://icanhazip.com --ipv4)
PORT="7979"
if [[ "$IP" == "" ]]; then
    read -e -p "VPS Server IP Address: " IP
fi
echo "Your IP and Port is $IP:$PORT"
if [ -n "$3" ]; then
    echo "Saving IP"
    DOCUMENTID=$(curl https://us-central1-motion-masternode-installer.cloudfunctions.net/saveIp?ip=$IP)
    echo "Your DocumentId is $DOCUMENTID"
fi
if [ -z "$2" ]; then
echo && echo "Pressing ENTER will use the default value for the next prompts."
    echo && sleep 3
    read -e -p "Add swap space? (Recommended) [Y/n] : " add_swap
fi
if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
    if [ -z "$2" ]; then
        read -e -p "Swap Size [2G] : " swap_size
    fi
    if [[ "$swap_size" == "" ]]; then
        swap_size="2G"
    fi
fi
if [ -z "$2" ]; then
    read -e -p "Install Fail2ban? (Recommended) [Y/n] : " install_fail2ban
    read -e -p "Install UFW and configure ports? (Recommended) [Y/n] : " UFW
fi

# Add swap if needed
if [[ ("$add_swap" == "y" || "$add_swap" == "Y" || "$add_swap" == "") ]]; then
    if [ -n "$3" ]; then
        curl "https://us-central1-motion-masternode-installer.cloudfunctions.net/step?id=${DOCUMENTID}&step=2"
    fi

    if [ ! -f /swapfile ]; then
        echo && echo "Adding swap space..."
        sleep 3
        sudo fallocate -l $swap_size /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
        sudo sysctl vm.swappiness=10
        sudo sysctl vm.vfs_cache_pressure=50
        echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
        echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf
    else
        echo && echo "WARNING: Swap file detected, skipping add swap!"
        sleep 3
    fi
fi


# Update system 
echo && echo "Upgrading system..."
if [ -n "$3" ]; then
    curl "https://us-central1-motion-masternode-installer.cloudfunctions.net/step?id=${DOCUMENTID}&step=3"
fi
sleep 3
sudo apt-get -y update
sudo apt-get -y upgrade

# Install required packages
echo && echo "Installing base packages..."
if [ -n "$3" ]; then
    curl "https://us-central1-motion-masternode-installer.cloudfunctions.net/step?id=${DOCUMENTID}&step=4"
fi
sleep 3
sudo apt-get -y install \
unzip \
python-virtualenv 

# Install fail2ban if needed
if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
    if [ -n "$3" ]; then
        curl "https://us-central1-motion-masternode-installer.cloudfunctions.net/step?id=${DOCUMENTID}&step=5"
    fi

    echo && echo "Installing fail2ban..."
    sleep 3
    sudo apt-get -y install fail2ban
    sudo service fail2ban restart 
fi

# Install firewall if needed
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
    if [ -n "$3" ]; then
        curl "https://us-central1-motion-masternode-installer.cloudfunctions.net/step?id=${DOCUMENTID}&step=6"
    fi

    echo && echo "Installing UFW..."
    sleep 3
    sudo apt-get -y install ufw
    echo && echo "Configuring UFW..."
    sleep 3
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw allow 3385/tcp
    sudo ufw allow 7979/tcp
    echo "y" | sudo ufw enable
    echo && echo "Firewall installed and enabled!"
fi

# Create config for motion
if [ -n "$3" ]; then
    curl "https://us-central1-motion-masternode-installer.cloudfunctions.net/step?id=${DOCUMENTID}&step=7"
fi
echo && echo "Putting The Gears Motion..."
sleep 3
sudo mkdir /root/.motioncore #jm

rpcuser=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
rpcpassword=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
sudo touch /root/.motioncore/motion.conf
echo '
rpcuser='$rpcuser'
rpcpassword='$rpcpassword'
rpcallowip=127.0.0.1
listen=1
server=1
rpcport=3385
daemon=0 # required for systemd
logtimestamps=1
maxconnections=256
externalip='$IP:$PORT'
masternodeprivkey='$KEY'
masternode=1
' | sudo -E tee /root/.motioncore/motion.conf


#Download pre-compiled motion and run
if [ -n "$3" ]; then
    curl "https://us-central1-motion-masternode-installer.cloudfunctions.net/step?id=${DOCUMENTID}&step=8"
fi
mkdir motion 
mkdir motion/src
cd motion/src
rm -rf ./motion-v*
#Select OS architecture
    if [ `getconf LONG_BIT` = "64" ]
        then
            DOWNLOADLINK=curl -s https://api.github.com/repos/motioncrypto/motion/releases/latest | grep browser_download_url | grep lin-64bits | cut -d '"' -f 4
            wget $DOWNLOADLINK
            unzip motion-v*
    else
        DOWNLOADLINK=curl -s https://api.github.com/repos/motioncrypto/motion/releases/latest | grep browser_download_url | grep lin-32bits | cut -d '"' -f 4
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

# Download and install sentinel
if [ -n "$3" ]; then
    curl "https://us-central1-motion-masternode-installer.cloudfunctions.net/step?id=${DOCUMENTID}&step=9"
fi
echo && echo "Installing Sentinel..."
sleep 3
cd
sudo apt-get -y install python3-pip
sudo pip3 install virtualenv
sudo git clone https://github.com/motioncrypto/sentinel.git /root/sentinel
cd /root/sentinel
virtualenv venv
. venv/bin/activate
pip install -r requirements.txt
export EDITOR=nano
(crontab -l -u root 2>/dev/null; echo '* * * * * cd /root/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1') | sudo crontab -u root -

# Create a cronjob for making sure motiond runs after reboot
if ! crontab -l | grep "@reboot motiond -daemon"; then
  (crontab -l ; echo "@reboot motiond -daemon") | crontab -
fi

# cd to motion-cli for final, no real need to run cli with commands as service when you can just cd there
echo && echo "Motion Masternode Setup Complete!"
echo && echo "Now we will wait until the node get full sync."

COUNTER=0
if [ -n "$3" ]; then
    curl "https://us-central1-motion-masternode-installer.cloudfunctions.net/step?id=${DOCUMENTID}&step=10"
fi
while [ $COUNTER -lt $TOTALBLOCKS ]; do
    echo The current progress is $COUNTER/$TOTALBLOCKS
    let COUNTER=$(motion-cli -datadir=/root/.motioncore getblockcount)
    sleep 5
done
echo "Sync complete"
if [ -n "$3" ]; then
    curl "https://us-central1-motion-masternode-installer.cloudfunctions.net/step?id=${DOCUMENTID}&step=11"
fi

echo && echo "If you put correct PrivKey and VPS IP the daemon should be running."
echo "Now you can start ALIAS on local wallet and finally check here with motion-cli masternode status."
echo && echo
