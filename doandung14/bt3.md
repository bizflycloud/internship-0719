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



