**tar**

Lệnh tar được sử dụng để trích xuất một tập hợp các tệp và thư mục thành tệp lưu trữ được nén cao thường được gọi là tarball hoặc tar, gzip và bzip trong Linux

**1. Create tar Archive File**

`# tar -cvf tecmint-14-09-12.tar /home/tecmint/`

c – Creates a new .tar archive file.

v – Verbosely show the .tar file progress.

f – File name type of the archive file.

**2. Create tar.gz Archive File**

`# tar cvzf MyImages-14-09-12.tar.gz /home/MyImages`

OR
`# tar cvzf MyImages-14-09-12.tgz /home/MyImages`

**3. Create tar.bz2 Archive File**

Tính năng bz2 nén và tạo file nhỏ hơn so với size of the gzip,mất nhiều thời gian để nén và giải nén file hơn gzip

`# tar cvfj Phpfiles-org.tar.bz2 /home/php`

OR

`# tar cvfj Phpfiles-org.tar.tbz /home/php`

OR 

`# tar cvfj Phpfiles-org.tar.tb2 /home/php`

**4. Untar tar Archive File**

 Untar files in Current Directory 

`# tar -xvf public_html-14-09-12.tar`

 Udntar files in specified Directory 
`# tar -xvf public_html-14-09-12.tar -C /home/public_html/videos/`

**5. Uncompress tar.gz Archive File**

`# tar -xvf thumbnails-14-09-12.tar.gz`

**6. Uncompress tar.bz2 Archive File**

`# tar -xvf videos-14-09-12.tar.bz2`

**7. List Content of tar Archive File**

`# tar -tvf uploadprogress.tar`

**8. List Content tar.gz Archive File**

`# tar -tvf staging.tecmint.com.tar.gz`

**9. List Content tar.bz2 Archive File**

`# tar -tvf Phpfiles-org.tar.bz2`

**10. Untar Single file from tar File**

`# tar -xvf cleanfiles.sh.tar cleanfiles.sh`

OR

`# tar --extract --file=cleanfiles.sh.tar cleanfiles.sh`

**11. Untar Single file from tar.gz File**

`# tar -zxvf tecmintbackup.tar.gz tecmintbackup.xml`

OR

`# tar --extract --file=tecmintbackup.tar.gz tecmintbackup.xml`

**12. Untar Single file from tar.bz2 File**

`# tar -jxvf Phpfiles-org.tar.bz2 home/php/index.php`

OR

`# tar --extract --file=Phpfiles-org.tar.bz2 /home/php/index.php`

**13. Untar Multiple files from tar, tar.gz and tar.bz2 File**

`# tar -xvf tecmint-14-09-12.tar "file 1" "file 2"` 

`# tar -zxvf MyImages-14-09-12.tar.gz "file 1" "file 2"`

`# tar -jxvf Phpfiles-org.tar.bz2 "file 1" "file 2"`

**14. Extract Group of Files using Wildcard**

`# tar -xvf Phpfiles-org.tar --wildcards '*.php'`

`# tar -zxvf Phpfiles-org.tar.gz --wildcards '*.php'`

`# tar -jxvf Phpfiles-org.tar.bz2 --wildcards '*.php'`

**15. Add Files or Directories to tar Archive File**

`# tar -rvf tecmint-14-09-12.tar xyz.txt`

`# tar -rvf tecmint-14-09-12.tar php`

**16. Add Files or Directories to tar.gz and tar.bz2 files**

`# tar -rvf MyImages-14-09-12.tar.gz xyz.txt`

`# tar -rvf Phpfiles-org.tar.bz2 xyz.txt`

**17. How To Verify tar, tar.gz and tar.bz2 Archive File**

`# tar tvfW tecmint-14-09-12.tar`

**18. Check the Size of the tar, tar.gz and tar.bz2 Archive File**

`# tar -czf - tecmint-14-09-12.tar | wc -c` 

12820480

`# tar -czf - MyImages-14-09-12.tar.gz | wc -c` 

112640

`# tar -czf - Phpfiles-org.tar.bz2 | wc -c` 

20480

**Tar Usage and Options**

c – create a archive file.

x – extract a archive file.

v – show the progress of archive file.

f – filename of archive file.

t – viewing content of archive file.

j – filter archive through bzip2.

z – filter archive through gzip.

r – append or update files or directories to existing archive file.

W – Verify a archive file.

wildcards – Specify patterns in unix tar command.

**dd**

Lệnh dd là viết tắt của trình sao chép dữ liệu và được sử dụng để sao chép và chuyển đổi dữ liệu. Nó là tiện ích cấp thấp rất mạnh của Linux,và có nhiều chức năng khác như:

• Sao lưu và khôi phục toàn bộ đĩa cứng hoặc phân vùng.

• Sao lưu MBR (Bản ghi khởi động chính)

