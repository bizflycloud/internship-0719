**build DHCP server**

**DHCP là gì**

DHCP (Dynamic Host Configuration Protocol)  là giao thức được sử dụng để cung cấp quản lý trung tâm nhanh chóng, tự động và trung tâm để phân phối địa chỉ IP trong mạng.

**DHCP hoạt động ntn**

Một thiết bị (máy khách) yêu cầu địa chỉ IP từ bộ định tuyến (máy chủ), sau đó máy chủ chỉ định một địa chỉ IP khả dụng để cho phép máy khách liên lạc trên mạng.

Khi một thiết bị được bật và kết nối với mạng có máy chủ DHCP, thiết bị sẽ gửi yêu cầu đến máy chủ, được gọi là yêu cầu DHCPDISCOVER.

Sau khi gói DISCOVER đến máy chủ DHCP, máy chủ sẽ cố giữ địa chỉ IP mà thiết bị có thể sử dụng và sau đó cung cấp cho khách hàng địa chỉ bằng gói DHCPOFFER.

Khi ưu đãi đã được thực hiện cho địa chỉ IP đã chọn, thiết bị sẽ phản hồi máy chủ DHCP bằng gói DHCPREQUEST để chấp nhận, sau đó máy chủ gửi ACK được sử dụng để xác nhận rằng thiết bị có địa chỉ IP cụ thể đó và để xác định lượng thời gian mà thiết bị có thể sử dụng địa chỉ trước khi nhận địa chỉ mới.

**Cách cài DHCP server**

**1.setup dhcp server**

`sudo apt install isc-dhcp-server` # cài dhcp trên server

`sudo vi /etc/default/isc-dhcp-server` sửa `INTERFACESv4="ens33"` # kiểm tra interface bằng lệnh ip a , ip r ....

`sudo vi /etc/dhcp/dhcpd.conf` # uncomment authoritative; # tìm file như hình để cấu hình subnet, range ip ...

`sudo systemctl start isc-dhcp-server` 

`sudo systemct  enable isc-dhcp-server` 

`sudo ufw status` # nếu ufw inactive thì k phải add rule còn nếu ufw đang chạy thì add rules như sau  `sudo ufw allow in on ens33 from any port 68 to any port 67 proto udp` vì dhcp chạy trên port 68 và sử dụng proto udp

**Config client**

`sudo vi /etc/network/interface` # thêm dòng auto ens33 ,iface ens33 inet dhcp để cho phép nhận ip từ dhcp server 

