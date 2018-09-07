Motion Multiple MasterNode Install
-------

### Preparation

- **Recommended VPS size:** 2GB RAM (if less its ok, we can make swap partition)
- **It must be Ubuntu 16.04 (Xenial)**
- Make sure you have a transaction of **exactly 1000 XMN* for each Masternode, in your desktop wallet. If you dont, you can make that transaction from you to you. Just go to receive tab, make a label, click request, copy the address and send 1000 XMN to the new address.
- motion.conf file on LOCAL wallet MUST BE EMPTY! (if you haven't touched this file it's OK)
- masternode.conf file on VPS wallet MUST BE EMPTY! (if you haven't touched this file it's OK)
- **IMPORTANT** You need a different IP for EACH masternode you plan to host
This will be different for each provider. You will need to log in to your VPS account online, and find the option to buy "Additional IP Address"
Order 1 IP address per Masternode, keeping in mind that 1 already comes stock. So for 4 Masternodes, order 3 Additional IP Addresses.

This guide is for a installing Multiple Masternodes, on a Ubuntu 16.04 LTS VPS. We will setup a swap partition so don't worry about the ram size, pick out a vps that fit's your budget. That will be controlled from the wallet on your local computer and most commands on VPS are running as root. We will create 4 new users and each will host the files for running Motiond.

**NOTES:** `WATCHDOG_EXPIRED` status is NOT an issue, just restart local wallet and wait a few minutes as everything syncs.


### Wallet Setup Part 1
Let's get your wallet all setup. What we suggest to do is transfer all of the coins in one transaction, then make each collateral output one after the next.

- Open your wallet on your desktop.
- Go to "Settings" then select "Advanced Settings" Then select "Show Masternodes" click save, Restart wallet
- Open back The Motion Wallet then get your XMN ready to send.
- Click `Receive`, then click `Request` and put a Label that you want to see payments show up as like â€œMN1â€.
- Click "Request" and copy the Address and Send **EXACTLY** 1000 XMN to this Address
- Go to the tab at the bottom that says `Tools`
- Go to the tab at the top that says `Console`

Wait for 15 confirmations, then run following command:

`masternode outputs`

You should see one line corresponding to the transaction id (tx_id) of your 1000 coins with a digit identifier (digit). Save these two strings in a text file.

Example:
```
{
  "6a66ad6011ee363c2d97da0b55b73584fef376dc0ef43137b478aa73b4b906b0": "0"
}
```

Copy this and paste it to that text file.

Note that if you get more than 1 line, itâ€™s because you made multiple 1000 XMN transactions, with the tx_id and digit associated. This isn't a problem, we just do some extra steps to make a new genkey for each one.

Now, type in and run the following command:

`masternode genkey`

You should see a long key: (masternodeprivkey)