• Nó có thể sao chép và chuyển đổi định dạng băng từ, chuyển đổi giữa các định dạng ASCII và EBCDIC, hoán đổi byte và cũng có thể chuyển đổi chữ thường thành chữ hoa.

• Nó cũng có thể được sử dụng bởi nhân Linux tạo các tệp để tạo ảnh khởi động.

chỉ có superuser mới có thể chạy lệnh này vì bạn có thể phải đối mặt với việc mất dữ liệu lớn do sử dụng không đúng cách, vì vậy bạn nên **rất cẩn thận khi làm việc với tiện ích này**.

Syntax: `dd if=<source file name> of=<target file name> [Options]`

if = <source> - Đây là nguồn từ nơi bạn muốn sao chép dữ liệu và nếu là viết tắt của tệp đầu vào.

of = <Destination> - Đây là nguồn từ nơi bạn muốn ghi / dán dữ liệu và viết tắt của tệp đầu ra.

[tùy chọn] - Các tùy chọn này bao gồm, dữ liệu nên được viết nhanh như thế nào, định dạng nào, v.v.]

###### b. Các tùy chọn
|Tùy chọn | Ý nghĩa |
|---------|---------|
|bs=Bytes |Quá trình đọc (ghi) bao nhiêu byte một lần đọc (ghi) |
|cbs=Bytes|Chuyển đổi bao nhiêu byte một lần |
|count=Blocks | thực hiện bao nhiêu Block trong quá trình thực thi câu lệnh |
|if | Chỉ đường dẫn đọc đầu vào |
|of | Chỉ đường dẫn ghi đầu ra|
|ibs=bytes | Chỉ ra số byte một lần đọc |
|obs=bytes | Chỉ ra số byte một lần ghi |
|skip=blocks | Bỏ qua bao nhiêu block đầu vào |
|conv=Convs | Chỉ ra tác vụ cụ thể của câu lệnh, các tùy chọn được ghi dưới bảng sau đây |

**Các tùy chọn của conv**

|Tùy chọn | Tác dụng  |
|-----------|----------|
|ascii | Chuyển đôi từ mã EBCDIC sáng ASCII |
|ebcdic | Chuyển đổi từ mã ASCII sang EBCDIC |
|lcase | Chuyển đổi từ chữ thường lên hết thành chữ in hoa |
|ucase | Chuyển đổi từ chữ in hoa sang chữ thường |
|nocreat | Không tạo ra file đầu ra |
|noerror | Tiếp tục sao chép dữ liệu khi đầu vào bị lỗi |
|sync | Đồng bộ dữ liệu với ổ đang sao chép sang |


*Lưu ý:* Khi bạn định dạng số lượng byte mỗi lần đọc. Mặc định nó được tính theo đơn vị là kb. Bạn có thể thêm một số trường sau để báo định dạng khác:

- c = 1 byte
- w = 2 byte
- b = 512 byte
- kB = 1000 byte 
- K = 1024 byte 
- MB = 1000000 byte
- M = (1024 * 1024) byte
- GB = (1000 * 1000 * 1000) byte
- G = (1024 * 1024 * 1024) byte

**1.  Clone one hard disk to another hard disk**

`dd if=/dev/sda of=/dev/sdb`

**2. take backup of a partition/complete HDD for future restoration**

Sao lưu phân vùng vào một tệp (vào thư mục chính là hdadisk.img)

`dd if =/dev/sda2 of=~/hdadisk.img`

**3. Khôi phục tập tin hình ảnh này vào máy khác**

`dd if=hdadisk.img of=/dev/sdb3`

**4. Do you feel hdadisk.img is bit big? Use gzip or bzip2 to compress when creating image**

`dd if =/dev/sda2 | bzip2 hdadisk.img.bz2`

**5. sử dụng lệnh dd để sao chép tệp từ vị trí này sang vị trí khác.**

`dd if=/home/imran/abc.txt of=/mnt/abc.txt`

**6. wipe/delete nội dung của đĩa để nó sẽ trống đối với một số người sử dụng nó.**

`dd if=/dev/zero of=/dev/sdb`

#### 7. Các ví dụ trong hay được sử dụng trong thực tế:
###### a. Sao lưu - phục hồi toàn bộ ổ cứng hoặc phân vùng trong ổ cứng
- Sao lưu toàn bộ dữ liệu ổ cứng sao ổ cứng khác:
```
#dd if=/dev/sda of=/dev/sdb conv=noerror,sync
```
Câu lệnh này dùng dể sao lưu toàn bộ dữ liệu của ổ sda sang ổ sdb với tùy chọn trong trường conv=noerrom.sync với ý ngĩa vẫn tiếp tục sao lưu nếu dữ liệu đầu vào bị lỗi và tự động đồng bộ với dữ liệu sdb

