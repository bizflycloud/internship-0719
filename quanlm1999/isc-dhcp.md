# DHCP 
***

### Server

**B1** Cài đặt gói: `sudo apt install isc-dhcp-server`

**B2** Cài đặt IP tĩnh cho interfaces phát DHCP.
* `vim sudo /etc/network/interfaces`
    * `auto ens3`
    `iface ens3 inet static` 
    `address 192.168.100.2`
    `netmask 255.255.255.0`
    `gateway 192.168.122.1`
    `dns-nameservers 8.8.8.8`
    `dns-nameservers 8.8.4.4`

**B3** Vào file `/etc/default/isc-dhcp-server` , điền vào interfaces nhận DHCP request ở đây interface là ens3 nên: 
* `INTERFACES="ens3"`

**B4** Vào file `/etc/dhcp/dhcpd.conf ` để config dhcp server
Ta thay đổi 1 số chỗ sau theo tình huống cần dùng: 
* `option domain-name "example.org";`
  `option domain-name-servers 192.168.100.1;`
  `default-lease-time 3600;` 
  `max-lease-time 7200;`
  `log-facility local7;`

![dhcp](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/dhcp1.png)
![dhcp2](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/dhcp2.png)

P/s: Nếu muốn gẵn ip tĩnh cho interfaces nào thì cần chỉ đích danh MAC address của nó:
VD: 
*   `host centos-node {`
	 `hardware ethernet 00:f0:m4:6y:89:0g;`
	 `fixed-address 192.168.10.105;`
 `}`

* **Enable service isc-dhcp-server**

**B5** Thiệp lập tường lửa :
* `sudo ufw allow  67/udp`
 `sudo ufw reload`
 `sudo ufw show`

**Phần thiết lập đã xong**

### Client
*** 
* Đầu tiên client chưa có địa chỉ IP: 
 
![pre](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/predhcp.png)

* Vào `/etc/network/interfaces` ta cấu hình cho interface ens3 nhận dhcp: 
    * `auto  ens3`
     * `iface ens3 inet dhcp`
* Restart lại service: `service networking restart`

* Chạy lệnh :`ip addr show` ta có: 

![after](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/afterdhcp.png)

* Chạy thử: 

![test](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/net_test.png)

* SSH thử: 

![ssh](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/sshtest.png)

Vậy đã cấu hình thành công dhcp server sử dùng isc-dhcp 


