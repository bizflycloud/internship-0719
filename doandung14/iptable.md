**iptable**

**Khái niệm cơ bản về Iptables**

Iptables là một ứng dụng dòng lệnh và là một bức tường lửa Linux mà bạn có thể sử dụng để thiết lập, duy trì và kiểm tra các bảng này. Bạn có thể thiết lập nhiều bảng khác nhau, mỗi bảng có thể chứa nhiều chuỗi, mỗi một chuỗi là một bộ quy tắc. Mỗi quy tắc định nghĩa phải làm gì với gói tin nếu nó phù hợp với gói đó. Khi một gói tin được xác định, nó sẽ đưa ra một TARGET. Một target (mục tiêu) có thể là một chuỗi khác để khớp với một trong các giá trị đặc biệt sau đây:

ACCEPT: gói tin sẽ được phép đi qua.

DROP: gói tin sẽ không được phép đi qua.

RETURN: bỏ qua chuỗi hiện tại và quay trở lại quy tắc tiếp theo từ chuỗi mà nó được gọi.

Trong phạm vi của bài hướng dẫn iptables này, chúng ta sẽ làm việc với một trong những bảng mặc định được gọi là bộ lọc. Bảng bộ lọc có ba chuỗi bộ quy tắc.

INPUT – được sử dụng để điều khiển các gói tin đến tới máy chủ. Bạn có thể chặn hoặc cho phép kết nối dựa trên cổng, giao thức hoặc địa chỉ IP nguồn.

FORWARD – được sử dụng để lọc các gói dữ liệu đến máy chủ nhưng sẽ được chuyển tiếp ở một nơi khác.

OUTPUT – được sử dụng để lọc các gói tin đi ra từ máy chủ của bạn.

**1. Cài đặt Iptables**

`sudo apt-get install iptables`

Trên ubuntu iptables là chuỗi lệnh chứ k phải 1 service nên k thể restart stop hay check status

**2. Kiểm tra trạng thái hiện tại của Iptables**

`sudo iptables -L -v`

Các nguyên tắc áp dụng trong Iptables

Để bắt đầu, bạn cần xác định các services muốn đóng/mở và các port tương ứng.

Ví dụ, với một website và mail server thông thường

Để truy cập VPS bằng SSH, bạn cần mở port SSH – 22.

Để truy cập website, bạn cần mở port HTTP – 80 và HTTPS – 443.

Để gửi mail, bạn sẽ cần mở port SMTP – 22 và SMTPS – 465/587

Để người dùng nhận được email, bạn cần mở port POP3 – 110, POP3s – 995, IMAP – 143 và IMAPs – 993

Sau khi đã xác định được các port cần mở, bạn cần thiết lập các quy tắc tường lửa tương ứng để cho phép.

Bạn có thể xóa toàn bộ các quy tắc firewall mặc định để bắt đầu từ đầu: # iptables -F

**các quy tắc của iptables**

Cột 1: TARGET hành động sẽ được áp dụng cho mỗi quy tắc

Accept: gói dữ liệu được chuyển tiếp để xử lý tại ứng dụng cuối hoặc hệ điều hành

Drop: gói dữ liệu bị chặn, loại bỏ

Reject: gói dữ liệu bị chặn, loại bỏ đồng thời gửi một thông báo lỗi tới người gửi

Cột 2: PROT (protocol – giao thức) quy định các giao thức sẽ được áp dụng để thực thi quy tắc, bao gồm all, TCP hay UDP. Các ứng dụng SSH, FTP, sFTP… đều sử dụng giao thức TCP.

Cột 4, 5: SOURCE và DESTINATION địa chỉ của lượt truy cập được phép áp dụng quy tắc.

**3. Định nghĩa các chain rules**

Định nghĩa các chain rules là thực hiện thêm nó vào danh sách chain hiện tại. Đây là lệnh Iptables được định dạng với các tùy chọn thông thườn

`sudo iptables -A  -i <interface> -p <protocol (tcp/udp)> -s <source> --dport <port no.>  -j <target>`

-A: thêm chain rules

-i <interface> là giao diện mạng bạn cần thực hiện lọc các gói tin

-p <protocol> là giao thức mạng thực hiện lọc (tcp/udp)

–dport <port no.> là cổng mà bạn muốn đặt bộ lọc
   
http://ipset.netfilter.org/iptables.man.html   
   
**4. iptable dùng để làm gì**

1. Cho phép lưu lượng truy cập trên localhost

`sudo iptables -A INPUT -i lo -j ACCEPT`

2. Cách sử dụng Iptables để mở port VPS

`iptables -A INPUT -p tcp -m tcp --dport xxx -j ACCEPT`

3.Để mở port trong Iptables, bạn cần chèn chuỗi ACCEPT PORT. Cấu trúc lệnh để mở port xxx như sau:

`# iptables -A INPUT -p tcp -m tcp --dport xxx -j ACCEPT`

A tức Append – chèn vào chuỗi INPUT (chèn xuống cuối)
hoặc

`# iptables -I INPUT -p tcp -m tcp --dport xxx -j ACCEPT`

I tức Insert- chèn vào chuỗi INPUT (chèn vào dòng chỉ định rulenum)

Để tránh xung đột với rule gốc, các bạn nên chèn rule vào đầu, sử dụng -I

***4.Port**

VD Để truy cập VPS qua SSH, bạn cần mở port SSH 22. Bạn có thể cho phép kết nối SSH ở bất cứ thiết bị nào, bởi bất cứ ai và bất cứ dâu.

`iptables -I INPUT -p tcp -m tcp --dport 22 -j ACCEPT`

**Chặn port**

`iptables -I INPUT -p tcp -m tcp --dport 22 -j DROP`

**5.Lọc các gói tin dựa trên nguồn của nó**

`sudo iptables -A INPUT -s 192.168.1.3 -j ACCEPT`

Cho phép các gói tin từ IP 192.168.1.3

`sudo iptables -A INPUT -s 192.168.1.3 -j DROP`

Chặn 1 IP truy cập 1 port cụ thể:

`#iptables -A INPUT -p tcp -s IP_ADDRESS –dport PORT -j DROP`

Từ chối các gói tin từ  IP 192.168.1.3

**6.Chặn tất cả các truy cập khác**

`sudo iptables -A INPUT -j DROP`

Sau khi đã thiết lập các rules, bạn có thể kiểm tra lại bằng lệnh sau

`sudo iptables -L -v`

7. Xóa rules

Nếu bạn muốn xóa tất cả các rules để tạo lại từ đầu hãy dùng lệnh

`sudo iptables -F`

Bạn có thể xóa từng rules khác nhau dùng tham số -D nhưng trước tiên bạn cần dùng lệnh

`sudo iptables -L --line-numbers`

để liệt kê các rules tương ứng với từng số

Sau đó dùng lệnh

`sudo iptables -D INPUT 3`

để xóa rules số 3 ở chain INPUT

8.Lưu giữ các thay đổi

Các Iptables rules chúng ta tạo ra đều được lưu ở bộ nhớ, nếu bạn reboot máy chủ thì bạn cần thực hiện tạo lại các rules này.

Để lưu giữ vào cấu hình hệ thống, bạn dùng lệnh sau

`sudo /sbin/iptables-save`

Nếu bạn muốn tắt firewall, hãy sử dụng lệnh

`sudo iptables -F`

`sudo /sbin/iptables-save`
