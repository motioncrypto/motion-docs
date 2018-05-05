**Preparation**

Get a VPS from a provider like DigitalOcean, Vultr, Linode, etc.
Recommended VPS size: 2GB RAM (if less its ok, we can make swap)
It must be Ubuntu 16.04 (Xenial)
Make sure you have a transaction of exactly 1000 MTN in your desktop cold wallet or ready to send.
motion.conf file on LOCAL wallet MUST BE EMPTY!
masternode.conf file on VPS wallet MUST BE EMPTY!
NOTES: PRE_ENABLED status is NOT an issue, just restart local wallet and wait a few minutes.
You need a different IP for each masternode you plan to host
This guide is for a single masternode, on a Ubuntu 14 64bit server (2GB RAM minimum) or 16.04 LTS. That will be controlled from the wallet on your local computer and all commands on VPS are running as root.

If your VPS doesn’t have enough RAM, create 2–4GB of swap memory using these commands line by line:

cd /
sudo dd if=/dev/zero of=swapfile bs=1M count=3000
sudo mkswap swapfile
sudo swapon swapfile
sudo nano etc/fstab
/swapfile none swap sw 0 0

**Wallet Setup Part 1**
Open your wallet on your desktop.
Click Receive, then click Request and put your Label such as “MN1”
Copy the Address and Send EXACTLY 1000 MTN to this Address
Go to the tab at the bottom that says "Tools"
Go to the tab at the top that says "Console"

Wait for 15 confirmations, then run following command:
masternode outputs

You should see one line corresponding to the transaction id (tx_id) of your 1000 coins with a digit identifier (digit). Save these two strings in a text file.
Example:
{
  "6a66ad6011ee363c2d97da0b55b73584fef376dc0ef43137b478aa73b4b906b0": "0"
}

Note that if you get more than 1 line, it’s because you made multiple 1000 coins transactions, with the tx_id and digit associated.
Run the following command:

masternode genkey

You should see a long key: (masternodeprivkey)
EXAMPLE: 7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
This is your masternode private key, record it to text file, keep it safe, do not share with anyone. This will be called “masternodeprivkey”

Next, you have to go to the data directory of your wallet 
Go to wallet settings=> and click “Open masternode configuration file”
You should see 2 lines both with a # to comment them out. Please make a new line and add:

MN1 (YOUR VPS IP):7979 masternodeprivkey tx_id digit

Put your data correctly, save it and close.
Go to Motion Wallet, Click Settings, Check “Show Masternodes Tab”
Save and Restart your wallet.
Note that each line of the masternode.conf file corresponds to one masternode if you want to run more than one node from the same wallet, just make a new line and repeat steps.

**VPS Setup**

Preparation:
Windows users will need a program called putty to connect to the VPS
For a guide of how to use putty to connect to a vps please use-
Digital ocean: https://www.digitalocean.com/community/tutorials/how-to-log-into-a-vps-with-putty-windows-users
Other: https://www.webhostface.com/kb/knowledgebase/connecting-to-vps-via-ssh/

Now, Use SSH to Log into your VPS
We need to install some dependencies. Please copy, paste and hit enter:

apt-get update;apt-get upgrade -y;apt-get dist-upgrade -y;apt-get install nano htop git wget -y;apt-get install build-essential libtool autotools-dev automake pkg-config -y;apt-get install libssl-dev libevent-dev bsdmainutils software-properties-common -y;apt-get install libboost-all-dev -y;apt-get install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev -y;add-apt-repository ppa:bitcoin/bitcoin -y;apt-get update;apt-get install libdb4.8-dev libdb4.8++-dev -y;

Now we have to build the wallet. Clone the Motion Github from Here:

git clone https://github.com/motioncrypto/motion.git

Then navigate to the newly created motion folder and execute the following, line by line:

cd motion
chmod 755 autogen.sh
./autogen.sh
./configure
chmod 755 share/genbuild.sh
make

**IMPORTANT**

Your build will FAIL if you do not have enough RAM memory. If you do not have 2GB or more make a Swap partition BEFORE you try to build!

This process can take a while, it will compile the Motion wallet.

After build completes, you need to start the daemon to create data folders and files, wait a few seconds and stop the daemon so you can edit the conf file on next step, use the follow comandos to navigate to src folder to do it:

cd src/
./motiond -daemon

Wait a few seconds then stops with:

./motion-cli stop

Navigate to the data directory by typing

cd /root/.motioncore
nano motion.conf

Now copy paste the following configuration :

rpcuser=user
rpcpassword=pass
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
rpcport=3385
staking=0
externalip=(YOUR VPS IP):7979
masternode=1
masternodeprivkey=masternodeprivkey

You need to change IP to your VPS IP address, the masternodeprivkey is the one that you got from the main wallet. Choose whatever you like for user and password. Note that the port should be 7979 for Motion masternodes and rpcport is 3385 for sentinel.

Type Ctrl + X => Y => Enter. The file motion.conf is now saved.

If you have a firewall running, you need to open the 7979 and 3385 port :

sudo ufw allow 7979/tcp
sudo ufw allow 3385/tcp

Now Let's restart

cd /root/motion/src/
./motiond -daemon

Wait like 10 mins for your wallet to download the blockchain. You can check the progress with the following command :

./motion-cli getblockcount

Now we need SENTINEL to fix WATCHDOG EXPIRED issue, run this 1 line for it:

**Install Prerequisites**
Make sure Python version 2.7.x or above is installed:

python --version
Update system packages and ensure virtualenv is installed:

sudo apt-get update
sudo apt-get update; sudo apt-get install python3-pip
sudo pip3 install virtualenv

Make sure the local Motion daemon running is at least version 0.1.0 (10000)

**Install Sentinel**
Clone the Sentinel repo and install Python dependencies.

cd
git clone https://github.com/motioncrypto/sentinel.git && cd sentinel
virtualenv ./venv
./venv/bin/pip install -r requirements.txt

**Set up Cron**
Set up a crontab entry to call Sentinel every minute:

crontab -e

In the crontab editor, add the lines below, replacing '/home/YOURUSERNAME/sentinel' to the path where you cloned sentinel to:

* * * * * cd /home/YOURUSERNAME/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1

**Test the Configuration**
Test the config by runnings all tests from the sentinel folder you cloned into

./venv/bin/py.test ./test

With all tests passing and crontab setup, Sentinel will stay in sync with motiond and the installation is complete

**Configuration**
An alternative (non-default) path to the motion.conf file can be specified in sentinel.conf:

motion_conf=/path/to/motion.conf

**Troubleshooting**
To view debug output, set the SENTINEL_DEBUG environment variable to anything non-zero, then run the script manually:

SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py

**Starting Your Masternode**

Go back to your desktop wallet, to the Masternode tab.
You need to wait for 15 confirmations in order to start the masternode On your VPS you can type: motion-cli getblockcount (needs to be more than 0 to be in sync)
NOTE: If the Masternode tab isn’t showing, you need to  click settings, check “Show Masternodes Tab” save, and restart the wallet
If your Masternode does not show, restart the wallet
 
Now Click “start-all”. Your masternode should be now up and running !

**Checking Your Masternode**
You can check the masternode status by going to the masternode vps and typing:

cd /root/motion/src/
./motion-cli masternode status
 
If your masternode is running it should print “Masternode successfully started”.
 
You can also check your Masternode status by local wallet - tools - console, just type:
 
masternode list full XXXXX
 
(Where XXXXX is yours first 5 character of TX_ID).
