# Linux Bridge overview

###  Giới thiệu

**Linux bridge** là một soft switch –  1 trong 3 công nghệ cung cấp switch ảo trong hệ thống Linux (bên cạnh macvlan và OpenvSwitch), giải quyết vấn đề ảo hóa network bên trong các máy vật lý. 

-	Bản chất, linux bridge sẽ tạo ra các switch layer 2 kết nối các máy ảo (VM) để các VM đó giao tiếp được với nhau và có thể kết nối được ra mạng ngoài. Linux bridge thường sử dụng kết hợp với hệ thống ảo hóa KVM-QEMU.

-	Linux Bridge thật ra chính là một switch ảo và được sử dụng với ảo hóa KVM/QEMU. ***Nó là 1 module trong nhân kernel***. Sử dụng câu lệnh `brctl` để quản lý .

-	Mô tả linux bridge (trường hợp cơ bản nhất):
![](http://imgur.com/LpMlNof.jpg)

###  Cấu trúc hệ thống sử dụng  Linux bridge

![](http://imgur.com/7d8bY6u.jpg)

Khái niệm về physical port và virtual port:

*    **Virtual Computing Device**: Thường được biết đến như là máy ảo VM chạy trong host server 

* **Virtual NIC (vNIC)**: máy ảo VM có virtual network adapters(vNIC) mà đóng vai trò là NIC cho máy ảo.

* **Physical swtich port**: Là port sử dụng cho Ethernet switch, cổng vật lý xác định bởi các port RJ45. Một port RJ45 kết nối tới port trên NIC của máy host.

* **Virtual swtich port**: là port ảo tồn tại trên virtual switch. Cả virtual NIC (vNIC) và virtual port đều là phần mềm, nó liên kết với virtual cable kết nối vNIC


#   Tìm hiểu Linux Bridge


### Cấu trúc và các thành phần

**Cấu trúc Linux Bridge:**

![](http://imgur.com/J0ZvKPk.jpg)

Một số khái niệm liên quan tới linux bridge:

*	**Port**: tương đương với port của switch thật

*	**Bridge**: tương đương với switch layer 2

*	**Tap**: hay tap interface có thể hiểu là giao diện mạng để các VM kết nối với bridge cho linux bridge tạo ra (nó nằm trong nhân kernel, hoạt động ở lớp 2 của mô hình OSI-datalink) 

*	**fd**: forward data - chuyển tiếp dữ liệu từ máy ảo tới bridge.

### Các tính năng

*	**STP**: Spanning Tree Protocol - giao thức chống loop gói tin trong mạng.

*	**VLAN**: chia switch (do linux bridge tạo ra) thành các mạng LAN ảo, cô lập traffic giữa các VM trên các VLAN khác nhau của cùng một switch.

*	**FDB**: chuyển tiếp các gói tin theo database để nâng cao hiệu năng switch.

# Các thao tác quản lý Linux Bridge

### Cài đặt công cụ phần mềm quản lý Linux Bridge

Linux bridge được hỗ trợ từ version nhân kernel từ 2.4 trở lên. Để sử dụng và quản lý các tính năng của linux birdge, cần cài đặt gói bridge-utilities (dùng các câu lệnh `brctl` để sử dụng linux bridge). Cài đặt dùng lệnh như sau: 

`sudo  apt-get install bridge-ultils -y `

### Một số câu lệnh quản lý

#### Bridge management

|ACTION	|BRCTL	|
|-|-|
|Tao bridge|	`brctl addbr <bridge>`|
|xóa bridge|	`brctl delbr <bridge>`|
|thêm interface vào bridge	| `brctl addif <bridge> <ifname>`	|
|xóa interface trong bridge |	`brctl delbr <bridge>`| 


#### FDB MANAGEMENT

|ACTION	|BRCTL	|BRIDGE|
|-|-|-|
|Shows a list of MACs in FDB|	`brctl showmacs <bridge>`	|`bridge fdb show`|
|Sets FDB entries ageing time|	`brctl setageingtime  <bridge> <time>`|	|
|Sets FDB garbage collector interval|	`brctl setgcint <brname> <time>`| |	
|Adds FDB entry	|	|`bridge fdb add dev <interface> [dst, vni, port, via]`|
|Appends FDB entry|		|`bridge fdb append` (parameters same as for fdb add)|
|Deletes FDB entry|		|`bridge fdb delete ` (parameters same as for fdb add)|

#### STP MANAGEMENT

|ACTION	|BRCTL	|BRIDGE|
|-|-|-|
|Turning STP on/off	|`brctl stp <bridge> <state>`| |	
|Setting bridge priority|	`brctl setbridgeprio <bridge> <priority>`	| |
|Setting bridge forward delay|	`brctl setfd <bridge> <time>`	| |
|Setting bridge 'hello' time|	`brctl sethello <bridge> <time>`| |	
|Setting bridge maximum message age|	`brctl setmaxage <bridge> <time>`	| |
|Setting cost of the port on bridge|	`brctl setpathcost <bridge> <port> <cost>`|	`bridge link set dev <port> cost <cost>`|
|Setting bridge port priority	|`brctl setportprio <bridge> <port> <priority>`|	`bridge link set dev <port> priority <priority>`|
|Should port proccess STP BDPUs	|	|`bridge link set dev <port > guard [on, off]`|
|Should bridge might send traffic on the port it was received|		|`bridge link set dev <port> hairpin [on,off]`|
|Enabling/disabling fastleave options on port|		|`bridge link set dev <port> fastleave [on,off]`|
|Setting STP port state	|	|`bridge link set dev <port> state <state>`|

#### VLAN MANAGEMENT

|ACTION|	BRCTL|	BRIDGE|
|-|-|-|
|Creating new VLAN filter entry|		|`bridge vlan add dev <dev> [vid, pvid, untagged, self, master]`|
|Delete VLAN filter entry	|	|`bridge vlan delete dev <dev>` (parameters same as for vlan add)|
|List VLAN configuration|		|`bridge vlan show`|


#### Cấu hình linux bridge khởi động cùng hệ điều hành

* Khi tạo bridge bằng command brctl addbr thì bridge là non-persistent bridge (tức là sẽ không có hiệu lực khi hệ thống khởi động lại).

    `brctl addbr br1 `

* Ban đầu, khi mới được tạo, bridge sẽ có một địa chỉ MAC mặc định ban đầu. Khi thêm một NIC của host vào thì MAC của bridge sẽ là MAC của NIC luôn. Khi del hết các NIC của host trên bridge thì MAC của bridge sẽ về là 00:00:00:00:00:00 và chờ khi nào có NIC khác add vào thì sẽ lấy MAC của NIC đó.

* Khi cấu hình bằng câu lệnh `brctl`, các ảnh hưởng của nó sẽ biến mất sau khi khởi động lại hệ thống host server. Để lưu lại thông tin cấu hình trên bridge và khởi động lại cùng hệ thống thì nên lưu lại cấu hình vào file (Ghi vào file, khi boot lại hệ thống, thông tin trong file cũng được cấu hình lại. Những thông tin được lưu dưới dạng file, thì luôn khởi động cùng hệ thống - nên có thể coi là vĩnh viễn - trừ khi tự tay stop lại dịch vụ.)

* Cấu hình trong file /etc/network/interfaces

    ```
    # This file describes the network interfaces available on your system
    # and how to activate them. For more information, see interfaces(5).
    # The loopback network interface
    auto lo 
    iface lo inet loopback
    # Set up interfaces manually, avoiding conflicts with, e.g., network manager
    iface eth0 inet manual
    iface eth1 inet manual
    # Bridge setup
    auto br0
    iface br0 inet static
        bridge_ports eth0 eth1
        address 192.168.1.2         # Địa chỉ của br1 có thể là cùng dải địa chỉ của eth0 hoặc eth1 tùy ý. 
        broadcast 192.168.1.255
        netmask 255.255.255.0
        gateway 192.168.1.1
    ```

    Khi khởi động lại, hệ thông sẽ đọc file cấu hình, và cấp địa chỉ cho interface br0 (đại điện cho bridge br0) thông qua liên kết giữa eth0 và mạng 192.168.1.0/24. Và các máy VM kết nối tới bridge, lấy chung dải mạng với bridge thông qua liên kết uplink qua eth0 và có thể liên lạc với mạng bên ngoài.
