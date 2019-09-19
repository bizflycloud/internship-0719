**Bt3 các cách mở rộng phân vùng**

**1.LVM**

Ví dụ thêm 2 ổ đĩa trên máy ảo

Kiểm tra Hard Drives nào trên hệ thống bằng cách sử dụng câu lệnh `lsblk`

**Bước1: Tạo Partition và thay đổi định dạng `fdisk /dev/sdc` (sdb tương tự)** 

![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/sdc.png)

**Bước2: Tạo Physical Volume**

Tạo các Physical Volume là /dev/sdb1 và /dev/sdc1 bằng các lệnh sau:

# pvcreate /dev/sdb1

# pvcreate /dev/sdc1

![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/pvcreate.png)

**Bước3: Tạo Volume Group** 

`vgcreate demo1 /dev/sdb1 /dev/sdc1`

**Bước4: Tạo Logical Volume**

`lvcreate -L 15G -n lv-demo1 demo1`

**Bước6: Định dạng Logical Volume**

`mkfs -t ext4 /dev/demo1/lv-demo1`

**Cuối cùng là mount và sử dụng**

`mount /dev/demo1/lv-demo1 demo1` ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/mount%20v%C3%A0%20s%E1%BB%AD%20d%E1%BB%A5ng.png)

**2.RAID**

**Bước1: tạo phân vùng**

`fdisk /dev/sdb`, `fisk /dev/sdc`(sdb và sdc mỗi ổ 1Gb)

**Bước2: tạo RAID trên tbị (ví dụ đang là RAID 0)**

`mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sd[b-c]1` ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/t%E1%BA%A1o%20raid0.png)

Xem lại raid đã tạo, số lượng thiết bị tham gia

`mdadm --detail /dev/md0` ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/xem%20raid%20%C4%91%C3%A3%20t%E1%BA%A1o%20v%C3%A0%20tb%E1%BB%8B.png)

**Bước3: Tạo file hệ thống trên thiết bị Raid**

`mkfs.ext4 /dev/md0`

**Bước4: Mount tbị**

`mount /dev/md0 /mnt/raid1/`
 
 => Kết quả 
 
 ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/sau%20khi%20t%E1%BA%A1o%20filesystem.png)
 
 **Kết Luận** 
 
 Phương thức để mở rộng filesystem là : lvm và raid ( hiện tại em biết được 2 phương thức này)
 
 ***1.LVM***
 
 **Khái niệm** 
 
 LVM là kỹ thuật quản lý việc thay đổi kích thước lưu trữ của ổ cứng. Là một phương pháp ấn định không gian ổ đĩa thành những logicalvolume khiến cho việc thay đổi kích thước của một phân vùng trở nên dễ dàng. Điều này thật dễ dàng khi bạn muốn quản lý công việc của mình tại riêng một phân vùng mà muốn mở rộng nó ra lớn hơn.
 
**Ưu điểm:**

Không để hệ thống bị gián đoạn hoạt động

Không làm hỏng dịch vụ

Có thể kế hợp swap

Có thể tạo ra các vùng dung lượng lớn nhỏ tuỳ ý.

**Nhược điểm:**

bước thiết lập phức tạp và khó khăn hơn

Càng gắn nhiều đĩa cứng và thiết lập càng nhiều LVM thì hệ thống khởi động càng lâu.

Khả năng mất dữ liệu cao khi một trong số các đĩa cứng bị hỏng.

***2.RAID***

là hình thức ghép nhiều ổ đĩa cứng vật lý(HardDisks) thành một hệ thống ổ đĩa cứng có chức năng: gia tăng tốc độ đọc/ghi dữ liệu(1)hoặc nhằm tăng sự an toàn dữ liệu chứa trên hệ thống đĩa(2) hoặc kết hợp cả 2 yếu tố (1) và (2).









