Motion MasterNode Install from script (Recommended)
-------

### Preparation

Get a VPS from a provider like [DigitalOcean](https://www.digitalocean.com), [Vultr](https://www.vultr.com/), [Linode](https://www.linode.com/), etc.

- **Recommended VPS size:** 2GB RAM (if less its ok, we can make swap partition)
- **It must be Ubuntu 16.04 (Xenial)**
- Make sure you have a transaction of **exactly 1000 XMN** in your desktop wallet (If you dont, just send 1000 XMN from you to you).
- motion.conf file on LOCAL wallet MUST BE EMPTY! (if you haven't touched this file it's OK)
- masternode.conf file on VPS wallet MUST BE EMPTY! (if you haven't touched this file it's OK)

**NOTES:** `PRE_ENABLED` status is NOT an issue, just restart local wallet and wait a few minutes.

'WATCHDOG_EXPIRED' is not a problem if you just installed. Give time for the network to sync, 10 + Minutes

You need a different IP for each masternode you plan to host.

### Wallet Setup Part 1

- Open your Motion wallet on your desktop.
- Click **Receive** tab, then put your Label such as “MN1” and click Request. 
- Copy the Address and Send **EXACTLY** 1000 XMN to this Address, wait for 15 confirmations.
- Go to the tab at the bottom that says `Tools`
- Go to the tab at the top that says `Console`
- Then run following command:

`masternode outputs`

You should see one line corresponding to the transaction id (tx_id) of your 1000 coins with a digit identifier (digit). Save these two strings in a text file.

Example:
```
{
  "6a66ad6011ee363c2d97da0b55b73584fef376dc0ef43137b478aa73b4b906b0": "0"
}
```

Note that if you get more than 1 line, it’s because you made multiple 1000 coin transactions, with the tx_id and digit associated.

Run the following command:

`masternode genkey`

You should see a long key: (masternodeprivkey)

EXAMPLE: `7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

This is your masternode private key, record it to text file, keep it safe, do not share with anyone. This will be called `masternodeprivkey`

Next, you have to go to the data directory of your wallet:

- Go to wallet settings tab and click `Open masternode configuration file`
- You should see 2 lines both with a # to comment them out.

Please make a new line and add:

`MN1 (YOUR VPS IP):7979 masternodeprivkey tx_id digit`

Example:

`MN1 148.124.58.33:7979 7xxxx(you get the idea)xxx 6a66ad6011ee363c2d97da0b0ef43137b478aa73b4b906b0 0`

Put your data correctly, **save it** and close.

Go to Motion Wallet, Click `Settings`, Check `Show Masternodes Tab`.

Save and restart your Motion wallet.

Note that each line of the `masternode.conf` file corresponds to one masternode if you want to run more than one node from the same wallet, just make a new line and repeat steps.

**VPS Setup**

**Preparation:**
Windows users will need a program called [putty](https://www.putty.org/) to connect to the VPS
Use SSH to Log into your VPS

**Please note:** We will run everything on root user, if you are using any other user will fail.

We need to install some dependencies. Please copy, paste and hit enter:

`apt-get update;apt-get upgrade -y; apt-get install nano git wget -y;`

Now Copy command into the VPS command line and hit enter:

```wget https://raw.githubusercontent.com/motioncrypto/motion-docs/master/scripts/masternode.sh; chmod +x masternode.sh; ./masternode.sh```

When prompted, enter your `masternodeprivkey` from before.

You will be asked for your VPS IP and a few other questions.
The installation should finish successfully.

Ask for help in [discord](https://discord.gg/pTDAaMa) if it doesn't.

Please note, the script will move motiond and motion-cli binaries to /usr/bin folder, so you don't need to navigate to motion/src folder anymore, you can run the commands without "./" on any place now.

### Testing:

After the script finishes, you will want to check that it is running properly. 
Please type in:

`motion-cli getinfo`

If you put wrong Privkey or VIPSIP>:PORT and get an error, you just need edit the .conf file with the correct data with:

`nano /root/.motioncore/motion.conf`

Then save and exit using CTRL+X, Y and Enter, and restart daemon with:

`motiond -daemon`

now test with:

`motion-cli getinfo`

or

`motion-cli getblockcount`

If you get an error that file does not exist, it may be that the script failed to build and we need to trace back the problem. Contact devs in [discord](https://discord.gg/pTDAaMa).

### Starting Your Masternode

Go back to your desktop wallet, to the Masternode tab.
You need to wait for 15 confirmations in order to start the masternode- you can also check on your VPS by:

`motion-cli getblockcount`

(needs to be more than 0 to be in sync, at the moment of writing this guide we are at block 4883)

**NOTE:** If the Masternode tab isn’t showing, you need to  click settings, check `Show Masternodes Tab` save, and restart the wallet.

If your Masternode does not show, restart the wallet.
 
Now Click `start-all`. Your masternode should be now up and running!
 
### Checking Your Masternode
You can check the masternode status by going to the masternode wallet and typing:
 
`motion-cli masternode status`
 
If your masternode is running it should print `Masternode successfully started`.
 
You can also check your MN status by local wallet - `tools -> console`, just type:
 
`masternode list full XXXXX`
 
(Where XXXXX is yours first 5 character of TX_ID).
 
**CONGRATULATIONS!**

**TROUBLESHOOTING:**

- If you put wrong Privkey or VPSIP:PORT and get an error, you need edit the .conf file with the correct data with:
`nano /root/.motioncore/motion.conf`

and restart daemon with:
`motiond -daemon`

- If get error: incorrect rpcuser or rpcpassword (authorization failed) you need to kill the process first with: pkill -9 motiond
Then save and exit using CTRL+X, Y and Enter, and restart daemon with:
`motiond -daemon`
Now test with:
`motion-cli getinfo`  or  `motion-cli getblockcount`

- If after start alias and when check with motion-cli masternode status on your VPS isn't showing as "Masternode successfully started", go to your data folder of local wallet and delete files: mncache.dat and mnpayments.dat, restart local wallet, wait full sync and start the alias again.

- If you get an error that file does not exist, it may be that the script failed to build and we need to trace back the problem. Contact our support in discord.
