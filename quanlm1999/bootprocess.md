# The Boot Process 
#### BIOS (Basic Input/Output System)

**BIOS** là chương trình được chạy đầu tiên khi bạn nhấn nút nguồn hoặc nút reset trên máy tính. 

BIOS thực hiện một công việc gọi là POST (Power-on Self-test). POST là một quá trình kiểm tra tính sẵn sàng phần cứng nhằm, kiểm tra thông số và trạng thái của các phần cứng máy tính khác như bộ nhớ, CPU, thiết bị lưu trữ, card mạng… Đồng thời, BIOS cũng cho phép bạn thay đổi các thiết lập, cấu hình của nó (tùy từng máy mà bạn nhấn phím F2, Delete, F10,… để vào giao diện cài đặt cho BIOS).

Nếu quá trình POST kết thúc thành công (tức, các phần cứng ở trạng thái tốt, BIOS không phát hiện ra các trục trặc nào), thì sau đó BIOS sẽ cố gắng tìm kiếm và khởi chạy (boot) một hệ điều hành được chứa trong các thiết bị lưu trữ như ổ cứng, CD/DVD, USB….

Thông thường, BIOS sẽ kiểm tra ổ đĩa mềm, hoặc CD-ROM xem có thể khởi động từ chúng được không, rồi đến phần cứng. Thứ tự của việc kiểm tra các ổ đĩa phụ thuộc vào các cấu hình trong BIOS.

Tiếp theo nó tìm đến một thiết bị để khởi động được cài đặt sẵn trong BIOS, thường là CD-ROM hoặc USB hoặc HDD. Nếu hệ điều hành Linux được cài trên ổ đĩa cứng thì nó sẽ tìm đến Master Boot Record (MBR) tại sector đầu tiên của ổ đĩa cứng đầu tiên.

#### MBR (Master Boot Record)

Sector đầu tiên của một thiết bị lưu trữ dữ liệu được gọi là MBR, ví dụ /dev/hda hoặc/dev/dsa/.  MBR rất nhỏ chỉ 512 byte.

MBR chứa các chỉ dẫn cho biết cách nạp trình quản lý khởi động GRUB/LILO cho Linux hay BOOTMGR cho Windows (7, 8).

#### Boot Loader

Có 2 boot loader phổ biến trên **Linux là GRUB và LILO.**

Boot loader tìm kiếm phân vùng boot và đọc thông tin cấu hình trong file grub.conf hoặc lilo.conf và hiển thị  các hệ điều hành có sẵn trong máy tính cho phép chúng ta lựa chọn để khởi động, sau đó chúng sẽ nạp kernel của hệ điều hành đó vào bộ nhớ và chuyển quyền điều khiển máy tính cho kernel này.

Ví dụ grub.conf:
* grub
Kernel

Sau khi chọn kernel trong file cấu hình của boot loader, hệ thống tự động nạp chương trình init trong thư mục /sbin/.

#### Init

Tiến trình này có PID (process ID) =1, init là cha của tất cả các tiến trình khác mà có trên hệ thống Linux này. Sau đó, init đọc file /etc/inittab để xác định mức hoạt động (runlevel).

Trên phần lớn các bản phân phối Linux, thường dùng 7 level, có giá trị từ 0-6, mức 4 không sử dụng. Các mức này thường được mô tả trong file /etc/inittab:

**runlevel**

Sau khi xác định runlevel (thông qua biến initdefault), chương trình /sbin/init sẽ thực thi các file statup script được đặt trong các thư mục con của thư mục /etc/rc.d/. Script sử dụng runlevel 0->6 để xác định thư mục chứa file script chỉ định cho từng level như: /etc/rc.d/rc0.d -> /etc/rc.d/rc6.d.

Runlevel được hiểu là các mức hoạt động của hệ thống, để chuyển đội các mức hoạt động này ta dùng lệnh: init giá_trị. Ví dụ ta muốn chuyển sang mức 1 ta dùng lệnh init 1. Đặt runlevel mặc định cho hệ thống ta dùng trình soạn thảo vi (sẽ nói trong các bài sau) để chỉnh thông số runlevel X(0->6) trong file /etc/inittab:

[root@localhost ~]#  vi /etc/inittab  (dùng để mở file inittab)
Sau khi mở file /etc/inittab, ta nhấn I để chỉnh sửa thông tin ở dòng:
id:5:initdefault: thành id:3:initdefault: để xài giao diện dạng text.

