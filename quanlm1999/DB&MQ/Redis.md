# Giới thiệu
****
#### Redis
**Re**mote **Di**ctionary **S**erver, là 1 hệ thống lưu trữ key-value rất mạnh mẽ và phổ biến. Dùng cho mục đích như , cơ sở dữ liệu, bộ nhớ tạm, message broker  và hàng đợi. 

#    Khả năng
****
**Hỗ trợ nhiều cấu trúc dữ liệu cơ bản**
*  Strings – text or binary data up to 512MB in size
*   Lists – a collection of Strings in the order they were added
*   Sets – an unordered collection of strings with the ability to intersect, union, and diff other Set types
*   Sorted Sets – Sets ordered by a value
*   Hashes – a data structure for storing a list of fields and values
*   Bitmaps – a data type that offers bit level operations
*   HyperLogLogs – a probabilistic data structure to estimate the unique items in a data set

**Lưu trữ key-value trên RAM giúp tối ưu performance**
*   Khác với PostgreSQL,Cassandra, MongoDB, và các CSDL khác thường lưu trữ trên đĩa, Redis lưu trữ trên RAM khiến cho việc thực thi nhanh hơn

**Đơn giản và dễ sử dụng**
*   Hỗ trợ nhiều ngôn ngữ như Java, Python, PHP, C, C++, C#, JavaScript, Node.js, Ruby, R, Go
*   Đơn giản code để lưu trữ, truy cập đến data store 

**Nhân rộng và đảm bảo**
* Hỗ trợ cấu trúc  primary-replica và hỗ trợ nhân rộng không đồng bộ  để dữ liệu đến nhiều server bản sao khác. Tăng tốc độ đọc và hồi phục nhanh hơn khi có sự cố xảy ra ở server chính 
* Hỗ trợ việc lưu thông tin ra đĩa để phục hồi khi gặp sự cố 

**Tính sẵn sàng cao và khả năng mở rộng** 
*   Hỗ trợ cấu trúc primary-replica với 1 máy chính hoặc 1 cụm 
*   Cụm có thể mở rộng dễ dàng 

#   Use case    
****
*   Bộ nhớ đệm 
*   Trò chuyện, nhắn tin, hàng đợi
*   Bảng xếp hạng 
*   Truyền phát đa phương tiện
*   Không gian địa lý
*   Machine Learning
*   Phân tích thời gian thực

#   Install
****
*   Sử dụng apt:
    ```
    sudo apt-get update
    sudo apt-get install redis-server
    ```
*   Install from source

    ```
    wget http://download.redis.io/redis-stable.tar.gz
    tar xvzf redis-stable.tar.gz
    cd redis-stable
    make
    make install
    ```
*   Kiểm tra: 
    * Sau khi cài đặt xong, ta chạy lệnh: `redis-server`     ( sau khi chạy sẽ trông thế này )
```
quanlm@quanlm-1:~$ redis-server 
19476:C 25 Nov 2019 16:55:16.784 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
19476:C 25 Nov 2019 16:55:16.784 # Redis version=5.0.7, bits=64, commit=00000000, modified=0, pid=19476, just started
19476:C 25 Nov 2019 16:55:16.784 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
19476:M 25 Nov 2019 16:55:16.785 * Increased maximum number of open files to 10032 (it was originally set to 1024).
                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 5.0.7 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                   
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 19476
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           http://redis.io        
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

19476:M 25 Nov 2019 16:55:16.785 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
19476:M 25 Nov 2019 16:55:16.785 # Server initialized
19476:M 25 Nov 2019 16:55:16.785 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
19476:M 25 Nov 2019 16:55:16.785 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
19476:M 25 Nov 2019 16:55:16.785 * DB loaded from disk: 0.000 seconds
19476:M 25 Nov 2019 16:55:16.785 * Ready to accept connections

```

Sang 1 tab khác để làm việc: 
Test thử 1 số lệnh:
```
quanlm@quanlm-1:~$ redis-cli
127.0.0.1:6379> ping
(error) ERR unknown command `ping`, with args beginning with:
127.0.0.1:6379> ping
PONG
127.0.0.1:6379> set mykey somevalue
OK
127.0.0.1:6379> get mykey
"somevalue"
127.0.0.1:6379>

```
#   HA  
****
Để HA redis, ta có sẵn Redis-sentinel được tích hợp sẵn 
Mô hình: 
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Redis_sentinel.png)
Đối với Redis-sentinel, tiến trình sẽ check hoạt động của các process .
Khi phát hiện ra process hoạt động không đúng như bình thường, các sentinel sẽ biểu quyết để đưa ra  thống nhất biến 1 node slave thành 1 node master và các slave còn lại sẽ theo master mới.

