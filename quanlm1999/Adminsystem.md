# Administering the System

#### Managing Users and Groups
Add thêm user mới ta dùng lệnh: 
*  **adduser [new_account]**
*  **useradd [new_account]**

Khi user được đưa vào hệ thống, điều tiếp theo xảy ra: 
1. thư mục home của user được tạo (/home/username mặc định .
2. Những file ẩn đưọc copy vào thư mục home của người dùng, cung cấp biến môi trường trong phiên làm việc của người đó 
 .bash_logout
.bash_profile
.bashrc
3. Mail spool được tạo ở  /var/spool/mail/username.
4. Một nhóm được tạo có tên trùng với tên của user 

Thông tin đầy đủ của người dùng được lưu trữ ở file:  /etc/passwd. Có cấu trúc như sau :
**[username]:[x]:[UID]:[GID]:[Comment]:[Home directory]:[Default shell]**
trong đó: 
* Fields [username] and [Comment] are self explanatory.

 *   The x in the second field indicates that the account is protected by a shadowed password (in /etc/shadow), which is needed to logon as [username].

*    The [UID] and [GID] fields are integers that represent the User IDentification and the primary Group IDentification to which [username] belongs, respectively.
    
*    The [Home directory] indicates the absolute path to [username]’s home directory
    
*    The [Default shell] is the shell that will be made available to this user when he or she logins the system.

Thông tin của nhóm được lưu ở : /etc/group có cấu trúc như sau :
**[Group name]:[Group password]:[GID]:[Group members]**
trong đó: 
*   [Group name] is the name of group.
*    An x in [Group password] indicates group passwords are not being used.
*    [GID]: same as in /etc/passwd.
*    [Group members]: a comma separated list of users who are members of [Group name].

Sau khi thêm người dùng, có thể dùng lệnh **usermod** để thay đổi những thông tin của người  dùng đó
**usermod [options] [username]**
vd: 
Use the –expiredate flag followed by a date in YYYY-MM-DD format.
**usermod --expiredate 2014-10-30 tecmint**

Adding the user to supplementary groups
Use the combined -aG, or –append –groups options, followed by a comma separated list of groups.
**usermod --append --groups root,users tecmint**

Changing the default location of the user’s home directory
Use the -d, or –home options, followed by the absolute path to the new home directory.
**usermod --home /tmp tecmint**

Changing the shell the user will use by default
Use –shell, followed by the path to the new shell.
**usermod --shell /bin/sh tecmint**

Disabling account by locking password
Use the -L (uppercase L) or the –lock option to lock a user’s password.
**usermod --lock tecmint**

Unlocking user password
Use the –u or the –unlock option to unlock a user’s password that was previously blocked.
**usermod --unlock tecmint**

Deleting a group
You can delete a group with the following command.
**groupdel [group_name]**
#### Using System Log Files: syslogd, rotating log files

**Syslog** là một gói phần mềm trong hệ thống linux nhằm để ghi lại log của hệ thống trong quá trình hoạt động như kernel, deamon, cron, auth hoặc các ứng dụng chạy trên hệ thống như dhcp, dns,http,ntp
**Ứng dụng** 
* Phân tích nguyên nhân gốc dễ cảu một vấn đề.
* Đưa ra giải pháp nhanh hơn cho vấn đề trong  hệ thống
* Khám và và dự đoán 1 vấn đề có thể xảy ra với hệ thống 

**4 khái niệm cơ bản** 
- **Facility**: Facility giúp kiểm soát các log đến dựa vào các nguồn gốc đc quy định như ứng dụng hay tiến trình nào. Syslog sử dung facility để quy hoạch lại log như vậy có thể coi các fácility là đại diện đối tượng tạo ra thông báo(kernel, process, app..)
- **Priority (level)** :mức độ quan trong của log message đc chỉ định
- **Selector**: sự kết hợp giữa facility và level
- **Action**: đại diện cho địa chỉ messages tương úng với facility.level.Action có thể là một tên file hoặc có thể là một host name đứng trc kí tự @

**Trong facility** có cácloại facility đc sử dụng và quy định trong hệ thống Linux

|  Facility  |	Miêu tả |
|------------|----------|
| auth  |  Các hoạt động liên quan đến yêu cầu tên và mật khẩu (getty, su, login)|
|  authpriv |	Tương tự như auth nhưng ghi log tới một file mà chỉ có thể được đọc bởi những người dùng được chọn.|
| console | Sử dụng để bắt các thông báo mà thường trực tiếp gửi tới bàn điều khiển hệ thống.|
| cron  |  Các thông báo từ người lập hệ thống cron.|
| daemon |	Hệ thống daemon nhận tất cả.|
| ftp | Các thông báo liên quan đến hệ thống ftp deamon.|
| kern |	Các thông báo kernel.|
| local0.local7 | 	Các phương tiện nội bộ được xác định cho mỗi site. |
| lpr | 	Các thông báo từ dòng hệ thống in. |
| mail |	Các thông báo liên quan tới hệ thống mail. |
| mark |	Các sự kiện giả được sử dụng để tạo timestamp trong các file hệ thống. |
| news |	Các thông báo liên quan tới mạng lưới giao thức tin tức (network news protocol) |
| ntp |	Các thông báo liên quan đến giao thức thời gian mạng. |
| user |	Các tiến trình người dùng thông thường. |
| uucp |	Hệ thống phụ UUCP.|
- Theo măc định các bản tin log của hệ thống được syslog lưu vào trong thư mục /var/log, và được lưu riêng rẽ đối với từng tác vụ trong hệ thông nhưng đối với tiến trình cron thì sẽ lưu trong file cron.log.
-file câu hình của linux đc lưu trong bản ghi có đường dẫn là : **/etc/rsyslog.conf**,  nhưng các rule được định nghĩa riêng trong **/etc/rsyslog.d/50-defaul.conf** . File rule này được khai báo include từ file cấu hình **/etc/rsyslog.conf**

**Syslog priority**

| Priority | Miêu tả |
| -------- | ------- |
| debug | Các message ở chế độ debug |
| info | Các message mang thông tin |
| notice | message mang tính chất thông báo |
| warning | Các mesage mang tính chất cảnh cáo |
| ere | cá message lỗi |
| crit | các message nguy hiểm |
| alert | các mesage về các hành động phải thực hiện ngay |
| emerg | message khi hệ thống không dùng đc nữa |

#### Rotating log files
* Logrotate là công cụ chương trình hỗ trợ cho việc quản lý các file log trong hệ thông
* Rotate là tạo tiến trình tạo ra 1 file log mới, còn file log cũ sẽ được xử lý theo các quy định được cấu hình như xóa/nén/lưu trữ vào đâu đó
* File log là 1 file text nơi mà 1 chương trình sẽ output ra thông tin cần thiết để cho quản trị vieenc biết điều gì đã và đang xảy ra với chương trình/ hệ thống đó 
* Logrotate đơn thuần là một chương trình hoạt động theo xếp lịch crontab chứ không phải 1 dịch vụ


* Cấu hình Logrotate được lưu tại **/etc/logrotate.conf**, chứa thông tin thiết lập toàn bộ log files mà Logrotate quản lý, bao gồm chu kì lặp, dung lượng file log, nén file…

* Thông tin cấu hình log file của từng ứng dụng cụ thể được lưu tại **/etc/logrotate.d/**

* Để chỉ định cụ thể một hay nhiều file log với đường dẫn tuyệt đối của file log đó, phân biệt danh sách các log file cụ thể bằng khoảng trắng. ex: `/home/*/logs/access.log /home/*/logs/error.log /home/*/logs/nginx_error.log`
##### Logrotate.conf
* Time Rotate
    * Daily    
    * Weekly  
    * Monthly  
    * Annually/Yearly

* Size rotate (K, M, G)
    * size ...k 
    * size ...M    
    * size ...G
    
* Action with Empty log
    * missingok: nếu file log bị mất hoặc không tồn tại `*.log` thì logrotate sẽ tự động di chuyển tới phần cấu hình log của file log khác mà không cần phải xuất ra thông báo lỗi. Ngược lại sẽ là cấu hình nomissingok  
    * Tham số Notifempty: không rotate log nếu file log này trống.
    
* Rotate with numbers of log files

  Quy định số lượng log file cũ đã được giữ lại sau khi rotate. Nếu đã đủ sẽ xóa file log cũ nhất đi dành chỗ cho log mới

  Syntax: `rotate [number]`

* Log compress

    * Tùy chọn Compress: Logrotate sẽ nén tất cả các file log lại sau khi đã được rotate, mặc định bằng gzip. Nếu muốn sử dụng chương trình nén khác như bzip2, xz hoặc zip thì phải đặt tên chương trình đó thành biến sau giá trị cấu hình Compresscmd xz
    
    * Tham số Delaycompress sẽ hữu dụng trong trường hợp không muốn file log cũ phải nén ngay sau khi vừa được rotate. Thay vào đó, công việc nén sẽ được delay bằng việc sẽ nén file log cũ đó vào lần chạy rotate kế tiếp. 
    
    * Tùy chọn nocompress không sử dụng tính năng nén đối với file log cũ
  
* Log file permission

    * Tạo file log mới cùng tên chèn lên file cũ. Cú pháp `create 660 owner group`
    * Bỏ tùy chọn tự động tạo file. `nocreate`
    * Đặt cho ngày tháng tự động lên đầu `Dateext`
    
* Thực thi lệnh trước và sau logrotate
    * `prerotate` [command] `endscript`
    * `postrotate` [command] `endscript`
   
    > Tùy chọn `sharedscripts` Script postrotate sẽ được chạy sau khi toàn bộ các file logs được rotate. Nếu không có tùy chọn này, postrotate script sẽ được chạy sau mỗi log file được rotate.

* Debugging Logrotate

    Nếu muốn kiểm tra cấu hình chuẩn chưa, sử dụng tham số `-d` (debug) đối với các file cấu hình LogRotate riêng biệt.

* Mannually run Logrotate
   
   syntax_ex: `logrotate -vf /etc/logrotate.d/nginx`
   
   - `-v` verbose hiển thị thêm thông tin so với thông thường, có ích khi bạn muốn dò lỗi logrotate
   - `-f` bắt buộc rotate ngay lập tức
    
#### Running Job in the Future: ‘cron’, ‘at’

**Cron** 
Có nhiều công việc trên linux phải lập lich một cách thường xuyên, định kì. Nên dùng cron để sắp xếp.

Cron có cron daemon, nó chạy ngầm và một khi nó được khởi động lên

Cron đọc các lịch công việc từ /etc/crontab và trong file /var/spoon/cron

**Crontab file**
* Crontab files không cho phép tạo hoặc chỉnh sửa trực tiếp với bất kỳ trình text editor nào, trừ phi bạn dùng lệnh crontab.
    * Một số lệnh thường dùng:
        * crontable -e: Tạo hoặc chỉnh sửa file crontab
        * crontable -l: Hiển thị file crontab
        * crontab -r: xóa file crontab
        
* crontab file: Mỗi người dùng có thể tạo crontab file của họ để đặt lịch công việc theo thời gian nhất định
    * Thời gian này gồm 5 trường theo thứ tự: phút, giờ, ngày trong tháng, tháng, ngày trong tuần (Nếu như đặt dâu * thì có nghĩa là tất cả trong trường đó)
    * Cú pháp: minutes hours dom month dow [command]
        * VD: 8 14 * * * [command] 
            Chạy lệnh mỗi 8 phút sau 2h chieuf, tất cả ngày trong tháng, tất cả các tháng, tất cả các ngày trong tuần.
* cron.allow and cron.deny
    * Nếu như tồn tại file cron.allow , tên bạn phải ở trong đó mới dùng được
    * Nếu như có file cron.deny, tên bạn ở trong đó sẽ không dùng được 


#### at

at để tạo công việc trong tương lai 1 lần

* Tạo ra "at" để hẹn trước công việc
Cú pháp: at -f [filename] [time] (+) [time]

**atq** 
   * Để kiểm tra công việc đã hẹn, dùng lệnh atq hoặc at -l
   * at có thể hiểu 1 số từ tiếng Anh như , tommorrow, teatime, ....
  
**atrm** 
   * Để bỏ công việc đã hẹn trong hàng chờ dùng atrm
   
**at.allow and at.deny**
  * Tương tự như cron.allow cron.deny 

#### Backup System: ‘rsnapshot’, ‘tar’, ‘dd’, ‘rsync’
**Rsnapshot** là một tiện ích backup. Về cơ bản, rsnapshot sẽ tạo ra 1 fille backup và các bản backup tiếp theo sẽ chỉ backup những file đã bị thay đổi.
Độ ưu việt của rsnapshot là khả năng sử dụng hards-links giữa các backup 
    * apt install rsnapshot
**Config** 
Mở tập tin /etc/rsnapshot.conf bằng trình soạn thảo văn bản  nhìn vào phần đầu của snapshot_root – đây là nơi rsnapshot lưu trữ các bản sao hệ thống. Theo mặc định chúng nằm trong thư mục root, nhưng có thể thay đổi thành /backup/snapshots/.

Bo chú thích cho dòng no_create_root 1, điều này sẽ dừng việc tạo thư mục snapshot_root .Lợi ích là trong trường hợp bạn sao lưu vào ổ USB mà quên rằng phải kết nối nó, rsnapshot sẽ không tiến hành sao lưu để trách gây tai nạn cho máy chủ (nếu không có phân vùng chính xác).

Bỏ dòng cmd_cp nếu sử dụng linux 

Bỏ  chú thích cmd_ssh và cung cấp cho nó đường dẫn chính xác tới ssh binary.

Chính sử file "rsnapshot.conf" để tạo bản backup tùy chỉnh theo ý mình

Kiểm tra cú pháp đúng hay sai dùng cú pháp rsnapshot configtest 

**Rsync** 
* Tính năng nổi bật của Rsync
    * Rsync hỗ trợ copy giữ nguyên thông số của files/folder như Symbolic links, Permissions, TimeStamp, Owner và Group.
   * Rsync nhanh hơn scp vì Rsync sử dụng giao thức remote-update, chỉ transfer những dữ liệu thay đổi
   * Rsync tiết kiệm băng thông do sử dụng phương pháp nén và giải nén khi transfer.
   * Rsync không yêu cầu quyền super-user.
* Cài đặt Rsync
    – Trên Red Hat/CentOS
    `yum install rsync`
– Trên Debian/Ubuntu
`apt-get install rsysnc`

* Sử dụng Rsync
    * Cú pháp: `rsync options source destination`

    * Các tham số cần biết khi dùng Rsync
    `-v:` hiển thị trạng thái kết quả
    -r: copy dữ liệu recursively, nhưng không đảm bảo thông số của file và thư mục
  `  -a:` cho phép copy dữ liệu recursively, đồng thời giữ nguyên được tất cả các thông số của thư mục và file
   ` -z`: nén dữ liệu khi transfer, tiết kiệm băng thông tuy nhiên tốn thêm một chút thời gian
   ` -h`: human-readable, output kết quả dễ đọc
    `--delete`: xóa dữ liệu ở destination nếu source không tồn tại dữ liệu đó.
    `--exclude`: loại trừ ra những dữ liệu không muốn truyền đi, nếu bạn cần loại ra nhiều file hoặc folder ở nhiều đường dẫn khác nhau thì mỗi cái bạn phải thêm --exclude tương ứng.
    `--progress` dể hiển thị tiến độ transfer dữ liệu, bạn có thể sử dụng tùy chọn 
    `--max-size` để giới hạn những file lớn được đồng bộ, bạn có thể sử dụng option 
    `--remove-source-files` để rsync tự động xóa dữ liệu sau khi đồng bộ lên server đích thành công.
    `--dry-run`` để rsync chỉ show output, không thay đổi dữ liệu. Dùng để kiểm tra ccaau lệnh có chính xác hay không .
    `--bwlimit=` để giới hạn bandwidth
    
Khi lần đầu chạy rsync, toàn bộ dữ liệu nguồn sẽ được copy đến server đích, từ lần chạy sau trở đi chỉ những dữ liệu chưa được copy mới được transfer – đây là quá trình đồng bộ dữ liệu. 

**Tar**
Tar giúp đóng gói các files/thư mục vào trong 1 file, giúp ích rất nhiều cho việc sao lưu dữ liệu. Thông thường, Tar file có đuôi *.tar.
* Tùy chọn: 
   * c: Tạo file lưu trữ.
    x: Giải nén file lưu trữ.
    z: Nén với gzip – Luôn có khi làm việc với tập tin gzip (.gz).
    j: Nén với bunzip2 – Luôn có khi làm việc với tập tin bunzip2 (.bz2).
    lzma: Nén với lzma – Luôn có khi làm việc với tập tin LZMA (.lzma).
    f: Chỉ đến file lưu trữ sẽ tạo – Luôn có khi làm việc với file lưu trữ.
    v: Hiển thị những tập tin đang làm việc lên màn hình.
    r: Thêm tập tin vào file đã lưu trữ.
    u: Cập nhật file đã có trong file lưu trữ.
    t: Liệt kê những file đang có trong file lưu trữ.
    delete: Xóa file đã có trong file lưu trữ.
    totals: Hiện thỉ thông số file tar
    exclude: loại bỏ file theo yêu cầu trong quá trình nén

Cú pháp: `sudo tar -[option] [filename] [the directory you want to backup]`

**Giải nén** 
Cú pháp: `sudo tar -[option] [file to recover from] -C [directory to put recovered things] `
* Options:
    C: change directory
    x: to extract information from a tarball
    v: verbose
    p: perserve permission
    z: uncompress
    f: give it a filename

**dd** 
dd - convert and copy a file

Using dd to:

    To backup the entire hard disk
    To blank out a drive (using source is dev/zero)
    Transfer all files, folders in one disk drive to another
    To create an image of a Hard Disk
    To restore using the Hard Disk Image

Syntax: dd if=<source> of=<dest> (bs=) (count)= [option]
