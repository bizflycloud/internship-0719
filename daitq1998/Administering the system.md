# Syslogd
**Syslog** 
- Là một gói phần mềm tronh hệ thống linux nhằm để ghi bản tin log của hệ thống trong quá trình hoạt động như của kernel, deamon, cron, auth hoặc các ứng dụng chạy trên hệ thống như dhcp, dns,http,ntp
- các tác dụng của log : Log ghi lại liên tục các thông báo về hoạt động của cả hệ thống hoặc của các dịch vụ được triển khai trên hệ thống và file tương ứng. Log file thường là các file văn bản thông thường dưới dạng “clear text” tức là bạn có thể dễ dàng đọc được nó, vì thế có thể sử dụng các trình soạn thảo văn bản (vi, vim, nano...) hoặc các trình xem văn bản thông thường (`cat`, `tailf`, `head`...) là có thể xem được file log.
- Các file log có thể nói cho bạn bất cứ thứ gì bạn cần biết, để giải quyết các rắc rối mà bạn gặp phải miễn là bạn biết ứng dụng nào, tiến trình nào được ghi vào log nào cụ thể. Trong hầu hết hệ thống Linux thì /var/log là nơi lưu lại tất cả các log.
- ứng dụng của log: phân tích nguyên nhân gốc dễ cảu một vấn đề. Giúp cho một hệ thống khi gắp vấn đề đc khắc phục nhanh hơn. Giúp cho việc phát hiện dự đoán một vấn đề có thể xảy ra đôi với hệ thống
**Trong syslogd có 4 khái niệm cần hiểu**
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
| kern |	Các thông báo kernel. |
| local0.local7 | 	Các phương tiện nội bộ được xác định cho mỗi site. |
| lpr | 	Các thông báo từ dòng hệ thống in. |
| mail |	Các thông báo liên quan tới hệ thống mail. |
| mark |	Các sự kiện giả được sử dụng để tạo timestamp trong các file hệ thống. |
| news |	Các thông báo liên quan tới mạng lưới giao thức tin tức (network news protocol) |
| ntp |	Các thông báo liên quan đến giao thức thời gian mạng. |
| user |	Các tiến trình người dùng thông thường. |
| uucp |	Hệ thống phụ UUCP.|
- Theo măc định các bản tin log của hệ thống được syslog lưu vào trong thư mục /var/log, và được lưu riêng rẽ đối với từng tác vụ trong hệ thông nhưng đối với tiến trình cron thì sẽ lưu trong file cron.log.
-file câu hình của linux đc lưu trong bản ghi có đường dẫn là : `/etc/rsyslog.conf`.  nhưng các rule được định nghĩa riêng trong `/etc/rsyslog.d/50-defaul.conf` . File rule này được khai báo include từ file cấu hình `/etc/rsyslog.conf`

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

**Rotating log files**
- Phần lớn các distro sẽ cài đặt một cấu hình syslog mặc định cho bạn, bao gồm logging to messages và các log files khác trong /var/log. Để ngăn cản những files này ngày càng trở nên cồng kềnh và khó kiểm soát, một hệ thống quay vòng log file (a log file rotation scheme) nên được cài đặt. Hệ thống cron đưa ra các lệnh để thiết lập những log files mới, những file cũ được đổi tên bằng cách thay một con số ở hậu tố. Với loại quay vòng này, /var/log/messages của ngày hôm qua sẽ trở thành messages.1 của ngày hôm nay và một messages mới được tạo. Sự luân phiên này được cấu hình cho một số lượng lớn các file, và các log files cũ nhất sẽ được xoá khi sự luân phiên bắt đầu chạy. Ví dụ trong /var/log có các messages sau: messages, messages.1, messages-20141111, messages-20141118, ...
- Tiện ích thi hành rotation là logrotate. Lệnh này được cấu hình sử dụng cho một hoặc nhiều files - được xác định bởi các tham số đi cùng. File cấu hình mặc định là /etc/logrotate.conf.
- LOGROTATE là một tiện ích tuyệt vời trên Linux giúp đơn giản hóa việc quản lý log files trên hệ thống, bao gồm xoay vòng file log, di chuyển, nén, gửi tự động… Rotate (xoay vòng) ở đây có thể hiểu là tiến trình xử lý file log cũ theo quy định trước đó (xóa/nén/move) đồng thời tạo ra file log mới.
- Bằng cách thiết lập đơn giản nhưng chặt chẽ thông qua file cấu hình, Logrotate hoạt động một cách tự động, không cần can thiệp thủ công.
- Log files rất quan trọng đối với quản trị viên để theo dõi tình trạng của hệ thống/ứng dụng, tuy vậy nếu quá nhiều log file sẽ khiến dung lượng ổ cứng bị quá tải cũng như gây khó khăn trong việc tìm kiếm thông tin cần thiết.
##Lệnh`cron`
- Có nhiều công việc trên linux phải lập lịch một các thường xuyên.Nên `cron` dùng để sắp xếp thực hiện các lệnh theo lịch trình
- `cron` bao gồm `cron daemon`tức là nó được chạy ngầm mãi mãi một khi nó được khởi động lên. Như các deamon khác thì bạn cần khởi động lại nó nếu như có thay đổi thiết lập gì đó và đc khỏi động bởi tiến trình init 
- `cron` đọc các lịch công việc từ `/etc/crontab` và trong file `/var/spoon/cron`
- Thư mục cron này lưu trữ các file lập lịch (thường được gọi là crontab hay cron table) cho những người sử dụng thông thường được phép chạy các công việc cron. Là một superuser, bạn có thể xác định một danh sách những người sử dụng được phép chạy các công việc cron trong file `/etc/cron.allow`
- Tương tự, ta có thể xác định những người sử dụng không được phép thực hiện các công việc cron trong file `/etc/cron.deny`. Cả hai file này đều sử dụng một định dạng cơ bản: một username trên một dòng. Nếu một người được phép thực hiện các công việc cron, người đó có thể sử dụng tiện ích crontab để thực hiện công việc lập lịch
- Crontab files không cho phép tạo hoặc chỉnh sửa trực tiếp với bất kỳ trình text editor nào, trừ phi bạn dùng lệnh crontab.
- **Một số lệnh thường dùng:**
- `crontable -e`: Tạo hoặc chỉnh sửa file crontab
- `crontable -l`: Hiển thị file crontab
- `crontab -r`: xóa file crontab
## Lệnh `at`
- Linux có các lệnh cho phép thực hiện các tiến trình ở thời điểm định trc thông qua lệnh at. Thời điểm thực hiện tiến trình đc nhập và thông qua tham số của lệnh at
- Chương trình tại cho phép một lệnh hoặc tập lệnh được lên lịch cho một lần thực hiện tại một thời gian sau Chức năng lập lịch trình thực sự khá linh hoạt và có thể lấy một số định dạng. Ví dụ, bạn có thể lên lịch một sự kiện liên quan đến thời gian hiện tại
- cú pháp: `at [time] <các lệnh thực hiện>`
