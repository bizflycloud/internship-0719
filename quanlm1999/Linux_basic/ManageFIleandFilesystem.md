# Managing Files and Filesystems
#### Understand File System Type
* ext2
  - On flash drives, usb drives, ext2 is recommended, as it doesn’t need to do the over head of journaling.
  - Maximum individual file size can be from 16 GB to 2 TB
  - Overall ext2 file system size can be from 2 TB to 32 TB
* ext3
  - The main benefit of ext3 is that it allows journaling.
  - Maximum individual file size can be from 16 GB to 2 TB
  - Overall ext3 file system size can be from 2 TB to 32 TB
* ext4
  - Maximum individual file size can be from 16 GB to 16 TB
  - Overall maximum ext4 file system size is 1 EB (exabyte). 1 EB = 1024 PB (petabyte). 1 PB = 1024 TB (terabyte).
  - Several other new features are introduced in ext4: multiblock allocation, delayed allocation, journal checksum. fast fsck, etc.
* jfs
  - JFS is an alternative to ext4 currently and is used where stability is required with the use of very few resources. 
* ReiserFS
  - alternative to ext3 with improved performance and advanced features.
* XFS
  - XFS was a high speed JFS which aimed at parallel I/O processing.
* Btrfs
  - B-Tree File System (Btrfs) focus on fault tolerance, fun administration, repair System, large storage configuration and is still under development.

#### Check file system : ‘fsck’

**fsck** Là lệnh dùng để kiểm tra tùy chọn sửa chữa một hoặc nhiều hệ thông tập tin cso ba chế độ hđ của fsck :là kiểm tra lỗi và nhắc người dùng tương tác để quyết định các vấn đề riêng lẻ
 *   kiểm tra lỗi và cố gắng tự động sửa bất kì lỗi nào
  *  kiểm tra lỗi và không cố gắng sửa chúng nhưng hiển thị các lỗi trên đầu ra tiêu chuẩn lệnhfsckcần được chạy với quyền superuser hoặc root
  
**Câu lệnh**  fsck <option> <file> 
**Option**
 * --A đc sử dụng để kiểm tra tấtc ả các hệ thống tập tin 
 * --c hiển thị thanh tiến trình 
 * --l khóa thiết bị để đảm bảo không có chương trình nào khác cố gắng sử dụng phân vùng trong quá trình kiểm tra 
 * --M Không kiểm tra các các hệ thống tệp tin gắn kết 
 * -- P nếu ng dùng muốn kiểm tra các hệ thống tập tin song song bao gồm cả root --
 * -- R không kiẻm tra hệ thống tập tin gốc=
 
#### Monitoring Disk: ‘df’, ‘du’
**df** là lệnh dùng để hiển thị dung lượng của hệ thống và còn đc sử dụng bao nhiêu trong linux
**câu lệnh** df <option><file> 
**Option** 
* -h: Hiển thị dưới dạng dễ đọc 
* -T: Hiển thị filesystem 
* -i: Hiển thị số inodes 
* -x: Không hiển thị filesystem đo

**du** là lệnh dùng để kiểm tra dung lượng đã dùng trên hệ thống
**câu lệnh** du <option> <file> 
**Option**
* -h: Hiển thị dễ đọc hơn 
* -s; Hiển thị tổng số lượng sử dụng 
* -a: Hiển thị tất các file và thư mục
* -c: Hiển thị bình thường và có thêm dòng tổng sử dụng ở cuối cùng 
* --exculde ="*.fileext" bỏ qua file có định dạng theo yêu cầu 

#### Creating Filesystems: ‘mkfs’
**mkfs** là lệnh được dùng để xây dựng một file hệ thống trên linux
**câu lệnh** $ mkfs -t <fs type> <device>

Create an ext2 file system:

mke2fs /dev/sda1

Create an ext3 file system:

mkfs.ext3 /dev/sda1

(or)

mke2fs –j /dev/sda1

Create an ext4 file system:

mkfs.ext4 /dev/sda1

(or)

mke2fs -t ext4 /dev/sda1

