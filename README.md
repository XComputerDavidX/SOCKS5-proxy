# SOCKS5-proxy
This proxy.sh allows you to connect to an external server eg. Google Cloud VM to bypass the IPS/School website restrictions

#How to use#

`cd path/to/folder/that/contain/proxy.sh`

Only do this once 

`chmod +x proxy.sh`

To start the script

`./proxy.sh start`

Remember to stop the script to prevent lag to system

`./proxy.sh stop`

You might encounter issue with Google Chrome on MacOS, as it doesn't obey the system proxy settings, this can be solved by installing extension "Proxy Switcher".
Once started proxy.sh, open proxy-switcher and select manual
Make sure HTTP proxy is set to 127.0.0.1 and Port 1080

Electron Apps might not respect system proxy, can be solved by using ClashX Pro, set mode as Global

=====Full tutorial=====

Demostrating with Google Cloud VM, server is running Ubuntu 24.04, commands may vary depending on your system version

First create your private ssh key
In terminal

`ssh-keygen -t rsa -b 4096 -C create_your_own_username -f ~/.ssh/create_your_own_file_name`

`pbcopy < ~/.ssh/your_file_name.pub`

In your Google Cloud Console, search SSH Keys

Click on edit

![Screenshot 2025-04-05 at 02 43 41](https://github.com/user-attachments/assets/c2341f82-873d-4f28-9080-b9752536e6e2)


Add item, and paste in the private key and save

Go to your Google Cloud Console-Compute Engine-VM Instances

Copy the External IP

![Screenshot 2025-04-05 at 02 43 32](https://github.com/user-attachments/assets/c922cbc9-17ad-4d6b-8cb0-cd0c19f73e5a)

In your terminal try

`ssh -i ~/.ssh/your_file_name username@External_IP`

Then try 

`ssh -i ~/.ssh/your_file_name username@External_IP -p 7000`

If you can SSH into your server, continue

If you encounter Prermission Denied. Use the built-in SSH feature in your VM Instances

Do

`nano ~/.ssh/authorized_keys`

Now go to your Mac terminal and do 

`pbcopy < ~/.ssh/your_file_name.pub`

Start a new line and paste in your Private SSH Key from your Mac to authorized keys in the server

To save the file, do : CTRL+X, Y, Enter

In your server, run

`sudo systemctl restart sshd`

Again, in your terminal, try

`ssh -i ~/.ssh/your_file_name username@External_IP`

Also try

`ssh -i ~/.ssh/your_file_name username@External_IP -p 7000`

You should be able to login into your server using terminal
