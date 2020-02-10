



# Mô hình
![](https://raw.githubusercontent.com/lmq1999/123/master/VM.png)

# Cài đặt 
#### Node 1
*   Lập máy ảo: KVM 1
*   Xóa Linux bridges đang có sẵn: 
    *  `ifconfig virbr0 down` `brctl delbr virbr0`
*   Tải về OVS  `apt-get install openvswitch-switch`
*   Tạo OVS switch mới: `ovs-vsctl add-br virbr1`
*   Thêm interface của máy ảo đang chạy vào OVS switch: `ovs-vsctl add-port virbr1 vnet0`
*   Cấu hình địa chỉ IP cho OVS switch: `ip addr add 192.168.123.1/24 dev virbr1`
*   Cấu hình địa chỉ IP trong KVM
    *   `virsh console kvm1`
    *   `ifconfig ens3 up && ip addr add 192.168.123.2/24 dev ens3`

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-07%2016-12-05.png)|

####    Node 2
*   Lập máy ảo KVM 2
*   Sử dụng luôn Linux bridges đang có sẵn

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-07%2016-11-43.png)

####    Routing 
*   Sử dụng Ip route 

**node 2**
```
root@test:~# ip route show
default via 192.168.122.1 dev ens3 
192.168.122.0/24 dev ens3 proto kernel scope link src 192.168.122.54 
192.168.123.0/24 via 192.168.122.252 dev ens3 
192.168.124.0/24 dev virbr1 proto kernel scope link src 192.168.124.1 
```

**node 1**
```
root@test2:~# ip route show
default via 192.168.122.1 dev ens3 proto dhcp src 192.168.122.252 metric 100 
192.168.122.0/24 dev ens3 proto kernel scope link src 192.168.122.252 
192.168.122.1 dev ens3 proto dhcp scope link src 192.168.122.252 metric 100 
192.168.123.0/24 dev virbr0 proto kernel scope link src 192.168.123.1 
192.168.124.0/24 via 192.168.122.54 dev ens3 
```

**kvm 2**
```
root@kvm2:~# ip route
default via 192.168.124.1 dev ens3 proto dhcp src 192.168.124.107 metric 100 
192.168.122.0/24 via 192.168.124.1 dev ens3 
192.168.124.0/24 dev ens3 proto kernel scope link src 192.168.124.107 
192.168.124.1 dev ens3 proto dhcp scope link src 192.168.124.107 metric 100 
```

**kvm 1**
```
root@kvm1:~# ip route show
192.168.122.0/24 via 192.168.123.1 dev ens3 
192.168.123.0/24 dev ens3 proto kernel scope link src 192.168.123.2 
192.168.124.0/24 via 192.168.123.1 dev ens3 
```

#### Kiểm tra thông mạng
**KVM 1**
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot_generic_2020-02-07_16%3A10%3A21.png)
**KVM 2**
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-07%2016-11-15.png)

Ta có thể thấy 2 máy đã thông mạng với nhau
*   Chuyển file qua scp: 

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-07%2016-27-32.png)
