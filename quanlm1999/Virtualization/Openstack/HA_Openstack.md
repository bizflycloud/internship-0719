# HA Openstack
## Mô hình
![](https://raw.githubusercontent.com/lmq1999/123/master/Openstack_HA.jpg)

## Cầu hình
#### 2 node loadbalancer chạy HAproxy và keepalived
**File** `/etc/keepalived/keepalived.conf` loadbalance1
```
global_defs {
        router_id loadbalance1
}
vrrp_script haproxy {
        script "killall -0 haproxy"
        interval 2
        weight 2
}
vrrp_instance 50 {
        virtual_router_id 50
        advert _int 1
        priority 101
        state MASTER
        interface ens3
        virtual_ipaddress {
                192.168.122.200 dev ens3
        }
        track_script {
                haproxy
        }
}
```
**File** `/etc/haproxy/haproxy.cfg`
```
global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	# An alternative list with additional directives can be obtained from
	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

defaults
	log	global
	mode	http
	option	httplog
	option	dontlognull
        timeout connect 5000
        timeout client  50000
        timeout server  50000
	errorfile 400 /etc/haproxy/errors/400.http
	errorfile 403 /etc/haproxy/errors/403.http
	errorfile 408 /etc/haproxy/errors/408.http
	errorfile 500 /etc/haproxy/errors/500.http
	errorfile 502 /etc/haproxy/errors/502.http
	errorfile 503 /etc/haproxy/errors/503.http
	errorfile 504 /etc/haproxy/errors/504.http

listen dashboard_cluster
  bind 192.168.122.200:443
  balance  source
  option  tcpka
  option  httpchk
  option  tcplog
  server controller1 10.0.0.100:443 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:443 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:443 check inter 2000 rise 2 fall 5

 listen glance_api_cluster
  bind 192.168.122.200:9292
  balance  source
  option  tcpka
  option  httpchk
  option  tcplog
  server controller1 10.0.0.100:9292 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:9292 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:9292 check inter 2000 rise 2 fall 5

 listen glance_registry_cluster
  bind 192.168.122.200:9191
  balance  source
  option  tcpka
  option  tcplog
  server controller1 10.0.0.100:9191 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:9191 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:9191 check inter 2000 rise 2 fall 5

 listen keystone_admin_cluster
  bind 192.168.122.200:35357
  balance  source
  option  tcpka
  option  httpchk
  option  tcplog
  server controller1 10.0.0.100:35357 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:35357 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:35357 check inter 2000 rise 2 fall 5

 listen keystone_public_internal_cluster
  bind 192.168.122.200:5000
  balance  source
  option  tcpka
  option  httpchk
  option  tcplog
  server controller1 10.0.0.100:5000 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:5000 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:5000 check inter 2000 rise 2 fall 5

 listen nova_ec2_api_cluster
  bind 192.168.122.200:8773
  balance  source
  option  tcpka
  option  tcplog
  server controller1 10.0.0.100:8773 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:8773 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:8773 check inter 2000 rise 2 fall 5

 listen nova_compute_api_cluster
  bind 192.168.122.200:8774
  balance  source
  option  tcpka
  option  httpchk
  option  tcplog
  server controller1 10.0.0.100:8774 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:8774 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:8774 check inter 2000 rise 2 fall 5

 listen nova_metadata_api_cluster
  bind 192.168.122.200:8775
  balance  source
  option  tcpka
  option  tcplog
  server controller1 10.0.0.100:8775 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:8775 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:8775 check inter 2000 rise 2 fall 5

 listen cinder_api_cluster
  bind 192.168.122.200:8776
  balance  source
  option  tcpka
  option  httpchk
  option  tcplog
  server controller1 10.0.0.100:8776 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:8776 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:8776 check inter 2000 rise 2 fall 5

 listen placement_api_cluster
  bind 192.168.122.200:8778
  balance  source
  option  tcpka
  option  tcplog
  server controller1 10.0.0.100:8778 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:8778 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:8778 check inter 2000 rise 2 fall 5

 listen nova_vncproxy_cluster
  bind 192.168.122.200:6080
  balance  source
  option  tcpka
  option  tcplog
  server controller1 10.0.0.100:6080 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:6080 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:6080 check inter 2000 rise 2 fall 5

 listen neutron_api_cluster
  bind 192.168.122.200:9696
  balance  source
  option  tcpka
  option  httpchk
  option  tcplog
  server controller1 10.0.0.100:9696 check inter 2000 rise 2 fall 5
  server controller2 10.0.0.66:9696 check inter 2000 rise 2 fall 5
  server controller3 10.0.0.12:9696 check inter 2000 rise 2 fall 5
```

Vậy ta đã có 2 node loadbalancer với 1VIP chạy giữa 2 node.

#### Cầu hình 3 node Controller
**Cấu hình Master_Master MariaDB sử dụng Galera_cluster**
*   Stop mysql trên tất cả các node **controller**
*   Trên các node **controller** Cấu hình mariaDB tại `/etc/mysql/my.cnf` có dạng
    ```
    [mysqld]
    datadir=/var/lib/mysql
    socket=/var/lib/mysql/mysql.sock
    user=mysql
    binlog_format=ROW
    bind-address= $controller_ip
    
    # InnoDB Configuration
    default_storage_engine=innodb
    innodb_autoinc_lock_mode=2
    innodb_flush_log_at_trx_commit=0
    innodb_buffer_pool_size=122M
    
    # Galera Cluster Configuration
    wsrep_provider=/usr/lib/libgalera_smm.so
    wsrep_provider_options="pc.recovery=TRUE;gcache.size=300M"
    wsrep_cluster_name="my_example_cluster"
    wsrep_cluster_address="gcomm://GALERA1-IP,GALERA2-IP,GALERA3-IP"
    wsrep_sst_method=rsync
    ```
* Chọn 1 node, bootstrap lên sử dụng lên `galera_new_cluster`
* Các node còn lại start lên bình thường
* Kiểm tra trong mysql:
    ```
    MariaDB [(none)]> SHOW STATUS LIKE 'wsrep_cluster_size';
    +--------------------+-------+
    | Variable_name      | Value |
    +--------------------+-------+
    | wsrep_cluster_size | 3     |
    +--------------------+-------+
    1 row in set (0.001 sec)
    ```
*   Vậy các node đã được replicate dạng Master-Master.

**Cấu hình Keepalived và HAproxy cho MariaDB**
* Cấu hình Keepalvied
    ```
    # Keepalived process identifier
    lvs_id haproxy_DH
    }
    # Script used to check if HAProxy is running
    vrrp_script check_haproxy {
        script "killall -0 haproxy"
        interval 2
        weight 2
    }
    # Virtual interface
    # The priority specifies the order in which the assigned interface to take over in a failover
    vrrp_instance VI_01 {
        state MASTER
        interface ens3
        virtual_router_id 51
        priority 100    # set to 50 on backup node
        # The virtual ip address shared between the two loadbalancers
        virtual_ipaddress {
            10.0.0.200/24 dev ens3
        }
        # Tracking Script
        track_script {
            check_haproxy
        }
    }
    ```
*   Cấu hình HAproxy:
    ```
    global
	log /dev/log	local0
	log /dev/log	local1 notice
	chroot /var/lib/haproxy
	stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
	stats timeout 30s
	user haproxy
	group haproxy
	daemon

	# Default SSL material locations
	ca-base /etc/ssl/certs
	crt-base /etc/ssl/private

	# Default ciphers to use on SSL-enabled listening sockets.
	# For more information, see ciphers(1SSL). This list is from:
	#  https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
	# An alternative list with additional directives can be obtained from
	#  https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=haproxy
	ssl-default-bind-ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:RSA+AESGCM:RSA+AES:!aNULL:!MD5:!DSS
	ssl-default-bind-options no-sslv3

    defaults
    	log	global
    	mode	tcp
    	option	tcplog
    	option	dontlognull
            timeout connect 5000
            timeout client  50000
            timeout server  50000
    	errorfile 400 /etc/haproxy/errors/400.http
    	errorfile 403 /etc/haproxy/errors/403.http
    	errorfile 408 /etc/haproxy/errors/408.http
    	errorfile 500 /etc/haproxy/errors/500.http
    	errorfile 502 /etc/haproxy/errors/502.http
    	errorfile 503 /etc/haproxy/errors/503.http
    	errorfile 504 /etc/haproxy/errors/504.http
    
    frontend galera_cluster_frontend
        bind 10.0.0.200:3306
        mode tcp
        option tcplog
        default_backend galera_cluster_backend
    
    # Galera Cluster Backend configuration
    backend galera_cluster_backend
        mode tcp
        option tcpka
        balance leastconn
        server controller1 10.0.0.100:3306  check weight 1
        server controller2 10.0.0.66:3306  check weight 1
        server controller3 10.0.0.12:3306  check weight 1
    ```
*   Vậy h ta đã có thể truy cập vào MariaDB cluster với VIP vừa tạo .
    ```
    root@controller1:~# mysql -h 10.0.0.200
    Welcome to the MariaDB monitor.  Commands end with ; or \g.
    Your MariaDB connection id is 912
    Server version: 10.3.22-MariaDB-1:10.3.22+maria~xenial-log mariadb.org binary distribution
    
    Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.
    
    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
    
    MariaDB [(none)]> 
    ```
**Cấu hình rabbitMQ**
*   Trên các node **controller** Tại và tạo user openstack với các quyền như theo hướng dẫn
*   Stop các service RabbitMQ
*   Copy cookies từ 1 node sang các node còn lại: `scp /var/lib/rabbitmq/.erlang.cookie root@NODE:/var/lib/rabbitmq/.erlang.cookie`
*   Cấp quyền cho các node:
    ```
    chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
     chmod 400 /var/lib/rabbitmq/.erlang.cookie
    ```
*   Khởi động lại các node:
*   Kiểm tra các ndoe đang chạy:
    ```
    [{nodes,[{disc,[rabbit@controller1]}]},
     {running_nodes,[rabbit@controller1]},
     {cluster_name,<<"rabbit@controller1">>},
     {partitions,[]},
     {alarms,[{rabbit@controller2,[]},{rabbit@controller1,[]}]}]
    ```
*   Trên các node **KHÔNG PHẢI** node 1, stop các node đó `rabbitmqctl stop_app`
*   Join các node vào node 1: `rabbitmqctl join_cluster rabbit@rabbit1`
*   Khởi động lại các node vừa  tắt: `rabbitmqctl start_app`
*   Kiểm tra lại các node
    ```
    root@controller1:~# rabbitmqctl cluster_status
    Cluster status of node rabbit@controller1
    [{nodes,[{disc,[rabbit@controller1,rabbit@controller2,rabbit@controller3]}]},
     {running_nodes,[rabbit@controller2,rabbit@controller1]},
     {cluster_name,<<"rabbit@controller1">>},
     {partitions,[]},
     {alarms,[{rabbit@controller2,[]},{rabbit@controller1,[]}]}]
    ```
*   Trên 1 node bất kì, sử dụng câu lệnh sau để  dùng HA node  `rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all"}'`

#### Để sử dụng rabbitMQ_cluster này khi cấu hình các service của openstack ở transport_url ta cấ hình như sau
`transport_url = rabbit://RABBIT_USER:RABBIT_PASS@rabbit1,RABBIT_USER:RABBIT_PASS@rabbit,RABBIT_USER:RABBIT_PASS@rabbit3`
```
rabbit_retry_interval=1
rabbit_retry_backoff=2
rabbit_max_retries=0
rabbit_durable_queues=true
rabbit_ha_queues=true
```

#### Để sử dụng memcache ta làm tương tự, khi cấu hình các service, ta dùng nhiều memcache server cách nhau bởi dấu ,
`Memcached_servers = controller1:11211,controller2:11211,controller3:11211`

#### Cấu hình các service Openstack như Keystone, glance, ... trên cả 3 node như theo hướng dẫn sau: 
https://github.com/bizflycloud/internship-0719/blob/master/quanlm1999/Virtualization/Openstack/Install_Openstack_and_lauch_instance.md

**Một số chú ý**
*   Cấu hình `transport_url` để sử dụng rabbitMQ_cluster như ở trên.
*   Cầu hình `memcahced` để sử dụng mmemcached như ở trên.
*   Các **api, endpoint, bootstrap ....** đều sử dụng **VIP của 2 node loadbalancer** 
*   Các kết nối đến **database** đều sử dụng **VIP của 3 node controller**
*   Vì tài nguyên giới hạn, không sử dụng được ceph. Sử dụng NFS, GlusterFS hoặc chỉ cần scp sang các node khác với thư mục: `/var/lib/glance/images/` để đảm bảo các khi tạo máy ảo không bị lỗi: **image is unacceptable: Image has no associated data'**

#### Cấu hình HA Network Openstack.
**Cấu hình VRRP trên 3 node controller**
*   **Controller1** 
    *   Cấu hình Neutron theo hướng dẫn ở trên.
    *   Trong file `/etc/neutron/neutron.conf` kích hoạt VRRP:
        ```
        [DEFAULT]
        l3_ha = True
        ```
*   **Controller2**
    *   Cấu hình tương tự như trên, có thêm vào `/etc/neutron/neutron.conf`
        ```
        [DEFAULT]
        l3_ha = True
        ```
*   **Controller3**
    *   Cấu hình tương tự

*   Khi cấu hình xong, tạo self-service network, add Router vào, trên mỗi node ta đều thấy 1 router: 
    ```
    root@quanlm-controller-1:~# ip netns
    qrouter-b6206312-878e-497c-8ef7-eb384f8add96
    
    root@quanlm-controller-2:~# ip netns
    qrouter-b6206312-878e-497c-8ef7-eb384f8add96
    
    root@quanlm-controller-3:~# ip netns
    qrouter-b6206312-878e-497c-8ef7-eb384f8add96
    ```
*   Sẽ có 1 mạng tự được tạo ra để quản lý HA router: 
    ```
    openstack network list
    +--------------------------------------+----------------------------------------------------+--------------------------------------+
    | ID                                   | Name                                               | Subnets                              |
    +--------------------------------------+----------------------------------------------------+--------------------------------------+
    | 1b8519c1-59c4-415c-9da2-a67d53c68455 | HA network tenant f986edf55ae945e2bef3cb4bfd589928 | 6843314a-1e76-4cc9-94f5-c64b7a39364a |
    +--------------------------------------+----------------------------------------------------+--------------------------------------+
    ```

*   Ip addr show router
    *   Controller1:
    ```
        # ip netns exec qrouter-b6206312-878e-497c-8ef7-eb384f8add96 ip addr show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever
    2: ha-eb820380-40@if21: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
        link/ether fa:16:3e:78:ba:99 brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 169.254.192.1/18 brd 169.254.255.255 scope global ha-eb820380-40
           valid_lft forever preferred_lft forever
        inet 169.254.0.1/24 scope global ha-eb820380-40
           valid_lft forever preferred_lft forever
        inet6 fe80::f816:3eff:fe78:ba99/64 scope link
           valid_lft forever preferred_lft forever
    3: qr-da3504ad-ba@if24: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
        link/ether fa:16:3e:dc:8e:a8 brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 192.168.2.1/24 scope global qr-da3504ad-ba
           valid_lft forever preferred_lft forever
        inet6 fe80::f816:3eff:fedc:8ea8/64 scope link
           valid_lft forever preferred_lft forever
    4: qr-442e36eb-fc@if27: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
        link/ether fa:16:3e:ee:c8:41 brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet6 fd00:192:168:2::1/64 scope global nodad
           valid_lft forever preferred_lft forever
        inet6 fe80::f816:3eff:feee:c841/64 scope link
           valid_lft forever preferred_lft forever
    5: qg-33fedbc5-43@if28: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether fa:16:3e:03:1a:f6 brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 203.0.113.21/24 scope global qg-33fedbc5-43
           valid_lft forever preferred_lft forever
        inet6 fd00:203:0:113::21/64 scope global nodad
           valid_lft forever preferred_lft forever
        inet6 fe80::f816:3eff:fe03:1af6/64 scope link
           valid_lft forever preferred_lft forever
    ```
    *   Controller2:
    ```
        # ip netns exec qrouter-b6206312-878e-497c-8ef7-eb384f8add96 ip addr show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever
    2: ha-7a7ce184-36@if8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
        link/ether fa:16:3e:16:59:84 brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 169.254.192.2/18 brd 169.254.255.255 scope global ha-7a7ce184-36
           valid_lft forever preferred_lft forever
        inet6 fe80::f816:3eff:fe16:5984/64 scope link
           valid_lft forever preferred_lft forever
    3: qr-da3504ad-ba@if11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
        link/ether fa:16:3e:dc:8e:a8 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    4: qr-442e36eb-fc@if14: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
    5: qg-33fedbc5-43@if15: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether fa:16:3e:03:1a:f6 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    ```
    *   Controller3:
    ```
        # ip netns exec qrouter-b6206312-878e-497c-8ef7-eb384f8add96 ip addr show
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host
           valid_lft forever preferred_lft forever
    2: ha-7a1e7ec84-40@if21: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
        link/ether fa:16:3e:16:59:84 brd ff:ff:ff:ff:ff:ff link-netnsid 0
        inet 169.254.192.2/18 brd 169.254.255.255 scope global ha-7a7ce184-36
           valid_lft forever preferred_lft forever
        inet6 fe80::f816:3eff:fe16:5984/64 scope link
           valid_lft forever preferred_lft forever
    3: qr-da3504ad-ba@if11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
        link/ether fa:16:3e:dc:8e:a8 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    4: qr-442e36eb-fc@if14: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default qlen 1000
    5: qg-33fedbc5-43@if15: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether fa:16:3e:03:1a:f6 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    ```
** Vậy trong trường hợp node controller1 chết, thì router ở controller2 sẽ hoạt động thay thế**

**Cấu hình HA DHCP**
*   Đảm bảo cả 3 node controller đều có **DHCP Agent đã được cấu hình** như hướng dẫn network ở trên.
*   Trong file: `/etc/neutron/neutron.conf`, cấu hình `dhcp_agents_per_network = $` $ = số agent DHCP
Khi tạo network, trên cả 3 node controller sẽ đều có 1 DHCP agent cấp IP cho :
```
root@quanlm-controller-1:~# ip netns
qdhcp-b9c5383f-dd16-4020-a11a-e4991b6cd182 (id: 0)

root@quanlm-controller-2:~# ip netns
qdhcp-b9c5383f-dd16-4020-a11a-e4991b6cd182 (id: 0)

root@quanlm-controller-3:~# ip netns
qdhcp-b9c5383f-dd16-4020-a11a-e4991b6cd182 (id: 0)

```
#### Evacuate instance khi node compute bị hỏng
Sử dụng lệnh `nova evacuate` để đưa VM từ node compute vừa bị hỏng sang node đang chạy. 
Gửi toàn bộ: `nova host-evacuate --target_host TARGET_HOST FAILED_HOST`
Gửi 1 server: `nova evacuate EVACUATED_SERVER_NAME HOST_B`
```
root@controller:~# openstack compute service list --service nova-compute
+----+--------------+----------+------+---------+-------+----------------------------+
| ID | Binary       | Host     | Zone | Status  | State | Updated At                 |
+----+--------------+----------+------+---------+-------+----------------------------+
|  7 | nova-compute | compute1 | nova | enabled | up    | 2020-03-17T05:02:57.000000 |
|  8 | nova-compute | compute2 | nova | enabled | up    | 2020-03-17T05:02:53.000000 |
+----+--------------+----------+------+---------+-------+----------------------------+
root@controller:~# openstack compute service list --service nova-compute
+----+--------------+----------+------+---------+-------+----------------------------+
| ID | Binary       | Host     | Zone | Status  | State | Updated At                 |
+----+--------------+----------+------+---------+-------+----------------------------+
|  7 | nova-compute | compute1 | nova | enabled | down  | 2020-03-17T05:03:17.000000 |
|  8 | nova-compute | compute2 | nova | enabled | up    | 2020-03-17T05:42:13.000000 |
+----+--------------+----------+------+---------+-------+----------------------------+
root@controller:~# nova host-evacuate --target_host compute2 compute1
+--------------------------------------+-------------------+---------------+
| Server UUID                          | Evacuate Accepted | Error Message |
+--------------------------------------+-------------------+---------------+
| a04e13c0-4362-494b-bae2-72b7ffea3770 | True              |               |
| d82aff21-0310-40b0-bae0-fb12dd64688a | True              |               |
| 09e5e4cf-a8e5-4aee-b403-c5521fc553d9 | True              |               |
| ac3c68d4-4e56-4369-9e4a-be185addb669 | True              |               |
+--------------------------------------+-------------------+---------------+

```
## Bổ sung thêm cinder và ceph 
![](https://raw.githubusercontent.com/lmq1999/123/master/Openstack_HA_2.jpg)
**Cấu hình cinder và ceph như theo 2 hướng dẫn sau:**

**Cinder**: https://github.com/bizflycloud/internship-0719/blob/master/quanlm1999/Virtualization/Openstack/Openstack_cinder.md

**Ceph**: https://github.com/bizflycloud/internship-0719/blob/master/quanlm1999/Virtualization/Openstack/Ceph_Openstack.md

*   **Chú ý** 
    *   Khi cấu hình **Cinder**, vẫn theo chú ý ở trên về `transport_url, endpoint, database, ...`    
    *   Khi cấu hình **ceph** phải đưa file cấu hình ceph và cấu hình trên **tất cả** các node 

Khi đã cấu hình thêm ceph, thì các node controller không lưu vào file `/var/lib/glance/images/` nữa mà lưu vào ceph, thế nên không cần phải scp hoặc shared storage cho file đó nữa. 

Tượng tự khi dùng ceph làm backend của cinder, khi 1 node cinder chết thì volumes đấy vẫn có thể truy cập được
