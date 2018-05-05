**Preparation**

Get a VPS from a provider like DigitalOcean, Vultr, Linode, etc.
Recommended VPS size: 2GB RAM (if less its ok, we can make swap)
It must be Ubuntu 16.04 (Xenial)
Make sure you have a transaction of exactly 1000 MTN in your desktop cold wallet.
motion.conf file on LOCAL wallet MUST BE EMPTY!
masternode.conf file on VPS wallet MUST BE EMPTY!
NOTES: PRE_ENABLED status is NOT an issue, just restart local wallet and wait a few minutes.
You need a different IP for each masternode you plan to host

**Wallet Setup Part 1**
Open your wallet on your desktop.
Click Receive, then click Request and put your Label such as “MN1”
Copy the Address and Send EXACTLY 1000 MTN to this Address
Go to the tab at the bottom that says "Tools"
Go to the tab at the top that says "Console"
Wait for 15 confirmations, then run following command: masternode outputs
You should see one line corresponding to the transaction id (tx_id) of your 1000 coins with a digit identifier (digit). Save these two strings in a text file. Example:
{
  "6a66ad6011ee363c2d97da0b55b73584fef376dc0ef43137b478aa73b4b906b0": "0"
}
Note that if you get more than 1 line, it’s because you made multiple 1000 coins transactions, with the tx_id and digit associated.
Run the following command: masternode genkey
You should see a long key: (masternodeprivkey)
EXAMPLE: 7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
This is your masternode private key, record it to text file, keep it safe, do not share with anyone. This will be called “masternodeprivkey”
Next, you have to go to the data directory of your wallet 
Go to wallet settings=> and click “Open masternode configuration file”
You should see 2 lines both with a # to comment them out.
Please make a new line and add:
MN1 (YOUR VPS IP):7979 masternodeprivkey tx_id digit

Put your data correctly, save it and close.
Go to Motion Wallet, Click Settings, Check “Show Masternodes Tab”
Save and Restart your wallet.
Note that each line of the masternode.conf file corresponds to one masternode if you want to run more than one node from the same wallet, just make a new line and repeat steps.

**VPS Setup**

**Preparation:**
Windows users will need a program called putty to connect to the VPS
For a guide of how to use putty to connect to a vps please use: Digital ocean Other
Use SSH to Log into your VPS
We need to install some dependencies. Please copy, paste and hit enter:
apt-get update;apt-get upgrade; apt-get install nano software-properties-common git wget -y;

Now Copy command into the VPS command line and hit enter:

wget https://raw.githubusercontent.com/motioncrypto/motion/master/contrib/masternodeinstall.sh && chmod +x masternodeinstall.sh && ./masternodeinstall.sh


When prompted, enter your “masternodeprivkey” from before.
You will be asked for your VPS IP and a few other questions.
The installation should finish successfully. Ask for help in discord if it doesn't.

**Starting Your Masternode**
Go back to your desktop wallet, to the Masternode tab.
You need to wait for 15 confirmations in order to start the masternode- On your VPS you can type:
motion-cli getblockcount
(needs to be more than 0 to be in sync)

NOTE: If the Masternode tab isn’t showing, you need to  click settings, check “Show Masternodes Tab” save, and restart the wallet
If your Masternode does not show, restart the wallet
 
Now Click “start-all”. Your masternode should be now up and running!
 
**Checking Your Masternode**
You can check the masternode status by going to the masternode wallet and typing:
 
.motion-cli masternode status
 
If your masternode is running it should print “Masternode successfully started”.
 
You can also check your MN status by local wallet - tools - console, just type:
 
masternode list full XXXXX
 
(Where XXXXX is yours first 5 character of TX_ID).
 
CONGRATULATIONS!
 