EXAMPLE: `7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

This is your masternode private key, copy and paste it to the text file, keep it safe, do not share with anyone. This will be called `masternodeprivkey`

Depending on how many Masternodes you want to set up, you will need to repeat these steps for each one. 
Now we need to repeat the same steps for each 1000 XMN transaction you have to make.

- Open wallet
- Select receive tab
- Make a new label and send 1000 XMN to this new address.
- Wait 15 confirmations, then open console and run `masternode outputs` then `masternode genkey`
- Take down this info, taking care to make sure you have each individual output separated.
- Repeat as many times as needed, remember you need a different IP Address assigned for each Masternode.
Don't worry, we will cover this part shortly.


Next, We need to get the configuation files ready.

- Open Wallet 
- Select "settings" => and click "Open masternode configuration file"
- Open this file with a text editor like notepad or notepad ++

You should see 2 lines both with a # to comment them out, Like this EXAMPLE:

```
# Masternode config file dc56e5560618aca0bdb900e5cd75f25b37910ae9ca7a214ca3d5c935f1912d62
# Format: alias IP:port masternodeprivkey collateral_output_txid collateral_output_index
# Example: mn1 127.0.0.2:19999 93HaYBVUCYjEMeeH1Y4X37tGBDQL8Xg 2bcd3c84c84f87ea188100324456a67c 0
```

The Format here is:

`MN1(LABEL)(YOUR VPS IP):7979 masternodeprivkey tx_id digit`

Please make a new line, or clear the document and put the information we copied earlier.

Example:

`MN1 148.124.58.33:7979 7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 6a66ad6011ee363c2d97313773b4b906b0 0`

So now it should look something like:

```
# Masternode config file dc56e5560618aca0bdb900e5cd75f25b37910ae9ca7a214ca3d5c935f1912d62
# Format: alias IP:port masternodeprivkey collateral_output_txid collateral_output_index
# Example: mn1 127.0.0.2:19999 93HaYBVUCYjEMeeH1Y4X37tGBDQL8Xg 2bcd3c84c84f87ea18810d0324456a67c 0
MN1 148.124.58.33:7979 7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 6a66ad6011ee363c2d973137b73b4b906b0 0
```
We now need to do this for each Masternode you want to set up, taking each of the outputs from `masternode ouputs` and `masternode genkey`
EXAMPLE:

```
# Masternode config file dc56e5560618aca0bdb900e5cd75f25b37910ae9ca7a214ca3d5c935f1912d62
# Format: alias IP:port masternodeprivkey collateral_output_txid collateral_output_index
# Example: mn1 127.0.0.2:19999 93HaYBVUCYjEMeeH1Y4X37tGBDQL8Xg 2bcd3c84c84f87ea18810d0324456a67c 0
MN1 165.124.58.33:7979 6xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 6a66ad6011ee363c2d973137b73b4b906b0 0
MN2 148.125.59.31:7979 7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 8a66ad6011ee363c2d973137b73b4b906b2 1
MN3 187.126.60.22:7979 9xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 9a66ad6011ee363c2d973137b73b4b90690 0
MN4 165.134.56.32:7979 0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 7a66ad6011ee363c2d973137b73b4b906b1 1
```

Put your data correctly, and save it. Keep this open though, we will need it.
Now save the document, backup your wallet and restart your wallet. Under "Masternode Tab" you will see the entries we just made as "Missing".

### VPS Setup

Preparation:

Windows users will need a program called [putty](https://www.putty.org/) to connect to the VPS

For a guide of how to use putty to connect to a vps please use-

Digital ocean:

https://www.digitalocean.com/community/tutorials/how-to-log-into-a-vps-with-putty-windows-users

Other: 

https://www.webhostface.com/kb/knowledgebase/connecting-to-vps-via-ssh/

**IMPORTANT** As said before, you need 1 IP address per Masternode you want to install. To get multiple addresses, you need to sign into your vps account, then order "additional IP Address" (IPV4) then assign it to the vps you want to use.

Now, Use SSH to Log into your VPS. Use either the login info they provide you, or the Main IP Address. You will need to login with:
root@(YOUR VPS IP) in where Putty says "host"
Then press "open"
Now copy the password provided by your account, and right click ONCE on putty then press ENTER

We need to install some dependencies. Please copy, paste and hit enter:

```
apt-get update;apt-get upgrade -y;apt-get install nano htop git wget unzip -y;
```

If your VPS is 1 GB or less of RAM, We need to make swap memory by using these commands line by line:

```
cd
sudo dd if=/dev/zero of=swapfile bs=1M count=3000
sudo mkswap swapfile
sudo swapon swapfile
```

Now we need to edit the fstab file to add the swap, copy, paste and press enter:

`sudo nano /etc/fstab`

copy and paste this one line, save with crtl x and y to save:

`/swapfile none swap sw 0 0`

If you have a firewall running, you need to open the `7979` `3385` `3386` `3387` `3388` ports, example on UFW:

```
sudo ufw allow ssh
sudo ufw allow 7979/tcp
sudo ufw allow 3385/tcp
sudo ufw allow 3386/tcp
sudo ufw allow 3387/tcp
sudo ufw allow 3388/tcp
sudo ufw enable
```

Now we have to make the users. You will need 1 user for every Masternode you are trying to run:

`sudo adduser motion1`

You will need to then provide a password for the user, and default info. Remember the password, we will need it.

`sudo usermod -a -G sudo motion1`

Repeat this now, for each Masternode you plan to install.

`sudo adduser motion2`

`sudo usermod -a -G sudo motion2`

etc.

Next, we need to download and get Motiond installed. Do:

`wget https://github.com/motioncrypto/motion/releases/download/v0.1.2/motion-v0.1.2-lin-64bits.zip`

