#    Khả năng
****
#### PostgreSQL         

*   **Là một hệ quản trị CSDL hỗ trợ  hướng đối tượng và chức năng của CSDL quan hệ**
    *   Đặc điểm cơ bản của cơ sở dữ liệu quan hệ hướng đối tượng là hỗ trợ các đối tượng người dùng tự định nghĩa và các hành vi của chúng bao gồm các kiểu dữ liệu, các hàm, các thao tác, các tên miền và các chỉ mục.


*   **Hỗ trợ 160/179 tính năng tuân thủ theo core SQL2011**


*   **Khả năng mở rộng: catalog-driven**
    *    Chứa thông tin không chỉ về bảng và cột, mà còn chưa thông tin về kiểu dữ liệu,  chức năng, phương thức truy cập ...., những chức năng này có thể tùy biến theo nhu cầu người dùng , thay vì phải thay đổi mã nguồn nhờ tải module của nhà cung cấp 


*   **Làm việc nhiều task 1 lúc hiệu quả, đảm bác tuân thue theo ACID**
    *   Sử dụng MVCC (Multi-version  Concurency Control). Khi  truy vấn, những giap dịch sẽ thấy được snapshot của dữ liệu từ trước đó. Điều này khiến cho các giao dịch nhìn thấy dữ liệu không nhất quán bởi giao dịch đồng thời khác trên cùng dòng đảm bảo tính độc  lập giữ các phiên ).


* **Tích hợp với các công cụ khác** 
    * Postgres tương thích với nhiều  ngôn ngữ lập trình và  nhiều nền tảng . Khi di chuyển  CSDL  sang HĐH  khác hoặc tích hợp với công cụ khác sẽ dễ dàng hơn 



#   Mục đích sử dụng
*   Ngành tài chính
   Thích hợp cho ngành tài chính vì tuần thủ hoàn toàn theo ACID, lý tưởng cho công việc OLTP. Ngoài ra còn hỗ trợ với công cụ         khác như matlab, R giúp cho việc phân tích cơ sở dưx liệu
   
*   Dữ liệu GIS của chính phủ ( hệ thống thông tin địa lý)
   PostgreSQL hỗ trợ GIS (PostGIS) có hỗ trợ hàm và thủ tục xử lý dữ liệu hình học với nhiều định dạng khác nhau
   
*   Chế tạo
   PostgreSQL tin cậy, được hỗ trợ dài hạn, làm lưu trữ đáng tin cậy với chi phí thấp, có thể cấu hình auto-failover, upgrade 0 downtime
   
*   Công nghê web
   Khả năng scale tốt, hỗ trợ nhiều framwork như Django (Python), node.js (JavaScript), Hibernate (Java), Ruby on rails, PHP .... 
   Là cơ sở dữ liệu quan hệ -đối  tương, có thể làm việc đến dữ liệu NoSQL
   
*   Dữ liệu khoa học 
   Khả năng xử lý dữ liệu lớn

#   Use case    
### Dùng khi
****
*   **Yêu cầu về tính toàn vẹn dữ liệu** 
    *   Postgres đả đảm bảo tuân thủ hoàn toàn theo ACID . Đồng thời  thực hiện MCVV  để đảm bảo dữ liệu an toàn. 
    

*   **Thủ tục phức tạp và khả năng tùy chỉnh cao**
    *   Postgres hỗ trợ việc lập kế hoạch các truy vấn nhằm tận dụng tối ưu CPU dể trả lời truy vấn nhanh hơn. Kết hợp cùng với hỗ trợ viết đồng thời khiến cho đây là lựa chọn tốt cho dữ liệu nhà khoa hoặc xử lý giao dịch trực tuyến.
    

*   **Sự đồng bộ**
    *   Nếu có phải chuyển từ hệ quản trị cơ sở dữ liệu quan hệ này sang một hệ quản trị cơ sở dữ liệu khác nhứ Oracle thì PostgreSQl cho việc chuyển đổi trong tương lại đó.
    
  
*   **Thiết kế phức tạp**
    *   So với sự thực hiện của các hệ quản trị cơ sở dữ liệu quan hệ mã nguồn mở miễn phí khác mà với thiết cơ sở dữ liệu phưc tạp thì PostgreSQL cung cấp cho chúng ta những giải pháp tối ưu.

### Không dùng khi
****
*   **Tốc độ**
    *   Nếu tất cả các các hoạt động yêu cầu đọc nhanh thì PostgreSQL không phải là công cụ phù hợp.


*   **Thiết lập đơn giản**
    *   Nếu bạn không yêu cầu tính toàn vẹn dữ liệu tuyệt đối, tuân thủ theo ACID hoặc thiết kế phức tạp thì PostgreSQL có thể là quá mức cần thiết  vơi thiết lập đơn giản.