**Cấu hình**
*   **redis.conf**
    *   **Master**: giữ nguyên
    *   **Slave1/2**: thêm dòng sau slaveof `{master-IP}`

*   **sentinel.conf**
    *   **Master/Slave1/2**: Chỉnh sửa dòng sau: `sentinel monitor{master-name} {master-ip} 6379(port) 2(quorum)`

Ta có thể thấy giá trị quorum ở đây là số sentinels cần thiết để xác nhận rằng master bị lỗi  ( tối thiểu là 2 )

Khởi động server với lệnh: `redis-server`
Khởi động sentinel với lệnh `redis-sentinel path/to/cofig (home/$USER/redis-stable/sentinel.conf)`
Ta được như sau: 
**Master**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Screenshot%20from%202019-12-03%2010-34-05.png)
**Slave1/2**
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Screenshot%20from%202019-12-03%2010-34-07.png)
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Screenshot%20from%202019-12-03%2010-34-10.png)
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Screenshot%20from%202019-12-03%2010-42-17.png)

**Kiểm tra dùng redis-cli**
**Master**
```
127.0.0.1:6379> info replication
# Replication
role:master
connected_slaves:2
slave0:ip=192.168.122.17,port=6379,state=online,offset=44047,lag=1
slave1:ip=192.168.122.192,port=6379,state=online,offset=44047,lag=0
master_replid:affba5a62c94d9b191209f4f58d58396c035904f
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:44190
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:44190
```
**Slave1**
```
127.0.0.1:6379> info replication
# Replication
role:slave
master_host:192.168.122.118
master_port:6379
master_link_status:up
master_last_io_seconds_ago:1
master_sync_in_progress:0
slave_repl_offset:52378
slave_priority:100
slave_read_only:1
connected_slaves:0
master_replid:affba5a62c94d9b191209f4f58d58396c035904f
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:52378
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:1
repl_backlog_histlen:52378
```

**Slave2**
```
127.0.0.1:6379> info replication
# Replication
role:slave
master_host:192.168.122.118
master_port:6379
master_link_status:up
master_last_io_seconds_ago:0
master_sync_in_progress:0
slave_repl_offset:58983
slave_priority:100
slave_read_only:1
connected_slaves:0
master_replid:affba5a62c94d9b191209f4f58d58396c035904f
master_replid2:0000000000000000000000000000000000000000
master_repl_offset:58983
second_repl_offset:-1
repl_backlog_active:1
repl_backlog_size:1048576
repl_backlog_first_byte_offset:155
repl_backlog_histlen:58829

```

Kiểm tra Replicate:
**Master**
```
quanlm@Redis1:~$ redis-cli
127.0.0.1:6379> set test 1
OK
127.0.0.1:6379> get test
"1"
127.0.0.1:6379> 
```

**Slave1**
```
quanlm@Redis2:~$ redis-cli
127.0.0.1:6379> get test
"1"
127.0.0.1:6379> 
```
**Slave2**
```
quanlm@Redis3:~$ redis-cli
127.0.0.1:6379> get test
"1"
127.0.0.1:6379> 
```

Kiểm tra FO:
**Master(old)**
```
8550:M 03 Dec 2019 03:58:48.947 * Background saving started by pid 1430
1430:C 03 Dec 2019 03:58:49.096 * DB saved on disk
1430:C 03 Dec 2019 03:58:49.101 * RDB: 0 MB of memory used by copy-on-write
8550:M 03 Dec 2019 03:58:49.152 * Background saving terminated with success
/bin/bash: line 55:  8550 Killed                  redis-server ../redis.conf
```
**Slave1(new Master)**
```
8814:S 03 Dec 2019 04:01:25.418 # Error condition on socket for SYNC: Connection refused
8814:S 03 Dec 2019 04:01:26.422 * Connecting to MASTER 192.168.122.118:6379
8814:S 03 Dec 2019 04:01:26.424 * MASTER <-> REPLICA sync started
8814:S 03 Dec 2019 04:01:26.426 # Error condition on socket for SYNC: Connection refused
8814:S 03 Dec 2019 04:01:27.433 * Connecting to MASTER 192.168.122.118:6379
8814:S 03 Dec 2019 04:01:27.435 * MASTER <-> REPLICA sync started
8814:S 03 Dec 2019 04:01:27.437 # Error condition on socket for SYNC: Connection refused
8814:M 03 Dec 2019 04:01:28.338 # Setting secondary replication ID to affba5a62c94d9b191209f4f58d58396c035904f, valid up to offset: 255912. New replication ID is 08e42c148b642974f043b87c91638dc4ffa13748
8814:M 03 Dec 2019 04:01:28.339 * Discarding previously cached master state.
8814:M 03 Dec 2019 04:01:28.340 * MASTER MODE enabled (user request from 'id=6 addr=192.168.122.17:43378 fd=11 name=sentinel-30398c6d-cmd age=1205 idle=0 flags=x db=0 sub=0 psub=0 multi=3 qbuf=140 qbuf-free=32628 obl=36 oll=0 omem=0 events=r cmd=exec')
8814:M 03 Dec 2019 04:01:28.346 # CONFIG REWRITE executed with success.
8814:M 03 Dec 2019 04:01:29.108 * Replica 192.168.122.192:6379 asks for synchronization
8814:M 03 Dec 2019 04:01:29.111 * Partial resynchronization request from 192.168.122.192:6379 accepted. Sending 449 bytes of backlog starting from offset 255912.
```

