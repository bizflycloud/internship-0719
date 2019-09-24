# Set static IP,DHCP,GATEWAY
- Để setting+config địa chỉ ip tĩnh trên linux cần sửa đổi cấu hình netplan trong đường dẫn `/etc/netplan` vào trong thư mục `50-cloud-init.yaml` để cấu hình ip tĩnh và DNS và gateway(đối với phiên bản ubuntu 17.1 trở lên)![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/ip%20st.png)
- Sau đó nhập lệnh `sudo netplan apply` để áp dụng 
- Trường hợp gặp một số vấn đề thực thi dùng lệnh `sudo netplan --debug apply` để gỡ lỗi
# DNS system
- DNS là hệ thống tên miền là một dịch vụ trên mạng tcp/ip cho phép khách hàng dịch tên thành địa chỉ ip như khi sử dụng trình duyệt để truy cập trang web,sau đó nhập tên của trang web đó vào phần thanh url. Nhưng để máy tính thực sự giao tiếp với máy chủ lưu trữ web cho biết trang web, máy tính cần địa chỉ IP của máy chủ web đó. Đó là nơi dns đến
# Config `ip route`
- Để hiển thị bảng định tuyến trên linux nhập lệnh `ip route show` hoặc `ip route list`
- Để gửi tất cả các gói trực tiếp đến một mạng cục bộ qua một cổng dùng lệnh `ip route add <ip address> dev <port>`
- Thêm tuyến đường mặc định dùng lệnh `ip route add <network> via <ip> dev <device>`
- Đặt định tuyến mặc định dùng lệnh `ip route add default via <địa chỉ ip mặc định>`
- Xóa định tuyến khỏi bảng dùng lệnh `ip route delete <ip address> dev <port>`
# SSH
-  là một chương trình để đăng nhập vào một máy từ xa và để thực hiện các lệnh trên một máy từ xa. Nó được dự định để thay thế rlogin và rsh, và cung cấp liên lạc được mã hóa an toàn giữa hai máy chủ không đáng tin cậy qua một mạng không an toàn. Các kết nối X11 và các cổng TCP tùy ý cũng có thể được chuyển tiếp qua kênh bảo mật.
- SSH là giao thức đăng nhập từ xa an toàn
- Mô hình client-server trên nền TCP cổng 22
- SSH tăng cường đc bảo mật nhờ có:
 - Kênh truyền đc mã hóa 
 - chứng thực người dùng, client server 
- Cung cấp kênh giao tiếp an toàn, tạo các kênh giao tiếp an toàn chia sẻ cho nhiều ứng dụng giữa 2 đầu cuối
- Để đăng nhập từ xa vào một server dùng lệnh `ssh <username>@<ip address>` sau đó nhập mật khẩu để đăng nhập vào server
**Thiết lập SSH key**
- Một trong các phương thức đăng nhập vào VPS khá an toàn đó là việc sử dụng SSH Key để thay thế cho mật khẩu. Mặc định mỗi VPS bạn sẽ đăng nhập vào bằng username root và mật khẩu root mà nhà cung cấp đã gửi cho bạn lúc thuê VPS, tuy nhiên việc sử dụng mật khẩu luôn có 2 nguy cơ lớn là:
 - Bạn sẽ mất hoàn toàn nếu lộ mật khẩu.
 - Các attacker có thể sử dụng Brute Force Attack để dò tìm mật khẩu.
- Đầu tiên để thiết lập ssh key dùng lệnh:`ssh-keygen` để tạo một cặp key rsa sau khi tạo sẽ ra kết quả như sau:![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/k.png)
- Sau khi thực hiện câu lệnh này hệ thống sẽ yêu cầu nhập passphrase tại chỗ này mình nên nhập một passphrase này để làm tăng hiệu qửa bảo mật 2 lớp
- Sau đó ta có thể copy key lên máy từ xa dùng lệnh `ssh-copy-id <user@ip>`có thể thấy thông báo ntn là thành công ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/cpsshid.png)
**Cấu hình ssh**
- SSH-add:
# Iptable
- Iptable là một tường lửa có tiêu chuẩn được bao gồm trong hầu hết tất cả các bản phân phối linux theo mặc định.   
- Iptables hoạt động dựa trên việc phân loại và thực thi các package ra/vào theo các quy tắc được thiết lập từ trước.
