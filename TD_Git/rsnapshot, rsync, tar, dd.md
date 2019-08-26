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
    
   Syntax: `rsync -avzh [source] [dest]`, this command will allow copying every files from source folder to destination folder
   
  **Copy folders from local to server**
    
   Syntax: `rsync -avz [source] root@[ip]:[dest]`, this command will allow copying every files from source folder to destination folder in server has ip address "ip"
   
  **Copy folders from server to local**

   Syntax: `rsync -avzh root@[ip]:[source] [dest]`
   
  **Copy file from Remote server to Local through SSH**
  
   We provide the `-e` with method `SSH` to define that we get file through SSH method
   
   Syntax: `rsync -avzhe ssh root@[ip]:[source] [dest]`
   
  **Copy file from Local to Remote server through SSH**
   
   Use the likely Syntax: `rsync -avzhe ssh [file] root@[ip]:[dest]`
   
  **To show the transfer data process**
   
   Add this option: `--progress`
   
  **Add or not include options**
   
   Add these options: Ex `--include 'R*' --exclude '*'` means that you copy all files that have character "R" at the beginning of file name with out copying the rest of them
   
  **The delete option**
    
   While transfering, if there's any file that is created and not included in the source directory then adding option `--delete` will kill it
   
  **Set limitation of the capability**
  
   While transfering, adding `--max-zize='...'` will do it, "..." may be k, m, g
   
  **__Delete source after transfer process complete__**
    
   By adding `--remove-source-files` option
   
  **You can you this option to test the transfer process**
  
   by adding this option `--dry-run` ,this will not make anything changes but show you the result
  
  **To limit transfer bandwitdh**
  
  Add this: ` --bwlimit=...`
   

 # Tar
 
  **To create a tarball**
  
  Syntax: `sudo tar -[option] [filename] [the directory you want to backup]`
   
   ex: `sudo tar -cvpzf backup.tar.gz --exclude=/mnt /` to backup root directory
   
   Options:
   
   - `c`: create or overwrite backup files
   - `v`: verbose display the backup process
   - `p`: to preserving permission 
   - `z`: compress the files as small as possible    
   - `f`: give tar a filename
   - `--exclude`: exclude directory
   
   **To restore from a tarball**
   
   Syntax: `sudo tar -[option] [file to recover from] -C [directory to put recovered things] `
   
   ex: `sudo tar -xvpzf backup.tar.gz -C /recover`
   
   Options:
   - `C`: change directory
   - `x`: to extract information from a tarball
   - `v`: verbose
   - `p`: perserve permission
   - `z`: uncompress
   - `f`: give it a filename


 # DD
    
  `dd` - convert and copy a file
  
  Using `dd` to: 
  
   - To backup the entire hard disk 
   - To blank out a drive (using source is dev/zero)
   - Transfer all files, folders in one disk drive to another
   - To create an image of a Hard Disk
   - To restore using the Hard Disk Image
   
  Syntax: `dd if=<source> of=<dest> (bs=) (count)= [option]`
