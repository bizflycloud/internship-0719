### Test I/O
* Bandwidth 
* IOPS 

Tool: Flexible I/O Tester(fio)

Cài đặt: `sudo apt-get install fio` / `sudo yum install fio -y

** Kiểm tra tốc độ ghi: `sudo fio --name=randwrite --ioengine=libaio --iodepth=1 --rw=randwrite --bs=4k --direct=0 --size=512M --numjobs=2 --runtime=240 --group_reporting` 

Câu lệnh này sẽ kiểm tra tốc độ ghi, tên file : `randwrite`, kích cỡ: `512MB`, chạy 4 jobs và 2 process  (tổng cộng 4GB)

![write](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/fio_W_test.png)

Ta thấy bandwidth và IOPS: `write: IOPS=6315, BW=24.7MiB/s (25.9MB/s)(1024MiB/41507msec)`

* Kiểm tra tốc độ đọc: `sudo fio --name=randread --ioengine=libaio --iodepth=16 --rw=randread --bs=4k --direct=0 --size=512M --numjobs=4 --runtime=240 --group_reporting` Đọc file ngẫu nhiên tổng cộng 2GB 

![read](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/fio_R_test.png)

Ta thấy bandwidth và IOPS: `read: IOPS=4173, BW=16.3MiB/s (17.1MB/s)(2048MiB/125615msec)`

* Kiểm tra tốc độ đọc ghi: `sudo fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75` tổng cộng 4 GB

![readwrite](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/fio_RW.png)

Ta thấy bandwidth và IOPS: `read: IOPS=2275, BW=9104KiB/s (9322kB/s)(3070MiB/345321msec)` và ` write: IOPS=760, BW=3042KiB/s (3115kB/s)(1026MiB/345321msec)`

### Monitor disk
Tool: iostat, htop

Cài đặt: `sudo apt-get install sysstat`
* Theo dõi report từ boot: `iostat`
* Theo dõi liên tục mỗi n giây: `iostat "n"` 
* Theo dõi n lần, mỗi lần cách m giây: `iostat m n`


Ví dụ: 
![iostat](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/iostat.png)

Trong đó các thông số: avg-cpu: trung bình các cpu
* 3 giá trị về % CPU
   *    %user: phần trăm CPU được sử dụng khi chạy các ứng dụng ở user level (tất cả những gì không thuộc về kernel)
   *    %system: phần trăm CPU được sử dụng khi chạy ở system level (kernel)
   *   %nice: tương tự %user nhưng với nice priority.

* 3 giá trị về % thời gian 
    * %iowait: phần trăm thời gian mà CPU(s) rảnh  khi hệ thống thực hiện disk I/O request.
    * %idle: phần trăm thời gian mà CPU(s) rảnh và hệ thống không thực hiện disk I/O request.
    * %steal: phần trăm thời gian dành cho chờ đợi của CPU hoặc CPU ảo trong khi bộ ảo hóa đang phục vụ một bộ xử lý ảo khác.
* 6 giá trị về device: 
   * Device: tên device, ở đây là "sda". Một device có 1 hay nhiều partition. (dùng iostat -pd sda để hiển thị thông số cho từng partition trong sda)
   * tps: transfer per second. Mỗi  transfer là một I/O request đến device. Nhiều logical request có thể được hợp lại thành 1 I/O request đến device =>  một transfer không có kích thước cố định.
    * kB_read/s: số kilobytes đọc từ device
   * kB_read: tổng số kilobytes đọc từ device  = kB_read/s * interval (s)
    * k B_wrtn/s: số kilobytes ghi vào device
    * kB_wrtn: tổng số kilobytes ghi  từ device  = kB_read/s * interval (s)

### Kiểm tra tốc độ ghi đọc tuần tự 
Command: dd 
Đọc: `dd if=/dev/zero of=/tmp/laptop.bin bs=1G count=1 oflag=direct` Ghi 1 file 1GB
Ghi: `dd if=/dev/zero of=/tmp/test1.img bs=1G count=1 oflag=dsync` Đọc 1 file 1GB
Kiểm tra latency(thời gian thao tác đến lúc hoàn thành): `dd if=/dev/zero of=/tmp/test2.img bs=512 count=1000 oflag=dsync` ghi 512byte 1000 lần

ví dụ:
![dd](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/dd.png)


### Kiểm tra độ trễ
Tool: ioping

Cài đặt: `sudo apt-get install ioping` 
Câu lệnh: `ioping -c "n"` Trong đó n là số request 

Ví dụ: n = 10 
![ioping](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/ioping.png)

Trong đó 529,5 us = 0,5295 ms

# Đánh giá
IOPS: Càng cao càng tốt
Lantency: Càng thấp càng tốt
Bandwidth: Càng cao càng tốt


