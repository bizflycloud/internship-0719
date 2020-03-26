# Docker là gì
Docker là một ứng dụng mã nguồn mở cho phép độc lập triển khai giữa các ứng dụng và cơ sở hạ tầng.

# Chức năng, vai trò của Docker

Cho phép phát triển, di chuyển và chạy các ứng dụng dựa vào công nghệ ảo hóa container trong Linux.

Tự động triển khai các ứng dụng bên trong các container bằng cách cung cấp thêm một lớp trừu tượng và tự động hóa việc ảo hóa "mức hệ điều hành".

Docker có thể sử dụng được trên cả 3 hệ điều hành phổ biến: Windows, Linux và Mac OS.

Lợi ích của docker bao gồm:
* Nhanh trong việc triển khai, di chuyển, khởi động container
* Bảo mật
* Lightweight (tiết kiệm disk & CPU)
* Mã nguồn mở
* Hỗ trợ APIs để giao tiếp với container
* Phù hợp trong môi trường làm việc đòi hòi phải liên tục tích hợp và triển khai các dịch vụ, phát triển cục bộ, các ứng dụng multi-tier.

# Các khái niệm trong docker

#### Image
* Image trong Docker hay còn gọi là Mirror. Là một template có sẵn (hoặc có thể tự tạo) với các chỉ dẫn dùng để tạo ra các container
* Được xây dựng từ một loạt các layers. Mỗi layer là một kết quả đại diện cho một lệnh trong Dockerfile.
* Lưu trữ dưới dạng read-only template.

#### Registry
*   Docker Registry là nơi lưu trữ các image với hai chế độ là private và public.
*   Là nơi cho phép chia sẻ các image template để sử dụng trong quá trình làm việc với Docker.

#### Volume
* Volume trong Docker là nơi dùng để chia sẻ dữ liệu cho các container.
* Có thể thực hiện sử dụng Volume đối với 2 trường hợp:
    *   Chia sẻ giữa container với container.
    *   Chia sẻ giữa container và host.

#### Container
*    Docker Container là một thể hiện của Docker Image với những thao tác cơ bản để sử dụng qua CLI như start, stop, restart hay delete, ...

*    Container Image là một gói phần mềm thực thi lightweight, độc lập và có thể thực thi được bao gồm mọi thứ cần thiết để chạy được nó: code, runtime, system tools, system libraries, settings. Các ứng dụng có sẵn cho cả Linux và Windows, các container sẽ luôn chạy ổn định bất kể môi trường.
![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/images/docker-container-images.png)

* Containers and virtual machines có sự cách ly và phân bổ tài nguyên tương tự, nhưng có chức năng khác vì các container ảo hóa hệ điều hành thay vì phần cứng. Các container có tính portable và hiệu quả hơn.

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/images/docker-container-vms.png)

* Container là một sự trừu tượng hóa ở lớp ứng dụng và code phụ thuộc vào nhau. Nhiều container có thể chạy trên cùng một máy và chia sẻ kernel của hệ điều hành với các container khác, mỗi máy đều chạy như các quá trình bị cô lập trong không gian người dùng. Các container chiếm ít không gian hơn các máy ảo (container image thường có vài trăm thậm chí là vài MB), và start gần như ngay lập tức.

* Máy ảo (VM) là một sự trừu tượng của phần cứng vật lý chuyển tiếp từ một máy chủ sang nhiều máy chủ. Hypervisor cho phép nhiều máy ảo chạy trên một máy duy nhất. Mỗi máy ảo bao gồm một bản sao đầy đủ của một hệ điều hành, một hoặc nhiều ứng dụng, các chương trình và thư viện cần thiết - chiếm hàng chục GB. Máy ảo cũng có thể khởi động chậm.

#### Dockerfile

*   Docker Image có thể được tạo ra một cách tự động bằng việc đọc các chỉ dẫn trong Dockerfile.

*   Dockerfile là một dữ liệu văn bản bao gồm các câu lệnh mà người sử dụng có thể gọi qua các dòng lệnh để tạo ra một image.

