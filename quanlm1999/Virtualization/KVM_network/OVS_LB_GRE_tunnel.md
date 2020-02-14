# Tổng quan GRE

####  GRE là gì?

* **Generic routing encapsulation (GRE)** là một giao thức sử dụng để thiết lập các kết nối ***oint-to-point*** ột các trực tiếp giữa các node trong mạng. Đây là một phương pháp đơn giản và hiệu quả để chuyển dữ liệu thông qua mạng public network, như Internet. GRE cho phép hai bên chia sẻ dữ liệu mà họ không thể chia sẻ với nhau thông qua mạng public network. 

* GRE **đóng gói dữ liệu** và **chuyển trực tiếp** tới thiết bị mà de-encapsulate  gói tin và định tuyến chúng tới **đích cuối cùng**. Gói tin và định tuyến chúng tới đích cuối cùng. 
* GRE cho pháp các switch nguồn và đích hoạt động như một kết nối ảo point-to-point với các thiết bị khác (bởi vì outer header được áp dụng với GRE thì trong suốt với payload được đóng gói bên trong). 

#### Các ưu điểm của GRE 

- Cho phép đóng gói nhiều giao thức và truyền thông qua một giao thức backbone (IP protocol).

- Cung cấp cách giải quyết cho các mạng bị hạn chế hop (hạn chế số hop di chuyển tối đa trong một mạng).

- Kết nối các mạng con gián tiếp.

- Yêu cầu ít tài nguyên hơn các giải pháp tunnel khác. (ví dụ Ipsec VPN).

#### GRE tunneling

- Dữ liệu được định tuyến bởi hệ thống  GRE endpoint trên các tuyến đường được thiết lập trong bảng tuyến. (Các tuyến này có thể được cấu hình tĩnh hoặc học động bằng các giao thức định tuyến như RIP hoặc OSPF) Khi một gói dữ liệu nhận được bởi GRE endpoint, nó được decapsulation và định tuyến lại đến địa chỉ đích cuối cùng của nó.

- GRE tunnel là **stateless** nghĩa là tunnel endpoint không chứa thông tin về trạng thái hoặc tính sẵn có của remote tunnel endpoint. Do đó, switch hoạt động như một tunnel source router không thể thay đổi trạng thái của GRE tunnel interface thành down nếu remote endpoint không thể truy cập được. (Hiểu như là không hoạt động kiểu cần phải thiết lập kết nối trước khi truyền dữ liệu như TCP)

#### Encapsulation và De-Encapsulation trên switch 

**Encapsulation** 

* Switch hoạt động như một tunnel source router đóng gói và chuyển tiếp các gói tin GRE như sau: 

* Switch nhận dữ liệu gói tin (payload) cần chuyển qua tunnel, nó sẽ chuyển gói tin ra tunnel interface.

* Tunnel interface đóng gói 

* Encapsulate dữ liệu vào trong gói tin GRE và thêm vào đó phần outer IP header để thành gói tin IP mới.  

* Gói tin IP được chuyển đến địa chỉ IP đích trong phần outer IP header (là địa chỉ IP của tunnel interface nhận)

**De-encapsulation** switch hoạt động như một tunnel remote router xử lý gói tin GRE như sau: 

* Khi đích outer IP nhận được gói tin từ tunnel interface, outer IP header và GRE header sẽ được bóc tách khỏi gói tin.

* Gói tin được định tuyến tới địa chỉ đích cuối cùng dựa vào inner IP header.

####  GRE frame format

* GRE thêm vào tối thiểu 24 byte vào gói tin, trong đó bao gồm 20-byte IP header mới, 4 byte còn lại là GRE header. GRE có thể tùy chọn thêm vào 12 byte mở rộng để cung cấp tính năng tin cậy như: checksum, key chứng thực, sequence number.

  ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/6.1.png)

* GRE header bản thân nó chứa đựng 4 byte, đây là kích cỡ nhỏ nhất của một GRE header khi không thêm vào các tùy chọn. 2 byte đầu tiên là các cờ (flags) để chỉ định những tùy chọn GRE. Những tùy chọn này nếu được active, nó thêm vào GRE header. Bảng sau mô tả những tùy chọn của GRE header.

  ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/6.2.png)

* Trong GRE header 2 byte còn lại chỉ định cho trường giao thức. 16 bits này xác định kiểu của gói tin được mang theo trong GRE tunnel. Hình sau mô tả cách mà một gói tin GRE với tất cả tùy chọn được gán vào một IP header và data:

  ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/6.3.png)

#### Phân loại GRE

- GRE là giao thức có thể đóng gói bất kì gói tin nào của lớp network. GRE cung cấp khả năng có thể định tuyến giữa những mạng riêng (private network) thông qua môi trường Internet bằng cách sử dụng các địa chỉ IP đã được định tuyến.

- GRE truyền thống là point-to-point, còn mGRE là sự mở rộng khái niệm này bằng việc cho phép một tunnel có thể đến được nhiều điểm đích, mGRE tunnel là thành phần cơ bản nhất trong DMVPN.

### Point-to-Point GRE

