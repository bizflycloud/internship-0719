### Cài đặt PPTP VPN Server
**B1: Cài đặt**
* Sử dụng câu lệnh sau để cài đặt:`apt-get install pptpd`
* Truy cập vào file `/etc/pptpd.conf` add thêm localip và remoteip
    * Trong đó: local ip là ip của server, remote ip là ip của client kết nối đến server đó
    * Ví dụ:    
        `localip 10.0.0.1`
        `remoteip 10.0.0.100-200`
* Truy cập vào file `/etc/ppp/chap-secrets` thêm vào các `user   server  secret(password )   IP address`
    * Ví dụ: `quan1     pptpd   123456  *`

**B2: thêm dns server**
* Truy cập file `/etc/ppp/pptpd-options` sau đó thêm vào dns server: 
    * `ms-dns 8.8.8.8`
    *  `ms-dns 8.8.4.4`
     
* Restart lại service: `service pptpd restart`

**B3: thiết lập forwarding**
* Truy cập file` /etc/sysctl.conf ` thêm dòng sau nếu chưa có :`net.ipv4.ip_forward = 1`
* Cập nhật thay đổi sử dụng câu lệnh :`sysctl -p`

**B4: Thiết lập NAT rules cho iptables** 
* `iptables -t nat -A POSTROUTING -o {interface} -j MASQUERADE && iptables-save`
* Nếu muốn cho client có thể liên lạc với nhau trong vpn
    * `iptables --table nat --append POSTROUTING --out-interface ppp0 -j MASQUERADE`
    * `iptables -I INPUT -s 10.0.0.0/8 -i ppp0 -j ACCEPT`
    * `iptables --append FORWARD --in-interface {interface} -j ACCEPT`

#### Cài đặt client 
**B1**
* Tải xuống:  `apt install pptp-linux` 
* Thêm module vào kernel: `modprobe ppp_mppe`

**B2**
* Tạo file `/etc/ppp/peers/{tên vpn}` có nội dung như sau:
    * pty "pptp {serverip} --nolaunchpppd"
    * name quan1
    * password 123456
    * remotename PPTP
    * require-mppe-128
* Trong đó, name và password được ghi ở file `/etc/ppp/chap-secrets` bên server 

* Kết nối đến  server : `pppd call {tên vpn }` 
* Add route đến VPN: `ip route add 10.0.0.0/8 dev ppp0`



# Salt
File PPTP_VPN: https://gist.github.com/lmq1999/fab2e6684509c67349db84f55bc02997
* Chạy state: `sudo salt '*' state.apply PPTP_VPN`

![vpn](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/PPTPPVN_install.png)

* Chaỵ lệnh: `sudo salt'*' cmd.run 'sysctl -p`'
* Output:

    `quan@quanlm:/srv/salt$ sudo salt '*' cmd.run 'sysctl -p'`
   ` ubuntu:`
   ` net.ipv4.ip_forward = 1`
là được.

Thiết lập rule iptables: 
![ip](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/PPTPVPN_iptables.png)

Trên client: sau khi ta chạy `pppd call vpn`: ta có thể thấy trên server: 
![log](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/syslog.png)

và sau khi `ip route add` :
![ifconfig](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/ifconfig.png)

test thử kết nối: 
![test](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/vpn_test.png)




