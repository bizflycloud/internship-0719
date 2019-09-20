# When no HDD is needed to add 
 
  ## Using GParted Live CD 

  - Pros: 
     - With Gparted we can interact with device through GUI which makes it easier for us to resize (both extend and shrink) partitions and file system in a device so that it shrink or extend filesystem accordingly.
     - Gparted saves time an simple with human
  - Cons:
     - Gparted only function in GUI mode so that if we don't have Live CD of Gparted, we cant use the tool. 
     - Indeed, our evironment is ubuntu server, which tend to have no GUI at all
     - GParted cant resize (shrink or extend) file system online , it only works if the file system is unmount (In some case, unmount root's container is impossible

# When HDD is needed to add
  
  ## Using LVM
  
  By following these steps: detect the new disk space, partition the new disk, creating a physical volume from that disk and then add it to the volume group, `LVM` can increase a logical volume with the `lvextend` command and then can extend the filesystem in it with `resize2fs` easily. So, it sounds like a good method, but what goes up must come down, although LVM seems to be perfect, it still have drawbacks
  
  - Pros:
     - Efficient because it's flexible to resize partition and then extends file system for further purpose if there's any getting-more-HDD plan
     - By providing storage to file system (as it's in logical volume), anytime HDD is added, it seems to be a good choice for such purpose
  - Cons: 
     - In a specific scheme, the file system contains root is non-lvm format, then it can't be added to vg and extend anymore size. Which leads to a problem is, you cant extend anymor eand root is full until you want to crush your laptop because of the poor performance
     - So, that traumatized problem can still be fixed if only you config your filesystem and block device as lvm format when you first set up your linux, but the fact is, not everyone notice about it until they face it - the worst nightmare.
     
  ## Using RAID0
 
 By fo
     
