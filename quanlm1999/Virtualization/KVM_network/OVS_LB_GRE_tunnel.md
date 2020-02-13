# Mô hình
![](https://raw.githubusercontent.com/lmq1999/123/master/OVS_LB_GRE_tunnel.png)

# Cài đặt

## Host 1 (192.168.122.100)
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
    ip link add tun-1 type gretap remote 192.168.122.132 ttl 64
    ip link set dev tun-1 up
    ```
*   Gán vào bridge mặc định của LB
    ```
    ip link set dev tun-1 master virbr0
    ```
*   Ta sẽ có kết quả như sau:
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-13%2016-23-55.png)

P/s: vì sử dụng network mặc định nên bỏ qua bước gắn vnet0 vào bridge

## Host 2 (192.168.122.132)

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
*   Thêm cổng cho GRE tunnel vào OVS switch ` ovs-vsctl add-port virbr1 gre0 -- set interface gre0 type=gre options:remote_ip=192.168.122.100`
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