- Đối với các tunnel GRE point-to-point thì trên mỗi router spoke (R2 & R3) cấu hình một tunnel chỉ đến HUB (R1) ngược lại, trên router HUB cũng sẽ phải cấu hình hai tunnel, một đến R2 và một đến R3. Mỗi tunnel như vậy thì cần một địa chỉ IP. Giả sử mô hình trên được mở rộng thành nhiều spoke, thì trên R1 cần phải cấu hình phức tạp và tốn không gian địa chỉ IP.
 
  ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/unnamed.jpg)

- Trong tunnel GRE point-To-point, điểm đầu và cuối được xác định thì có thể truyền dữ liệu. Tuy nhiên, có một vấn đề phát sinh là nếu địa chỉ đích là một multicast (chẳng hạn 224.0.0.5) thì GRE point-to-point không thực hiện được. Để làm được việc này thì phải cần đến mGRE.

### Point-to-Multipoint GRE (mGRE)

- Như vậy, mGRE giải quyết được vấn đề đích đến là một địa chỉ multicast. Đây là tính năng chính của mGRE được dùng để thực thi Multicast VPN trong Cisco IOS. Tuy nhiên, trong mGRE, điểm cuối chưa được xác định nên nó cần một giao thức để ánh xạ địa chỉ tunnel sang địa chỉ cổng vật lý. Giao thức này được gọi là NHRP (Next Hop Resolution Protocol)

  ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/unnamed2.jpg)

- Đối với các mGRE Tunnel thì mỗi router chỉ có một Tunnel được cấu hình cùng một subnet logical.

# Lab kết nối Linux bridge và OVS sử dụng GRE  tunnel
## Mô hình
![](https://raw.githubusercontent.com/lmq1999/123/master/OVS_LB_GRE_tunnel.png)

## Cài đặt

### Host 1 (192.168.122.132)
#### Cấu hình
**Host 1 sử dụng Linux bridge (LB)**

**Bridge setup**
*   Sử dụng luôn bridge mặc định đã được tạo sẵn (virbr0)
    ```
    root@node1:~# brctl show
    bridge name	bridge id		STP enabled	interfaces
    virbr0		8000.525400064b96	yes		tun-1
    						            	virbr0-nic
    							            vnet0
    ```
*   IP bridge đã được tạo sẵn: 192.168.123.1/24
Sử dụng GRE tunnel
**GRE tunnel**
*   Ta tạo GRE endpoit (remote đến ip của host 2)
    ```
    ip link add tun-1 type gretap remote 192.168.122.100 ttl 64
    ip link set dev tun-1 up
    ```
*   Gán vào bridge mặc định của LB
    ```
    ip link set dev tun-1 master virbr0
    ```
*   Ta sẽ có kết quả như sau:
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-13%2016-23-55.png)

P/s: vì sử dụng network mặc định nên bỏ qua bước gắn vnet0 vào bridge

### Host 2 (192.168.122.100)

#### Cấu hình HOST

**Host 2 sử dụng Openvswitch (OVS)**

**Bridge setup**
*   Ta xóa LB tồn tại từ trước đó:
    ```
    ifconfig virbr0 down
    brctl delbr virbr0
    ```
    Kết quả
    ```
    root@node2:~# brctl show
    bridge name	bridge id		STP enabled	interfaces
    ```
    P/s: có thể unload Linux bridge module: `modprobe -r bridge`

*   Cài đặt Openvswitch `apt-get install openvswitch-switch`
*   Tạo OVS switch: `ovs-vsctl add-br virbr1`
*   Gán interface của KVM đang sử dụng  (vnet0)vào  OVS switch mới tạo:  `ovs-vsctl add-port virbr1 vnet0`
*   Gán địa chỉ IP vào OVS switch: `ip addr add 192.168.123.2/24 dev virbr1`
*   Tạo network mới sử dụng OVS switch vừa tạo: 
    ```
    vim ovs-gre.xml
    
    <network>
        <name>ovs-gre</name>
        <forward mode='bridge'/>
        <bridge name='virbr1'/>
        <virtualport type='openvswitch'/>
    </network>
    ```

*   Khởi động lại KVM và sử dụng network mới này
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-13%2016-34-22.png)

Sử dụng GRE tunnel
**GRE tunnel**
*   Thêm cổng cho GRE tunnel vào OVS switch ` ovs-vsctl add-port virbr1 gre0 -- set interface gre0 type=gre options:remote_ip=192.168.122.132`
*   Kết quả:
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-13%2016-38-09.png)
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-13%2016-39-09.png)

#### Cấu hình máy ảo

**Host1**
*   Khởi động interface ens3 và gán ip trong dải mạng 192.168.123.0/24 `ifconfig ens3 up`, `ip addr add 192.168.123.100/24 dev ens3) 
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-13%2016-44-14.png)
**Host2**
*   Tương tự, gán ip 192.168.123.101.
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-13%2016-45-05.png)

#### Kiểm tra kết nối
**2 máy ảo nằm trên 2 host kahsc nhau**
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-13%2016-46-39.png)

*   VM1 ping VM2
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-13%2016-48-26.png)

*   VM2 ping VM1
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-13%2016-48-28.png)

Vậy ta thấy 2 máy ảo đã thông mạng với nhau giữa 2 host sử dụng LB và OVS 