*   Bằng việc sử dụng `docker build` người dùng có thể tạo một tự động xây dựng thực hiện một số lệnh dòng lệnh liên tiếp.

####    Các thành phần, kiến trúc trong Docker

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/images/docker-engine-components-flow.png)

*   Máy chủ đảm nhiệm thực hiện quá trình daemon (chạy câu lệnh **dockerd**).
*   REST API xác định các giao diện mà các chương trình có thể sử dụng để nói chuyện với daemon và hướng dẫn nó phải làm gì.
*   CLI (chạy câu lệnh **docker**).
    * CLI sẽ sử dụng Docker REST API để kiểm soát hoặc tương tác với Docker daemon thông qua kịch bản hoặc lệnh CLI trực tiếp.
    
    ![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/images/docker-architecture.png)

    * Docker sử dụng kiến trúc client-server. Docker client sẽ giao tiếp với Docker daemon các công việc building, running và distributing các Docker Container.

    * Docker client và Docker daemon có thể chạy cùng trên một hệ thống hoặc ta có thể kết nối một Docker client tới một remote Docker daemon. Docker client và Docker daemon liên lạc với nhau bằng việc sử dụng REST API thông qua UNIX sockets hoặc network interfaces.

    * Docker daemon (dockerd ) sẽ lắng nghe các request từ Docker API và quản lý Docker objects bao gồm images, containers, networks và volumes. Một daemon cũng có thể liên lạc với các daemons khác để quản lý Docker services.

    * Docker client (docker ) là con đường chính để những người sử dụng Docker tương tác và giao tiếp với Docker. Khi sử dụng mộ câu lệnh chẳng hạn như `docker run` thì client sẽ gửi câu lệnh tới dockerd để thực hiện câu lệnh. Các câu lệnh từ Docker client sử dụng Docker API và có thể giao tiếp với nhiều Docker daemon.

#### Các trạng thái, sự chuyển giao trạng thái của container trong Docker

**Vòng đời của container trong Docker**
![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/images/docker-state.png)

#### Network trong Docker

**Container Networking Model (CNM).**

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/images/docker-network-models.png)

**Ta có:**
* **Sandbox** - Chứa các cấu hình của ngăn xếp mạng container. Bao gồm quản lý network interface, route table và các thiết lập DNS. Một Sandbox có thể được coi là một namespace network và có thể chứa nhiều endpoit từ nhiều mạng.

* **Endpoint** - Là điểm kết nối một Sandbox tới một mạng.

* **Network** - CNM không chỉ định một mạng tuân theo mô hình OSI. Việc triển khai mạng có thể là VLAN, Bridge, ... Các endpoint không kết nối với mạng thì không có kết nối trên mạng.

* CNM cung cấp 2 interface có thể được sử dụng cho việc liên lạc, điều khiển, ... container trong mạng:

    * **Network Drivers** - Cung cấp, thực hiện thực tế việc tạo ra một mạng hoạt động. Được sử dụng với các drivers khác và thay đổi một cách dễ dàng đối với các trường hợp cụ thể. Nhiều network driver có thể được sử dụng trong Docker nhưng mỗi một network chỉ là một khởi tạo từ một network driver duy nhất. Theo đó mà ta có 2 loại chính của CNM network drivers như sau:

        * **Native Network Drivers** - Là một phần của Docker Engine và được cung cấp bới Docker. Có nhiều drivers để dễ dàng lựa chọn cho khả năng của mạng như overlay networks hay local bridges.

        * **Remote Network Drivers** - Là các network drivers được tạo ra bởi cộng đồng và các nhà cung cấp. Được sử dụng để tích hợp vào các phần mềm hoặc phần cứng đang hoạt động.

* **IPAM Drivers**: Drivers quản lý các địa chỉ IP cung cấp mặc định cho các mạng con hoặc địa chỉ IP cho các mạng và endpoint nếu chúng không được chỉ định. Địa chỉ IP cũng có thể gán thủ công qua mạng, container, ...

**Giao tiếp giữa docker engine - libnetwork - driver**

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/images/docker-ipam-network.png)