`unzip motion-v0.1.2-lin-64bits.zip`

`chmod +x motion*`

```
sudo mv motion-cli /usr/bin/motion-cli
sudo mv motion-tx /usr/bin/motion-tx
sudo mv motiond /usr/bin/motiond
```

Now we need to login to each user and setup the Masternodes (depending on how many you make). Do:

`su motion1`

Enter your password, hit enter.

Now lets get the folders ready.

`cd`

`mkdir .motioncore`

Now, let's get your motion.conf ready with:

`cd .motioncore`

`nano motion.conf`

Copy and paste this configuration template, add in your own variables:

```
rpcuser=<make a user>
rpcpassword=<make a password>
rpcallowip=127.0.0.1
rpcport=3385
bind=<your main ip address>
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
staking=0
externalip=<your main ip address and motion port 7979>
masternode=1
masternodeprivkey=<masternodeprivkey for MN1>
```
To edit this in putty, you need to use the arrow keys to navigate to the place you need to edit, delete and add the info from masternode.conf
- For rpcuser and pass, make up something you can remember, it can be random no problem.
- For `bind` you need to add the Main IP address provided for your VPS, only the IP
- For `externalip` you need to have your MN1 VPS IP and Motiond port EXAMPLE: 165.124.58.33:7979
- For  `masternodeprivkey` you need to use the MN1 Masternode genkey we made earlier.

Save this by using crtl x and Y to save.

Let's get Motiond running. Do:

`cd`

`motiond -daemon`

Motiond should now have started! 

It will take about 10 mins for your wallet to download the blockchain. You can check the progress with the following command :

`motion-cli getblockcount`

Now we need SENTINEL to fix WATCHDOG EXPIRED issue:

### Install Prerequisites For Sentinel
First, we need to return back to home do:

`cd`

Now Make sure Python version 2.7.x or above is installed:

`python --version`

Update system packages and ensure virtualenv is installed:

```
sudo apt-get update
sudo apt-get update; sudo apt-get install python3-pip
sudo pip3 install virtualenv
```

### Install Motion Sentinel
Clone the Sentinel repo and install Python dependencies.

type in terminal line by line:

```
cd
git clone https://github.com/motioncrypto/sentinel.git && cd sentinel
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
```

### Set up Cron
Set up a crontab entry to call Sentinel every minute:

`crontab -e`

In the crontab editor, add the lines below, replace `/home/YOURUSERNAME/sentinel` to the path where you cloned sentinel: (should be /motion1)

```
* * * * * cd /home/motion1/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1
@reboot motiond -daemon
```

### Troubleshooting
To view debug output, set the SENTINEL_DEBUG environment variable to anything non-zero, then run the script manually:

SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py

###MasterNode Number 2
Congrats, your MN1 should be running, and synced by now. Let's get the rest ready.

`su motion2`

Then enter the password

`cd`

Your now in the motion2 home folder. We will need to repeat the same steps as motion1

Now lets get the folders ready.

`cd`

`mkdir .motioncore`

Now, let's get your motion.conf ready with:

`cd .motioncore`

`nano motion.conf`

Copy and paste this configuration template, add your variables:

