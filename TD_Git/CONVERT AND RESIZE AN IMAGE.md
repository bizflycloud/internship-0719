# CONVERT AND RESIZE AN IMAGE 

**DOWNLOAD** 
  
  Use the following link: (https://cloud-images.ubuntu.com/releases/xenial/release/) choose specified qcow2 image description
  
  Checking downloaded qcow2 image's size : `qemu-img info xenial-server-cloudimg-amd64-disk1.img`![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/1.png)

**CONVERT** 
  
  ` qemu-img convert -O  raw xenial-server-cloudimg-amd64-disk1.img xenial-server-cloudimg-amd64-disk1.raw`

**RESIZING**
  
  > The goal is to resize the image as smallest as possible without causing any trouble or the loss of datas
  
  - Checking raw image's sqcow2 : `qemu-img info xenial-server-cloudimg-amd64-disk1.raw`![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/2.png)  
  - Resizing: Using `GParted`, `fdisk` and `truncate`
  
    - GParted operates on devices, not simple files like images. So we need to create a device for the image using the loopback-functionality of Linux.
    
      - First we will enable loopback if it wasn't already enabled: `sudo modprobe loop`
      - Then we can request a new (free) loopback device: `sudo losetup -f`
      - Create a device of the image: `sudo losetup /dev/[loopback device] [image]`
       
       Example: we have a device `/dev/loop0` that represents `this.img`
      - We want to access the partitions that are on the image, so we need to ask the kernel to load those too: `sudo partprobe /dev/loop0`
    
    - Next step using GParted:
      
      - Load the device using GParted: `sudo gparted /dev/loop0` 
      
      ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/3.png)
      ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/4.png)
      ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/5.png)
      - Select the partition and click Resize/Move.
      - Drag the right bar to the left as much as possible. (The process of dragging can return error of sizing because it's the smallest size that is possible to resize, so try to drag slightly at that time until you can resize no more)
      - Press Apply . It will now move files and finally shrink the partition, so it can take a minute or two, most of the time it finishes quickly
      - Unload loopback-device: `sudo losetup -d /dev/loop0`
     
    - Shaving Image
    
      > Now all the important data stand at the beginning of the image so it's time to shave of that unallocated part
      
     - To know where the partition ends and where the unallocated part begins, use: `fdisk -l this.img`![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/6.png)
     
        - The partition ends on block "X" shown under `End`
        - The block-size is 512 bytes shown as `sectors of 1 * 512`
       
        > The numbers mean that the parition ends on byte "X"x512 of the file. After that byte comes the unallocated-part.
       
     - Shrink the image-file to a size that can just contain the partition using `truncate`: 
      
      > Need (X+1)x512 bytes to supply the size of the file in bytes. `+1` because block-numbers start at 0
      
       Perform: `truncate --size=$[(X+1)*512] this.img`![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/7.png)
    
        
