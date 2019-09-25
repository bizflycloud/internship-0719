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
  
