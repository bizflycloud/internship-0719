# SCP

## Defination

  - Sercure Copy - an application using SSH to encrypt the process of transfering files
  - SCP is used to transfer files between computers via IP address
  - SCP has the same security like SSH
  
 # Using 
 
  - Basic syntax: `scp source_file_name username@destination_host:destination_folder`. This command will read as “copy source_file_name” into “destination_folder” at “destination_host” using “username account”. To transfer files, we add spaces between them.
 
    ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/20.png)
    ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/21.png) 
  - Provide the detail information of SCP process using `-v` parameter: 
    ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/22.png)   
  - To preserve all the attributes of the original file, add parameter `-p`
  - To transfer an entire folders to destination host: `scp -v -r folder username@destination_host:destination_folder`. `-r` means to add recursive transfer.
  - To transfer file from server to client, *stand on client* using `scp username@destination_host:file_from_server directory_on_client`
  - To transfer between 2 servers: `scp user1@remotehost1:/some/remote/dir/ user2@remotehost2:/some/remote/dir/`
  - Make file transfer faster using `-C` parameter. The `-C` parameter will compress your files on the go. The unique thing is the compression is only happen in the network. When the file is arrived to the destination server, it will returning into the original size as before the compression happen.
  - Limiting bandwidth usage, the `-l` parameter will limit the bandwidth to use. It will be useful if you do an automation script to copy a lot of file, but you don’t want the bandwidth is drained by the SCP process.
    
      Usage: `scp -l 400 folder_on_client username@destination_host:destination_folder`. One thing to remember that bandwidth is specified in Kilobits/sec (kbps). It is mean that 8 bits equal with 1 byte. While SCP counts in Kilobyte/sec (KB/s). So if you want to limit your bandwidth for SCP maximum only 50 KB/s, you need to set it into 50 x 8 = 400.
  - Specify specific port to use with SCP: Usually SCP is using port 22 as a default port. But for security reason, you may change the port into another port. For example, we are using port 2249. Then the command should be like :`scp -P 2249 folder_on_client usernameo@destination_host:destination_folder`
  - To specified private key, use command: `scp -i private_key.pem file_on_client username@destination_host:destination_folder`
  - To use other encryption methods, use command: `scp -c other_algorithm local_file username@destination_host:destination_folder`
  - To use other SSH configuration file, use command: `scp -F path_to_your_custom_ssh_config_file file(folder) username@destination_host:destination_folder`