#### Mounting and Unmounting Filesystems: ‘mount’, ‘umount’
**Mount** là lệnh gắn 1 thiết bị lưu trữ hoặc hệ thống file vào thư mục  đã có . Thư mục đó được gọi là điểm  gắn kết 
**Câu lệnh** mount [option] <tên thiết bị> <điểm gắn két> 
**Option**
* mount xem tất cả các file dã gắn kết 
* mount -t [type] [source] [dest] to mount a device file to a directory in a file system we want to mount
* mount -a [source] [dest] try to mount using all supported file system types
* mount -o [option or options] specified more mount options
* mount -o loop [filename.iso] [mount point] mount an iso image
* mount -U uuid mount the partition that have the universal unique id "uuid"

**Mount** khi boot hệ thống, chỉnh sửa file /etc/fstab theo lệnh sau: 
**<file system> <mount point>   <type>  <options>       <dump>  <pass>**


**Unmount** là ngắt kết nối tập tin đã gắn ra khỏi hệ thống của bạn 
**câu lệnh** unmount <tên thiết bị> hoặc <điểm gắn kết > 

#### Partitioning Disks: Understanding Partitions, Creating Partitions ‘fdisk’, Understanding RAID, ‘mdadm, Understanding LVM, create/resize/delete lvm, pv, pg.

**Understanding Partitions** 
* Partition là những phân vùng nhỏ (phân vùng logic) được chia ra từ 1 ổ cứng vật lý. Một ổ cứng có thể có 1 hoặc nhiều partition.
* Dữ liệu trên 1 partition A sẽ được phân tách với dữ liệu trên partition B,
* Hiện có 3 loại partition chính là: primary, extended và logical.
  - Primary partition: đây là những phân vùng có thể được dùng để boot hệ điều hành
  - Extended partition: là vùng dữ liệu còn lại khi ta đã phân chia ra các primary partition, extended partition chứa các logical partition trong đó. Mỗi một ổ đĩa chỉ có thể chứa 1 extended edition.
  - Logical partition: các phân vùng nhỏ nằm trong extended partition, thường dùng để chứa dữ liệu.

**Creating Partitions ‘fdisk’** 
Fdisk là một tiện ích text-based được sử dụng để xem và quản lý các phân vùng ổ cứng trên Linux.
**Câu lệnh** 
sudo fdisk -l: Hiển thi danh sách phân vùng tất cả ổ đĩa 
sudo fdisk <disk>: Vào chế độ command của ổ  đĩa đã chọn 
* m để hiện thỉ hướng dẫn 
* d để xóa phân vùng
* n để tạo phân vùng mới 
* w để lưu thay đổi
* q để thoát mà k làm thay đổi

**Understanding RAID**
Raid là hình thức ghép nhiều ổ cứng vật lý thành một hệ ổ cứng có chức năng gia tăng tốc độ đọc/ghi dữ liệu hoặc nhằm tăng thêm sự an toàn của dữ liệu chứa trên hệ thống đĩa hoặc kết hợp cả hai yếu tố trên.
Các loại RAID phổ biến: 
* Raid 0 Là raid đòi hỏi tối thiểu 2 đĩa cứng và ghi dữ liệu theo phương pháp striping raid 0 truy xuất dữ liêu lớn tốc độ đọc rất nhanh.
* Raid 1 Là raid tương tự như raid 0 nhưng ghi dữ liệu theo phương pháp mirroring :raid 1 là raid cơ bản nhất có khả năng đảm bảo an toàn dữ liệu. Dữ liệu được ghi trên 2 đĩa giống hệt nhau. Trong trường hợp dữ liệu ở đĩa 1 gặp sự cố thì dữ liệu ở đĩa 2 sẽ tiếp tục hoạt động bình thường.
* Raid 5:được sử dụng ở cấp doanh nghiệp. RAID5 hoạt động theo phương pháp parity. Thông tin chẵn lẻ sẽ được sử dụng để xây dựng lại dữ liệu. Nó xây dựng lại từ thông tin còn lại trên các ổ đĩa tốt còn lại. Điều này sẽ bảo vệ dữ liệu của chúng ta khi ổ đĩa bị lỗi. Dử liệu trên RAID5 có thể tồn tại sau một lỗi ổ đĩa duy nhất, nếu các ổ đĩa bị lỗi nhiều hơn 1 sẽ gây mất dữ liệu.
* Raid 6: giống như RAID5 hoạt động theo phương pháp parity. Chủ yếu được sử dụng trong một số lượng lớn các mảng. Chúng ta cần tối thiểu 4 ổ đĩa, khi có 2 ổ đĩa bị lỗi, chúng ta có thể xây dựng lại dữ liệu trong khi thay thế các ổ đĩa mới.
* Raid 10: có thể được gọi là RAID1 + RAID0 hoặc RAID0 + RAID1. RAID10 sẽ làm cả hai công việc của Mirror và Striping. Mirror sẽ là đầu tiên và Stripe sẽ là thứ hai trong RAID10. Stripe sẽ là đầu tiên và mirror sẽ là thứ hai trong RAID01. RAID10 tốt hơn so với RAID01. 

