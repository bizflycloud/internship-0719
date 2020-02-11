# Open vSwitch là gì?
* Open vSwitch là phần mềm switch mã nguồn mở hỗ trợ giao thức OpenFlow
* Open vSwitch được sử dụng với các hypervisors để kết nối giữa các máy ảo trên một host vật lý và các máy ảo giữa các host vật lý khác nhau qua mạng.
* Open vSwitch cũng được sử dụng trên một số thiết bị chuyển mạch vật lý (Ví dụ: switch Pica8)
* Open vSwitch là một trong những thành phần quan trọng hỗ trợ SDN (Software Defined Networking - Công nghệ mạng điều khiển bằng phần mềm)
* Tính năng:
  * Hỗ trợ VLAN tagging và chuẩn 802.1q trunking
  * Hỗ trợ STP (spanning tree protocol 802.1D)
  * Hỗ trợ LACP (Link Aggregation Control Protocol)
  * Hỗ trợ port mirroring (SPAN/RSPAN)
  * Hỗ trợ Flow export (sử dụng các giao thức sflow, netflow)
  * Hỗ trợ các giao thức đường hầm (GRE, VXLAN, IPSEC tunneling)
  * Hỗ trợ kiểm soát QoS
  
# Kiến trúc của Open vSwitch
### Kiến trúc tổng quan

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/ovs_arch.jpg)

* Open vSwitch thường được sử dụng để kết nối các VMs/containers trong một host. Ví dụ như trên OpenStack compute node, nó được sử dụng với vai trò là _**ntegration bridge_**để kết nối các VMs chạy trên Compute node đó. Nó quản lý cả các port vật lý (eth0, eth1) và các port ảo (ví dụ như tap port của các VMs).
- Ba khối thành phần chính của Open vSwitch được mô tả như trên hình:
  * vswitchd:
    - Là ovs daemon chạy trên user space
    - Công cụ tương tác: ovs-dpctl, ovs-appctl, ovs-ofctl, sFlowTrend
  - ovsdb-serve:
    - Là database server của Open vSwitch chạy trên user space
    - Công cụ tương tác: ovs-vsctl, ovsdb-client
  - kernel module (datapath):
    - Là module thuộc kernel space, thực hiện công việc chuyển tiếp gói tin

### Kiến trúc chi tiết

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/ovs-arch.png)

# Các thành phần của Open vSwitch

### vswitchd
*   ovs-vswitchd là daemon của Open vSwitch chạy trên userspace. Nó đọc cấu hình của Open vSwitch từ ovsdb-server thông qua kênh IPC (Inter Process Communication) và đẩy cấu hình xuống ovs bridge (là các instance của thư viện ofproto). Nó cũng đẩy trạng thái và thông tin thống kê từ các ovs bridges vào trong database.

*   ovs-vswitchd giao tiếp với:
  * outside world sử dụng OpenFlow
  * ovsdb-server sử dụng giao thức OVSDB protocol
  * kernel thông qua netlink (tương tự như Unix socket domain)
  * system thông qua abstract interface là netdev
- ovs-vswitchd triển khai mirroring, bonding và VLANs
  
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/vswitchd_ovsdb_ofproto.png)

### ovsdb
* Nếu như những cấu hình tạm thời ví dụ như flows được lưu trong datapath và vswitchd thì các cấu hình bền vững sẽ được lưu trữ trong ovsdb và vẫn lưu giữ khi sau khi khởi động lại hệ thống. Các cấu hình này bao gồm cấu hình về bridge, port, interface, địa chỉ của OpenFlow controller...
*   ovsdb-server cung cấp giao diện RPC(remote procedure call) tới ovsdb. Nó hỗ trợ trình khách JSON-RPC kết nối tới thông qua passive TCP/IP hoặc Unix domain sockets.
*   ovsdb-server chạy hoặc như một backup server hoặc như một active server. Tuy nhiên chỉ có active server mới xử lý giao dịch làm thay đổi ovsdb.

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/ovsdb_tables.jpg)

# So sánh OpenvSwitch và Linux Bridge

#### Hạn chế của Linux Bridge

Linux Bridge (LB) là cơ chế ảo hóa mặc định được sử dụng trong KVM. Nó rất dễ dàng để cấu hình và quản lí tuy nhiên nó vốn không được dùng cho mục đích ảo hóa vì thế bị hạn chế một số các chức năng.

LB không hỗ trợ tunneling và OpenFlow protocols. Điều này khiến nó bị hạn chế trong việc mở rộng các chức năng. Đó cũng là lí do vì sao  Open vSwitch xuất hiện.

Dưới đây là bảng so sánh giữa hai công nghệ này:

| Open vSwitch | Linux bridge |
|--------------|--------------|
| Được thiết kế cho môi trường mạng ảo hóa | Mục đích ban đầu không phải dành cho môi trường ảo hóa |
| Có các chức năng của layer 2-4 | Chỉ có chức năng của layer 2 |
| Có khả năng mở rộng | Bị hạn chế về quy mô |
| ACLs, QoS, Bonding | Chỉ có chức năng forwarding |
| Có OpenFlow Controller | Không phù hợp với môi trường cloud |
| Hỗ trợ netflow và sflow | Không hỗ trợ tunneling |

**OVS**

- Ưu điểm: các tính năng tích hợp nhiều và đa dạng, kế thừa từ linux bridge. OVS hỗ trợ ảo hóa lên tới layer4. Được sự hỗ trợ mạnh mẽ từ cộng đồng. Hỗ trợ xây dựng overlay network.

- Nhược điểm: Phức tạp, gây ra xung đột luồng dữ liệu

**LB**

- Ưu điểm:
Các tính năng chính của switch layer được tích hợp sẵn trong nhân. Có được sự ổn định và tin cậy, dễ dàng trong việc troubleshoot
Less moving parts: được hiểu như LB hoạt động 1 cách đơn giản, các gói tin được forward nhanh chóng

- Nhược điểm:
Để sử dụng ở mức user space phải cài đặt thêm các gói. VD vlan, ifenslave. Không hỗ trợ openflow và các giao thức điều khiển khác.
Không có được sự linh hoạt

