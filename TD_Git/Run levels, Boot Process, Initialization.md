# BOOT PROCESS

**_Boot Process_**

 - BIOS run first, it checks the statistics, hardware information of the computer. After that, it seeks for the boot code in MBR ( Master boot record ) to load the OS, the Boot code will determine what partition or device will BIOS select as priority to boot in
 
 - MBR (the first sector) will be read and a program will be execute and that program's gonna locate and execute Bootloader - which will find and load the kernel
 
 - Bootloader(GRUB - Gran Unified Bootloader) let you decide which OS you want and then load its kernel (kernel's extracted until the session ends). Bootloader can also load initrd to add other necessary modules for kernel
 
 - Kernel executes sbin/init (PID=1) - an ancestor process of the every processes. Init never dies and mustn't dies ( by kill command or the other) 
 
 - Init executes level programs by looking into "file /etc/inittab"
 
 
 # RUN LEVELS
 
 **_List of run levels_**
 
- 0 - System halt

- 1 - Single user mode

- 2 - Multiuser, without NFS

- 3 - Full multiuser mode

- 4 - Experimental, unused

- 5 - X11

- 6 - reboot

> In order not to get into trouble, mustn't set the default run level to 0 or 6

_Depending on the default init level setting, the system will execute the programs from one of the following directories._

Run level 0 – /etc/rc.d/rc0.d/

...

Run level 6 – /etc/rc.d/rc6.d/

- There are also symbolic links available for these directory under /etc directly. So, /etc/rc0.d is linked to /etc/rc.d/rc0.d.

- Under the /etc/rc.d/rc*.d/ directories, programs that start with S and K. S are used during startup, K are used during shutdown.
 
# Initialization

**_Initialization_**

> The init process is the last step in the boot procedure and identified by process id "1". Init is responsible for starting system processes as defined in: `/lib/systemd/system/default.target` (A symbolic link) and the files in `/etc/systemd/system/` and `/lib/systemd/system/`

> Init typically will start multiple instances of "getty" which waits for console logins which spawn one's user shell process.

> Upon shutdown, init controls the sequence and processes for shutdown. 

> The init process is never shut down. It's an user process and not a kernel system process although it does run as root.

**_System Processes:_**

|Process ID|Description|
|:---------|----------:|
|0         |The Scheduler|
|1         |The init process|
|2         |kflushd|
|3         |kupdate|
|4         |kpiod|
|5         |kswapd|
|6         |mdrecoveryd|





