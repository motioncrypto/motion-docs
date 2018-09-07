Motion MasterNode Install from script (10 minutes)
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

### Wallet Setup

- Open your Motion wallet on your desktop.
- Click **Receive** tab, then put your Label such as “MN1” and click Request. 
- Copy the Address and Send **EXACTLY** 1000 XMN to this Address, wait for 15 confirmations.
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

Copy this and paste it to that text file, we will throw away all the {} "" :

Note that if you get more than 1 line, it's because you made multiple 1000 XMN transactions, with the tx_id and digit associated. This isn't a problem, we just do some extra steps to make a new genkey for each one, if your installing more than one.

Now, type in and run the following command:

`masternode genkey`

You should see a long key: (masternodeprivkey)

EXAMPLE: `7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

This is your masternode private key, copy and paste it to the text file, keep it safe, do not share with anyone. This will be called `masternodeprivkey`

Next, We need to get the configuation files ready.

- Open Wallet 
- Select "settings" => and click "Open masternode configuration file"
- Open this file with a text editor like notepad or notepad ++

You should see 3 lines both with a # to comment them out, Like this EXAMPLE:

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
Put your data correctly, **save it** and close.

Go to Motion Wallet, Click `Settings`, Check `Show Masternodes Tab`.

Save and restart your Motion wallet.

Note that each line of the `masternode.conf` file corresponds to one masternode if you want to run more than one node from the same wallet, just make a new line and repeat steps.

### VPS Setup

**Preparation:**
Windows users will need a program called [putty](https://www.putty.org/) to connect to the VPS
Use SSH to Log into your VPS

**Please note:** We will run everything on root user, if you are using any other user will fail.

We need to install some dependencies. Please copy, paste and hit enter:

`apt-get update;apt-get upgrade -y; apt-get install nano git wget -y;`

Now lets download the script, copy command into the VPS command line and hit enter: ``wget https://raw.githubusercontent.com/motioncrypto/motion-docs/master/scripts/masternode.sh``

And give it permission and run: ``chmod +x masternode.sh; ./masternode.sh``

When prompted, enter your `masternodeprivkey` from before.

You will be asked a few other questions, you can push enter to default on these.
The installation should finish successfully.

Ask for help in [discord](https://discord.gg/pTDAaMa) if it doesn't.

### Testing

After the script finishes, you will want to check that it is running properly. 
Please type in:

`motion-cli getinfo`

**IF** you put wrong Privkey or VIPSIP>:PORT and get an error, you just need edit the .conf file with the correct data with:

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

(needs to be more than 0 to be in sync, at the moment of writing this guide we are at block 20000)

**NOTE:** If the Masternode tab isn’t showing, you need to  click settings, check `Show Masternodes Tab` save, and restart the wallet.

If your Masternode does not show, restart the wallet.
 
If it is your first, Click `start-all`. Your masternode should be now up and running!
If this is another Masternode, Highlight the Masternode by clicking on it once, then click "Start Alias"

### Checking Your Masternode
You can check the masternode status by Logging into the VPS and typing:
 
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
