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
**ví dụ** 
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

Xem các mảng đĩa:
$ cat /proc/mdstat.
Tắt một thiết bị RAID
$ mdadm --stop /dev/md0.
Bật lên
$ mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1/.




