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
- Đầu tiên để thiết lập ssh key dùng lệnh:`ssh-keygen` để tạo một cặp key rsa sau khi tạo sẽ ra kết quả như sau:
![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/k.png)
- Sau khi thực hiện câu lệnh này hệ thống sẽ yêu cầu nhập passphrase tại chỗ này mình nên nhập một passphrase này để làm tăng hiệu qửa bảo mật 2 lớp
- Sau đó ta có thể copy key lên máy từ xa dùng lệnh `ssh-copy-id <user@ip>`có thể thấy thông báo ntn là thành công
![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/cpsshid.png)
Ngoài phương pháp này còn các phương pháp thủ công(phức tạp hơn)
**Cấu hình ssh**
- Để cấu hình cho các kết nối ssh sử dụng các tên thay thế ngắn hơn cho hostname trong file /etc/ssh/ssh_config
- `ssh-add`:là lệnh dùng để thêm các khóa mới vào trong ssh
- `ssh-agent`: là một chương trình nền xử lý mật khẩu cho các khóa riêng của SSH. Các ssh-add lệnh nhắc nhở người sử dụng cho một mật khẩu khóa riêng và thêm nó vào danh sách duy trì bởi ssh-agent
- Để khởi động `ssh-agent`dùng lệnh `eval ssh-agent`
- Sau khi khởi động để thêm một private key vào ssh-agent dùng lệnh `ssh-add` và nhập mật khẩu khóa riêng
- ssh forward agent: Sau khi ssh đến một server sau đó muốn ssh đến một server khác với key đang dùng thì sử dụng ssh forward agent
- forward agent :đc bật với tùy chon -A của ssh
- Để cho phép Agent Forwarding bạn cần phải thực hiện lệnh ssh-add để add key của bạn trước khi thực hiện ssh với tùy chọn Agent Forwarding.
- cũng có thể thực hiện Agent Forwarding bằng cách thêm vào các kết nối ssh trong file ssh_config tùy chọn như sau:
Forward Agent yes 
- rsync qua ssh :với rsync ta có thể transfer (copy và đồng bộ) qua giao thức ssh qua đó thì dữ liệu đc bảo mật và an toàn hơn. Nó an toàn & nhanh hơn scp & cũng có thể được sử dụng thay cho lệnh scp để sao chép tệp / thư mục vào máy chủ từ xa.
- Để các định giao thức sẽ đc sử dụng rsync cần thêm tùy chọn -e cùng với tên giao thức(ssh) có thể copy file từ localserver lên remote server và ngược lại
![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/rs.png)
![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/rsync.png)
- scp : SCP (Secure Copy) là file transfer protocol (giao thức chuyển file trên mạng), giúp di chuyển file trong hệ thống mạng an toàn và dễ dàng. Nó có thể chuyển file giữa một máy tính cá nhân đến máy chủ từ xa, hoặc chuyển file giữa 2 máy tính từ xa. Để dễ hiểu SCP giống như một kết hợp giữa RCP và SSH (Secure Shell). Nó dựa trên RCP để thực hiện thao tác copy, và SSH để mã hóa mọi thông tin truyền đi, và chứng thực máy tính từ xa là đúng máy cần truyền.
- Nhưng không giống Rsync, lệnh SCP với username và password hoặc passphrase là có thể chuyển file được rồi. Nó đơn giản hóa cả quá trình này, và bạn không phải đăng nhập vào bất kỳ máy tính nào.Nó dựa trên RCP để thực hiện thao tác copy, và SSH để mã hóa mọi thông tin truyền đi, và chứng thực máy tính từ xa là đúng máy cần truyền.
- Để copyfile từ local server lên remote server:`scp <option> <source_file><remoteuser>:/<destination_file>`
![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/scpssh.png)
hoặc ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/scp.png)
- Ngoài ra rysnc có tùy chọn để sao lưu vi sai mà scp thiếu. Nhưng cả hai đều an toàn như nhau và rất dễ sử dụng.
# Iptables
- Iptable là một tường lửa có tiêu chuẩn được bao gồm trong hầu hết tất cả các bản phân phối linux theo mặc định.   
- Iptables hoạt động dựa trên việc phân loại và thực thi các package ra/vào theo các quy tắc được thiết lập từ trước.
**Nguyên tắc áp dụng iptables**
- Liệt kê các quy tắc của iptables dùng lệnh: `iptables -L` ![](
- Trong đó :
 - Cột 1: là các target có các taget như :
   - Accept: gói dữ liệu đc chuyển tiếp để xử lý tại ứng dụng cuối hoặc hệ điều hành
   - Drop: gói dữ liệu bị chặn hoặc loại bỏ
   - Reject: gói dữ liệu đc chặn loại bỏ và gửi thông báo lỗi đến ng gửi
 - Cột 2:prot(giao thức) quy định các giao thức sẽ đc thực thi để áp dụng các quy tắc bao gồm all TCP,UDP
 - Cột 4,5 :(Source,Destination) là địa chỉ của lượt truy cập cho phép áp dụng quy tắc
 **Xử lý gói trong iptables**
 -Tất cả mọi dữ liệu đều đc kiểm tra bởi iptables bằng cách dùng các bảng tuần tự xây dựng sẵn gồm:
- *Fillter table*
 - Filter table đc sử dụng để lọc các gói tin dữ liệu Noa gồm 3 nguyên tắc:
  - Forward chain: Lọc gói khi đi đến các server khác
  - Input chain: Lọc gói khi đi vào server
  - output chain: Lọc gói khi đi ra khỏi server
  *Nat*
  - Pre-routing chain: thay đổi địa chỉ đến của các gói dữ liệu khi cần thiết
  - Post-routing chain: thay đổi địa chỉ nguồn của các gói dữ liệu khi cần thiết
  **Định nghĩa các chain rules**
  - Là việc thực hiện thêm vào các chain hiện tại dùng lệnh : `sudo iptables -A  -i <interface> -p <protocol (tcp/udp)> -s <source> --dport <port no.>  -j <target>`
   - -A: thêm chain tules
   - -i<interface> là giao diện mang cần thực hiện lọc các gói tin
   - p<protocol>là giao thức mạng thực hiện lọc(tcp/udp)
   - dport<port>là cổng ng dùng muốn đặt bộ lọc
 - Giả sử : muốn thêm một chain rules như sau:`sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT` là cho phép truy cập giao thức TCP trên cổng 22
 hoặc `sudo iptables -A INPUT -s 192.168.122.1 -j DROP` là từ chối các gói tin từ ip address 192.168.122.1 ; `sudo iptables -A OUTPUT -p tcp --dport 443 -j DROP`là chặn các gói tin đi ra với giao thức tcp đi ra từ cổng 433
 - Để xóa tất cả các rules dùng lệnh `sudo iptables -F`
 - Để xóa từng dòng rules :`sudo iptable -D <chain rules>
 -Ví dụ: `sudo iptables -D INPUT3` Để xóa dòng thứ 3 của chain rules INPUT3
