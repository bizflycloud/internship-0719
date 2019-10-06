# NFS Server
  
   - NFS (Network File System) is a distributed file system protocol. Through NFS, you can allow a system to share directories and files with others over a network. In NFS file sharing, users and even programs can access information on remote systems almost as if they were standing on a local machine.
   - NFS is operated in a client-server environment where the server is responsible for managing the authentication, authorization, and management of clients, as well as all the data shared within a specific file system. 
    
# Setting up the host server
    
### Step 1: Install NFS Kernel Server
    
   - Before installing the NFS Kernel server, we need to update our system’s repository index with that of the Internet through command : `apt-get update`
   - Run this command in order to install the NFS Kernel Server on your system: `apt install nfs-kernel-server`
      
### Step 2: Create the Export Directory
    
   The directory that we want to share with the client system is called an export directory.
   - We create an export directory by the name of “sharedfolder” in our system’s mnt(mount) directory: `mkdir -p /mnt/sharedfolder`
   - As we want all clients to access the directory, we will remove restrictive permissions of the export folder through the following commands: 
          
       `chown nobody:nogroup /mnt/sharedfolder`
       
       `chmod 777 /mnt/sharedfolder`
### Step 3: Assign server access to client(s) through NFS export file
   - We need to provide the clients the permission to access the host server machine. This permission is defined through the exports file located in your system’s `/etc` folder.
   Using command: `vim /etc/exports` to open the file 
    
   > Editing this file needs root access
   - Allow access to one client by adding the following line in the file: `/mnt/sharedfolder 192.168.122.140(rw,sync,no_subtree_check)`
   ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/33.png)
   > If there's multiple clients, add the number of clients' entry accordingly
   > The other way to do it is by specifying an entire subnet that the clients belong to: `/mnt/sharedfolder 192.168.122.0/24(rw,sync,no_subtree_check)`
   
   The permissions “rw,sync,no_subtree_check” permissions defined in this file mean that the client(s) can perform:

      - rw: read and write operations
      - sync: write any change to the disc before applying it
      - no_subtree_check: prevent subtree checking
      
### Step 4: Export the shared directory
   - After making all the above configurations in the host system, we export the shared directory through command: `exportfs -a`
   - In order to make all the configurations take effect, restart the NFS Kernel server as follows: `systemctl restart nfs-kernel-server`
   
### Step 5: Open firewall for the client (s)
   - Configure the firewall to give access to clients through NFS: `ufw allow from [clientIP or clientSubnetIP] to any port nfs`
   - Check the status of your Ubuntu firewall through the following command: `ufw status`
   ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/34.png)
   
    Host server is now ready to export the shared folder to the specified client(s) through the NFS Kernel Server.

# Configuring the Client Machine

### Step 1: Install NFS Common
   - Update our system’s repository index : `apt-get update` this lets us install the latest available version of a software through the Ubuntu repositories.
   - Install the NFS Common client on your system: `apt-get install nfs-common`
   
### Step 2: Create a mount point for the NFS host’s shared folder
   - Client’s system needs a directory where all the content shared by the host server in the export folder can be accessed. You can create this folder anywhere on your system. I create a mount folder in the `mnt` directory of client’s machine: `mkdir -p /mnt/sharedfolder_client`
   
### Step 3: Mount the shared directory on the client
   - Mount the shared folder from the host to a mount folder on the client: `mount serverIP:/exportFolder_server /mnt/mountfolder_client`
   
   > Ex:`mount 192.168.122.241:/mnt/sharedfolder /mnt/sharedfolder_client`
   
### Step 4: Test the connection

   Create or save a file in the export folder of the NFS host server. Now, open the mount folder on the client machine; you should be able to view the same file shared and accessible in this folder.
   
   ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/35.png)