**Docker Native Network Drivers** - là một phần của Docker Engine và không yêu cầu cần phải có nhiều modules. Được gọi và sử dụng thông qua các câu lệnh **Docker network**, Dưới đây là native network hiện có:

| Driver | Mô tả |
| ------------- | ------------- |
| Host | Với host driver, một container sẽ sử dụng ngăn xếp mạng của host. Không có sự phân biệt giữa namespace, tất cả các interface trên host có thể được sử dụng trực tiếp bởi container |
| Bridge | Bridge driver tạo ra Linux bridges trên host và được quản lý bởi Docker. Mặc định, containers trên một bridge có thể liên lạc với nhau. Việc truy cập từ bên ngoài tới các container có thể được cấu hình thông qua bridge driver.  |
| Overlay | Overlay driver tạo ra một overlay network hỗ trợ cho các mạng multi-host. Được sử dụng kết hợp với Linux bridges và VXLAN để che đi liên lạc giữa các container qua cơ sở mạng hạ tầng vật lý. |
| MACVLAN | MACVLAN driver sử dụng chế độ MACVLAN bridge để thiết lập kết nối giữa container interface và host interface (hoặc sub-interface). Nó có thể được sử dụng để cung cấp địa chỉ IP cho các container và định tuyến trên mạng vật lý. Ngoài ra VLANs có thể được trunked đến MACVLAN driver |
| None | None driver cho một ngăn xếp mạng riêng và namespace nhưng không cấu hình interfaces bên trong container. Nếu không có cấu hình bổ sung, container hoàn toàn bị cô lập khỏi mạng của host |

**Đối với native driver network trong container. Ta có**
*   Chiều outbound khi các container sử dụng trong container 
![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/images/docker-native-network-out.png)

*   Chiều inbound khi các container sử dụng trong container 

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/images/docker-native-network-in.png)

* Container kết nối với network thông quan docker0 interface:

![](https://raw.githubusercontent.com/hocchudong/ghichep-docker/master/images/docker-native-network-inhost.png)

![](https://image.slidesharecdn.com/containernetworkingdeepdive-170414164547/95/container-networking-deep-dive-19-1024.jpg?cb=1492188410)
*   Các interface, bridges trên máy labs
```
root@docker-labs:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: ens3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:dc:41:9f brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.131/24 brd 192.168.122.255 scope global ens3
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fedc:419f/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:fb:28:eb:5d brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:fbff:fe28:eb5d/64 scope link 
       valid_lft forever preferred_lft forever
21: veth2b43262@if20: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default 
    link/ether b2:c3:21:3f:a1:4e brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::b0c3:21ff:fe3f:a14e/64 scope link 
       valid_lft forever preferred_lft forever
25: vetha4b5987@if24: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default 
    link/ether d2:c4:15:e2:c1:12 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::d0c4:15ff:fee2:c112/64 scope link 
       valid_lft forever preferred_lft forever

```
```
root@docker-labs:~# brctl show
bridge name     bridge id               STP enabled     interfaces
docker0         8000.0242fb28eb5d       no              veth2b43262
                                                        vetha4b5987

```

#### Volume trong Docker

* Volume là một thư mục đặc biệt được chỉ định trong một hoặc nhiều container.

* Volumes được thiết kế để duy trì dữ liệu, độc lập với vòng đời của container.

* Do đó, Docker sẽ không bao giờ tự động xóa volumes khi ta xóa bỏ containers. Còn được biết đến là `data volume`.

* Có 3 kiểu volume đó là: host, anonymous, named:

    * `host volume` - tồn tại trên filesystem của Docker host và có thể được truy cập từ bên trong container.
    
    * `named volume`- là volume được Docker quản lý và được đặt tên.
    
    * `anonymous volume`- tương tự như `named volume`. Tuy nhiên rất khó để có thể tham vấn tới cùng một volume theo thời gian khi volume là một đối tượng vô danh. Lưu trữ các tập tin mà Docker xử lý.

____

# Cài đặt Docker Community Engine
****
####    Cài đặt sử dụng repository

Cập nhật chỉ mục:  `apt update`

Cài đắt gói cho phép sử dụng repository qua HTTPS
`sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common`

Thêm GPG key của Docker
`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

Kiểm tra keyprint có giống không: `9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88`
Kiểm tra 8 ký tự ở cuối sử dụng câu lệnh: 
```
sudo apt-key fingerprint 0EBFCD88
    
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```

Thêm repository:
```
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
####   Cài đặt Docker Engine - Community
Cập nhât chỉ mục `sudo apt-get update`

Cài Docker engine community
`sudo apt-get install docker-ce docker-ce-cli containerd.io`

Sau khi cài xong, chạy `sudo docker run hello-world` để kiểm tra 
Kết quả:
```
root@docker-labs:~# docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

#### Cài đặt sử dụng gói
Truy cập https://download.docker.com/linux/ubuntu/dists/
Chọn phiên bản ubuntu, dẫn đến `pool/stable/`
Chọn bản phù hợ với phần cứng, chọn bản muốn cài đặt download về

Cài đặt gói sử dụng: `sudo dpkg -i  <vị trí file>.deb`

Kiểm tra sử dụng câu lệnh ` sudo docker run hello-world`

****
# Một số thao tác với docker

#### Chạy một container

**Chạy một container tức là khởi chạy một ứng dụng nào đó trong container**
```
root@docker-labs:~# docker run busybox echo 'TEST'
TEST
```

Ta có thể thấy khi chạy lệnh `docker ps`
```
CONTAINER ID        IMAGE                       COMMAND                  CREATED             STATUS                      PORTS               NAMES
5a21162c7441        busybox                     "echo TEST"              27 seconds ago      Exited (0) 26 seconds ago                       suspicious_blackwell

```
```
root@docker-labs:~# docker run busybox route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         172.17.0.1      0.0.0.0         UG    0      0        0 eth0
172.17.0.0      *               255.255.0.0     U     0      0        0 eth0

root@docker-labs:~# docker ps --all
CONTAINER ID        IMAGE                       COMMAND                  CREATED              STATUS                          PORTS               NAMES
e85442b0d827        busybox                     "route"                  5 seconds ago        Exited (0) 3 seconds ago                            clever_swirles
```

Ta có thể thấy:

Cú pháp của câu lệnh là `docker run <image> <commands >`. Trong đó:

*   docker: là tên lệnh để máy cài docker thực hiện thao tác với docker bằng CLI.
*   run: là tùy chọn để thực hiện, ngoài run còn nhất nhiều các tùy chọn khác như images, pull, rm..., chúng ta sẽ khám phá sau.
*   busybox: là tên images dùng để tạo các container.
*   echo, route: là các lệnh sẽ được truyền vào trong container thực hiện.

Khi thực hiện lệnh `docker run` thì máy sẽ tiến hành tìm kiếm images được chỉ định trong **localhost**, nếu không có thì mặc nó sẽ thực hiện pulled từ **registry Docker Hub** về máy cài docker. Registry Docker Hub là một kho lưu trữ các images. Ta cũng có thể sử dụng một registry local - tức là một registry offline trong nội bộ mạng LAN.

**Thao tác với một container với chế độ tương tác**
`
root@docker-labs:~# docker run -i busybox
`
```
ls
bin
dev
etc
home
proc
root
sys
tmp
usr
var
route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         172.17.0.1      0.0.0.0         UG    0      0        0 eth0
172.17.0.0      *               255.255.0.0     U     0      0        0 eth0
```
`docker run -t busybox`
```
root@docker-labs:~# docker run -t busybox
/ # ls

^C
/ # 
```

`docker run -it busybox`
```
root@docker-labs:~# docker run -it busybox
/ # ls
bin   dev   etc   home  proc  root  sys   tmp   usr   var
/ # route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         172.17.0.1      0.0.0.0         UG    0      0        0 eth0
172.17.0.0      *               255.255.0.0     U     0      0        0 eth0
/ # 
```

Ta có thể thấy trong phần trên ta đã sử dụng tùy chọn -it, trong đó -i là tùy chọn sử dụng để tạo container với chế độ tương tác, tùy chọn -t là tùy chọn mở ra một phiên làm việc. Nếu chỉ sử dụng tùy chọn -i thì chúng ta sẽ mở ra một section và đóng lại luôn. Nếu sử dụng chỉ tùy chọn -t thì sẽ mở ra một section và không thao tác được.

**Tạo một container với chế độ deamon,**sử dụng tùy chọn `-d`

Thông thường, khi tạo một container với các tùy chọn trước thì sau khi tạo xong hoặc thoát container thì ngay lập tức container đó sẽ dừng hoạt động. Trong một số trường hợp ta sẽ cần các container chạy ngầm, trong trường hợp này ta sử dụng tùy chọn -d.

`docker run -d httpd`
```
root@docker-labs:~# docker run -d httpd
e1d5d40f31ffcfe2a0abf095073b924c924fdd02a4235e431a94173eb644fe7a
```
Ta kiểm tra trên `docker ps`
```
root@docker-labs:~# docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS               NAMES
e1d5d40f31ff        httpd               "httpd-foreground"   5 seconds ago       Up 4 seconds        80/tcp              modest_rubin
root@docker-labs:~# docker ps -a
CONTAINER ID        IMAGE                       COMMAND                  CREATED             STATUS                      PORTS               NAMES
e1d5d40f31ff        httpd                       "httpd-foreground"       14 seconds ago      Up 12 seconds               80/tcp              modest_rubin
e51fa6676e32        busybox                     "sh"                     6 minutes ago       Exited (0) 5 minutes ago                        hopeful_elbakyan
f4623dbb61b4        busybox                     "sh"                     6 minutes ago       Exited (0) 6 minutes ago                        quirky_black
182606f0cb2e        busybox                     "sh"                     12 minutes ago      Exited (0) 10 minutes ago                       keen_hoover
e85442b0d827        busybox                     "route"                  20 minutes ago      Exited (0) 20 minutes ago                       clever_swirles
5a21162c7441        busybox                     "echo TEST"              21 minutes ago      Exited (0) 21 minutes ago                       suspicious_blackwell

```
Ở cột `STATUS` ta có thế thấy  container vừa tạo vẫn **Up**, trong khi những container trước đó đã **Exited**

**Tạo một container với port chỉ định** sử dụng tùy chọn `-p`

Nếu không chỉ định tùy chọn `-p` cho container thì thường container sinh ra sẽ có một port mặc định nào đó, lúc đó ta muốn sử dụng container đó thì phải đứng ở máy chứa container và thao tác.

Do vậy, để ánh xạ port của container ra bên ngoài - giúp các máy ngoài container có thể sử dụng được thì ta cần dùng tùy chọn -p

Tạo ra một container chạy web và ánh xạ **port 4000 của máy host** tới **port 80 của container** được sinh ra.

`docker run -d -p 4000:80 httpd`
```
root@docker-labs:~# docker run -d -p 4000:80 httpd
d191f46b282ec5047c86db1168fd10f785c56fa9d22568ce9e532817c2ccc01f
root@docker-labs:~# docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                  NAMES
d191f46b282e        httpd               "httpd-foreground"   5 seconds ago       Up 3 seconds        0.0.0.0:4000->80/tcp   funny_knuth
```

Tra trên `netstat`
```
root@docker-labs:~# netstat -tupln | grep 4000
tcp6       0      0 :::4000                 :::*                    LISTEN      6198/docker-proxy   
```

Sử dụng lên **curl** ở trên máy host:
```
quanlm@quanlm-desktop:~$ curl 192.168.122.131:4000
<html><body><h1>It works!</h1></body></html>
```

Sử dụng tùy chọn `-P` để ánh xạ 1 port ngẫu nhiên:
```
root@docker-labs:~# docker run -d -P nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
68ced04f60ab: Already exists 
28252775b295: Pull complete 
a616aa3b0bf2: Pull complete 
Digest: sha256:2539d4344dd18e1df02be842ffc435f8e1f699cfc55516e2cf2cb16b7a9aea0b
Status: Downloaded newer image for nginx:latest
cc2febe0f23e83468904cb4cbdb7d2a3df17324d85ccf00e37359bdd46573df1

root@docker-labs:~# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                   NAMES
cc2febe0f23e        nginx               "nginx -g 'daemon of…"   59 seconds ago      Up 56 seconds       0.0.0.0:32768->80/tcp   vigorous_dewdney

```

Sử dụng lên **curl**
```
quanlm@quanlm-desktop:~$ curl 192.168.122.131:32768
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at 
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

```
**Thao tác với container đang chạy**

Để thảo tác với 1 container đang chạy, ta sử dụng câu lệnh `docker exec -it <container_ID> /bin/bash`
`docker exec -it cc2febe0f23e /bin/bash`
```
root@docker-labs:~# docker exec -it cc2febe0f23e /bin/bash
root@cc2febe0f23e:/# ls
bin  boot  dev	etc  home  lib	lib64  media  mnt  opt	proc  root  run  sbin  srv  sys  tmp  usr  var
root@cc2febe0f23e:/# exit
exit
root@docker-labs:~# 

```

**Chỉ định RAM và CPU cho một container**
Một container có thể chỉ định lượng RAM và CPU và đặt tên kia tạo.  

`docker run -d -p 4000:80 --name webserver --memory 400m --cpus 0.5 httpd`
```
root@docker-labs:~# docker run -d -p 4000:80 --name webserver --memory 400m --cpus 0.5 httpd
WARNING: Your kernel does not support swap limit capabilities or the cgroup is not mounted. Memory limited without swap.
e5aee4533dd8ed5e901a88d8d9b4e8ba9ce61fab3a998e20a3e819413ab81cbe

```

**Kiểm tra nội dung, logs, port của container**
Sử dụng `docker inspect <ID>`
```
root@docker-labs:~# docker inspect e5aee4533dd8
[
    {
        "Id": "e5aee4533dd8ed5e901a88d8d9b4e8ba9ce61fab3a998e20a3e819413ab81cbe",
        "Created": "2020-03-26T03:31:01.129220747Z",
        "Path": "httpd-foreground",
        "Args": [],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 7192,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2020-03-26T03:31:02.870459386Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:c5a012f9cf45ce0634f5686cfb91009113199589bd39b683242952f82cf1cec1",
        "ResolvConfPath": "/var/lib/docker/containers/e5aee4533dd8ed5e901a88d8d9b4e8ba9ce61fab3a998e20a3e819413ab81cbe/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/e5aee4533dd8ed5e901a88d8d9b4e8ba9ce61fab3a998e20a3e819413ab81cbe/hostname",
        "HostsPath": "/var/lib/docker/containers/e5aee4533dd8ed5e901a88d8d9b4e8ba9ce61fab3a998e20a3e819413ab81cbe/hosts",
        "LogPath": "/var/lib/docker/containers/e5aee4533dd8ed5e901a88d8d9b4e8ba9ce61fab3a998e20a3e819413ab81cbe/e5aee4533dd8ed5e901a88d8d9b4e8ba9ce61fab3a998e20a3e819413ab81cbe-json.log",
        "Name": "/webserver",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "docker-default",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {
                "80/tcp": [
                    {
                        "HostIp": "",
                        "HostPort": "4000"
                    }
                ]
            },
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Capabilities": null,
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 419430400,
            "NanoCpus": 500000000,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "KernelMemory": 0,
            "KernelMemoryTCP": 0,
            "MemoryReservation": 0,
            "MemorySwap": -1,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/527b2d25d2ba2ad27d01854c76ee8f48a7f7c3bc9444cbb0ef8f6cc8605b22c6-init/diff:/var/lib/docker/overlay2/61e44c63359e1ef6789f47b24ffa758473238a47d4f6b9c4791921d19c10acf6/diff:/var/lib/docker/overlay2/d7c8b54cdbfb26c9b56b7a8f44a5dd2dc349db5ec9b7b3ea1c614bb01406971b/diff:/var/lib/docker/overlay2/f7385ebb7c88d048ebdff3499326cbbe8438967aa58d0219b830fb56da92417b/diff:/var/lib/docker/overlay2/5acd055ba3e48a949e9213c3a1abd4f41abfd31262d1f303923fbae8f536196e/diff:/var/lib/docker/overlay2/e8b1b2cfd59d821aca48795ac8bdd5ec2c1a6b6971a6acb10ce8d9a8a73a116a/diff",
                "MergedDir": "/var/lib/docker/overlay2/527b2d25d2ba2ad27d01854c76ee8f48a7f7c3bc9444cbb0ef8f6cc8605b22c6/merged",
                "UpperDir": "/var/lib/docker/overlay2/527b2d25d2ba2ad27d01854c76ee8f48a7f7c3bc9444cbb0ef8f6cc8605b22c6/diff",
                "WorkDir": "/var/lib/docker/overlay2/527b2d25d2ba2ad27d01854c76ee8f48a7f7c3bc9444cbb0ef8f6cc8605b22c6/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "e5aee4533dd8",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/apache2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "HTTPD_PREFIX=/usr/local/apache2",
                "HTTPD_VERSION=2.4.41",
                "HTTPD_SHA256=133d48298fe5315ae9366a0ec66282fa4040efa5d566174481077ade7d18ea40",
                "HTTPD_PATCHES="
            ],
            "Cmd": [
                "httpd-foreground"
            ],
            "Image": "httpd",
            "Volumes": null,
            "WorkingDir": "/usr/local/apache2",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {},
            "StopSignal": "SIGWINCH"
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "3e64cebdae101d0c0ad63c408ba31ff6a061f9d96a98a20020cd98074716da8b",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "80/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "4000"
                    }
                ]
            },
            "SandboxKey": "/var/run/docker/netns/3e64cebdae10",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "ae22d90d67399ef53c8e4e7be760975b81e866272d51536d7523a4cda87593d2",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "277e740aa807c2512da6172da98fc975da2711e9b4ea359b35a53e592ee158ab",
                    "EndpointID": "ae22d90d67399ef53c8e4e7be760975b81e866272d51536d7523a4cda87593d2",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]

