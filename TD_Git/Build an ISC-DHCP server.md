# ISC - DHCP

### Installation

  - Using command: `apt install isc-dhcp-server`
  
### Configuration
  
  - First, we config DHCP in DHCP server, using command: `vim /etc/dhcp/dhcpd.conf`
    - Uncomment the `authoritative` parameter because you want your server becomes an official DHCP for local network 
    - Under section named "A slightly different configuration for an internal subnet", we config the subnet, the IP range that's gonna be provided...
    
      ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/25.png)
      
      ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/26.png)
     
  - Use this command to check the syntax of `dhcpd.conf` file for errors: `dhcpd -t`
  - Use this command to edit the `isc-dhcp-server` file, where we can manually determine the interface of the server: `vim /etc/default/isc-dhcp-server`
  - We have to set the interfaces to `ens3` in our file.
  - Securing DHCP server by modifying configuration file to secure the DHCP server
    
     ddns-update-style none;
     
     deny declines;
     
     deny bootp;
     
      **The DoS attack** on DHCP server can be avoided by denying the DHCP decline messages and can deny supporting old bootp clients.

  - Restart the DHCP service
  
### On Client
  
  - Make sure under `/etc/network/interfaces.d/50-cloud-init.cfg` we set dhcp on ens3 interface 
  - Restart networking service to apply changes on client: `service networking restart`

### Testing
   
   - After restarting networking service on client, the SSH session is end, because of the new IP addresse that is provided for client(minion1)
   
   ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/27.png)
   
   - On client(minion1)'s physical machine, show the new assigned IP address:
   
   ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/28.png)
   
   - Try to SSH to client(minion1) with new IP address, return successful message:
   
   ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/29.png)
   
   


 
