# When no HDD is needed to add 
 
  ## Using GParted Live CD 

  - Pros: 
     - With Gparted we can interact with device through GUI which makes it easier for us to resize (both extend and shrink) partitions and file system in a device so that it shrink or extend filesystem accordingly.
     - Gparted saves time and simple with human
  - Cons:
     - Gparted only function in GUI mode so that if we don't have Live CD of Gparted, we cant use the tool. 
     - Indeed, our evironment is ubuntu server, which tend to have no GUI at all
     - GParted cant resize (shrink or extend) file system online , it only works if the file system is unmount (In some case, unmount root's container is impossible

# When HDD is needed to add
  
  ## Using LVM (An Ideal choice)
  
  By following these steps: detect the new disk space, partition the new disk, creating a physical volume from that disk and then add it to the volume group, `LVM` can increase a logical volume with the `lvextend` command and then can extend the filesystem in it with `resize2fs` easily. So, it sounds like a good method, but what goes up must come down, although LVM seems to be perfect, it still have drawbacks
  
  - Pros:
     - Efficient because it's flexible to resize partition and then extends file system for further purpose if there's any getting-more-HDD plan
     - By providing storage to file system (as it's in logical volume), anytime HDD is added, it seems to be a good choice for such purpose
  - Cons: 
     - In a specific scheme, the file system contains root is non-lvm format, then it can't be added to vg and extend anymore size. Which leads to a problem is, you cant extend anymore and root is full until you want to crush your laptop because of the poor performance
     - So, that traumatized problem can still be fixed if only you config your filesystem and block device as lvm format when you first set up your linux, but the fact is, not everyone notice about it until they face it - the worst nightmare.
     
  ## Using RAID 0
 
 The goal of RAID 0 is to extend the size of volume that contains file system, make it capable of extending the file system inside it. RAID 0 combine size of block devices to one RAID pool.
 
 RAID 0 can easily be set up using `mdadm` command
 Suppose we have two block devices `/dev/sda`( the original disk) and `/dev/sdb` ( the additional disk ) 
 The following steps are RAID configuration steps:
   
   - First we execute command : `mdadm --create RAID --level=0 --raid-device=2 /dev/sda /dev/sdb` , then RAID 0 disk "RAID" is created  
   - Save the configuration : `mdadm --detail --scan > /etc/mdadm.conf`   
   - Config auto mount for rebooting
   
 - Pros:
     - RAID 0 is simple to interact with 
     - Easy to perform command execution and it's popular, too
 - Cons:
     - RAID 0 requires additional disk has the same size with the original
     - RAID 0 easily to fail too, can put data at risk if there's a chance a disk meets issues  
     - RAID 0 can’t be perform on a block device contains root 
