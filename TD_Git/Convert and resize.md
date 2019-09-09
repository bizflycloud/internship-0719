# CONVERT AND RESIZE AN IMAGE 

**DOWNLOAD** 
  
  Sử dụng link: (https://cloud-images.ubuntu.com/releases/xenial/release/) chọn đặc tả qcow2
  
  Checking downloaded qcow2 image's size : `qemu-img info xenial-server-cloudimg-amd64-disk1.img`

**CONVERT** 
  
  ` qemu-img convert -O  raw xenial-server-cloudimg-amd64-disk1.img xenial-server-cloudimg-amd64-disk1.raw`

**RESIZING**

  - Checking raw image's sqcow2 : `qemu-img info xenial-server-cloudimg-amd64-disk1.raw`
  
  - Resizing: Using `GParted`, `fdisk` and `truncate`
  
    - GParted operates on devices, not simple files like images. So we need to create a device for the image using the loopback-functionality of Linux.
    
      - First we will enable loopback if it wasn't already enabled: `sudo modprobe loop`
      - Then we can request a new (free) loopback device: `sudo losetup -f`
      - Create a device of the image: `sudo losetup /dev/[loopback device] [image]`
       
       Example: we have a device `/dev/loop0` that represents `this.img`
      - We want to access the partitions that are on the image, so we need to ask the kernel to load those too: `sudo partprobe /dev/loop0`
    
    - Next step using GParted:
      
      - Load the device using GParted: `sudo gparted /dev/loop0` 
      - Select the partition and click Resize/Move.
      - Drag the right bar to the left as much as possible. (The process of dragging can return error of sizing because it's the smallest size that is possible to resize, so try to drag slightly at that time until you can resize no more)
      - Press Apply . It will now move files and finally shrink the partition, so it can take a minute or two, most of the time it finishes quickly
      - Unload loopback-device: `sudo losetup -d /dev/loop0`
     
    - Shaving Image
       