```

Kiểm tra **logs** của containers sử dụng lệnh `docker logs -f <ID>`
```
root@docker-labs:~# docker logs -f e5aee4533dd8
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
[Thu Mar 26 03:31:02.936195 2020] [mpm_event:notice] [pid 1:tid 140127243449472] AH00489: Apache/2.4.41 (Unix) configured -- resuming normal operations
[Thu Mar 26 03:31:02.936362 2020] [core:notice] [pid 1:tid 140127243449472] AH00094: Command line: 'httpd -D FOREGROUND'

```

Kiểm tra **port** của container sử dụng câu lệnh: `docker port <ID>`
```
root@docker-labs:~# docker port e5aee4533dd8
80/tcp -> 0.0.0.0:4000
```

Dừng, khởi động,xóa Container 
Sử dụng lệnh `Docker stop/start/rm (rm -f)` để dừng, xóa các container
```
root@docker-labs:~# docker ps
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                  NAMES
e5aee4533dd8        httpd               "httpd-foreground"   13 minutes ago      Up 13 minutes       0.0.0.0:4000->80/tcp   webserver
root@docker-labs:~# docker stop e5aee4533dd8
e5aee4533dd8
root@docker-labs:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS                     PORTS               NAMES
e5aee4533dd8        httpd               "httpd-foreground"   14 minutes ago      Exited (0) 3 seconds ago                       webserver
root@docker-labs:~# docker start e5aee4533dd8
e5aee4533dd8
root@docker-labs:~# docker ps -a
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                  NAMES
e5aee4533dd8        httpd               "httpd-foreground"   14 minutes ago      Up 4 seconds        0.0.0.0:4000->80/tcp   webserver

```
Để xóa containter với lệnh `docker rm <ID>` thì container phải stop trước
```
root@docker-labs:~# docker rm e5aee4533dd8
Error response from daemon: You cannot remove a running container e5aee4533dd8ed5e901a88d8d9b4e8ba9ce61fab3a998e20a3e819413ab81cbe. Stop the container before attempting removal or force remove
```
Nếu như dùng lệnh `docker rm -f` thì không cần thiết phải stop 
```
root@docker-labs:~# docker rm -f e5aee4533dd8
e5aee4533dd8
root@docker-labs:~# docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

```
