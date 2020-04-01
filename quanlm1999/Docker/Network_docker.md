# Network trong Docker.

![](https://camo.githubusercontent.com/d2c856d1986260ace4a29c8478e17bba09dacc13/687474703a2f2f692e696d6775722e636f6d2f614e534a3639792e706e67)

Khi chúng ta cài đặt Docker, những thiết lập sau sẽ được thực hiện:
  - Virtual bridge docker0 sẽ được tạo ra
  - Docker tìm một subnet chưa được dùng trên host và gán một địa chỉ cho docker0

Sau đó, khi chúng ta khởi động một container (với **bridge network**), một **veth** (Virtual Ethernet) sẽ được tạo ra nối 1 đầu với **docker0** và một đầu sẽ được nối với interface **eth0** trên container.

### Default network
Khi cài đặt xong, Docker sẽ tạo ra 3 card mạng mặc định là:
- bridge
- host
- only.

- Tương ứng với các nền tảo ảo hóa khác, ta có các chế độ card mạng của docker so với các nền tảng đấy là:

| General Virtualization Term | Docker Network Driver                            |
|-----------------------------|--------------------------------------------------|
| NAT Network                 | bridge                                           |
| Bridged                     | macvlan, ipvlan (experimental since Docker 1.11) |
| Private / Host-only         | bridge                                           |
| Overlay Network / VXLAN     | overlay                                          |



Để xem chi tiết, ta có thể dùng lệnh
```sh
docker network ls
```

```sh
root@docker-labs:/# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
1d8aa8d520a2        bridge              bridge              local
a8ddedeecca8        host                host                local
ad1c5f949ef2        none                null                local
root@adk:/# 
```

Mặc định khi tạo container mà ta không chỉ định dùng network nào, thì docker sẽ dùng dải bridge.

### None network
Các container thiết lập network này sẽ không được cấu hình mạng. 

### Bridge
Docker sẽ tạo ra một switch ảo. Khi container được tạo ra, interface của container sẽ gắn vào switch ảo này và kết nối với interface của host.

```sh
root@docker-labs:~# docker network inspect bridge
[
    {
        "Name": "bridge",
        "Id": "1d8aa8d520a2775b5f02279e2ff057e2d781a67e116e603d367edab58211a5d9",
        "Created": "2017-03-14T09:35:39.561628223+07:00",
        "Scope": "local",
        "Driver": "bridge",
        "EnableIPv6": false,
        "IPAM": {
            "Driver": "default",
            "Options": null,
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
        "Internal": false,
        "Attachable": false,
        "Containers": {},
        "Options": {
            "com.docker.network.bridge.default_bridge": "true",
            "com.docker.network.bridge.enable_icc": "true",
            "com.docker.network.bridge.enable_ip_masquerade": "true",
            "com.docker.network.bridge.host_binding_ipv4": "0.0.0.0",
            "com.docker.network.bridge.name": "docker0",
            "com.docker.network.driver.mtu": "1500"
        },
        "Labels": {}
    }
]
root@adk:~# 
```

### Host
Containers sẽ dùng mạng trực tiếp của máy host. Network configuration bên trong container đồng nhất với host.

### User-defined networks
Ngoài việc sử dụng các network mặc định do docker cung cấp. Ta có thể tự định nghĩa ra các dải network phù hợp
với công việc của mình.

Để tạo network, ta dùng lệnh
```sh
docker network create --driver bridge --subnet 192.168.1.0/24 bridgexxx
```
Trong đó:
- **--driver bridge**: Chỉ định dải mạng mới được tạo ra sẽ thuộc kiểu nào: bridge, host, hay none.
- **--subnet**: Chỉ định địa địa chỉ mạng.
- **bridgexxx**: Tên của dải mạng mới.

Khi chạy container chỉ định sử dụng 1 dải mạng đặc biệt, ta dùng lệnh
```sh
docker run --network=bridgexxx -itd --name=container3 busybox
```
Trong đó:
  - **--network=bridgexxx:** Chỉ định ra dải mạng bridgexxx sẽ kết nối với container.

Container mà bạn chạy trên network này đều phải thuộc về cùng một Docker host. Mỗi container trong network có thể communicate với các containers khác trong cùng network.

### Overlay network with Docker Engine swarm mode
- Overlay network là mạng có thể kết nối nhiều container trên các **Docker Engine** lại với nhau, trong môi trường cluster.
- Swarm tạo ra overlay network chỉ available với các nodes bên trong swarm. Khi bạn tạo ra một service sử dụng overlay network, manager node sẽ tự động kế thừa overlay network tới các nodes chạy các service tasks.

Ví dụ sau sẽ hướng dẫn cách tạo ra một network và sử dụng nó cho một service từ một manager node bên trong swarm:
```sh
docker network create \
    --driver overlay \
    --subnet 10.0.9.0/24 \
    my-multi-host-network

400g6bwzd68jizzdx5pgyoe95

docker service create --replicas 2 --network my-multi-host-network --name my-web nginx

716thylsndqma81j6kkkb5aus
```

### Giao tiếp giữa các container với nhau.

- Trên cùng một host, các container chỉ cần dùng bridge network để nói chuyện được với nhau. Tuy nhiên, các container được cấp ip động nên nó có thể thay đổi, dẫn đến nhiều khó khăn. Vì vậy, thay vì dùng địa chỉ ip, ta có thể dùng name của các container để "liên lạc" giữa các container với nhau.
- Trong trường hợp sử dụng default bridge network thì ta khai báo thêm lệnh `--link=name_container`.
- Trong trường hợp sử dụng user-defined bridge network thì ta không cần phải link nữa.

### Trường hợp sử dụng default bridge network để kết nối các container

- Giả sử ta có mô hình: `web - db`
- container web phải link được với container db. 

```sh
docker run -itd --name=db -e MYSQL_ROOT_PASSWORD=pass mysql:latest
docker run -itd --name=web --link=db nginx:latest
```

- Kiểm tra: 
```sh
docker exec -it web sh
# ping redis
PING redis (172.17.0.3): 56 data bytes
64 bytes from 172.17.0.3: icmp_seq=0 ttl=64 time=0.245 ms
...
# ping db
PING db (172.17.0.2): 56 data bytes
64 bytes from 172.17.0.2: icmp_seq=0 ttl=64 time=0.126 ms
...
```

### Trường hợp sử dụng user-defined bridge network để kết nối các container

- Bạn không cần thực hiện thao tác link qua link lại giữa các container nữa.

```sh
docker network create my-net
docker network ls
NETWORK ID          NAME                DRIVER
716f591e185a        bridge              bridge              
4b0041303d6d        host                host                
7239bb9e0255        my-net              bridge              
016cf6ec1791        none                null

docker run -itd --name=web1 --net my-net nginx:latest
docker run -itd --name=db1 --net my-net -e MYSQL_ROOT_PASSWORD=pass mysql:latest

docker exec -it web1 sh
# ping db1
PING db1 (172.18.0.4): 56 data bytes
64 bytes from 172.18.0.4: icmp_seq=0 ttl=64 time=0.161 ms
# ping redis1
PING redis1 (172.18.0.3): 56 data bytes
64 bytes from 172.18.0.3: icmp_seq=0 ttl=64 time=0.168 ms
```

### DNS server.
Docker sẽ sử dụng `built-in dns` riêng cho các container cùng 1 network.
Nội dung file `/etc/resolv.conf`
```sh
root@07c8c10a7a81:/# cat /etc/resolv.conf 
nameserver 127.0.0.11
options ndots:0
root@07c8c10a7a81:/# 
```

Docker chưa cung cấp công cụ để xem thông tin các record của built-in dns này.

- Dùng cờ `--dns`: để khai báo dns-server sẽ sử dụng trong container:

```sh
root@docker-labs:/opt# docker run -it --name hcm --dns=10.10.10.1 ubuntu /bin/bash
```

### MacVlan.
Macvlan cho phép cấu hình sub-interfaces (hay còn gọi là slave devices) trên một Ethernet interface vật lý (còn gọi là upper device), mỗi sub-interfaces này có địa chỉ MAC riêng và do đó có địa chỉ IP riêng. Các ứng dụng, VM và các containers có thể kết nối với một sub-interface nhất định để kết nối trực tiếp với mạng vật lý, sử dụng địa chỉ MAC và địa chỉ IP riêng của chúng.


### Ipvlan

Ipvlan khá giống so với macvlan, tuy nhiên nó có điểm khác so với macvlan là không gán địa chỉ MAC riêng cho các sub-interfaces. Các sub-interfaces chia sẻ chung địa chỉ MAC với parent interfaces (card vật lý trên đó tạo các sub-interfaces), nhưng có địa chỉ IP riêng.

- Ipvlan L2: Ipvlan L2 hay Layer 2 mode tương tự với chế độ macvlan bridge mode.

- Ipvlan L3: Ipvlan L2 được coi coi như bridge hay switch giữa các sub-interfaces và parent interface. Tương tự như vậy, Ipvlan L3 hay Layer 3 mode được coi như thiết bị lớp 3 (như router) giữa các sub-interfaces và parent interfaces.

- Thông tin về macvlan và ipvlan các bạn có thể tham khảo thêm tại đây:
