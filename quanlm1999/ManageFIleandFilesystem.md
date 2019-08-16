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

**Mounting and Unmounting Filesystems: ‘mount’, ‘umount’**

