# FHS

*File Hierarchy Standard*

__/boot__

> contains the bootloader files of the system, kernel files and initrd files, it's considers as a separated partition

__/bin & /sbin__ 

> contain binary files that are essential and can be executed for booting the system , the `/sbin` contains system's binary files or binaries that administrator use to manage the system 

__/etc__

> contains all system's configuration files (services, network, ...)

__/home__

> this directory gives users their own place to store their own files

__/lib__

> It stores essential shared libraries that the essential binaries in /bin and /sbin need to run. This is also the directory where kernel modules are stored.

__/usr, /usr/bin, /usr/lib and /usr/sbin__

> When installing a software on the system, its binary files and library files go into the corresponding directory.

__/usr/local__

> A special version of `/user` that has its own internal structure of bin, lib and sbin directories, but /usr/local is designed to be a place where users can install their own software outside the distribution's provided software without worrying about overwriting any distribution files

__/opt__

> It serves just like `/usr/local` but instead of having `/usr/bin, /usr/lib`, it store applications in their own subdirectory, so whenever they're needed to be remove, the action can be taken by removing their folders

__/root__

> The `/var` directory was designed for storing files that might vary wildly in size or might get written to frequently. Unlike with `/usr`, which is read-only, the `/var` directory most definitely needs to be writeable, because within it you will find log files, mail server spools, and other files that might come and go or otherwise might grow in size in unpredictable ways.

__/dev__

> This directory contains files for devices on your system from disks and partitions to mice and keyboards.

__/proc and /sys__

> The `/proc` directory stores files that represent information about all of the running processes on the system.

> The `/sys` directory is designed to contain all of files that let you interact with the kernel, and this directory gets dynamically populated with files that often show up as nested series of recursive symlinks

__srv__

> Compared to some of the directories, `/srv` is a bit of a newcomer. This directory is designed for storing files that a server might share externally.

__/tmp, /var/tmp and /dev/shm__

> The `/tmp` directory is aimed at storing temporary files that don't need to stick around after a reboot. 

> The `/var/tmp` directory, on the other hand, does not get cleaned out between reboots, so this is a good place to store files, such as caches that you'd appreciate sticking, even if you don't absolutely need them

>the `/dev/shm` directory is a small ramdisk, and any files that are stored there reside only in RAM, and after the system is turned off, these files are erased