**Slave2**
```
15239:S 03 Dec 2019 04:01:27.011 * Connecting to MASTER 192.168.122.118:6379
15239:S 03 Dec 2019 04:01:27.011 * MASTER <-> REPLICA sync started
15239:S 03 Dec 2019 04:01:27.013 # Error condition on socket for SYNC: Connection refused
15239:S 03 Dec 2019 04:01:28.016 * Connecting to MASTER 192.168.122.118:6379
15239:S 03 Dec 2019 04:01:28.017 * MASTER <-> REPLICA sync started
15239:S 03 Dec 2019 04:01:28.017 # Error condition on socket for SYNC: Connection refused
15239:S 03 Dec 2019 04:01:28.808 * REPLICAOF 192.168.122.17:6379 enabled (user request from 'id=6 addr=192.168.122.17:48834 fd=11 name=sentinel-30398c6d-cmd age=1205 idle=0 flags=x db=0 sub=0 psub=0 multi=3 qbuf=295 qbuf-free=32473 obl=36 oll=0 omem=0 events=r cmd=exec')
15239:S 03 Dec 2019 04:01:28.815 # CONFIG REWRITE executed with success.
15239:S 03 Dec 2019 04:01:29.028 * Connecting to MASTER 192.168.122.17:6379
15239:S 03 Dec 2019 04:01:29.031 * MASTER <-> REPLICA sync started
15239:S 03 Dec 2019 04:01:29.033 * Non blocking connect for SYNC fired the event.
15239:S 03 Dec 2019 04:01:29.036 * Master replied to PING, replication can continue...
15239:S 03 Dec 2019 04:01:29.040 * Trying a partial resynchronization (request affba5a62c94d9b191209f4f58d58396c035904f:255912).
15239:S 03 Dec 2019 04:01:29.046 * Successful partial resynchronization with master.
15239:S 03 Dec 2019 04:01:29.046 # Master replication ID changed to 08e42c148b642974f043b87c91638dc4ffa13748
15239:S 03 Dec 2019 04:01:29.047 * MASTER <-> REPLICA sync: Master accepted a Partial Resynchronization.
```
Ta có thể thấy rằng sau khi master chết, tự động Slave 1 trở thành master mới và slave 2 trở thành slave của  master mới Vì cấu trúc Master-Slave nên các slave được đặt vào chế độ read-only, điều nà y có thể được sửa trong file `redis.conf`
#   Benchmark 
****
Redis hỗ trợ benchmark khi cài đặt: sử dụng lệnh `redis-benchmark `
```
Redis-benchmark [-h <host>] [-p <port>] [-c <clients>] [-n <requests]> [-k <boolean>]

 -h <hostname>      Server hostname (default 127.0.0.1)
 -p <port>          Server port (default 6379)
 -s <socket>        Server socket (overrides host and port)
 -a <password>      Password for Redis Auth
 -c <clients>       Number of parallel connections (default 50)
 -n <requests>      Total number of requests (default 100000)
 -d <size>          Data size of SET/GET value in bytes (default 2)
 --dbnum <db>       SELECT the specified db number (default 0)
 -k <boolean>       1=keep alive 0=reconnect (default 1)
 -r <keyspacelen>   Use random keys for SET/GET/INCR, random values for SADD
  Using this option the benchmark will expand the string __rand_int__
  inside an argument with a 12 digits number in the specified range
  from 0 to keyspacelen-1. The substitution changes every time a command
  is executed. Default tests use this to hit random keys in the
  specified range.
 -P <numreq>        Pipeline <numreq> requests. Default 1 (no pipeline).
 -q                 Quiet. Just show query/sec values
 --csv              Output in CSV format
 -l                 Loop. Run the tests forever
 -t <tests>         Only run the comma separated list of tests. The test
                    names are the same as the ones produced as output.
 -I                 Idle mode. Just open N idle connections and wait.
```

#### Benchmark result: https://docs.google.com/spreadsheets/d/1Hll999Q3hnQ5guirKqd-bjSx65_VSZqHYu7Et9RA9-4/edit?usp=sharing