**mdadm** 
mdadm là công cụ quản lý chuẩn để tạo RAID có thể tìm thấy trong hầu hết các bản phân phối hiện nay.
mdadm có bảy chức năng.

  * Create: Tạo một thiết bị RAID mới
  *  Assemble: Tập hợp các thiết bị để tạo RAID.
  * Monitor: theo dõi thiết bị RAID. RAID0 hay Linear không never have missing, spare, hay các ổ đĩa hỏng.
  * Build
  * Grow : thay đổi kích thước của mảng. Hiện tại nó hỗ trợ thay đổi kích thước cho RAID 1/4/5/6 và thay đổi số thiết bị trong RAID1.
  *  Manage: thực hiện các thao tác với các thành phần của mảng như là thêm ổ đĩa và gỡ bỏ thiết bị sai hỏng.
  *  Misc: thực hiện các thao tác khác như tẩy xóa các superblock cũ, thu thập thông tin.

**Câu lệnh** 
$ mdadm --create /dev/md0 <chế độ> <tùy chọn> <danh sách các thiết bị tham gia>.
**Ví dụ** 
* raid 0 : $ mdadm --create --verbose /dev/md0 --level=stripe --raid-devices=2 /dev/sdb2 /dev/sdc2.
* raid 1:
$ mdadm --create --verbose /dev/md0 --level=mirror --raid-devices=2 /dev/sdb1 /dev/sdc1.
$ mdadm --create --verbose /dev/md0 --level=mirror --raid-devices=2 /dev/sdb1 /dev/sdc1 --spare-devices=1 /dev/sdd1.
--spare-devices: thiết bị dự phòng.
* raid 5: mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1 --spare-devices=1 /dev/sde1.

--level: chế độ raid.
--raid-devices: số thiết bị tham gia raid.


**Lưu lại thay đổi:** 
$ mdadm --detail --scan >> /etc/mdadm/mdadm.conf.
$ mdadm --detail --scan | tee /etc/mdadm.conf # chỉ dùng lần đầu.
**Theo dõi** 
$ mdadm --monitor /dev/md0.
**Quản lý** 
$ mdadm --manage/dev/md0.

**Xem các mảng đĩa:**
$ cat /proc/mdstat.
**Tắt một thiết bị RAID**
$ mdadm --stop /dev/md0.
**Bật lên**
$ mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1/.

**Understanding LVM** 
LVM là một công cụ để quản lý phân vùng logic được tạo và phân bổ từ các ổ đĩa vật lý. Với LVM bạn có thể dễ dàng tạo mới, thay đổi kích thước hoặc xóa bỏ phân vùng đã tạo.
*    Không để hệ thống bị gián đoạn hoạt động
*    Không làm hỏng dịch vụ
*    Có thể kết hợp Hot Swapping (thao tác thay thế nóng các thành phần bên trong máy tính)