- Tạo một file image cho ổ sda1. Các này sẽ nhanh hơn là viêc chuyển dữ liệu sao ổ khác
```
dd if=/dev/sda1 of=/root/sda1.img 
```
- Nếu muốn nén ảnh file anh vào bạn có thể sử dụng command sau
```
dd if=/dev/sda1 | grip > /root/sda1.img.gz
```
-Sao lưu dữ liệu từ một phân vùng này đến một phân vùng khác
```
dd if=/dev/sda2 of=/dev/sdb2 bs=512 conv=noerror,sync
```
*Đối với câu lệnh này bs=512 có ý nghĩa mỗi lần đọc ghi nó đọc và ghi 512 byte*
- Phục hồi dữ liệu 
```
dd if=/root/sda1.img of=/dev/sda1
```
- Sao lưu từ đĩa CDroom
```
dd if=/dev/cdrom of=/root/cdrom.img conv=noerror
```

###### b.Sao lưu phục hồi MBR
Việc sao lưu lại mbr là việc làm cần thiết đối với hệ thống linux. nó đề phòng cho việc khi virut có thể nhảy được hẳn vào vùng MBR. Lúc bày bất kì một phần mềm diệt virut nào cũng không diệt được con virut này. Cách hay nhất là cài đặt lại mbr và lúc đó việc sao chép MBR lúc trước khi nhiễm sẽ phát huy tác dụng:
- Sao chép MBR
```
dd if=/dev/sda1 of=/root/mbr.txt bs=512 count=1
```
- Phục hồi lại MBR
```
dd if=/root/mbr.txt of=/dev/sda1
```
###### c. Chuyển đổi chữ thường thành chữ in hoa
- Chuyển chữ thường thành chữ in hoa
```
dd if=/root/test.doc of=/root/test1.doc conv=ucase
```
<img class="image__pic js-image-pic" src="http://i.imgur.com/ihXZb4z.png" alt="" id="screenshot-image">

- Chuyển chứ hoa thành chứ thường
```
dd if=/root/test1.doc of=/test2.doc conv=scase,sycn
```
###### d. Tạo một file có dung lượng cố định 
Tạo ra một file có kích thước 100M
```
dd if=/dev/zero of=/root/file1 bs=100M count=1
```

#### 8. Các tình huống áp dụng trong thực tế

Các ví dụ tôi vừa nêu trên đều sử dụng rất nhiều trong thực tế. Ngoài ra còn kết hợp với một số câu lệnh để làm thêm tác vụ khác như:

- VD1: Kết hợp với câu lệnh mkswap để tạo phân vùng swap cho máy 
    - Sử dụng câu lênh dd để tạo một phân vùng trống có kích cỡ 1G:
```
dd if=/dev/zero of=/root/swap bs=1024M count=1
```

<img class="image__pic js-image-pic" src="http://i.imgur.com/ULIQkPh.png" alt="" id="screenshot-image">

  - Gán quyền cho nó chỉ root mới vào xem được
```
chmod 600 /root/swap
```
<img class="image__pic js-image-pic" src="http://i.imgur.com/nllxHrl.png" alt="" id="screenshot-image">

- Chỉ cho đến vùng swap
```
mkswap /root/swap
```
```
swapon /root/swap 
```
<img class="image__pic js-image-pic" src="http://i.imgur.com/f6taOEY.png" alt="" id="screenshot-image">

Oki nào bây giờ kiểm tra lại xem thành công chưa. Sử dụng lệnh
```
swapon -s
```
<img class="image__pic js-image-pic" src="http://i.imgur.com/Rw4Zg2o.png" alt="" id="screenshot-image">
 
 Lúc này tổng dung lượng phân vùng swap sẽ là 2G ( do trước đó tôi cài đặt cho phân vùng swap là 1G trước rồi )
 
 <img class="image__pic js-image-pic" src="http://i.imgur.com/Wb2mdPV.png" alt="" id="screenshot-image">
 
 Nếu bạn muốn tạo vùng swap không bị mất khi reboot lại máy. Bạn vào file này rồi chỉnh sửa như sau:
 ```
 vi /etc/fstab
 rồi chỉnh sửa:
 /root/swap                 swap                    swap                defaults        0  0
 ```
 
 VD2: Ngoài ra bạn còn có thể kết hợp với câu lênh crontab để có thể lâp lịch sao chép dữ liêu ổ cứng của bạn theo định kì
Đầu tiên vào một file sh để chạy
```
vi dd_command.sh
với nội dung là:
dd if=/dev/sda1 of=/dev/sdb1 conv=noerror,sync
```
Tạo một crotab cho file chạy

```
crontab 0 10 * * * sh dd_command.sh
```
Lúc này đến 10h hàng ngày quá trình sao chép dữ liệu giữa ổ sda1 sang ổ sdb1 được thực hiện