```
rpcuser=<make a user>
rpcpassword=<make a password>
rpcallowip=127.0.0.1
rpcport=3386 #<-you need a different port for every MN
bind=<your Second ip address>
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
staking=0
externalip=<your Second ip address and motion port 7979>
masternode=1
masternodeprivkey=<masternodeprivkey for MN2>
```
To edit this in putty, you need to use the arrow keys to navigate to the place you need to edit, delete and add the info from masternode.conf
- For rpcuser and pass, make up something you can remember, it can be random no problem.
- For `bind` you need to add the Second IP address provided for your VPS, only the IP
- For `externalip` you need to have your MN2 VPS IP and Motiond port EXAMPLE: 148.125.59.31:7979
- For  `masternodeprivkey` you need to use the MN2 Masternode genkey we made earlier.

Save this by using crtl x and Y to save.

Let's get Motiond running. Do:

`cd`

`motiond -daemon`

Motiond should now have started! 

It will take about 10 mins for your wallet to download the blockchain. You can check the progress with the following command :

`motion-cli getblockcount`

Now we need SENTINEL to fix WATCHDOG EXPIRED issue:

### Install Motion Sentinel
Clone the Sentinel repo and install Python dependencies.

type in terminal line by line:

```
cd
git clone https://github.com/motioncrypto/sentinel.git && cd sentinel
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
```

### Set up Cron
Set up a crontab entry to call Sentinel every minute:

`crontab -e`

In the crontab editor, add the lines below, replace `/home/YOURUSERNAME/sentinel` to the path where you cloned sentinel: (should be /motion1)


```
* * * * * cd /home/motion2/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1
@reboot motiond -daemon
```

### Troubleshooting
To view debug output, set the SENTINEL_DEBUG environment variable to anything non-zero, then run the script manually:

SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py

**NOTE:** You will need to repeat these steps for each Masternode you are going to install on this VPS. I suggest you do NO MORE than 4 per VPS

Now we need to login to each user and setup the 3rd Masternode. Do:

`su motion3`

Enter your password, hit enter.

Now lets get the folders ready.

`cd`

`mkdir .motioncore`

Now, let's get your motion.conf ready with:

`cd .motioncore`

`nano motion.conf`

Copy and paste this configuration template:

```
rpcuser=<make a user>
rpcpassword=<make a password>
rpcallowip=127.0.0.1
rpcport=3387
bind=<your third ip address>
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
staking=0
externalip=<your third ip address and motion port 7979>
masternode=1
masternodeprivkey=<masternodeprivkey for MN3>
```
To edit this in putty, you need to use the arrow keys to navigate to the place you need to edit, delete and add the info from masternode.conf
- For rpcuser and pass, make up something you can remember, it can be random no problem.
- For `bind` you need to add the third IP address provided for your VPS, only the IP
- For `externalip` you need to have your MN3 VPS IP and Motiond port EXAMPLE: 165.124.58.33:7979
- For  `masternodeprivkey` you need to use the MN3 Masternode genkey we made earlier.

Save this by using crtl x and Y to save.

Let's get Motiond running. Do:

`cd`

`motiond -daemon`

Motiond should now have started! 

It will take about 10 mins for your wallet to download the blockchain. You can check the progress with the following command :

`motion-cli getblockcount`

Now we need SENTINEL to fix WATCHDOG EXPIRED issue:

### Install Motion Sentinel
Clone the Sentinel repo and install Python dependencies.

type in terminal line by line:

```
cd
git clone https://github.com/motioncrypto/sentinel.git && cd sentinel
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
```

### Set up Cron
Set up a crontab entry to call Sentinel every minute:

`crontab -e`

In the crontab editor, add the lines below, replace `/home/YOURUSERNAME/sentinel` to the path where you cloned sentinel: (should be /motion3)

```
* * * * * cd /home/motion3/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1
@reboot motiond -daemon
```

### Troubleshooting
To view debug output, set the SENTINEL_DEBUG environment variable to anything non-zero, then run the script manually:

SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py

###MasterNode Number 4
Congrats, your MN should be running, and synced by now. Let's get the last one ready.