**Mô hình các thành phần trong LVM** 
![alt](https://bachkhoa-aptech.edu.vn/upload/image/gioi-thieu-ve-logical-volume-manager-01.png)
Trong đó: 
* **Hard drives – Drives**
Thiết bị lưu trữ dữ liệu, ví dụ như trong linux nó là /dev/sda
**Partition**
Partitions là các phân vùng của Hard drives, mỗi Hard drives có 4 partition, trong đó partition bao gồm 2 loại là primary partition và extended partition
**Physical Volumes**
Là một cách gọi khác của partition trong kỹ thuật LVM, nó là những thành phần cơ bản được sử dụng bởi LVM. Một Physical Volume không thể mở rộng ra ngoài phạm vi một ổ đĩa.
Chúng ta có thể kết hợp nhiều Physical Volume thành Volume Groups
**Volume Group**
Nhiều Physical Volume trên những ổ đĩa khác nhau được kết hợp lại thành một Volume Group
Volume Group được sử dụng để tạo ra các Logical Volume, trong đó người dùng có thể tạo, thay đổi kích thước, lưu trữ, gỡ bỏ và sử dụng.
Một điểm cần lưu ý là boot loader không thể đọc /boot khi nó nằm trên Logical Volume Group. Do đó không thể sử dụng kỹ thuật LVM với /boot mount point
**Logical Volume**
Volume Group được chia nhỏ thành nhiều Logical Volume, mỗi Logical Volume có ý nghĩa tương tự như partition. Nó được dùng cho các mount point và được format với những định dạng khác nhau như ext2, ext3, ext4,…
Khi dung lượng của Logical Volume được sử dụng hết ta có thể đưa thêm ổ đĩa mới bổ sung cho Volume Group và do đó tăng được dung lượng của Logical Volume
Ví dụ bạn có 4 ổ đĩa mỗi ổ 5GB khi bạn kết hợp nó lại thành 1 volume group 20GB, và bạn có thể tạo ra 2 logical volumes mỗi disk 10GB

**Tạo Logical Volume trên LVM** 
* **B1** Kiểm tra xem có những Hard Drives nào trên hệ thống bằng cách sử dụng câu lệnh **lsblk**
* **B2** Từ các Hard Drives trên hệ thống, tạo các partition. sử dụng lệnh sau fdisk 
* **B3** Tạo các Physical Volume là /dev/sdb1 và /dev/sdc1 bằng các lệnh sau:
  -   pvcreate /dev/sdb1
  -   pvcreate /dev/sdc1
* **B4** Nhóm các Physical Volume thành 1 Volume Group bằng cách sử dụng câu lệnh sau:
  -   vgcreate vg-demo1 /dev/sdb1 /dev/sdc1
Trong đó vg-demo1 là tên của Volume Group
* **B5** Từ một Volume Group, chúng ta có thể tạo ra các Logical Volume bằng cách sử dụng lệnh sau:
  -   lvcreate -L 1G -n lv-demo1 vg-demo1
-L: Chỉ ra dung lượng của logical volume
-n: Chỉ ra tên của logical volume
 Trong đó lv-demo1 là tên Logical Volume, vg-demo1 là Volume Group mà mình vừa tạo ở bước trước
 Lưu ý là chúng ta có thể tạo nhiều Logical Volume từ 1 Volume Group
* **B6** Định dạng Logical Volume sử dụng **mkfs** 
* **B7** Mount và sử dụng

**Thay đổi dung lượng volume trên LVM** 
* Để tăng kích thước Logical Volume ta sử dụng câu lệnh sau: **lvextend -L <size>  <vị trí LV>**
* Tăng kích thước cho Logical Volume thì Logical Volume đã được tăng nhưng file system trên volume này vẫn chưa thay đổi, sử dụng lệnh sau để thay đổi **resize2fs /<vị trí LV>**
* Để giảm kích thước của Logical Volume, trước hết phải **umount**Logical Volume muốn giảm
* Tiến hành giảm kích thước của Logical Volume **lvreduce -L  <size> <vị trí LV>**
Sau đó tiến hành format lại Logical Volume sử dụng **mkfs**
* Cuối cùng là mount lại Logical Volume

**Thay đổi dung lượng Volume Group trên LVM**
Việc thay đổi kích thước của Volume Group chính là việc nhóm thêm Physical Volume hay thu hồi Physical Volume ra khỏi Volume Group
Mở rộng **vgextend** <volumegroup> <physical volume>
Thu hẹp **vgreduce** <volume volume> <physical volume>

**Xóa lv, vg, pv**
**lv** 
* B1 Umount Logical Volume
* B2: Dùng câu lệnh: **lvremove <Logical volume>**

**vg**
* Trước khi xóa volume group phải xóa logical volume 
* Câu lệnh:  **vgremove <volume group>**


**pv**
* Sau khi xóa xong lv với vg, ta xóa pv dùng câu lênh: **pvremove pv**

#### Understanding Filesystem Hierarchy Standard
**FHS** defines the directory structure and directory contents in Linux distributions
**Thư mục root** 
Tất cả hệ thống của Linux  đều có  cấu trúc thư mục bắt đầu từ  thư mục root ,được đai diện bởi dấu / 
**Các thư mục cấp cao**     
* /bin/: các chương trình cơ bản;
*   /boot/: Linux kernel và các tệp khác cần thiết cho tiến trình khởi động ban đầu;
*    /dev/: tệp thiết bị;
*    /etc/: các tệp cấu hình;
*    /home/: các tệp cá nhân của người dùng;
*    /lib/: các thư viện cơ bản;
*    /media/*: điểm truy nhập cho các thiết bị rời (CD-ROM, bàn phím USB và các thiết bị tương tự);
*    /mnt/: điểm truy nhập tạm thời;
*    /opt/: các ứng dụng bổ sung do bên thứ ba cung cấp;
*    /root/: các tệp cá nhân của người quản trị (root);
*    /run/: dữ liệu thời gian chạy không lưu trữ qua các lần khởi động lại (chưa có trong FHS);
*    /sbin/: các chương trình hệ thống;
*    /srv/: dữ liệu được sử dụng bởi các máy chủ lưu trữ trên hệ thống này;
*    /tmp/: các tệp tạm thời; Thư mục này thường được làm trống khi khởi động;
*    /usr/: ứng dụng; Thư mục này được chia nhỏ thànhbin,sbin,lib(theo logic giống như trong thư mục gốc). Hơn nữa,/usr/share/chứa dữ liệu độc lập về kiến trúc./usr/local/được quản trị viên sử dụng để cài đặt ứng dụng theo thủ công mà không ghi đè lên các tệp được hệ thống đóng gói (dpkg) quản lý.
*    /var/: dữ liệu biến được xử lý bởi daemon. Điều này bao gồm các tệp nhật ký, hàng đợi, bộ đệm, bộ nhớ cache, v.v....
*    /proc/và/sys/được sử dụng cho nhân Linux (chứ không phải là một phần của FHS). Chúng được sử dụng bởi nhân để xuất dữ liệu sang không gian người dùng

#### Managing File Ownership: ‘chown’, ‘chgrp’
**chgrp** You can change the group owner of a file using the chgrp command.
**Ví dụ**
root@rhel65:/home/paul/owners# chgrp snooker file2
root@rhel65:/home/paul/owners# ls -l file2
-rw-r--r--. 1 root snooker 185 Apr  8 18:46 file2

**chown** The user owner of a file can be changed with chown command.
**Ví dụ**
* root@laika:/home/paul# ls -l FileForPaul 
-rw-r--r-- 1 root paul 0 2008-08-06 14:11 FileForPaul
root@laika:/home/paul# chown paul FileForPaul 
root@laika:/home/paul# ls -l FileForPaul 
-rw-r--r-- 1 paul paul 0 2008-08-06 14:11 FileForPaul

 You can also use chown to change both the user owner and the group owner
* root@laika:/home/paul# ls -l FileForPaul
-rw-r--r-- 1 paul paul 0 2008-08-06 14:11 FileForPaul
root@laika:/home/paul# chown root:project42 FileForPaul
root@laika:/home/paul# ls -l FileForPaul 
-rw-r--r-- 1 root project42 0 2008-08-06 14:11 FileForPaul

#### Controlling Access to Files: Understanding Permissions, ‘chmod’
**chmod** cho pháp bạn thay đổi quyền (permission) của một file hay folder.
**Quyền trong linux**
| Permission	|in file   	|in dir   	|
|---	|---	|---	|
|   r	|   đọc nội dung (cat)	|   xem thư mục (ls)	|
|  w	|   sửa nội dung (vi)	|  Tạo thư mục (touch) 	|
|  x     | thực thi      |         Truy cập thư mục (cd)|
**Unix file permissions position**
|Vị trí   	|Kí tự   	|Chức năng   	|
|---	|---	|---	|
|   1	|   -	|   file bình thường	|
|  2 3 4 	|   rwx	| quyền của user owner  	|
|   5 6 7    |    r-x   | quyền của group owner      |
|    8 9 10   |   r--    | quyền của other       |

**Unix special file**
| Ký tự  	|  Loại file 	|
|---	|---	|
| -  	|   file bình thường	|
|  d 	|  thư mục  	|
|   l	|  symbolic link 	|
|   p	|   named pipe	|
|   b	|   block device	|
|   c	|   character device	|
|   s	|   socket	|

**Octal permissions**
| nhị phân  	|thập phân   	|quyền    	|
|---	|---	|---	|
| 000  	|  0 	|   ---	|
|   001	|   1	|   --x	|
|   010	|   2	|   -w-	|
|   011	|   3	|   -wx	|
|   100	|   4	|   r--	|
|   101	|   5	|   r-x	|
|   110	|   6	|   rw-	|
|    111   | 7      |  rwx     |
**Câu lệnh**  chmod <u/g/o> <+/-> <permisson> <file/dir> 
**Ví dụ** 
removes the group owners read permission.
* paul@laika:~/perms$ chmod g-r permissions.txt 
paul@laika:~/perms$ ls -l permissions.txt 
-rwx---r-- 1 paul paul 0 2007-02-07 22:34 permissions.txt

 set explicit permissions.
* paul@laika:~/perms$ chmod u=rwx,ug+rw,o=r permissions.txt 
 paul@laika:~/perms$ ls -l permissions.txt 
 -rwxrw-r-- 1 paul paul 0 2007-02-07 22:34 permissions.txt

Octal 
* paul@laika:~/perms$ chmod 777 permissions.txt 
 paul@laika:~/perms$ ls -l permissions.txt
 -rwxrwxrwx 1 paul paul 0 2007-02-07 22:34 permissions.txt
 paul@laika:~/perms$ chmod 664 permissions.txt 
 paul@laika:~/perms$ ls -l permissions.txt 
 -rw-rw-r-- 1 paul paul 0 2007-02-07 22:34 permissions.txt
 paul@laika:~/perms$ chmod 750 permissions.txt 
 paul@laika:~/perms$ ls -l permissions.txt 
 -rwxr-x--- 1 paul paul 0 2007-02-07 22:34 permissions.txt

#### Tools for Locating Files: ‘find’, ‘locate’, ‘whereis’, ‘which’
**find** là lệnh tìm kiếm file hay là directory trong filesystem 
**Câu lệnh** 
* TÌm theo tên: 
  -  find -name "file_name"
  -  find -not -name “file_name_to_avoid”
  -  find \\! -name “file_name_to_avoid”
* Tìm theo thể loại 
  -  các file có đuôi txt: find -type f -name “*.txt”
* Tìm theo thời gian và size
   -  các file nặng hơn 1GB: find / -size +1G
   -  các file được chỉnh sửa trong vòng 1 ngày trước: find / -mtime 1
   -  file được truy cập trong ngày hôm qua: find / -atime -1
* Tìm theo Owner và Permission
  -  file mà group "sudo" sở hữu: find / -group sudo
  -  file có permission 644: find / -perm 644
 **Kết hợp find và command khác**
**Câu lệnh** 
* find find_parameters -exec command_and_params {} \;
* Ví dụ
  -  Tìm các file có permission là 744 và chmod sang 755: *find / -type f -perm 777 -print -exec chmod 755 {} \;*
  -  Tìm 1 file test.py và xóa nó: *find . -type f -name "test.py" -exec rm -f {} \;*
  -  Hoặc xóa các file có đuôi .mp3 ở dir hiện tại: *find . -type f -name "*.mp3" -exec rm -f {} \;*

**Locate** tìm kiếm ở trong mục lục csdl của locate,  việc tìm kiếm sẽ rất nhanh nhưng thông tin có thể đã bị lỗi thời ,để cập nhật csdl của locate dùng lệnh: **updatedb** 
**Ví dụ** 
* quan@quan-HP-Pavilion-Laptop-15-cs2xxx:~$ locate ManageFIleandFilesystem.md
/home/quan/Documents/quanlm1999/ManageFIleandFilesystem.md

**which** 
Xác định đường dẫn đến file cần thực thi.
**câu lệnh** which <option> <command> 
-a : Hiển thị tất cả đường dẫn đến thư mục cần tìm 

**whereis**
Tìm đường dẫn đến file binary, manual và source code của 1 chương trình hoặc lệnh trong linux 
**câu lệnh**
*  whereis [options] program/command
 whereis -BMS /directory -f command/program
* Option
  -  b: chỉ tìm file binary
  -  m: chỉ tìm file manual 
  -  s: chỉ tìm source code 
  -  -f: chỉ tìm ở thư mục đó

