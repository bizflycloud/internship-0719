#   Openstack network componet
## Linux bridge
#### Thành phần: 
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack.jpg)

#### Packet flow
**Kết nối cùng node cùng mạng**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_1.jpg)
*   Gói tin đi từ VM1 qua vNIC, đến `tap interface` từ `tap interface` đi qua `brq` rồi đến `tap interface` bên VM2 
```
root@compute1:~# brctl show
bridge name	bridge id		STP enabled	interfaces
brqf1f60d52-5a		8000.b61ea1bccad8	no		tap232c0493-3a
							tapdcee7890-8e
							vxlan-58

```
**Kết nối cùng node khác mạng:**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_4.jpg)

**Kết nối khác node cùng mạng**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_5.jpg)

**Kết nối khác node khác mạng** 
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_6.jpg)

**Kết nối ra Internet**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_2.jpg)

*   Gói tin đi đến brqhttps://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_3.jpg
*   gói tin đi qua VXLAN tunnel
*   Đén interface `tap` gói tin được đưa đến interface `qr` của qrouter namspace,
*   Gói tin được gưi đi qua interface `qg` đến `tap` bridge kết nối với interface vật lý ra ngoài mạng .

```
root@controller:~# ip netns exec qrouter-c798c2f8-6a21-4c82-8b65-d269a4f1eff8 ip addr list
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
4: qg-2810aeb2-90@if13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether fa:16:3e:7f:71:6c brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.122.214/24 brd 192.168.122.255 scope global qg-2810aeb2-90
       valid_lft forever preferred_lft forever
    inet 192.168.122.227/32 brd 192.168.122.227 scope global qg-2810aeb2-90
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fe7f:716c/64 scope link 
       valid_lft forever preferred_lft forever
5: qr-35b67b58-55@if19: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
    link/ether fa:16:3e:a9:a7:4e brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 10.0.0.1/24 brd 10.0.0.255 scope global qr-35b67b58-55
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fea9:a74e/64 scope link 
       valid_lft forever preferred_lft forever
```

**Cấp phát DHCP**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_3.jpg)
*   Gói tin đi theo đường tương tự, nhưng sau khi đến  `tap` của `brq`  nối với `ens4`, gói tin được đẩy đến `ns` của qDHCP namcespace.
*   Openstack sử dụng `dnsmaq` để cấp phát DHCP cho  VM
*   Ta có thể thấy trong `/var/log/syslog` 
    ```
    Feb 26 08:48:21 controller dnsmasq-dhcp[5852]: DHCPDISCOVER(ns-3dfffc2d-f2) fa:16:3e:3b:4d:c4
    Feb 26 08:48:21 controller dnsmasq-dhcp[5852]: DHCPOFFER(ns-3dfffc2d-f2) 10.0.0.135 fa:16:3e:3b:4d:c4
    Feb 26 08:48:21 controller dnsmasq-dhcp[5852]: DHCPREQUEST(ns-3dfffc2d-f2) 10.0.0.135 fa:16:3e:3b:4d:c4
    Feb 26 08:48:21 controller dnsmasq-dhcp[5852]: DHCPACK(ns-3dfffc2d-f2) 10.0.0.135 fa:16:3e:3b:4d:c4 host-10-0-0-135
    ```
*   tap interface có MAC addr tương ứng:
    ```
    14: tapdcee7890-8e: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc fq_codel master brqf1f60d52-5a state UNKNOWN group default qlen 1000
    link/ether fe:16:3e:3b:4d:c4 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::fc16:3eff:fe3b:4dc4/64 scope link 
       valid_lft forever preferred_lft forever
    ```
*   Tắt máy, giải phóng IP:
    ```
    Feb 26 08:47:54 controller dnsmasq-dhcp[5852]: DHCPRELEASE(ns-3dfffc2d-f2) 10.0.0.135 fa:16:3e:3b:4d:c4
    ```
