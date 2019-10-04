**What is VPN**

A Virtual Private Network is a connection method used to add security and privacy to private and public networks, like WiFi Hotspots and the Internet. Virtual Private Networks are most often used by corporations to protect sensitive data. However, using a personal VPN is increasingly becoming more popular as more interactions that were previously face-to-face transition to the Internet. Privacy is increased with a Virtual Private Network because the user's initial IP address is replaced with one from the Virtual Private Network provider. Subscribers can obtain an IP address from any gateway city the VPN service provides. For instance, you may live in San Francisco, but with a Virtual Private Network, you can appear to live in Amsterdam, New York, or any number of gateway cities.

**Why do I need a VPN?**

Hide your IP address(Connecting to a Virtual Private Network often conceals your real IP address)

Change your IP address(Using a VPN will almost certainly result in getting a different IP address)

Encrypt data transfers(A Virtual Private Network will protect the data you transfer over public WiFi)

Mask your location(With a Virtual Private Network, users can choose the country of origin for their Internet connection)

Access blocked websites(Get around website blocked by governments with a VPN)

**Build PPTP VPN Server**

**1.Install pptpd**

`sudo apt-get install pptpd -y`

**2. Adding DNS Servers**

`sudo vi /etc/ppp/pptpd-options`

Find the following line:

`#ms-dns 10.0.0.1`

`#ms-dns 10.0.0.2`

Change them to

`ms-dns 8.8.8.8`

`ms-dns 8.8.4.4`

8.8.8.8 and 8.8.4.4 is Google’s DNS server. If Google’s DNS server is blocked in your area, then you can use OpenDNS Server: 208.67.222.222 and 208.67.220.220

**3. Adding VPN User Accounts**

Open up /etc/ppp/chap-secrets file

`sudo vi /etc/ppp/chap-secrets`

[username] [service] [password] [ip]

example:`doandung pptpd doandung-password *`

Username and password are pretty straightforward, service and IP are not though. Service is usually pptpd. If you just want to setup a VPN, use pptpd for the service - it will work. If you want to restrict the IP that a user can login from, you can use his/her IP. If you want connections from that account to be made from all IPs, you can use *.

**4. Allocating Private IP for VPN Server and Clients**

Edit /etc/pptpd.conf file.

`sudo vi /etc/pptpd.conf`

Add the following lines to at the enf of file.

`localip 10.0.0.1`

`remoteip 10.0.0.100-200`

Save and close the file. localip is the IP for your VPN server. remoteip are for VPN clients.

**5. Enable IP Forwarding**

In order for the VPN server to route packets between VPN client and the outside world, we need to enable IP forwarding. Thus, the VPN server becomes a router.

`sudo vi /etc/sysctl.conf`

Add the following line.

`net.ipv4.ip_forward = 1`

**6. Configure Firewall for IP Masquerading**

`sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE`

The above command append (-A) a rule to the end of of POSTROUTING chain of nat table. It will link your virtual private network with the Internet. And also hide your network from the outside world. So the Internet can only see your VPN server’s IP, but can’t see your VPN client’s IP. Just like your home router hide your private home network.

Your server’s ethernet card name may not be eth0. You can use ip address or ip link command to check that. In order to save this iptables rule permanently, you can put the above command in /etc/rc.local file, so the command will be executed on system boot by root automatically. By the way, you don’t have to add sudo to the commands in rc.local.

On ubuntu, it may be a good idea to remove the -e part from the first line in rc.local file. If you have -e option, then when a command in rc.local fails to run, any command below will not be executed.

**7. Start PPTPD Daemon**

`sudo systemctl start pptpd`   or   `sudo service pptpd start`

If you have Systemd on your server, then enable pptpd service on system boot:

`sudo systemctl enable pptpd`

Now set up your vpn client and you should be able to connect to your VPN server.

**Install PPTP VPN Client**

`sudo apt-get install pptp-linux network-manager-pptp network-manager-pptp-gnome`


