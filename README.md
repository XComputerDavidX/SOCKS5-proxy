# SOCKS5-proxy
This proxy.sh allows you to connect to an external server eg. Google Cloud VM to bypass the IPS/School website restrictions

You might encounter issue with Google Chrome on MacOS, as it doesn't obey the system proxy settings, this can be solved by installing extension "Proxy Switcher".
Once started proxy.sh, open proxy-switcher and select manual
Make sure HTTP proxy is set to 127.0.0.1 and Port 1080

Electron Apps might not respect system proxy, can be solved by using ClashX Pro, set mode as Global

Demostrating with Google Cloud VM

First create your private ssh key
In terminal

`ssh-keygen -t rsa -b 4096 -C create_your_own_username -f ~/.ssh/create_your_own_file_name`

`pbcopy < ~/.ssh/your_file_name.pub`

In your Google Cloud Console, search SSH Keys
![Screenshot 2025-04-05 at 02 31 42](https://github.com/user-attachments/assets/7fc4d983-0bc2-4959-9e46-f10a6265062a)

Click on edit

![Screenshot 2025-04-05 at 02 32 49](https://github.com/user-attachments/assets/7da1001a-4276-4e46-92a4-3d6cf4a8f127)

Add item, and paste in the private key

Go to your Google Cloud Console-Compute Engine-VM Instances
Copy the External IP
![Screenshot 2025-04-05 at 02 25 00](https://github.com/user-attachments/assets/5342f19c-35f1-4d94-9b8d-fe86ce607572)

In your terminal try

`ssh -i ~/.ssh/your_file_name username@External_IP`

Then try 

`ssh -i ~/.ssh/your_file_name username@External_IP -p 7000`