*   **Nhân rộng phức tạp**  
    *   Mặc dù postgres hỗ trợ mạnh mẽ cho việc nhân rộng  nhưng vẫn còn là tính năng  mới cần cấu hình thê, yêu cầu thêm những tiện ích mở rộng. Điều này phức tạp hơn so với MySQL
    

#   Install
****
*   Sử dụng apt:`apt-get install postgresql`
*   Install from source:
    1.   `wget https://ftp.postgresql.org/pub/source/v10.0/postgresql-10.0.tar.bz2`
    2.   `tar -xvf postgresql-10.0.tar.bz2`
    3.   `cd postgresql-10.0`
    4.   ```
            mkdir /opt/PostgreSQL-10/
            ./configure --prefix=/opt/PostgreSQL-10
        
    5.   `make` -> `make install`
    6.  ``` 
        useradd postgres
        passwd postgres
        mkdir /pgdatabase/data
        chown -R postgres. /pgdatabase/data
        echo 'export PATH=$PATH:/opt/PostgreSQL-10/bin' > /etc/profile.d/postgres.sh
    7.  ```
        su postgres
        $ initdb -D /pgdatabase/data/ -U postgres -W

#### Cấu hình để có thể remote connect 
*  Vị trí: `/etc/postgresql/9.5/main/postgresql.conf``/etc/postgresql/9.5/main/pg_hba`
*  Edit: `listen_addresses='*'`
*  Phân quyền: `host all all all md5`
*  Câu lệnh: `psql -h hostname -U username -d database`

#   HA  
****
1. ### Sử dụng patroni 
**Mô hình**
   ![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Untitled%20Diagram.png)
   
**Trong đó**
*   Patroni:    Là công cụ để tạo, quản lý , HA cho postgreSQL sử dụng python , bao gồm cả  nhân rộng, backups, phục hồi 

**Cài đặt như trên mô hình**
*   Cấu hình etcd
    *   Vị trí: `/etc/default/etcd`
    *   Nội dụng: 
    ```
    ETCD_LISTEN_PEER_URLS="http://{hostIP}:2380,http://127.0.0.1:7001"
    ETCD_LISTEN_CLIENT_URLS="http://127.0.0.1:2379, http://{hostIP}:2379"
    ETCD_INITIAL_ADVERTISE_PEER_URLS="http://{hostIP}:2380"
    ETCD_INITIAL_CLUSTER="etcd0=http://{hostIP}:2380,"
    ETCD_ADVERTISE_CLIENT_URLS="http://{hostIP}:2379"
    ETCD_INITIAL_CLUSTER_TOKEN="cluster1"
    ETCD_INITIAL_CLUSTER_STATE="new"
    ```

*   Cấu hình patroni
    *   Vị trí: `/etc/patroni.yml`(tạo mới)
    *   Nội dung
    ```
    scope: postgres
    namespace: /db/
    name: postgresql0

    restapi:
     listen: {hostIP}:8008
     connect_address: {hostIP}:8008

    etcd:
        host: {etcd_IP}:2379

    bootstrap:
    dcs:
        ttl: 30
        loop_wait: 10
        retry_timeout: 10
        maximum_lag_on_failover: 1048576
        postgresql:
            use_pg_rewind: true

    initdb:
    - encoding: UTF8
    - data-checksums

    pg_hba:
    - host replication replicator 127.0.0.1/32 md5
    - host replication replicator {DB1_IP} md5
    - host replication replicator {DB2_IP} md5
    - host all all 0.0.0.0/0 md5

    users:
        admin:
            password: admin
            options:
                - createrole
                - createdb

    postgresql:
        listen: {DB1_IP:5432
        connect_address: {DB1_IP}:5432
        data_dir: /data/patroni
        pgpass: /tmp/pgpass
        authentication:
            replication:
                username: replicator
                password: password
            superuser:
                username: postgres
                password: password
        parameters:
            unix_socket_directories: '.'

    tags:
        nofailover: false
        noloadbalance: false
        clonefrom: false
        nosync: false
    ```
    *   Tạo thư mục data cho 2 DB
        *   Vị trí:` /data/patroni`
        *   Owner: `postgres`
        
    *   Tạo startup scrips 
        *   Vị trí: `/etc/systemd/system/patroni.service`
        *   Nội dung:
        ```
        [Unit]
        Description=Runners to orchestrate a high-availability PostgreSQL
        After=syslog.target network.target

        [Service]
        Type=simple

        User=postgres
        Group=postgres

        ExecStart=/usr/local/bin/patroni /etc/patroni.yml

        KillMode=process

        TimeoutSec=30

        Restart=no

        [Install]
        WantedBy=multi-user.targ
        ```
        
**P/s**:    Trước khi cài đặt phải stop service của postgreSQL và patroni, cấu hình xong khởi động service patroni trước rồi mới khởi động service postgreSQL

```
1 quanlm@DB1:~⟫ service patroni status
● patroni.service - Runners to orchestrate a high-availability PostgreSQL
   Loaded: loaded (/etc/systemd/system/patroni.service; disabled; vendor preset: enabled)
   Active: active (running) since Wed 2019-11-13 04:34:35 UTC; 3h 33min ago
 Main PID: 6424 (patroni)
    Tasks: 13
   Memory: 65.8M
      CPU: 1min 40.684s
   CGroup: /system.slice/patroni.service
           ├─ 6424 /usr/bin/python3 /usr/local/bin/patroni /etc/patroni.yml
           ├─ 6475 postgres -D /data/patroni --config-file=/data/patroni/postgresql.conf --cluster_name=postgres --max_prepared_transactions=0 --m
           ├─ 6502 postgres: postgres: checkpointer process                                                                                       
           ├─ 6503 postgres: postgres: writer process                                                                                             
           ├─ 6504 postgres: postgres: stats collector process                                                                                    
           ├─ 6506 postgres: postgres: postgres postgres 192.168.122.77(52144) idle                                                               
           ├─ 6612 postgres: postgres: wal writer process                                                                                         
           ├─ 6613 postgres: postgres: autovacuum launcher process                                                                                
           └─31240 postgres: postgres: postgres postgres 192.168.122.240(59862) idle    
```

*   Cấu hình HAproxy
    *   Vị trí: `/etc/haproxy/haproxy.cfg`
    *   Nội dung: 
    ```
    global
    maxconn 100

    defaults
        log global
        mode tcp
        retries 2
        timeout client 30m
        timeout connect 4s
        timeout server 30m
        timeout check 5s

    listen stats
        mode http
        bind *:7000
        stats enable
        stats uri /

    listen postgres
        bind *:5000
        option httpchk
        http-check expect status 200
        default-server inter 3s fall 3 rise 2 on-marked-down shutdown-sessions
        server DB1 {DB1_IP}:5432 maxconn 100 check port 8008
        server DB2 {DB2_IP}:5432 maxconn 100 check port 8008
    ```

**Kiểm tra HA:**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Screenshot%20from%202019-11-13%2015-24-50.png)
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Screenshot%20from%202019-11-13%2015-26-28.png)

*   Cấu hình heartbeat

2. ### Sử dụng  repmgr
    *   Ngoài việc cài đặt postgres ở trên, repmgr yêu cầu thêm `postgresql-9.5-repmgr`

**Mô hình**: Việc cài đặt PostgreSQL cluster với repmgr chỉ cần yêu cầu tối thiểu 2 node cho 2 server postgreSQL 
**Cả 2 server**
*  Tạo DB riêng với user có quyền superuser
    ```
    sudo -i -u postgres
    createuser --replication --createdb --createrole --superuser repmgr
    psql -c 'ALTER USER repmgr SET search_path TO repmgr_test, "$user", public;'
    createdb repmgr --owner=repmgr
    ```
    
*   Thiết lập kết nối ssh  dùng key đến server còn lại 
*   **Cấu hình postgres(1):** `/etc/postgresql/9.5/main/postgresql.conf`
    ```
    wal_keep_segments = 5000
    hot_standby = on
    archive_mode = on
    # Update your ips according to your cluster hosts
    listen_addresses = '127.0.0.1,192.168.122.240.192.168.122.77'
    max_wal_senders = 18
    wal_level = hot_standby
    shared_preload_libraries = 'repmgr_funcs'
    ```
    * Sửa thông số như trên (IP đặt theo trường hợp của mình )

*   **Cấu hình postgres(2)** `/etc/postgresql/9.5/main/pg_hba.conf`
    ```
    host    repmgr          repmgr          192.168.122.240/24      trust
    host    replication     repmgr          192.168.122.77/24       trust
    host    repmgr          repmgr          192.168.122.240/24      trust
    host    replication     repmgr          192.168.122.77/24       trust
    ```
    *   Restart dịch vụ postgres và kiểm tra kết nối giữa 2 sv 
    ```
    psql 'host=DB1 dbname=repmgr user=repmgr'
    psql 'host=DB2 dbname=repmgr user=repmgr'
    ```
**Tạo cluster**
*   **Cấu hình repmgr** `/etc/repmgr.conf`
    ```
    cluster=cluster
    node=1  ##DB1 node1 DB2 node 2
    node_name=DB1 ## phụ thuộc host (DB1 = DB1 )
    conninfo='host=DB1 user=repmgr dbname=repmgr connect_timeout=2' ## phụ thuộc host (DB1 = DB1)
    failover=automatic
    promote_command='repmgr standby promote -f /etc/repmgr.conf --log-to-file'
    follow_command='repmgr standby follow -f /etc/repmgr.conf --log-to-file'
    logfile='/var/log/postgresql/repmgr.log'
    loglevel=NOTICE
    reconnect_attempts=4
    reconnect_interval=5
    ```
    
* `/etc/default/repmgrd`
    ```
    REPMGRD_ENABLED=yes
    REPMGRD_CONF="/etc/repmgr.conf"
    ```
*   Tạo link đến đường dẫn pg_ctl  `sudo ln -s /usr/lib/postgresql/9.5/bin/pg_ctl /usr/bin/pg_ctl`

**Đăng ký cluster cho server**
*   **DB1**
    `repmgr primary register` để đặt làm master

*   **DB2** 
    ```
    sudo -i -u repmgr
    rm -rf /var/lib/postgresql/9.5/main
    repmgr -h server1 -U repmgr -d repmgr standby clone
    exit
    sudo service postgresql start
    sudo -i -u repmgr
    repmgr standby register
    ``` 
    Đêt dặt làm standby server 
    Kiểm tra `repmgr cluster show`
    ```
    postgres@DB1:~$ repmgr cluster show
    Role      | Name | Upstream | Connection String
    ----------+------|----------|-----------------------------------------------------
    * master  | DB1  |          | host=DB1 user=repmgr dbname=repmgr connect_timeout=2
      standby | DB2  | DB1      | host=DB2 user=repmgr dbname=repmgr connect_timeout=2
    ```
    
    Khi server 1 down 
    
    ```
    postgres@DB1:~$ repmgr cluster show
    Role      | Name | Upstream | Connection String
    ----------+------|----------|-----------------------------------------------------
      FAILED  | DB1  |          | host=DB1 user=repmgr dbname=repmgr connect_timeout=2
    * master  | DB2  | DB1      | host=DB2 user=repmgr dbname=repmgr connect_timeout=2
    ```
    Khi server 1 hoạt động trở lại, server 1 sẽ trở thành standby 
    ```
    Role      | Name | Upstream | Connection String
    ----------+------|----------|-----------------------------------------------------
      standby | DB1  |          | host=DB1 user=repmgr dbname=repmgr connect_timeout=2
     * master | DB2  | DB1      | host=DB2 user=repmgr dbname=repmgr connect_timeout=2
    ```
    
    Muốn server 1 trở lại thành master ta phải thiết lập thủ công : 
    ```
    cd /usr/lib/postgresql/9.5/bin
    sudo -upostgres ./pg_ctl promote -D /var/lib/postgresql/9.5/main/
    ```
     ```
    postgres@DB1:~$ repmgr cluster show
    Role      | Name | Upstream | Connection String
    ----------+------|----------|-----------------------------------------------------
    * master  | DB1  |          | host=DB1 user=repmgr dbname=repmgr connect_timeout=2
      standby | DB2  | DB1      | host=DB2 user=repmgr dbname=repmgr connect_timeout=2
    ```
    
    Dữ liệu vẫn sẽ được replicate 
    ```
    postgres=# select * from guestbook;
     visitor_email | vistor_id |        date         |     message     
    ---------------+-----------+---------------------+-----------------
    jim@gmail.com |         1 | 2019-11-15 00:00:00 | This is a test.
    jim@gmail.com |        34 | 2019-11-15 00:00:00 | This is a test.
    (2 rows)
    ```
    ```
    postgres=# select * from guestbook;
    visitor_email | vistor_id |        date         |     message     
    ---------------+-----------+---------------------+-----------------
    jim@gmail.com |         1 | 2019-11-15 00:00:00 | This is a test.
    jim@gmail.com |        34 | 2019-11-15 00:00:00 | This is a test.
    (2 rows)
    ```
    
    3. ### Sử dụng PAF(PostgreSQL Automatic Failover)
        *   yêu cầu:
            *    pacemaker 
            *   resource-agents 
            *   pcs
            *   fence-agents
            *   PAF (X.Y.Z-n ) là phiên bản
        ```
        wget 'https://github.com/ClusterLabs/PAF/releases/download/vX.Y.Z/resource-agents-paf_X.Y.Z-n_all.deb'
        dpkg -i resource-agents-paf_X.Y.Z-n_all.deb
        ```
**Cấu hình PostgreSQL Streaming Replicate** 
*   Chú ý: bắt buộc trong file recovery.conf ở sv slave phải có thông tin sau: 
    ```
    have standby_mode = on
    have recovery_target_timeline = ‘latest’
    a primary_conninfo with an application_name set to the node name
    ```

**Cài đặt cluster**
*   Disable corosync và pacemaker
    ```
    systemctl disable corosync
    systemctl disable pacemaker
    ```
*   Pcsd sử dùng tài khoảng hacluster để quản lý
    ```
    passwd hacluster
    systemctl enable pcsd
    systemctl start pcsd
    ```

*   Xác thực các máy sử dụng câu lệnh sau :(server1 và  server 2 là tên server )
    ```
    pcs cluster auth server1 server2 -u hacluster
    Password: 
    server1: Authorized
    server2: Authorized
    ```
    **Chú ý** Nếu bị lỗi không authorized được thì có thể do sai địa chỉ IP trong file`etc/hosts `hoặc là chưa xóa file `/etc/corosync/corosync.conf` 

*   Tạo cluster
    ```
     pcs cluster setup --name cluster_pgsql server1 server2
    ```
    
    Nếu thành công thì sẽ trông thế này: 
    ```
    Destroying cluster on nodes: server1, server2...
    server1: Stopping Cluster (pacemaker)...
    server2: Stopping Cluster (pacemaker)...
    server1: Successfully destroyed cluster
    server2: Successfully destroyed cluster

    Sending 'pacemaker_remote authkey' to 'server1', 'server2'
    server1: successful distribution of the file 'pacemaker_remote authkey'
    server2: successful distribution of the file 'pacemaker_remote authkey'
    Sending cluster config files to the nodes...
    server1: Succeeded
    server2: Succeeded

    Synchronizing pcsd certificates on nodes server1, server2...
    server1: Success
    server2: Success
    Restarting pcsd on the nodes in order to reload the certificates...
    server1: Success
    server2: Success
    ```
    
    Nếu không sẽ yêu cầu kiểm tra lại xem đã  **authorized** hay chưa .
    
*   Khởi động cluster
    ```
    pcs cluster start --all
    server2: Starting Cluster...
    server1: Starting Cluster...
    ```
    
    và 
    ```
    pcs resource defaults migration-threshold=5
    pcs resource defaults resource-stickiness=10
    ```
    
    * Trong đó 
        *   `resource-stickiness`: gán 1 số vào tài nguyên, tránh trường hợp tài nguyên đi lại giữa các node có cùng số 
        *   `migration-threshold`: số lần cluster cố gắng lấy tài nguyên ở node đó trước khi chuyển sang node  khác 

* Node fencing
    * Tạo Fence
        ```
         pcs cluster cib cluster1.xml
    
        pcs -f cluster1.xml stonith create fence_vm_server1 fence_virsh \
        > pcmk_host_check="static-list" pcmk_host_list="server1"        \
        > ipaddr="192.168.122.1" login="root" port="server1"            \
        > action="reboot" identity_file="/root/.ssh/id_rsa"
    
        pcs -f cluster1.xml stonith create fence_vm_server2 fence_virsh \
        > pcmk_host_check="static-list" pcmk_host_list="server2"        \
        > ipaddr="192.168.122.1" login="root" port="server2"            \
        > action="reboot" identity_file="/root/.ssh/id_rsa"
    
        pcs -f cluster1.xml constraint location fence_vm_server1 avoids server1=INFINITY
        pcs -f cluster1.xml constraint location fence_vm_server2 avoids server2=INFINITY
        pcs cluster cib-push cluster1.xml
        ```
    *   Kiểm tra 
        ```
        pcs status
        Cluster name: cluster_pgsql
        Stack: corosync
        Current DC: server1 (version 1.1.16-12.el7_4.5-94ff4df) - partition with quorum
        Last updated: ...
        Last change: ... by root via cibadmin on server1
    
        2 nodes configured
        2 resources configured
    
        Online: [ server1 server2 ]
    
        Full list of resources:
    
        fence_vm_server1	(stonith:fence_virsh):	Started server2
        fence_vm_server2	(stonith:fence_virsh):	Started server1
    
        Daemon Status:
        corosync: active/disabled
        pacemaker: active/disabled
        pcsd: active/enabled
        ```
    Fence thành công

* Tạo 3 resource:  `pgsqld, pgsql-ha, pgsql-master-ip.`
    *   Trong đó:  
        *   `pgsqld`: định nghĩa các thuộc tính của postgreSQL: file được đặt ở đâu, binaries, cấu hình, monitor ntn
        *   `pgsql-ha`: kiểm sóa hoạt động của `pgsqld` , quyết định xem khi nào chuyển lên làm primary server, khi nào là standby server 
        *   `pgsql-master-ip`: kiểm soát VIP
    *   Tạo `pgsqld`
        ```
        pcs cluster cib cluster1.xml
    
        pcs -f cluster1.xml resource create pgsqld ocf:heartbeat:pgsqlms    \
        bindir="/usr/lib/postgresql/9.5/bin"                            \
        pgdata="/etc/postgresql/9.5/main"                               \
        datadir="/var/lib/postgresql/9.5/main"                          \
        recovery_template="/etc/postgresql/9.5/main/recovery.conf.pcmk" \
        pghost="/var/run/postgresql"                                    \
        op start timeout=60s                                            \
        op stop timeout=60s                                             \
        op promote timeout=30s                                          \
        op demote timeout=120s                                          \
        op monitor interval=15s timeout=10s role="Master"               \
        op monitor interval=16s timeout=10s role="Slave"                \
        op notify timeout=60s
        ```
    
    *   Tạo `pgsql-ha`
        ```
        pcs -f cluster1.xml resource master pgsql-ha pgsqld notify=true
        ```
    
    *   Tạo `pgsql-master-ip`
        ```
        pcs -f cluster1.xml resource create pgsql-master-ip ocf:heartbeat:IPaddr2 \
        ip=192.168.122.50 cidr_netmask=24 op monitor interval=10s
        ```
    
    *   Định nghĩa sự kết nối giữa `pgsql-ha` và `pgsql-master-ip`
        ```
        pcs -f cluster1.xml constraint colocation add pgsql-master-ip with master pgsql-ha INFINITY
        pcs -f cluster1.xml constraint order promote pgsql-ha then start pgsql-master-ip symmetrical=false kind=Mandatory
        pcs -f cluster1.xml constraint order demote pgsql-ha then stop pgsql-master-ip symmetrical=false kind=Mandatory
        ```
    *   Cài đặt xong rồi thì đẩy lên
        ```
        pcs cluster cib-push cluster1.xml
        ```
    *   Kiểm tra
        ```
        root@DB1:/home/quanlm# pcs status
        Cluster name: cluster_pgsql
        Stack: corosync
        Current DC: server1 (version 1.1.16-12.el7_4.5-94ff4df) - partition with quorum
        Last updated: ...
        Last change: ... by root via crm_attribute on server1

        2 nodes configured
        5 resources configured

        Online: [ server1 server2 ]

        Full list of resources:
    
         fence_vm_server1	(stonith:fence_virsh):	Started server2
         fence_vm_server2	(stonith:fence_virsh):	Started server1
         pgsql-master-ip	(ocf::heartbeat:IPaddr2):	Started server1
         Master/Slave Set: pgsql-ha [pgsqld]
             Masters: [ server1 ]
             Slaves: [ server2 ]
        
        Daemon Status:
          corosync: active/disabled
          pacemaker: active/disabled
          pcsd: active/enabled
        ```
        
* **Kết luận**
    *   `Patroni` Hỗ trợ cài đặt postgreSQL trên file patroni.xml, yêu cầu 4 node tối thiểu để đảm bảo HA , hỗ trợ HAproxy, auto-failover
    *   `repmgr` manual-failover, đơn giản, yêu cầu 2 node tổi thiểu, k cần thêm port  như PAF.
    *   `PAF`: auto-failover, cài đặt khá phức tạp, yêu cầu 2 node tối thiểu , postgres cài đặt trước 
#   Benchmark   
#### Pgbench 
*   Pgbench có sẵn khi cài postgreSQL

*   **Để benchmark đầu tiên tạo 1 database***
    ```   
    postgres@DB1:/home/quanlm$ psql
    psql (9.5.19)
    Type "help" for help.

    postgres=# CREATE DATABASE example;
    CREATE DATABASE
    ```

*   **Khởi tạo dữ liệu**
    ```
    postgres@DB1:/home/quanlm$ pgbench -i -s 50 example
    ```
    pgbench sẽ tạo 4 table như sau
    ```
    example=# \dt
              List of relations
    Schema |       Name       | Type  |  Owner   
    --------+------------------+-------+----------
     public | pgbench_accounts | table | postgres
     public | pgbench_branches | table | postgres
     public | pgbench_history  | table | postgres
     public | pgbench_tellers  | table | postgres
    (4 rows)
    ```
    *   Trong đó: 
        * `-i` : chế đố khởi taoj
        * `-s` : scale, -s 50 khởi tạo 500.000 dòng 
        *  `example`: tên CSDL
*   **Thiết lập benchmark**
`postgres@DB1:/home/quanlm$ pgbench -c 10 -j 2 -t 10000 example`
    *   Trong đó:
        *   `-c`: số client, ở đây là 10 trong trường hợp này mở 10 session 
        *   `-j`: số threads
        *    `-t`: transactions, số transactions mỗi client thực hiện, ở đây là 10*10.000= 100.000 
        *    Ngoài ra còn `-T`: thực hiện trong thời gian bao lâu. 
        *   Một transactions sẽ thực hiện như sau
        ```
        1. BEGIN; 
    
        2. UPDATE pgbench_accounts SET abalance = abalance + :delta WHERE aid = :aid; 
    
        3. SELECT abalance FROM pgbench_accounts WHERE aid = :aid; 
    
        4. UPDATE pgbench_tellers SET tbalance = tbalance + :delta WHERE tid = :tid; 
    
        5. UPDATE pgbench_branches SET bbalance = bbalance + :delta WHERE bid = :bid; 
    
        6. INSERT INTO pgbench_history (tid, bid, aid, delta, mtime) VALUES (:tid, :bid, :aid, :delta, CURRENT_TIMESTAMP); 
    
        7. END; 
        ```
    
    *   Kết quả
    ```
    postgres@DB1:/home/quanlm$ pgbench -c 10 -j 2 -T 60 example
    starting vacuum...end.
    transaction type: TPC-B (sort of)
    scaling factor: 50
    query mode: simple
    number of clients: 10
    number of threads: 2
    duration: 60 s
    number of transactions actually processed: 606
    latency average: 1004.772 ms
    tps = 9.952511 (including connections establishing)
    tps = 9.954163 (excluding connections establishing)
    ```
   P/s: lúc test `-t 10000` postgres bị treo nên lần này test `-T 60`
   
   Sau khi tăng shared-bufferds từ 128MB -> 256MB
   
        
        postgres@DB1:/home/quanlm$ pgbench -c 10 -j 2 -T 60 example
        starting vacuum...end.
        transaction type: TPC-B (sort of)
        scaling factor: 50
        query mode: simple
        number of clients: 10
        number of threads: 2
        duration: 60 s
        number of transactions actually processed: 715
        latency average: 845.485 ms
        tps = 11.827524 (including connections establishing)
        tps = 11.830167 (excluding connections establishing)
        
      
        
   256MB 20 client
   
   
    postgres@DB1:/home/quanlm$ pgbench -c 20 -j 2 -T 60 example
    starting vacuum...end.
    transaction type: TPC-B (sort of)
    scaling factor: 50
    query mode: simple
    number of clients: 20
    number of threads: 2
    duration: 60 s
    number of transactions actually processed: 1215
    latency average: 996.283 ms
    tps = 20.074610 (including connections establishing)
    tps = 20.076320 (excluding connections establishing)
    
     
#### Sysbench
*   Cài đặt:
    ```
    curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | sudo bash
    sudo apt -y install sysbench
    ```
    *   sysbench sẽ dùng nhưng thông số sau khi benchmark postgreSQL
        *   pgsql-host=localhost
        *   pgsql-port=5432
        *   pgsql-user=sbtest
        *   pgsql-password=password
        *   pgsql-db=sbtest
*   Thiết lập DB:
    ```
    postgres=# CREATE USER "sbtest" WITH PASSWORD 'password';
    CREATE ROLE
    postgres=# CREATE DATABASE sbtest;
    CREATE DATABASE
    postgres=# GRANT ALL PRIVILEGES ON DATABASE sbtest TO sbtest;
    GRANT
    ```
    
*   Bổ sung file `pg_hba` để kiểm tra truy cập vào user mới 
    ```
    postgres@DB1:~$ psql -U sbtest -h 192.168.122.77 -p 5432 -d sbtest -W
    Password for user sbtest: 
    psql (9.5.19)
    SSL connection (protocol: TLSv1.2, cipher: ECDHE-RSA-AES256-GCM-SHA384, bits: 256, compression: off)
    Type "help" for help.

    sbtest=> 
    ```
    
*   Chạy sysbench, khởi tạo dữ liệu
    ```
    sysbench \
    --db-driver=pgsql \
    --oltp-table-size=10000 \
    --oltp-tables-count=24 \
    --threads=1 \
    --pgsql-host=192.168.122.77 \
    --pgsql-port=5432 \
    --pgsql-user=sbtest \
    --pgsql-password=password \
    --pgsql-db=sbtest \
    /usr/share/sysbench/tests/include/oltp_legacy/parallel_prepare.lua \
    run
    ```
    
    Thành công: 
    ```
        SQL statistics:
        queries performed:
            read:                            0
            write:                           96
            other:                           48
            total:                           144
        transactions:                        1      (0.02 per sec.)
        queries:                             144    (3.26 per sec.)
        ignored errors:                      0      (0.00 per sec.)
        reconnects:                          0      (0.00 per sec.)
    
    General statistics:
        total time:                          44.2150s
        total number of events:              1
    
    Latency (ms):
             min:                                44213.50
             avg:                                44213.50
             max:                                44213.50
             95th percentile:                    44472.74
             sum:                                44213.50
    
    Threads fairness:
        events (avg/stddev):           1.0000/0.00
        execution time (avg/stddev):   44.2135/0.00
    
    ```
    Kiểm tra lại: 
    ```
        postgres@DB1:~$ psql -U sbtest -h 192.168.122.77 -p 5432 -W -c '\dt+\'
    Password for user sbtest: 
                         List of relations
     Schema |   Name   | Type  | Owner  |  Size   | Description 
    --------+----------+-------+--------+---------+-------------
     public | sbtest1  | table | sbtest | 2192 kB | 
     public | sbtest10 | table | sbtest | 2192 kB | 
     public | sbtest11 | table | sbtest | 2192 kB | 
     public | sbtest12 | table | sbtest | 2192 kB | 
     public | sbtest13 | table | sbtest | 2192 kB | 
     public | sbtest14 | table | sbtest | 2192 kB | 
     public | sbtest15 | table | sbtest | 2192 kB | 
     public | sbtest16 | table | sbtest | 2192 kB | 
     public | sbtest17 | table | sbtest | 2192 kB | 
     public | sbtest18 | table | sbtest | 2192 kB | 
     public | sbtest19 | table | sbtest | 2192 kB | 
     public | sbtest2  | table | sbtest | 2192 kB | 
     public | sbtest20 | table | sbtest | 2192 kB | 
     public | sbtest21 | table | sbtest | 2192 kB | 
     public | sbtest22 | table | sbtest | 2192 kB | 
     public | sbtest23 | table | sbtest | 2192 kB | 
     public | sbtest24 | table | sbtest | 2192 kB | 
     public | sbtest3  | table | sbtest | 2192 kB | 
     public | sbtest4  | table | sbtest | 2192 kB | 
     public | sbtest5  | table | sbtest | 2192 kB | 
     public | sbtest6  | table | sbtest | 2192 kB | 
     public | sbtest7  | table | sbtest | 2192 kB | 
     public | sbtest8  | table | sbtest | 2192 kB | 
     public | sbtest9  | table | sbtest | 2192 kB | 
    (24 rows)

    ```
*   Test Read_Write Load 
    ```
    sysbench \
    --db-driver=pgsql \
    --report-interval=2 \
    --oltp-table-size=10000 \
    --oltp-tables-count=24 \
    --threads=64 \
    --time=60 \
    --pgsql-host=192.168.122.77 \
    --pgsql-port=5432 \
    --pgsql-user=sbtest \
    --pgsql-password=password \
    --pgsql-db=sbtest \
    /usr/share/sysbench/tests/include/oltp_legacy/oltp.lua \
    run
    ```
    Kết quả 
    ```
        SQL statistics:
        queries performed:
            read:                            114534
            write:                           32430
            other:                           16467
            total:                           163431
        transactions:                        8087   (133.88 per sec.)
        queries:                             163431 (2705.55 per sec.)
        ignored errors:                      94     (1.56 per sec.)
        reconnects:                          0      (0.00 per sec.)
    
    General statistics:
        total time:                          60.4035s
        total number of events:              8087
    
    Latency (ms):
             min:                                   56.40
             avg:                                  476.55
             max:                                 2137.08
             95th percentile:                     1304.21
             sum:                              3853890.76
    
    Threads fairness:
        events (avg/stddev):           126.3594/2.24
        execution time (avg/stddev):   60.2170/0.07

    ```
    
*   Test Read_only 
 
    ```
    sysbench \
    --db-driver=pgsql \
    --report-interval=2 \
    --oltp-table-size=10000 \
    --oltp-tables-count=24 \
    --threads=64 \
    --time=60 \
    --pgsql-host=192.168.122.77 \
    --pgsql-port=5432 \
    --pgsql-user=sbtest \
    --pgsql-password=password \
    --pgsql-db=sbtest \
    /usr/share/sysbench/tests/include/oltp_legacy/select.lua \
    run
    ```
    Kết quả
    ```
        SQL statistics:
        queries performed:
            read:                            371597
            write:                           0
            other:                           0
            total:                           371597
        transactions:                        371597 (6174.45 per sec.)
        queries:                             371597 (6174.45 per sec.)
        ignored errors:                      0      (0.00 per sec.)
        reconnects:                          0      (0.00 per sec.)
    
    General statistics:
        total time:                          60.1807s
        total number of events:              371597
    
    Latency (ms):
             min:                                    0.12
             avg:                                   10.34
             max:                                  613.52
             95th percentile:                       16.71
             sum:                              3840702.82
    
    Threads fairness:
        events (avg/stddev):           5806.2031/31.18
        execution time (avg/stddev):   60.0110/0.03
    ```