```
root@controller:~# ps -ef | grep dnsmasq
nobody    5839     1  0 07:12 ?        00:00:00 dnsmasq --no-hosts --no-resolv --pid-file=/var/lib/neutron/dhcp/9ad36917-4615-4fa0-9659-e7722e0da213/pid --dhcp-hostsfile=/var/lib/neutron/dhcp/9ad36917-4615-4fa0-9659-e7722e0da213/host --addn-hosts=/var/lib/neutron/dhcp/9ad36917-4615-4fa0-9659-e7722e0da213/addn_hosts --dhcp-optsfile=/var/lib/neutron/dhcp/9ad36917-4615-4fa0-9659-e7722e0da213/opts --dhcp-leasefile=/var/lib/neutron/dhcp/9ad36917-4615-4fa0-9659-e7722e0da213/leases --dhcp-match=set:ipxe,175 --dhcp-userclass=set:ipxe6,iPXE --local-service --bind-dynamic --dhcp-range=set:subnet-bfd1c109-8b81-4587-9dae-80d2ee160a72,192.168.122.0,static,255.255.255.0,86400s --dhcp-option-force=option:mtu,1500 --dhcp-lease-max=256 --conf-file= --domain=openstacklocal
nobody    5852     1  0 07:12 ?        00:00:00 dnsmasq --no-hosts --no-resolv --pid-file=/var/lib/neutron/dhcp/f1f60d52-5ace-4f28-a229-d0020f5da4d6/pid --dhcp-hostsfile=/var/lib/neutron/dhcp/f1f60d52-5ace-4f28-a229-d0020f5da4d6/host --addn-hosts=/var/lib/neutron/dhcp/f1f60d52-5ace-4f28-a229-d0020f5da4d6/addn_hosts --dhcp-optsfile=/var/lib/neutron/dhcp/f1f60d52-5ace-4f28-a229-d0020f5da4d6/opts --dhcp-leasefile=/var/lib/neutron/dhcp/f1f60d52-5ace-4f28-a229-d0020f5da4d6/leases --dhcp-match=set:ipxe,175 --dhcp-userclass=set:ipxe6,iPXE --local-service --bind-dynamic --dhcp-range=set:subnet-7bd43d34-da5d-45d0-9ecb-46c8aeb35b19,10.0.0.0,static,255.255.255.0,86400s --dhcp-option-force=option:mtu,1450 --dhcp-lease-max=256 --conf-file= --domain=openstacklocal
root      9154  6564  0 09:06 pts/1    00:00:00 grep --color=auto dns
```
Trên mỗi subnet tạo ra thì có 1 qDHCP namespace cho n

## Openvswitch
#### Thành phần:
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_ovs.jpg)
Mỗi VM sẽ có cặp qvo và qvb đi với nh
```
qvoa71ca823-6b@qvba71ca823-6b: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master ovs-system state UP group default qlen 1000
    link/ether fe:9e:cd:5b:50:67 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::fc9e:cdff:fe5b:5067/64 scope link 
       valid_lft forever preferred_lft forever
17: qvba71ca823-6b@qvoa71ca823-6b: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master qbra71ca823-6b state UP group default qlen 1000
    link/ether a2:31:c5:85:29:fb brd ff:ff:ff:ff:ff:ff
    inet6 fe80::a031:c5ff:fe85:29fb/64 scope link 
       valid_lft forever preferred_lft forever

```
#### Packet flow
**Cùng node cùng mạng** 
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_ovs_1.jpg)

**Khác node cùng mạng**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_ovs_4.jpg)

**Internet**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_ovs_2.jpg)

**Khác node khác mạng** 
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_ovs_3.jpg)

**DHCP**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/network_flow_openstack_ovs_5.jpg)
Trên qDHCP namespace khi sử dụng OVS sử dụng port `tap` thay vì port `ns` như trên LB
```
root@controller:~# ip netns exec qdhcp-edeafb45-23ce-4fde-9ae9-be0dd9651886 ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
11: tap1984f1bd-49: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether fa:16:3e:be:30:da brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.2/24 brd 10.0.0.255 scope global tap1984f1bd-49
       valid_lft forever preferred_lft forever
    inet 169.254.169.254/16 brd 169.254.255.255 scope global tap1984f1bd-49
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:febe:30da/64 scope link 
       valid_lft forever preferred_lft forever

```
