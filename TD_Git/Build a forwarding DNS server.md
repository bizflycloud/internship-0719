# Build a forwarding DNS server

### Forwarding DNS Server

  A forwarding DNS server offers the advantage of maintaining a cache to improve DNS resolution times for clients. However, it actually does none of the recursive querying itself. Instead, it forwards all requests to an outside resolving server and then caches the results to use for later queries. This lets the forwarding server respond from its cache, while not requiring it to do all of the work of recursive queries. This allows the server to only make single requests (the forwarded client request) instead of having to go through the entire recursion routine. This may be an advantage in environments where external bandwidth transfer is costly, where your caching servers might need to be changed often, or when you wish to forward local queries to one server and external queries to another server.

### Install Bind on the DNS Server

  Using command: 
  
    `sudo apt-get update` and 
    
    `sudo apt-get install bind9 bind9utils bind9-doc`
    
### Configure as a Forwarding DNS Server

  - On DNS server, change directory to  `/etc/bind/`
  
  - The `named.conf.options` file should look like this:

      ...
      options {
              directory "/var/cache/bind";

              recursion yes;

              dnssec-validation auto;

              auth-nxdomain no;    # conform to RFC1035
              listen-on-v6 { any; };
      }; 
      
  - Do not change recursion to no. The forwarding server is still providing recursive services by answering queries for zones it is not authoritative for. Instead, we need to set up a list of caching servers to forward our requests to. This will be done within the options {} block. First, we create a block inside called forwarders that contains the IP addresses of the recursive name servers that we want to forward requests to, we will use Google’s public DNS servers (8.8.8.8 and 8.8.4.4):

      ...
      options {
              directory "/var/cache/bind";

              recursion yes;
              allow-query { goodclients; };

              forwarders {
                     8.8.8.8;
                     8.8.4.4;
              };
      ...
      
  - Afterward, we should set the forward directive to “only” since this server will forward all requests and should not attempt to resolve requests on its own.

    The configuration file will look like this when you are finished:

      acl goodclients {
              192.168.122.0/24;
              localhost;
              localnets;
      };

      options {
              directory "/var/cache/bind";

              recursion yes;
              allow-query { goodclients; };

              forwarders {
                      8.8.8.8;
                      8.8.4.4;
              };
              forward only;

              dnssec-validation auto;

              auth-nxdomain no;    # conform to RFC1035
              listen-on-v6 { any; };
      };
      
  - One final change we should make is to the dnssec parameters. With the current configuration, depending on the configuration of forwarded DNS servers, you may see some errors that look like this in the logs:

    `Jun 25 15:03:29 cache named[2512]: error (chase DS servers) resolving 'in-addr.arpa/DS/IN': 8.8.8.8#53`
    `Jun 25 15:03:29 cache named[2512]: error (no valid DS) resolving '111.111.111.111.in-addr.arpa/PTR/IN': 8.8.4.4#53`
    
    To avoid this, change the dnssec-validation setting to “yes” and explicitly enable dnssec:

      ...
      forward only;

      dnssec-enable yes;
      dnssec-validation yes;

      auth-nxdomain no;    # conform to RFC1035
      ...
      
  - Save and close the file when you are finished. You should now have a forwarding DNS server in place. Continue to the next section to validate your configuration files and restart the daemon.

Test your Configuration and Restart Bind
Now that you have your Bind server configured as either a caching DNS server or a forwarding DNS server, we are ready to implement our changes.

Before we take the plunge and restart the Bind server on our system, we should use Bind’s included tools to check the syntax of our configuration files.

We can do this easily by typing:

sudo named-checkconf
If there are no syntax errors in your configuration, the shell prompt will return immediately without displaying any output.

If you have syntax errors in your configuration files, you will be alerted to the error and line number where it occurs. If this happens, go back and check your files for errors.

When you have verified that your configuration files do not have any syntax errors, restart the Bind daemon to implement your changes:

sudo service bind9 restart
Afterwards, keep an eye on the server logs while you set up your client machine to make sure that everything goes smoothly. Leave this running on the server:

sudo tail -f /var/log/syslog
Now, open a new terminal window to configure your client machines.
Configure the Client Machine
Now that you have your server up and running, you can configure your client machine to use this DNS server for queries.

Log into your client machine. Make sure that the client you are using was specified in the ACL group you set for your DNS server. Otherwise the DNS server will refuse to serve requests for the client.

We need to edit the /etc/resolv.conf file to point our server to the name server. Changes made here will only last until reboot, which is great for testing. If we are satisfied with the results of our tests, we can make these changes permanent.

Open the file with sudo privileges in your text editor:

sudo nano /etc/resolv.conf
The file will list the DNS servers to use to resolve queries by setting the nameserver directives. Comment out all of the current entries and add a nameserver line that points to your DNS server:

nameserver 192.0.2.1
# nameserver 8.8.4.4
# nameserver 8.8.8.8
# nameserver 209.244.0.3
Save and close the file.

Now, you can test to make sure queries can resolve correctly by using some common tools.

You can use ping to test that connections can be made to domains:

ping -c 1 google.com
