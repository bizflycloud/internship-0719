**cron**

Cron là một tiện ích cho phép thực hiện các tác vụ một cách tự động theo định kỳ, ở chế độ nền của hệ thống. Crontab (CRON TABLE) là một file chứa đựng bảng biểu (schedule) của các entries được chạy.

Một cron schedule đơn giản là một text file. Mỗi người dùng có một cron schedule riêng, file này thường nằm ở /var/spool/cron. Crontab files không cho phép bạn tạo hoặc chỉnh sửa trực tiếp với bất kỳ trình text editor nào, trừ phi bạn dùng lệnh crontab.

Một số lệnh thường dùng:

crontab -e: tạo hoặc chỉnh sửa file crontab 

crontab -l: hiển thị file crontab 

crontab -r: xóa file crontab

Hầu hết tất cả VPS đều được cài đặt sẵn crontab, tuy nhiên vẫn có trường hợp VPS không có. Nếu bạn sử dụng lệnh crontab -l mà thấy output trả lại -bash: crontab: command not found thì cần tự cài crontab thủ công.

**1. Cấu trúc của crontab**

Một crontab file có 5 trường xác định thời gian, cuối cùng là lệnh sẽ được chạy định kỳ, cấu trúc như sau


` *     *     *     *     *`

  -     -     -     -     -

  |     |     |     |     |

  |     |     |     |     +----- day of week (0 - 6) (Sunday=0)

  |     |     |     +------- month (1 - 12)

  |     |     +--------- day of month (1 - 31)

  |     +----------- hour (0 - 23)

  +------------- min (0 - 59)
 
 Ví dụ:

– Chạy script 30 phút 1 lần:

`0,30 * * * * command`

– Chạy script 15 phút 1 lần:

`0,15,30,45 * * * * command`

– Chạy script vào 3 giờ sáng mỗi ngày:

`0 3 * * * command`

**2. Ví dụ cụ thể**
Giả sử mình viết một đoạn script sao lưu toàn bộ thư mục /home/domain.com/public_html/ và chuyển file nén .zip vào thư mục /root/ như sau:

#!/bin/bash

zip -r /root/backup_domain.com_$(date +"%Y-%m-%d").zip /home/domain.com/public_html/ -q
Script này lưu lại ở đường dẫn /etc/backup.sh (gán quyền execute – chmod +x nếu là bash script).

Sau đó cho script này chạy định kỳ vào 15h thứ Hai và thứ Năm hàng tuần bằng cách tạo một file crontab như sau:

`crontab -e`

Nhấn o (chữ o) để thêm dòng mới với nội dung:

`0 15 * * 1,4 sh /etc/backup.sh`

Để lưu lại và thoát nhấn ESC, rồi gõ vào :wq nhấn Enter.

Cuối cùng, khởi động lại cron daemon:

`/etc/init.d/crond restart`

Nếu muốn dùng Editor nano sửa cho dễ thì dùng lệnh sau: EDITOR=nano crontab -e

Ví dụ khác

– Để crontab chạy mỗi phút một lần:

`* * * * * sh /etc/backup.sh`

– Để crontab chạy 24h một lần (vào nửa đêm):

`0 0 * * * sh /etc/backup.sh`

– Để crontab chạy file PHP 24h một lần:

`0 0 * * * /usr/bin/php /var/www/html/reset.php`

**3. Disable email**

Mặc định cron gửi email cho người thực thi cron job, nếu bạn muốn tắt chức năng gửi email này đi thì hãy thêm đoạn sau vào cuối dòng

>/dev/null 2>&1

Ví dụ:

`0 15 * * 1,4 sh /etc/backup.sh >/dev/null 2>&1`

**4. Tạo log file**

Để lưu log vào file:

`30 18 * * * rm /home/someuser/tmp/* > /home/someuser/cronlogs/clean_tmp_dir.log`

**at**



**1. Kích hoạt tính năng tự động khởi động của daemon at**

Một số bản phân phối sẽ tự động kích hoạt tính năng khởi động của daemon at khi boot. Nhưng một số bản phân phối khác thì không. Hãy kiểm tra với:

`systemctl is-enabled atd.service`

Kích hoạt tính năng tự động khởi động

Nếu kết quả là “disabled”, thì hãy kích hoạt nó với:

`sudo systemctl enable atd.service`

Và bắt đầu daemon:

`sudo systemctl start atd.service`

**Cách chỉ định ngày và thời gian để lên lịch cho các lệnh at
Người dùng có thể sử dụng một trong các hình thức sau đây.**

**2. Chạy lệnh sau số phút, giờ, ngày hoặc tuần được chỉ định.**

1. Chạy lệnh sau số phút, giờ, ngày hoặc tuần được chỉ định.

`at now + 10 minutes`
 
`at now + 10 hours`

`at now + 10 days`
 
`at now + 10 weeks`

2. Chạy vào một thời điểm chính xác:

`at 23:10`

Nếu bây giờ là 12:00, và chạy lệnh:

`at 11:00`

Thì lệnh sẽ chạy vào ngày mai, tại thời điểm được chỉ định.

3. Chạy vào thời gian và ngày được chỉ định chính xác:

`at 12:00 December 31`

**Xem và/hoặc xóa các công việc theo lịch trình**

Người dùng có thể xem các công việc được xếp theo thứ tự với lệnh:

`atq`

Hoặc lệnh:

`at -l`

Xem các công việc được lên lịch

Để xem những lệnh nào được lên lịch trong một công việc, hãy sử dụng số tiền tố của công việc đó.

`at -c 22`

Sử dụng tiền tố

Các dòng đầu ra cuối cùng sẽ hiển thị cho người dùng các lệnh đã lên lịch.

Để xóa một công việc, sử dụng số tiền tố của nó như sau:

`atrm 22`

`at -d`

**Thực hiện chương trình lệnh trong 1 file list**

`at -f /root/chuongtrinh.txt now + 1 hour`

**Kiểm soát user nào mới được quyền sử dụng at**

`/etc/at.allow`

nếu `/etc/at.allow` có tồn tại thì chỉ user được liệt kê mới có quyền sử dụng at

còn `/etc/at.allow` k tồn tại thì chương trình sẽ kiểm tra /etc/at.deny nếu file này tồn tại thì những user được liệt kê trong này sẽ không được quyền thực thi chương trình at

**Các file thư mục được sử dụng bởi at**

/var/spool/at

/var/spool/at/spool

/proc/loadavg

/var/run/utmp

/etc/at.allow

/etc/at.deny
