# FSCK

>fsck's used to check the system files

fsck has 3 modes:

* check errors and let user take action to solve them manually
* check errors and automatically solve them 
* check errors and display them to standard output error without trying to solve them
* Command:`fcsk [option] [filename]` 

Options:

1. `-A` Check every files
2. `-l` lock the device in order not to let any program interfere the process
3. `-c` show the process status bar
4. `-P` If you want to check filesystems in parallel, including root.
5. `-M` Do not check mounted filesystems.
6. `-N` Only show what would be done.
7. `-r` Provide statistics for each device that is being checked.
8. `-R `Do not check root filesystem.
9. `-V` Provide description what is being done.

# MAKING FILE SYSTEM

__mkfs__

> mkfs is like an front-end program use to create file system on partitions

* `mkfs [option] devicename(partition)` is to create new file system


Options :
1. `-t` customize type of file system, default is ext2

> the file system can also be create by using the following command `mkfs.[type] devicename(partition)`

>  etc: `mkfs.ext4 /dev`

2. `-c` using check bad block before create new file system

# MOUNT AND UNMOUNT

__mount__

> Mount is used to attach file system or a storage device to an existing directory structure

1. `mount` view all mounted file systems
2. `mount -t [type] [source] [dest]` to mount a device file to a directory in a file system we want to mount
3. `mount -a [source] [dest]` try to mount using all supported file system types
4. `mount -o [option or options]` specified more mount options
5. `mount -o loop [filename.iso] [mount point]` mount an iso image
6. `mount -U uuid` mount the partition that have the universal unique id "uuid"

__unmount__

> Unmount is to detach file system on a directory structure

1. `umount [device]`
2. `umount [the directory that the device is mounted on]`

__fdisk__

> Is an most commonly used command-line based disk manipulation utility. It can create a maximum of four new primary partition and number of logical (extended) partitions, based on size of the hard disk in system.

* `fdisk -l` view all partition in system
* `fdisk -l [hard disk]` specify a partition
* `fdisk [h]` 
   * choose `m` to view all available commands for the specified partition
   * choose `d` to delete the partition you want, `w` to alter the partition table
   * choose `n` to create new partition
    
