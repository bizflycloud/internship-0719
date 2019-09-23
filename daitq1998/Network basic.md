# Set static IP,DHCP,GATEWAY
- Để setting+config địa chỉ ip tĩnh trên linux cần sửa đổi cấu hình netplan trong đường dẫn `/etc/netplan` vào trong thư mục `50-cloud-init.yaml để cấu hình ip tĩnh và DNS và gateway(đối với phiên bản ubuntu 17.1 trở lên)
- Sau đó nhập lệnh `sudo netplan apply` để áp dụng 
- Trường hợp gặp một số vấn đề thực thi dùng lệnh `sudo netplan --debug apply` để gỡ lỗi
# DNS system
- DNS là 
# Config `ip route`
- Để hiển thị bảng định tuyến trên linux nhập lệnh `ip route show` hoặc `ip route list`
- Để gửi tất cả các gói trực tiếp đến một mạng cục bộ qua một cổng dùng lệnh `ip route add <ip address> dev <port>
- Đặt tuyến đường mặc định dùng lệnh `ip route add default via <địa chỉ ip mặc định>
- Xóa tuyến đường khỏi bảng dùng lệnh `ip route delete <ip address> dev <port>
# SSH
-  là một chương trình để đăng nhập vào một máy từ xa và để thực hiện các lệnh trên một máy từ xa. Nó được dự định để thay thế rlogin và rsh, và cung cấp liên lạc được mã hóa an toàn giữa hai máy chủ không đáng tin cậy qua một mạng không an toàn. Các kết nối X11 và các cổng TCP tùy ý cũng có thể được chuyển tiếp qua kênh bảo mật.
- SSH là giao thức đăng nhập từ xa an toàn
- Mô hình client-server trên nền TCP cổng 22
- SSH tăng cường đc bảo mật nhờ có:
 - Kênh truyền đc mã hóa 
 - chứng thực người dùng, client server 
- Cung cấp kênh giao tiếp an toàn, tạo các kênh giao tiếp an toàn chia sẻ cho nhiều ứng dụng giữa 2 đầu cuối
- Để đăng nhập từ xa vào một server dùng lệnh `ssh <username>@<ip address>` sau đó nhập mật khẩu để đăng nhập vào server
# Iptable
- Iptable là một tường lửa có tiêu chuẩn được bao gồm trong hầu hết tất cả các bản phân phối linux theo mặc định.   Iptables hoạt động dựa trên việc phân loại và thực thi các package ra/vào theo các quy tắc được thiết lập từ trước.
