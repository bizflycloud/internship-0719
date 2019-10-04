**Build NFS Server**

**1.What is NFS**

NFS or Network File System is a distributed file system protocol.Through NFS, you can allow a system to share directories and files with others over a network. In NFS file sharing, users and even programs can access information on remote systems almost as if they were residing on a local machine.

NFS is operated in a client-server environment where the server is responsible for managing the authentication, authorization, and management of clients, as well as all the data shared within a specific file system.Upon authorization, any number of clients can access the shared data as if it was present in their internal storage. Setting up an NFS server on your Ubuntu system is very simple. All you need to do is make some necessary installations and configurations, both on the server and client machines and you are good to go.

**2.Build NFS Server**

**Step 1: Install NFS Kernel Server**

`sudo apt install nfs-kernel-server`

**Step 2: Create the Export Directory**

The directory that we want to share with the client system is called an export directory. You can name it according to your choice; here, we are creating an export directory by the name of “sharedfolder” in our system’s mnt(mount) directory.

Use the following command, by specifying a mount folder name according to your need, through the following command as root:

`sudo mkdir -p /mnt/sharedfolder`

As we want all clients to access the directory, we will remove restrictive permissions of the export folder through the following commands:

`sudo chown nobody:nogroup /mnt/sharedfolder`

`sudo chmod 777 /mnt/sharedfolder`

**Step 3: Assign server access to client(s) through NFS export file**

After creating the export folder, we will need to provide the clients the permission to access the host server machine. This permission is defined through the exports file located in your system’s /etc folder. Please use the following command in order to open this file through the Nano,vim... editor:

Once you have opened the file, you can allow access to:

A single client by adding the following line in the file:

/mnt/sharedfolder clientIP(rw,sync,no_subtree_check)

Multiple clients by adding the following lines in the file:

/mnt/sharedfolder client1IP(rw,sync,no_subtree_check)

/mnt/sharedfolder client2IP(rw,sync,no_subtree_check)

Multiple clients, by specifying an entire subnet that the clients belong to:

/mnt/sharedfolder subnetIP/24(rw,sync,no_subtree_check)

The permissions “rw,sync,no_subtree_check” permissions defined in this file mean that the client(s) can perform:

rw: read and write operations

sync: write any change to the disc before applying it

no_subtree_check: prevent subtree checking

**Step 4: Export the shared directory**

After making all the above configurations in the host system, now is the time to export the shared directory through the following command as sudo:

`sudo exportfs -a`

Finally, in order to make all the configurations take effect, restart the NFS Kernel server as follows:

`sudo systemctl restart nfs-kernel-server`

**Step 5: Open firewall for the client(s)**(check ufw if ufw inactive -> skip step 5)

An important step is to verify that the server’s firewall is open to the clients so that they can access the shared content. The following command will configure the firewall to give access to clients through NFS:

`sudo ufw allow from [clientIP or clientSubnetIP] to any port nfs`

Eg: `sudo ufw allow from 192.168.100/24 to any port nfs`

`sudo ufw status` to check ufw

**Configuring the Client Machine**

**Step 1: Install NFS Common**

run the following command in order to install the NFS Common client on your system:`sudo apt-get install nfs-common`

**Step 2: Create a mount point for the NFS host’s shared folder**

Your client’s system needs a directory where all the content shared by the host server in the export folder can be accessed. You can create this folder anywhere on your system. We are creating a mount folder in the mnt directory of our client’s machine:

`sudo mkdir -p /mnt/sharedfolder_client`

**Step 3: Mount the shared directory on the client**

The folder that you created in the above step is like any other folder on your system unless you mount the shared directory from your host to this newly created folder.

Use the following command in order to mount the shared folder from the host to a mount folder on the client:

`sudo mount serverIP:/exportFolder_server /mnt/mountfolder_client`

**Step 4: Test the connection**