`su motion4`

Then enter the password

`cd`

Your now in the motion4 home folder. We will need to repeat the same steps as motion1

Now lets get the folders ready.

`cd`

`mkdir .motioncore`

Now, let's get your motion.conf ready with:

`cd .motioncore`

`nano motion.conf`

Copy and paste this configuration template:

```
rpcuser=<make a user>
rpcpassword=<make a password>
rpcallowip=127.0.0.1
rpcport=3388 #<-you need a different port for every MN
bind=<your fourth ip address>
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
staking=0
externalip=<your fourth ip address and motion port 7979>
masternode=1
masternodeprivkey=<masternodeprivkey for MN4>
```
To edit this in putty, you need to use the arrow keys to navigate to the place you need to edit, delete and add the info from masternode.conf
- For rpcuser and pass, make up something you can remember, it can be random no problem.
- For `bind` you need to add the fourth IP address provided for your VPS, only the IP
- For `externalip` you need to have your MN4 VPS IP and Motiond port EXAMPLE: 148.125.59.31:7979
- For  `masternodeprivkey` you need to use the MN4 Masternode genkey we made earlier.

Save this by using crtl x and Y to save.

Let's get Motiond running. Do:

`cd`

`motiond -daemon`

Motiond should now have started! 

Wait like 10 mins for your wallet to download the blockchain. You can check the progress with the following command :

`motion-cli getblockcount`

Now we need SENTINEL to fix WATCHDOG EXPIRED issue:

### Install Motion Sentinel
Clone the Sentinel repo and install Python dependencies.

type in terminal line by line:

```
cd
git clone https://github.com/motioncrypto/sentinel.git && cd sentinel
virtualenv ./venv
./venv/bin/pip install -r requirements.txt
```

### Set up Cron
Set up a crontab entry to call Sentinel every minute:

`crontab -e`

In the crontab editor, add the lines below, replace `/home/YOURUSERNAME/sentinel` to the path where you cloned sentinel: (should be /motion4)


```
* * * * * cd /home/motion4/sentinel && ./venv/bin/python bin/sentinel.py >/dev/null 2>&1
@reboot motiond -daemon
```

### Troubleshooting
To view debug output, set the SENTINEL_DEBUG environment variable to anything non-zero, then run the script manually:

SENTINEL_DEBUG=1 ./venv/bin/python bin/sentinel.py


### Starting Your Masternode

Now that everything is installed, go back to your desktop wallet, to the Masternode tab.
You need to wait for 15 confirmations in order to start the masternode on your VPS

If the Masternode tab is not showing, you need to  click settings, check `Show Masternodes Tab` save, and restart the wallet
If your Masternode does not show, restart the wallet
We should see each line in the Masternode tab as "MISSING" unless you restarted the wallet. If you did a restart, you need to wait for it to fully sync. Then go to Masternodes Tab and click "Start All" 
Your masternode should be now up and running!
It should either say "Watchdog Expired" or "Enabled" Watchdog Expired is just a sync error with Sentinel, it is no problem and should correct in a few minutes/hours. Sometimes you may need to run the "Start Alias" More than once, within the first hour, it is possible that a Masternode may need a new start, the best practice is to leave the wallet open a few hours and return back to check on it. If any has the status of "New Start Required" Highlight it by clicking on it, then click "Start Alias" or, Right click and "Start Alias"

### Checking Your Masternode
You can check the masternode status by going to the masternode users and typing:

```
su (your usernames)
motion-cli masternode status
```

If your masternode is running it should print `Masternode successfully started`.
If it prints `Not Capable Masternode Not in Masternode List` This means you have not started the masternode on the local wallet.
If it prints `New Start Required` You will need to open wallet, and run "Start Alias"
 
You can also check your MN status by local wallet - `tools -> console`, then type:
 
`masternode list full XXXXX`
 
(Where XXXXX is yours first 5 character of TX_ID).
 
**CONGRATULATIONS!**
