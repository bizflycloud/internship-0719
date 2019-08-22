# System Log

 Syslog is an software package in Linux system used to record "log" of the system like in kernel, deamon, cron, auth, http, dns, dhcp, ntp,..

**_Log usage_**
- Analyze the root of an event
- Provide faster solution when the system meets problem
- Discover and predict an event's gonna happen to the system
- ...

**_syslogd syntax_**

> `syslogd + option`

Options:

1. `-f` Specify an alternative configuration file instead of /etc/syslog.conf, which is the default.
2. `-h` By default, syslogd will not forward messages it receives from remote hosts. Specifying this switch on the command line will cause the log daemon to forward any remote messages it receives to forwarding hosts which have been defined.
3. `-l` Specify a hostname that should be logged only with its simple hostname and not the fqdn. Multiple hosts may be specified using the colon (``:'') separator.
4. `-m` (interval) The syslogd logs a mark timestamp regularly. The default interval between two -- MARK --lines is 20 minutes. This can be changed with this option and, setting the interval to zero turns it off entirely.
5. `-r` Used to allow receipt of network messages.

Syslog configuration file stored in `/etc/rsyslog.conf`

- syslog file has 2 parts:
  - part 1: Seletor
    - Log Sources
  
    |Sources| Meaning |
    |--------------|---------|
    |kernel | Logs created by kernel |
    |auth or authpriv | Logs created by accounts authentication |
    |mail | Mail logs |
    |cron | Logs created by cron process |
    |user | Logs created from user applications |
    |lpr | Logs from printing |
    |deamon | Logs created by background process |
    |ftp | Logs created by ftp | 
    |local 0 -> local 7 | Log generate in local |

    - Level of Alert

    | Alert Levels | Meaning |
    |--------------|---------|
    |emerg | Emergency |
    |alert | Needs interfere right about time |
    |crit | Critical situation |
    |error | Errors Notifications |
    |warn | Warning level |
    |notice | Noticable to System |
    |info | Info of the System |
    |debug | Debugging of the System |
    
  - part 2: Action shows the directory of where logs are saved
  
# Rotating Log

- Quản lý chu kỳ lặp của log, tạo log mới, nén log cũ, ...
 
- Cấu hình Logrotate được lưu tại `/etc/logrotate.conf`, chứa thông tin thiết lập toàn bộ log files mà Logrotate quản lý, bao gồm chu kì lặp, dung lượng file log, nén file…

- Thông tin cấu hình log file của từng ứng dụng cụ thể được lưu tại `/etc/logrotate.d/`

- Để chỉ định cụ thể một hay nhiều file log với đường dẫn tuyệt đối của file log đó, phân biệt danh sách các log file cụ thể bằng khoảng trắng. ex: `/home/*/logs/access.log /home/*/logs/error.log /home/*/logs/nginx_error.log`

1. Time Rotate
    
    1.1. Daily    
    1.2. Weekly  
    1.3. Monthly  
    1.4. Yearly

2. Size rotate (K, M, G)

    2.1. size ...k 
    2.2. size ...M    
    2.3. size ...G
    
3. Action with Empty log

    3.1. missingok: nếu file log bị mất hoặc không tồn tại `*.log` thì logrotate sẽ tự động di chuyển tới phần cấu hình log của file log khác mà không cần phải xuất ra thông báo lỗi. Ngược lại sẽ là cấu hình nomissingok  
    3.2. Tham số Notifempty: không rotate log nếu file log này trống.
    
4. Rotate with numbers of log files

  Quy định số lượng log file cũ đã được giữ lại sau khi rotate. Nếu đã đủ sẽ xóa file log cũ nhất đi dành chỗ cho log mới

  Syntax: `rotate [number]`

5. Log compress

    5.1. Tùy chọn Compress: Logrotate sẽ nén tất cả các file log lại sau khi đã được rotate, mặc định bằng gzip. Nếu muốn sử dụng chương trình nén khác như bzip2, xz hoặc zip thì phải đặt tên chương trình đó thành biến sau giá trị cấu hình Compresscmd xz
    
    5.2. Tham số Delaycompress sẽ hữu dụng trong trường hợp không muốn file log cũ phải nén ngay sau khi vừa được rotate. Thay vào đó, công việc nén sẽ được delay bằng việc sẽ nén file log cũ đó vào lần chạy rotate kế tiếp. 
    
    5.3. Tùy chọn nocompress không sử dụng tính năng nén đối với file log cũ
  
6. Log file permission

    6.1. Create a new log file with the same name over ride the older one. Syntax: `create 660 owner group`
    
    6.2. To set the "no" option to auto-generate log file, type`nocreate`
    
    6.3. To set datetime to be prefix of logfile names, type `Dateext`
    
7. Execute commands before and after logrotate:
    7.1. `prerotate` [command] `endscript`
    7.2. `postrotate` [command] `endscript`
   
    > Tùy chọn `sharedscripts` Script postrotate sẽ được chạy sau khi toàn bộ các file logs được rotate. Nếu không có tùy chọn này, postrotate script sẽ được chạy sau mỗi log file được rotate.

8. Debugging Logrotate

    Nếu muốn kiểm tra cấu hình chuẩn chưa, sử dụng tham số `-d` (debug) đối với các file cấu hình LogRotate riêng biệt.

9. Mannually run Logrotate
   
   syntax_ex: `logrotate -vf /etc/logrotate.d/nginx`
   
   - `-v` verbose hiển thị thêm thông tin so với thông thường, có ích khi bạn muốn dò lỗi logrotate
   - `-f` bắt buộc rotate ngay lập tức
    
