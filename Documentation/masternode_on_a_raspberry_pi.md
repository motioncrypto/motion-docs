**WARNING**
The Raspberry pi is not a good choice for a Masternode. It's going to give you a ton of errors, but it will work. You may need to scrap
and re-install later on as the blockcount grows and you run out of space. Either way, its dirt cheap and it does work. Plus you could
probably run other home automations from it and get the most out of it. This is not for the faint of heart.

**Preparation**
You will need a Raspberry pi 2 or 3
A 64GB (or More) SD Card
Download and Install Rasbian (lastest) to the pi
Make sure you have a transaction of exactly 1000 MTN in your desktop cold wallet or ready to send.
motion.conf file on LOCAL wallet MUST BE EMPTY!
masternode.conf file on VPS wallet MUST BE EMPTY!
NOTES: PRE_ENABLED status is NOT an issue, just restart local wallet and wait a few minutes.
You need a different IP for each masternode you plan to hos
This guide is for a single masternode, on a Ubuntu 14 64bit server (2GB RAM minimum) or 16.04 LTS. That will be controlled from the wallet on your local computer and all commands on VPS are running as root.

First we need to create 2–4GB of swap memory using these commands line by line:

cd /
sudo dd if=/dev/zero of=swapfile bs=1M count=3000
sudo mkswap swapfile
sudo swapon swapfile
sudo nano etc/fstab
/swapfile none swap sw 0 0

**Wallet Setup Part 1**
go to whatismyipaddress.com and take note of your IP. 
Then pull the plug on your modem, wait a bit and replug. Check the page again. If the same then good! If not, you will need to either:
A) Get a "Static IP Address" From your Service provider or
B) Monitor your IP Address and change info if it changes.
Moving on:
Open your wallet on your desktop.
Click Receive, then click Request and put your Label such as “MN1”
Copy the Address and Send EXACTLY 1000 MTN to this Address
Go to the tab at the bottom that says "Tools"
Go to the tab at the top that says "Console"
Wait for 15 confirmations, then run following command: masternode outputs
You should see one line corresponding to the transaction id (tx_id) of your 1000 coins with a digit identifier (digit). Save these two strings in a text file. Example:
EXAMPLE:
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

MN1 (YOUR IP):7979 masternodeprivkey tx_id digit

Put your data correctly, save it and close.
Go to Motion Wallet, Click Settings, Check “Show Masternodes Tab”
Save and Restart your wallet.
Note that each line of the masternode.conf file corresponds to one masternode if you want to run more than one node from the same wallet, just make a new line and repeat steps.

**Raspberry Pi Setup**

Preparation:
Windows users will need a program called putty to connect to the Pi
For a guide of how to use putty to connect please use- https://www.raspberrypi.org/documentation/remote-access/ssh/windows.md
The default login for Raspbian is: pi 
password: raspberry

Fetch the IP

On Windows press windowsbutton+R. type 'cmd' and press enter. 
type IPCONFIG and press enter. 
Scroll up a bit till you see Standard Gateway. Take note of the IP. 99% of the time it starts with 192.168.1.xxx or 192.168.0.xxx


Config your router 

Start your browser and enter that IP. You will now see your router's website. Enter login + password (sticker on router?)
In the menu's somewhere there is a list of connected devices. They all have a IPaddress. Take note of the one called RASPBERRY.

Somewhere in the menus of your router you can do a DHCP reservation for the IP address of the Pi.
This means everytime the Pi boots it gets the same IPaddress. Thats what we want. We dont want it to change.
Dunno your router so cannot help on this one please check manual or do a search on it.

Now, in the menu of the router there is a NAT or PORT FORWARD menu. Enter the IPaddress of the Pi and open port 7979 and 3385.
Usally by just filling all portboxes IN / OUT etc. Maybe you just have one box to put it in.

Save the config of the router and reboot it. (also in the menus somewhere)

You are now re-routes internet traffic on port 7979 and 3385 to your Pi.

Now, Use SSH to Log into your Pi
After you have logged in, please copy paste and then hit enter:

sudo raspi-config

You are shown a simple menu. We are gonna do options 1 2 and 3. Use the arrows and tab to navigate.
1. Expand the filesystem so it uses the whole 32gb of the SDcard
2. Change the password of the user pi. Make a strong password!
3. Make it boot to command-line. So that way we save some ram by not loading the desktop enviroment that we will not be using anyways.

It should reboot automatically afterwards, but if not manually type in and press enter:

sudo reboot

Putty will give an error it has lost connection. Reopen Putty and log in again. Remember you got a new password for the user 'pi'.

We need to install some dependencies. Please copy, paste and hit enter:

sudo su

apt-get update;apt-get upgrade -y;apt-get dist-upgrade -y;apt-get install nano htop git -y;apt-get install build-essential libtool autotools-dev automake pkg-config joe -y;apt-get install autotools-dev autoconf -y;apt-get install libssl-dev libevent-dev bsdmainutils software-properties-common dh-autoreconf -y;apt-get install libboost-all-dev ufw protobuf-compiler libprotobuf-dev -y;apt-get install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev -y;add-apt-repository ppa:bitcoin/bitcoin -y;apt-get update;apt-get install libdb-dev libdb++-dev libqt4-dev -y;

Now we have to build the wallet. Clone the Motion Github from Here:

git clone https://github.com/motioncrypto/motion.git

Then navigate to the newly created motion folder and execute the following, line by line:

cd motion
chmod 755 autogen.sh
./autogen.sh
./configure --with-incompatible-bdb
chmod 755 share/genbuild.sh
make

**IMPORTANT**

Your build will FAIL if you do not have enough RAM memory. If you do not have 2GB or more make a Swap partition BEFORE you try to build!
This Will take a really really long time and will throw a million errors. This is natural as it is, a Raspberry Pi. Don't worry as it will still work once your done, it will compile the Motion wallet.

After build completes, you need to start the daemon to create data folders and files, wait a few seconds and stop the daemon so you can edit the conf file on next step, use the following commands to navigate to src folder to do it:

cd src/
./motiond -daemon

Wait a few seconds then stops with:

./motion-cli stop

Navigate to the data directory by typing

cd /root/.motioncore
nano motion.conf

Now copy paste the following configuration:

rpcuser=user
rpcpassword=pass
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
rpcport=3385
staking=0
externalip=(YOUR IP):7979
masternode=1
masternodeprivkey=masternodeprivkey

You need to change IP to your public IP address, the masternodeprivkey is the one that you got from the main wallet. Choose whatever you like for user and password. Note that the port should be 13385 for Motion masternodes and rpcport is 3385 for sentinel.

Type Ctrl + X => Y => Enter. The file motion.conf is now saved.

We need to open the 7979 and 3385 port :

sudo ufw allow ssh/tcp
sudo ufw limit ssh/tcp
sudo ufw allow 7979/tcp
sudo ufw allow 3385/tcp
sudo ufw logging on
sudo ufw enable

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

In the crontab editor, add the lines below, replacing '/root/sentinel' to the path where you cloned sentinel to:

* * * * * cd /root/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1

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
You need to wait for 15 confirmations in order to start the masternode On your Pi you can type: motion-cli getblockcount (needs to be more than 0 to be in sync)
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
