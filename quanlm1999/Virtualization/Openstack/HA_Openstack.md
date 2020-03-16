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


