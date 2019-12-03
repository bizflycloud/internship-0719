#   Giới thiệu
***

### Kiến trúc  
Aerospike là một cơ sở dữ liệu phân tán, có thể mở rộng. Kiến trúc có ba mục tiêu chính:
*  Tạo ra nền tảng linh hoạt, có thể mở rộng cho ứng dụng web.
*   Hỗ trợ độ tin cậy (trong ACID) như các CSDL truyền thống.
*   Hiệu quả hoạt động mà không cần thao tác thủ công nhiều .

Cấu trúc của Aero spike có 3 lớp:
*   **Client Layer**: Bao gồm có thư viện mã nguồn mở, track nodes, nhận biết dữ liệu được lưu trữ ở đâu 
*   **Clustering and Data Distribution Layer**:Kiểm soát việc liên lạc giữa các cụm, tự động FO, nhân rộng, đồng bộ hóa dữ liệu chéo, cân bằng và di chuyển dữ liệu 1 cách thông minh
*   **Data Storage Layer** Lưu trữ dữ liệu 1 cách tin cậy trên DRAM hoặc FLASH  để thu hồi nhanh hơn

# Khả năng
****

Aerospike hỗ trợ hoạt động khóa-giá trị cải tiến. Dữ liệu được cấu trúc trong các `bins`, mỗi bin này sẽ hỗ trợ các loại dữ liệu như: 

*   integer
*    string
*    float
*    list
*    map
*    geojson
*    binary object
*    language-serialized objects. 

Quản lý dữ liệu bao gồm:

*   Hoạt động khóa-giá trị, bao gồm các hoạt động trong CSDL như tăng giảm, liệt kê các yếu tố hoạt động 
*   Sao chép dữ liệu để có tính sẵn sàng cao 
*   Tự động hết hạn và trục xuất dữ liệu
*   Nâng cấp liền mạch và thay đổi kích thước cụm
*   Tối ưu cho Flash(SSD) 
*   Sao chép chéo CSDL (XDR)

Phân phối:
Aerospike được thiết kế để chạy những ứng dụng càcần hoạt động 24/7  và có thể chịu được lượng dữ liệu lớn.
*   Tự động phát hiện vị trí dữ liệu: 
*   Tự động cân bằng các cụm
*   Không có điểm chịu lỗi duy nhất 


Ngoài ra Aerospike còn hỗ trợ

*   **Kiểu dữ liệu phức tạp** trong `bins` (list, map và có thể nest )
*   **Truy vấn** sử dụng các chuỗi chỉ mục và giá trị số của bin được tìm kiếm đồng thời 
*   **Hàm do người dùng định nghĩa** cho phép tăng tốc độ xử lý của CSDL bằng cách thực hiện các ứng dụng 
*   **Aggregations** là tập hợp các bản ghi mà UDF và giá trị aggregations trả về.
*   **Nhiều ngôn ngữ** 
#  Mục đích sử dụng
****

*   Giảm tổng chi phí sở hữu (TCO)
*   Cần mở rộng và đàn hồi cao 
*   Độ ổn định cao và tính sẵn sàng cao 
*   Cần dữ liệu thống nhất với nhau
*   Cần khả năng quản lý và vận hành dễ dàng khi mở rộng quy mô   
*   Thời gian hoạt động cao (99,999%)

#   Use case 
****

*   Phòng chống lỗi 
*   IOT
*   Payment Processing
*   Online Gaming and Gambling
*   Messaging & Chat
*   Ecommerce and Retail
*   Telecomunication


#   Install
****

Download: `wget -O aerospike.tgz 'https://www.aerospike.com/download/server/latest/artifact/ubuntu18`

Extract: `tar -xvf aerospike.tgz`

Install:
`cd aerospike-server-community-*-ubuntu18*`
`sudo ./asinstall`


Start: `sudo service aerospike start `
Check: `sudo service aerospike status`

