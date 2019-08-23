#  Rsnapshot
  
  An incremental backup consists of one full backup and then performing additional backups that will only backup files that have changed since the last backup, instead of backing up an entire hard drive
  
  Rsnapshot allows users to create customized incremental backup solutions
  
  The true power of rsnapshot is its ability to utilize hard-links between each backup.
  
  **Installation**
  
   - Syntax: `apt-get install rsnapshot`
   
   - Before backing up, take a look at `/etc`, if `/etc/rsnapshot.conf.default` exists you need to copy it to `/etc/rsnapshot.conf` otherwise, create a backup of the regular `.conf` . This is useful in the case you need to reference it later on.
    
   - By editing "rsnapshot.conf" you can make a custom remote back up by yourself, remmember to use [TAB] dont get it wrong with [Space bar]
  
   - To check the syntax which you typed in if its right or wrong , use this command: `rsnapshot configtest`
   
   
 # Rsync
 
  Rsync provides helps to synchronizing and copying datas between locals or servers
  
  **Copy files in local**
    
   Syntax: `rsync -zvh [file to copy] [destination]`
   
  **Copy folders in local**
    
   Syntax: `rsync -avzh [source] [dest]`
   > this command will allow copying every files from source folder to destination folder
   
  **Copy folders from local to server**
    
   Syntax: `rsync -avz [source] root@[ip]:[dest]`
   > this command will allow copying every files from source folder to destination folder in server has ip address "ip"
   
  **Copy folders from server to local**

   Syntax: `rsync -avzh root@[ip]:[source] [dest]`
