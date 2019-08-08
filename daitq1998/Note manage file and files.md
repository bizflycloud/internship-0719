**Managing File and Filesystems**
 
 **Filesystems in linux**

 - file hệ thống của linux:gồm cáo các file hệ thống sau: `ext2`, `ext3`,`ext4`,`jfs`,`reiserfs`,`xfs`,`btrf`

 - `ext2,3,4`:Là phiên bản tích lũy của extended filesystem(ext):gồm phiên bản mở rộng phiên bản cải tiến và `ext4`

 - `jfs`: đc phát triển bởi IBM AIX UNIX đc sd như là một thay thế cho hệ thống ext jfs là một thay thế cho ext4 hiện tại và đc sd khi cần sự ổn định vs việc sd ít tài nguyên khi cpu bị hạn chế `jfs` sẽ có ích

 - `reiserfs`:đc giới thiệu để thay thế cho `ext3` với hiệu suất đc cải thiện và các tính năng cao `reiserfs` hỗ trợ mở rộng hệ thống têp một cách linh hoạt 
 
 `xfs`là một jfs tốc độ cao nhằm xử lý I/O song song

 - `btrfs`:hệ thống tệp `b-tree(btrfs)` tập trung vào khả năng chịu lỗi hệ thống sửa chữa cấu hình lưu trữ lớn và vẫn đang đc phát triển (nhưng `btrfs` k đc khuyến nghị cho hệ thống sx)

 - `btrfs` có các chức năng :tự kiểm tra và sửa lỗi cấu trúc file hệ thống ,chống phân mảnh dữ liệu kiểm tra và khắc phục lỗi của dữ liệu bằng các bảng dự phòng, hỗ trợ cơ chế cloning(kể cả tập tin), hỗ trợ subvolume và snapshot, hỗ trợ incremental backup
 
 -So với `ext4`, `btrfs` hoạt động ổn định, tin cậy và dễ quản lí hơn. `btrfs` file system thích hợp cho các server doanh nghiệp,do hiệu suất cao, tạo snapshot nhanh chóng và nhiều tính năng khác.
 
 **lệnh `fsck`**
-Là lệnh dùng để kiểm tra tùy chọn sửa chữa một hoặc nhiều hệ thông tập tin
cso ba chế độ hđ của `fsck` :là kiểm tra lỗi và nhắc người dùng tương tác để quyết định các vấn đề riêng lẻ 
- kiểm tra lỗi và cố gắng tự động sửa bất kì lỗi nào 
- kiểm tra lỗi và không cố gắng sửa chúng nhưng hiển thị các lỗi trên đầu ra tiêu chuẩn 
lệnh`fsck`cần được chạy với quyền superuser hoặc root
**cú pháp** `fsck [option] [file]
**tùy chon**
-`-A` đc sử dụng để kiểm tra tấtc ả các hệ thống tập tin
-`-c` hiển thị thanh tiến trình 
-`-l` khóa thiết bị để đảm bảo không có chương trình nào khác cố gắng sử dụng phân vùng trong quá trình kiểm tra
-`-M` Không kiểm tra các các hệ thống tệp tin gắn kết
-`-P` nếu ng dùng muốn kiểm tra các hệ thống tập tin song song bao gồm cả root
-`-R` không kiẻm tra hệ thống tập tin gốc 

**lệnh `df`**
- là lệnh dùng để hiển thị dung lượng của hệ thống và được sử dụng bao nhiêu trong linux

**cú phap** `df [option] [file]`

**tùy chon**
-`-h` in tất cả các hệ thống tập tin
-`-m` có thể được dùng để hiển thị thông tin dung lượng MB
-`-k` có thể hiển thị thông tin dung lượng bằng KB
-`-T` cho biết loại file của hệ thống
**lệnh `du`**
là lệnh dùng để kiểm tra dung lượng đã dùng trên hệ thống
 
**cú pháp**  `du [option] [file]`
**tùy chọn**
-`-m` có thể được dùng để hiển thị thông tin dung lượng MB
-`-k` có thể hiển thị thông tin dung lượng bằng KB
-`-b` hiển thị thông tin dung lượng đã dùng bầng B
**lệnh `mkfs`**
- là lệnh được dùng để  xây dựng một file hệ thống trên l