Check log:`
`sudo tail -f /var/log/aerospike/aerospike.log | grep cake`

Kết quả trả về: `Nov 29 2019 02:26:32 GMT: INFO (as): (as.c:420) service ready: soon there will be cake!`

#   HA
****
**Tạo cluster Aerospike rất đơn giản, chỉ cần tối thiểu 2 node, có 2 cách cấu hình: multicast và mesh (unicast)**

**Cấu hình Mesh**
* 2 node truy cập vào thư mục `/etc/aerospike/aerospike.conf`
* Trong network/heartbeat:
    * đặt **mode mesh**
    * đặt **address là address interface để heartbeat**
    * **port 3002** là port để heartbeat
    * thêm **mesh-seed-address-port: tất cả IP của máy muốn trong cluster**

*   VD: 
```
network {
        service {
                address any
                port 3000
        }

        heartbeat {
                mode mesh
                address 192.168.122.17
                port 3002
        # Heartbeat port for this node.
                # To use unicast-mesh heartbeats, remove the 3 lines above, and see
                # aerospike_mesh.conf for alternative.
                mesh-seed-address-port 192.168.122.17  3002
                mesh-seed-address-port 192.168.122.118  3002
                interval 150
                timeout 10
        }
```
**Cấu hình Multicast**
* 2 node truy cập vào thư mục `/etc/aerospike/aerospike.conf`
* Trong network/heartbeat:
    * đặt **mode multicast**
    * đặt **multicast-group** (239.0.0.0-239.255.255.255)
    * đặt port là 9918
    * đặt địa chỉ IP interface heartbeat 

*   VD
```
network {
        service {
                address any
                port 3000
        }

        heartbeat {
                mode multicast
                multicast-group 239.1.99.2
                port 9918
                address 192.168.122.17

        # Heartbeat port for this node.
                # To use unicast-mesh heartbeats, remove the 3 lines above, and see
                # aerospike_mesh.conf for alternative.
                interval 150
                timeout 10
        }

```

**Khi xong thì ra kiểm tra ta được như hình:** 
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Screenshot%20from%202019-12-02%2014-38-53.png)
Ta có thể thấy 2 node đã cùng nằm trong cluster 

**Dữ liệu cũng đã được sao chép sang node trong cluster**
```
quanlm@Aero1:/var/log⟫ aql
Seed:         127.0.0.1
User:         None
Config File:  /etc/aerospike/astools.conf /home/quanlm/.aerospike/astools.conf 
Aerospike Query Client
Version 3.21.1
C Client Version 4.6.5
Copyright 2012-2019 Aerospike. All rights reserved.
aql> CREATE INDEX ind1 ON test.demo (bin1) NUMERIC
OK, 1 index added.
```
```
quanlm@Aero2:~/aerospike-server-community-4.7.0.5-ubuntu16.04⟫ aql
Seed:         127.0.0.1
User:         None
Config File:  /etc/aerospike/astools.conf /home/quanlm/.aerospike/astools.conf 
Aerospike Query Client
Version 3.21.1
C Client Version 4.6.5
Copyright 2012-2019 Aerospike. All rights reserved.
aql> CREATE INDEX ind1 ON test.demo (bin1) NUMERIC
Error: (200)  Index with the same name already exists or this bin has already been indexed.

aql> show indexes
+--------+--------+-----------+--------+-------+-----------+--------+-----------+
| ns     | bin    | indextype | set    | state | indexname | path   | type      |
+--------+--------+-----------+--------+-------+-----------+--------+-----------+
| "test" | "bin1" | "NONE"    | "demo" | "RW"  | "ind1"    | "bin1" | "NUMERIC" |
+--------+--------+-----------+--------+-------+-----------+--------+-----------+
[127.0.0.1:3000] 1 row in set (0.008 secs)

+--------+--------+-----------+--------+-------+-----------+--------+-----------+
| ns     | bin    | indextype | set    | state | indexname | path   | type      |
+--------+--------+-----------+--------+-------+-----------+--------+-----------+
| "test" | "bin1" | "NONE"    | "demo" | "RW"  | "ind1"    | "bin1" | "NUMERIC" |
+--------+--------+-----------+--------+-------+-----------+--------+-----------+
[192.168.122.118:3000] 1 row in set (0.015 secs)

OK
```
**Có thể thấy khi cố add lại 1 Index tương tự, kết quả trả về là đã có index đó rồi**
**Các node là như nhau nên đều có thể làm việc được**
```
quanlm@Aero1:/var/log⟫ asadm
Seed:        [('127.0.0.1', 3000, None)]
Config_file: /home/quanlm/.aerospike/astools.conf, /etc/aerospike/astools.conf
Aerospike Interactive Shell, version 0.3.0

Found 1 nodes
Online:  192.168.122.118:3000
Extra nodes in alumni list: 192.168.122.17:3000

Admin> info
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Network Information (2019-12-02 07:57:50 UTC)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      Node               Node                     Ip       Build   Cluster   Migrations        Cluster     Cluster         Principal   Client     Uptime   
         .                 Id                      .           .      Size            .            Key   Integrity                 .    Conns          .   
Aero1:3000   *BB9D0B08A005452   192.168.122.118:3000   C-4.7.0.5         1      0.000     91EC5E682BD9   True        BB9D0B08A005452        4   00:01:17   
Number of rows: 1

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Namespace Usage Information (2019-12-02 07:57:50 UTC)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Namespace         Node     Total   Expirations,Evictions     Stop       Disk    Disk     HWM   Avail%         Mem     Mem    HWM      Stop          PI         PI      PI     PI   
        .            .   Records                       .   Writes       Used   Used%   Disk%        .        Used   Used%   Mem%   Writes%        Type       Used   Used%   HWM%   
bar         Aero1:3000   0.000     (0.000,  0.000)         false         N/E   N/E     50      N/E       0.000 B    0       60     90        undefined   0.000 B    0       N/E    
bar                      0.000     (0.000,  0.000)                  0.000 B                              0.000 B                                         0.000 B                   
test        Aero1:3000   0.000     (0.000,  0.000)         false         N/E   N/E     50      N/E      18.000 KB   1       60     90        undefined   0.000 B    0       N/E    
test                     0.000     (0.000,  0.000)                  0.000 B                             18.000 KB                                        0.000 B                   
Number of rows: 4

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Namespace Object Information (2019-12-02 07:57:50 UTC)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Namespace         Node     Total     Repl                      Objects                   Tombstones             Pending   Rack   
        .            .   Records   Factor   (Master,Prole,Non-Replica)   (Master,Prole,Non-Replica)            Migrates     ID   
        .            .         .        .                            .                            .             (tx,rx)      .   
bar         Aero1:3000   0.000     1        (0.000,  0.000,  0.000)      (0.000,  0.000,  0.000)      (0.000,  0.000)     0      
bar                      0.000              (0.000,  0.000,  0.000)      (0.000,  0.000,  0.000)      (0.000,  0.000)            
test        Aero1:3000   0.000     1        (0.000,  0.000,  0.000)      (0.000,  0.000,  0.000)      (0.000,  0.000)     0      
test                     0.000              (0.000,  0.000,  0.000)      (0.000,  0.000,  0.000)      (0.000,  0.000)            
Number of rows: 4
```
**Khi tắt sv Aero2**
```

Admin> exit
quanlm@Aero1:/var/log⟫ asadm
Seed:        [('127.0.0.1', 3000, None)]
Config_file: /home/quanlm/.aerospike/astools.conf, /etc/aerospike/astools.conf
Aerospike Interactive Shell, version 0.3.0

Found 2 nodes
Online:  192.168.122.17:3000, 192.168.122.118:3000

Admin> info
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Network Information (2019-12-02 07:58:06 UTC)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      Node               Node                     Ip       Build   Cluster   Migrations       Cluster     Cluster         Principal   Client     Uptime   
         .                 Id                      .           .      Size            .           Key   Integrity                 .    Conns          .   
Aero1:3000   *BB9D0B08A005452   192.168.122.118:3000   C-4.7.0.5         2     11.547 K   E3D9956C2F6   True        BB9D0B08A005452        2   00:01:34   
Aero2:3000   BB91E7DB8005452    192.168.122.17:3000    C-4.7.0.5         2     11.555 K   E3D9956C2F6   True        BB9D0B08A005452        5   00:00:57   
Number of rows: 2

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Namespace Usage Information (2019-12-02 07:58:06 UTC)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Namespace         Node     Total   Expirations,Evictions     Stop       Disk    Disk     HWM   Avail%         Mem     Mem    HWM      Stop          PI         PI      PI     PI   
        .            .   Records                       .   Writes       Used   Used%   Disk%        .        Used   Used%   Mem%   Writes%        Type       Used   Used%   HWM%   
bar         Aero1:3000   0.000     (0.000,  0.000)         false         N/E   N/E     50      N/E       0.000 B    0       60     90        undefined   0.000 B    0       N/E    
bar         Aero2:3000   0.000     (0.000,  0.000)         false         N/E   N/E     50      N/E       0.000 B    0       60     90        undefined   0.000 B    0       N/E    
bar                      0.000     (0.000,  0.000)                  0.000 B                              0.000 B                                         0.000 B                   
test        Aero1:3000   0.000     (0.000,  0.000)         false         N/E   N/E     50      N/E      18.000 KB   1       60     90        undefined   0.000 B    0       N/E    
test        Aero2:3000   0.000     (0.000,  0.000)         false         N/E   N/E     50      N/E      18.000 KB   1       60     90        undefined   0.000 B    0       N/E    
test                     0.000     (0.000,  0.000)                  0.000 B                             36.000 KB                                        0.000 B                   
Number of rows: 6

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Namespace Object Information (2019-12-02 07:58:06 UTC)~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Namespace         Node     Total     Repl                      Objects                   Tombstones               Pending   Rack   
        .            .   Records   Factor   (Master,Prole,Non-Replica)   (Master,Prole,Non-Replica)              Migrates     ID   
        .            .         .        .                            .                            .               (tx,rx)      .   
bar         Aero1:3000   0.000     2        (0.000,  0.000,  0.000)      (0.000,  0.000,  0.000)      (3.716 K, 3.719 K)    0      
bar         Aero2:3000   0.000     2        (0.000,  0.000,  0.000)      (0.000,  0.000,  0.000)      (3.719 K, 3.715 K)    0      
bar                      0.000              (0.000,  0.000,  0.000)      (0.000,  0.000,  0.000)      (7.435 K, 7.434 K)           
test        Aero1:3000   0.000     2        (0.000,  0.000,  0.000)      (0.000,  0.000,  0.000)      (2.072 K, 2.024 K)    0      
test        Aero2:3000   0.000     2        (0.000,  0.000,  0.000)      (0.000,  0.000,  0.000)      (2.024 K, 2.072 K)    0      
test                     0.000              (0.000,  0.000,  0.000)      (0.000,  0.000,  0.000)      (4.096 K, 4.096 K)           
Number of rows: 6
```
**Khi bật trở lại**

#   Benchmark
***
Ta sử dụng **Aerospike Go client benchmark tool** 

**Build**

```
go get github.com/aerospike/aerospike-client-go
cd $GOPATH/src/github.com/aerospike/aerospike-client-go/tools/benchmark
go build .
```
**Run**
`go run benchmark.go`

**Output**
```
quanlm@quanlm-1:~/go/src/github.com/aerospike/aerospike-client-go/tools/benchmark$ go run benchmark.go

2019/12/03 12:02:32 Setting number of CPUs to use: 4
2019/12/03 12:02:32 benchmark.go:197: hosts:		127.0.0.1
2019/12/03 12:02:32 benchmark.go:198: port:		3000
2019/12/03 12:02:32 benchmark.go:199: namespace:	test
2019/12/03 12:02:32 benchmark.go:200: set:		testset
2019/12/03 12:02:32 benchmark.go:201: keys/records:	1000000
2019/12/03 12:02:32 benchmark.go:202: object spec:	I, size: 0
2019/12/03 12:02:32 benchmark.go:203: random bin values:	false
2019/12/03 12:02:32 benchmark.go:204: workload:		Initialize 100% of records
2019/12/03 12:02:32 benchmark.go:205: concurrency:	32
2019/12/03 12:02:32 benchmark.go:206: max throughput:	unlimited
2019/12/03 12:02:32 benchmark.go:207: timeout:		0 ms
2019/12/03 12:02:32 benchmark.go:208: max retries:	2
2019/12/03 12:02:32 benchmark.go:209: debug:		false
2019/12/03 12:02:32 benchmark.go:210: latency:		0:0
2019/12/03 12:02:32 benchmark.go:211: conn. pool size:	128
2019/12/03 12:02:32 benchmark.go:212: conn. threshold:	64
2019/12/03 12:02:32 benchmark.go:151: Warm-up conns.	:127
2019/12/03 12:02:32 benchmark.go:153: Nodes Found: [BB93922DF3E16FA]
2019/12/03 12:02:33 benchmark.go:730: write(tps=72073 timeouts=0 errors=0 totalCount=72073)
2019/12/03 12:02:34 benchmark.go:730: write(tps=84956 timeouts=0 errors=0 totalCount=157029)
2019/12/03 12:02:36 benchmark.go:730: write(tps=79687 timeouts=0 errors=0 totalCount=236716)
2019/12/03 12:02:37 benchmark.go:730: write(tps=79693 timeouts=0 errors=0 totalCount=316409)
2019/12/03 12:02:38 benchmark.go:730: write(tps=83647 timeouts=0 errors=0 totalCount=400056)
2019/12/03 12:02:39 benchmark.go:730: write(tps=71748 timeouts=0 errors=0 totalCount=471804)
2019/12/03 12:02:40 benchmark.go:730: write(tps=89200 timeouts=0 errors=0 totalCount=561004)
```
Thông số khác :
```
quanlm@quanlm-1:~/go/src/github.com/aerospike/aerospike-client-go/tools/benchmark$ ./benchmark -u
2019/12/03 12:04:50 Setting number of CPUs to use: 4
Usage of ./benchmark:
  -A string
    	Authentication mode: internal | external (default "internal")
  -L string
    	Latency <columns>,<shift>.
    		Show transaction latency percentages using elapsed time ranges.
    		<columns> Number of elapsed time ranges.
    		<shift>   Power of 2 multiple between each range starting at column 3.
  -M	Use marshaling a struct instead of simple key/value operations
  -P string
    	User password.
  -R	Use dynamically generated random bin values instead of default static fixed bin values.
  -T int
    	Read/Write timeout in milliseconds.
  -U string
    	User name.
  -c int
    	Number of goroutines to generate load. (default 32)
  -d	Run benchmarks in debug mode.
  -g int
    	Throttle transactions per second to a maximum value.
    		If tps is zero, do not throttle throughput.
  -h string
    	Aerospike server seed hostnames or IP addresses (default "127.0.0.1")
  -k int
    	Key/record count or key/record range. (default 1000000)
  -maxRetries int
    	Maximum number of retries before aborting the current transaction. (default 2)
  -n string
    	Aerospike namespace. (default "test")
  -o string
    	Bin object specification.
    		I	: Read/write integer bin.
    		B:200	: Read/write byte array bin of length 200.
    		S:50	: Read/write string bin of length 50. (default "I")
  -openingConnectionThreshold int
    	Maximum number of connections allowed to open simultaniously. (default 64)
  -p int
    	Aerospike server seed hostname or IP address port number. (default 3000)
  -profile
    	Run benchmarks with profiler active on port 6060 by default.
  -profilePort int
    	Profile port. (default 6060)
  -queueSize int
    	Maximum number of connections to pool. (default 128)
  -s string
    	Aerospike set name. (default "testset")
  -u	Show usage information.
  -w string
    	Desired workload.
    		I:60	: Linear 'insert' workload initializing 60% of the keys.
    		RU:80	: Random read/update workload with 80% reads and 20% writes. (default "I:100")
  -warmUp int
    	Number of connections to open on start up. (default 128)

```

#### Benchmark result: https://docs.google.com/spreadsheets/d/1Hll999Q3hnQ5guirKqd-bjSx65_VSZqHYu7Et9RA9-4/edit?usp=sharing

**Ta có thể thấy hiệu năng của Aerospike vượt trội hơn redis**

`
