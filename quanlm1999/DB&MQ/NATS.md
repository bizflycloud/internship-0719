KQ benchmark : https://docs.google.com/spreadsheets/d/1_XLV_KKw3cTamAT_Lc9u16D6p0aRt87y9u8ZKQgQuAE/edit?usp=sharing
# Khả năng
****
    Dễ sử dụng và vận hành 
    Hiệu năng cao
    Độ sẵn sàng cao
    Rất nhẹ
    At Most Once and At Least Once Delivery
    Support for Observable and Scalable Services and Event/Data Streams
    Hỗ trợ nhiều ngôn ngữ 
    Cloud Native, a CNCF project with Kubernetes and Prometheus integrations
    
#  Mục đích sử dụng
****
    Cloud Messaging

        Services (microservices, service mesh)

        Event/Data Streaming (observability, analytics, ML/AI)

    Command and Control

        IoT and Edge

        Telemetry / Sensor Data / Command and Control

    Augmenting or Replacing Legacy Messaging Systems
#   Install
****
**Download:**

`wget https://github.com/nats-io/nats-server/releases/download/v2.1.2/nats-server-v2.1.2-386.deb` 
Hoặc
`wget https://github.com/nats-io/nats-server/releases/download/v2.1.2/nats-server-v2.1.2-amd64.deb`

**Cài đặt**
`sudo dpkg -i nats-server-v2.1.2-amd64.deb`
hoặc
`sudo dpkg -i nats-server-v2.1.2-386.deb`

**Khởi động:**
```
quanlm@rabbitmq1:~$ nats-server 
[4923] 2019/12/24 03:40:16.513044 [INF] Starting nats-server version 2.1.2
[4923] 2019/12/24 03:40:16.516183 [INF] Git commit [679beda]
[4923] 2019/12/24 03:40:16.520154 [INF] Listening for client connections on 0.0.0.0:4222
[4923] 2019/12/24 03:40:16.522575 [INF] Server id is NDSFAU5D2FASOC7ZK6RVWGCGZF5WK3OMQGVYI5XKOCHUHKJ3I2OKLM2F
[4923] 2019/12/24 03:40:16.524778 [INF] Server is ready
```

**Option**

* `nats-server -p xxxx` (chạy ở port port xxxx, mặc định là 4222)
* `nats-server -m xxxx` (chạy monitor ở port xxxx)

Monitor
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Screenshot%20from%202019-12-24%2010-42-18.png)
#   HA
****
**Mô hình:**
![](https://raw.githubusercontent.com/lmq1999/123/master/Untitled%20Diagram.png)

**Chọn 1 node là mốc**
* Chọn  node `192.168.122.253` là mốc
    * Chạy server với lệnh sau: `nats-server -p 4222 -cluster nats://192.168.122.253:4248 -D`
        ```
        quanlm@rabbitmq1:~$ nats-server -p 4222 -cluster nats://192.168.122.253:4248 -D
        [23052] 2019/12/24 04:34:06.999773 [INF] Starting nats-server version 2.1.2
        [23052] 2019/12/24 04:34:07.001280 [DBG] Go build version go1.12.13
        [23052] 2019/12/24 04:34:07.001564 [INF] Git commit [679beda]
        [23052] 2019/12/24 04:34:07.002263 [INF] Listening for client connections on 0.0.0.0:4222
        [23052] 2019/12/24 04:34:07.002613 [INF] Server id is NDT4NV7JCDND4JFEHQGMP2ETMIUDOFCK5HLQRP7R3DEBVUSA3KJC6QRQ
        [23052] 2019/12/24 04:34:07.002833 [INF] Server is ready
        [23052] 2019/12/24 04:34:07.003061 [DBG] Get non local IPs for "0.0.0.0"
        [23052] 2019/12/24 04:34:07.003693 [DBG]  ip=192.168.122.253
        ```
    
    * Chạy server thứ 2 với lệnh sau: `nats-server -p 4222 -cluster nats://192.168.122.17:4248 -routes nats://192.168.122.253:4248 -D`
        ```
        quanlm@rabbitmq2:~$ nats-server -p 4222 -cluster nats://192.168.122.17:4248 -routes nats://192.168.122.253:4248 -D
        [24597] 2019/12/24 04:35:10.820098 [INF] Starting nats-server version 2.1.2
        [24597] 2019/12/24 04:35:10.822916 [DBG] Go build version go1.12.13
        [24597] 2019/12/24 04:35:10.825204 [INF] Git commit [679beda]
        [24597] 2019/12/24 04:35:10.828186 [INF] Listening for client connections on 0.0.0.0:4222
        [24597] 2019/12/24 04:35:10.830524 [INF] Server id is NCEZZUAD5FDLR4WT7NU34KGZM7HTAZMKFRL3R74Q4XLCQS2DDGLY32I4
        [24597] 2019/12/24 04:35:10.831732 [INF] Server is ready
        [24597] 2019/12/24 04:35:10.832246 [DBG] Get non local IPs for "0.0.0.0"
        [24597] 2019/12/24 04:35:10.834477 [DBG]  ip=192.168.122.17
        [24597] 2019/12/24 04:35:10.836473 [INF] Listening for route connections on 192.168.122.17:4248
        [24597] 2019/12/24 04:35:10.837975 [DBG] Trying to connect to route on 192.168.122.253:4248
        [24597] 2019/12/24 04:35:10.839994 [DBG] 192.168.122.253:4248 - rid:1 - Route connect msg sent
        [24597] 2019/12/24 04:35:10.841361 [INF] 192.168.122.253:4248 - rid:1 - Route connection created
        [24597] 2019/12/24 04:35:10.842151 [DBG] 192.168.122.253:4248 - rid:1 - Registering remote route "NDT4NV7JCDND4JFEHQGMP2ETMIUDOFCK5HLQRP7R3DEBVUSA3KJC6QRQ"
        [24597] 2019/12/24 04:35:10.847050 [DBG] 192.168.122.253:4248 - rid:1 - Sent local subscriptions to route
        [24597] 2019/12/24 04:35:10.845393 [INF] 192.168.122.3:46242 - rid:2 - Route connection created
        ```
        
    *   Ở server mốc ta  sẽ thấy : 
        ```
        [23052] 2019/12/24 04:34:07.005115 [INF] Listening for route connections on 192.168.122.253:4248
        [23052] 2019/12/24 04:34:10.829363 [INF] 192.168.122.17:52618 - rid:1 - Route connection created
        [23052] 2019/12/24 04:34:10.831963 [DBG] 192.168.122.17:52618 - rid:1 - Registering remote route "NCBF4P3VQPDA7VVARCQQCGTBT752DP4WF3IZDMCWKEVR742NHA4YIP7M"
        [23052] 2019/12/24 04:34:10.832049 [DBG] 192.168.122.17:52618 - rid:1 - Sent local subscriptions to route
        [23052] 2019/12/24 04:34:12.017321 [DBG] 192.168.122.17:52618 - rid:1 - Router Ping Timer
        ```
    
    * Chạy server 3 với câu lệnh sau: `nats-server -p 4222 -cluster nats://192.168.122.3:4248 -routes nats://192.168.122.253:4248 -D`
        ```
        [23810] 2019/12/24 04:34:58.315776 [INF] Starting nats-server version 2.1.2
        [23810] 2019/12/24 04:34:58.318391 [DBG] Go build version go1.12.13
        [23810] 2019/12/24 04:34:58.321221 [INF] Git commit [679beda]
        [23810] 2019/12/24 04:34:58.324447 [INF] Listening for client connections on 0.0.0.0:4222
        [23810] 2019/12/24 04:34:58.326779 [INF] Server id is NCYAEK7TGYS7BFJQYE4FH2QPPLE4PLKYTPWU4EVAA4JFLECI25WTWMVF
        [23810] 2019/12/24 04:34:58.328272 [INF] Server is ready
        [23810] 2019/12/24 04:34:58.328768 [DBG] Get non local IPs for "0.0.0.0"
        [23810] 2019/12/24 04:34:58.331640 [DBG]  ip=192.168.122.3
        [23810] 2019/12/24 04:34:58.333429 [INF] Listening for route connections on 192.168.122.3:4248
        [23810] 2019/12/24 04:34:58.337511 [DBG] Trying to connect to route on 192.168.122.253:4248
        [23810] 2019/12/24 04:34:58.343874 [DBG] 192.168.122.253:4248 - rid:1 - Route connect msg sent
        [23810] 2019/12/24 04:34:58.347336 [DBG] 192.168.122.253:4248 - rid:1 - Registering remote route "NDT4NV7JCDND4JFEHQGMP2ETMIUDOFCK5HLQRP7R3DEBVUSA3KJC6QRQ"
        [23810] 2019/12/24 04:34:58.351007 [DBG] 192.168.122.253:4248 - rid:1 - Sent local subscriptions to route
        [23810] 2019/12/24 04:34:58.354840 [INF] 192.168.122.253:4248 - rid:1 - Route connection created
        [23810] 2019/12/24 04:34:58.358112 [DBG] 192.168.122.17:47052 - rid:2 - Registering remote route "NCBF4P3VQPDA7VVARCQQCGTBT752DP4WF3IZDMCWKEVR742NHA4YIP7M"
        [23810] 2019/12/24 04:34:58.359479 [DBG] 192.168.122.17:47052 - rid:2 - Sent local subscriptions to route
        [23810] 2019/12/24 04:34:58.360931 [INF] 192.168.122.17:47052 - rid:2 - Route connection created
        [23810] 2019/12/24 04:34:59.425097 [DBG] 192.168.122.253:4248 - rid:1 - Router Ping Timer
        [23810] 2019/12/24 04:34:59.469676 [DBG] 192.168.122.17:47052 - rid:2 - Router Ping Timer
        [23810] 2019/12/24 04:35:02.555369 [INF] 192.168.122.17:47052 - rid:2 - Router connection closed
        [23810] 2019/12/24 04:35:10.885308 [DBG] Trying to connect to route on 192.168.122.17:4248
        [23810] 2019/12/24 04:35:10.888444 [DBG] 192.168.122.17:4248 - rid:3 - Route connect msg sent
        [23810] 2019/12/24 04:35:10.890570 [DBG] 192.168.122.17:4248 - rid:3 - Registering remote route "NCEZZUAD5FDLR4WT7NU34KGZM7HTAZMKFRL3R74Q4XLCQS2DDGLY32I4"
        [23810] 2019/12/24 04:35:10.890619 [DBG] 192.168.122.17:4248 - rid:3 - Sent local subscriptions to route
        [23810] 2019/12/24 04:35:10.895551 [INF] 192.168.122.17:4248 - rid:3 - Route connection created
        [23810] 2019/12/24 04:35:12.035228 [DBG] 192.168.122.17:4248 - rid:3 - Router Ping Timer
        [23810] 2019/12/24 04:36:59.425991 [DBG] 192.168.122.253:4248 - rid:1 - Router Ping Timer
        [23810] 2019/12/24 04:37:12.036178 [DBG] 192.168.122.17:4248 - rid:3 - Router Ping Timer
        [23810] 2019/12/24 04:38:59.427055 [DBG] 192.168.122.253:4248 - rid:1 - Router Ping Timer
        [23810] 2019/12/24 04:39:12.037222 [DBG] 192.168.122.17:4248 - rid:3 - Router Ping Timer
        [23810] 2019/12/24 04:40:59.428244 [DBG] 192.168.122.253:4248 - rid:1 - Router Ping Timer
        [23810] 2019/12/24 04:41:12.038164 [DBG] 192.168.122.17:4248 - rid:3 - Router Ping Timer
        ```
        
* Ta có thể thấy server 3 đã kết nối với server 1 và 2 
* Ở server 1 và 2 sẽ có: 
    *   Server 1 
        ```
        23052] 2019/12/24 04:34:26.351149 [INF] 192.168.122.3:32984 - rid:2 - Route connection created
        [23052] 2019/12/24 04:34:26.353565 [DBG] 192.168.122.3:32984 - rid:2 - Registering remote route "NA7EWWAAAHPMDB2TFOUABELRACVOJYI37SD7VEYBR44WXJE35IPNJ3DX"
        [23052] 2019/12/24 04:34:26.354498 [DBG] 192.168.122.3:32984 - rid:2 - Sent local subscriptions to route
        [23052] 2019/12/24 04:34:27.450888 [DBG] 192.168.122.3:32984 - rid:2 - Router Ping Timer
        [23052] 2019/12/24 04:34:50.464526 [INF] 192.168.122.3:32984 - rid:2 - Router connection closed
        [23052] 2019/12/24 04:34:58.342318 [INF] 192.168.122.3:32986 - rid:3 - Route connection created
        [23052] 2019/12/24 04:34:58.350458 [DBG] 192.168.122.3:32986 - rid:3 - Registering remote route "NCYAEK7TGYS7BFJQYE4FH2QPPLE4PLKYTPWU4EVAA4JFLECI25WTWMVF"
        [23052] 2019/12/24 04:34:58.350579 [DBG] 192.168.122.3:32986 - rid:3 - Sent local subscriptions to route
        [23052] 2019/12/24 04:34:59.358063 [DBG] 192.168.122.3:32986 - rid:3 - Router Ping Timer
        [23052] 2019/12/24 04:35:02.552559 [INF] 192.168.122.17:52618 - rid:1 - Router connection closed
        [23052] 2019/12/24 04:35:10.879834 [INF] 192.168.122.17:52624 - rid:4 - Route connection created
        [23052] 2019/12/24 04:35:10.881241 [DBG] 192.168.122.17:52624 - rid:4 - Registering remote route "NCEZZUAD5FDLR4WT7NU34KGZM7HTAZMKFRL3R74Q4XLCQS2DDGLY32I4"
        [23052] 2019/12/24 04:35:10.881302 [DBG] 192.168.122.17:52624 - rid:4 - Sent local subscriptions to route
        [23052] 2019/12/24 04:35:12.027640 [DBG] 192.168.122.17:52624 - rid:4 - Router Ping Timer
        [23052] 2019/12/24 04:36:59.358910 [DBG] 192.168.122.3:32986 - rid:3 - Router Ping Timer
        [23052] 2019/12/24 04:36:59.359078 [DBG] 192.168.122.3:32986 - rid:3 - Delaying PING due to remote ping 2m0s ago
        [23052] 2019/12/24 04:37:12.028781 [DBG] 192.168.122.17:52624 - rid:4 - Router Ping Timer
        [23052] 2019/12/24 04:38:59.359552 [DBG] 192.168.122.3:32986 - rid:3 - Router Ping Timer
        [23052] 2019/12/24 04:38:59.359755 [DBG] 192.168.122.3:32986 - rid:3 - Delaying PING due to remote ping 2m0s ago
        [23052] 2019/12/24 04:39:12.029674 [DBG] 192.168.122.17:52624 - rid:4 - Router Ping Timer
        [23052] 2019/12/24 04:40:59.360235 [DBG] 192.168.122.3:32986 - rid:3 - Router Ping Timer
        [23052] 2019/12/24 04:40:59.360325 [DBG] 192.168.122.3:32986 - rid:3 - Delaying PING due to remote ping 2m0s ago
        [23052] 2019/12/24 04:41:12.030545 [DBG] 192.168.122.17:52624 - rid:4 - Router Ping Timer
        [23052] 2019/12/24 04:42:59.360637 [DBG] 192.168.122.3:32986 - rid:3 - Router Ping Timer
        [23052] 2019/12/24 04:42:59.361927 [DBG] 192.168.122.3:32986 - rid:3 - Delaying PING due to remote ping 2m0s ago
        [23052] 2019/12/24 04:43:12.031420 [DBG] 192.168.122.17:52624 - rid:4 - Router Ping Timer
        ```
        
    * Server 2: 
        ```
        [24597] 2019/12/24 04:35:10.845393 [INF] 192.168.122.3:46242 - rid:2 - Route connection created
        [24597] 2019/12/24 04:35:10.848176 [DBG] 192.168.122.3:46242 - rid:2 - Registering remote route "NCYAEK7TGYS7BFJQYE4FH2QPPLE4PLKYTPWU4EVAA4JFLECI25WTWMVF"
        [24597] 2019/12/24 04:35:10.849926 [DBG] 192.168.122.3:46242 - rid:2 - Sent local subscriptions to route
        [24597] 2019/12/24 04:35:11.853920 [DBG] 192.168.122.253:4248 - rid:1 - Router Ping Timer
        [24597] 2019/12/24 04:35:11.930577 [DBG] 192.168.122.3:46242 - rid:2 - Router Ping Timer
        [24597] 2019/12/24 04:37:11.854757 [DBG] 192.168.122.253:4248 - rid:1 - Router Ping Timer
        [24597] 2019/12/24 04:37:11.854850 [DBG] 192.168.122.253:4248 - rid:1 - Delaying PING due to remote ping 2m0s ago
        [24597] 2019/12/24 04:37:11.931315 [DBG] 192.168.122.3:46242 - rid:2 - Router Ping Timer
        [24597] 2019/12/24 04:37:11.931481 [DBG] 192.168.122.3:46242 - rid:2 - Delaying PING due to remote ping 2m0s ago
        [24597] 2019/12/24 04:39:11.855292 [DBG] 192.168.122.253:4248 - rid:1 - Router Ping Timer
        [24597] 2019/12/24 04:39:11.855397 [DBG] 192.168.122.253:4248 - rid:1 - Delaying PING due to remote ping 2m0s ago
        [24597] 2019/12/24 04:39:11.932145 [DBG] 192.168.122.3:46242 - rid:2 - Router Ping Timer
        [24597] 2019/12/24 04:39:11.932383 [DBG] 192.168.122.3:46242 - rid:2 - Delaying PING due to remote ping 2m0s ago
        [24597] 2019/12/24 04:41:11.855925 [DBG] 192.168.122.253:4248 - rid:1 - Router Ping Timer
        [24597] 2019/12/24 04:41:11.856005 [DBG] 192.168.122.253:4248 - rid:1 - Delaying PING due to remote ping 2m0s ago
        [24597] 2019/12/24 04:41:11.932874 [DBG] 192.168.122.3:46242 - rid:2 - Router Ping Timer
        [24597] 2019/12/24 04:41:11.932982 [DBG] 192.168.122.3:46242 - rid:2 - Delaying PING due to remote ping 2m0s ago
        [24597] 2019/12/24 04:43:11.856268 [DBG] 192.168.122.253:4248 - rid:1 - Router Ping Timer
        [24597] 2019/12/24 04:43:11.856321 [DBG] 192.168.122.253:4248 - rid:1 - Delaying PING due to remote ping 2m0s ago
        [24597] 2019/12/24 04:43:11.933427 [DBG] 192.168.122.3:46242 - rid:2 - Router Ping Timer
        [24597] 2019/12/24 04:43:11.933531 [DBG] 192.168.122.3:46242 - rid:2 - Delaying PING due to remote ping 2m0s ago
        ```
        
Vậy ta có thể thấy được cả 3 server tạo thành cluster, messenge được chia sẻ với nhau .

#   Benchmark
***
**Cài đặt nats-bench**
% go install $GOPATH/src/github.com/nats-io/nats.go/examples/nats-bench/main.go

**Câu lệnh sử dụng**
```
 nats-bench [-s server (nats://127.0.0.1:4222)] [--tls] [-np NUM_PUBLISHERS] [-ns NUM_SUBSCRIBERS] [-n NUM_MSGS] [-ms MESSAGE_SIZE] [-csv csvfile] <subject>
  -creds string
    	User Credentials File
  -csv string
    	Save bench data to csv file
  -h	Show help message
  -ms int
    	Size of the message. (default 128)
  -n int
    	Number of Messages to Publish (default 100000)
  -np int
    	Number of Concurrent Publishers (default 1)
  -ns int
    	Number of Concurrent Subscribers
  -s string
    	The nats server URLs (separated by comma) (default "nats://127.0.0.1:4222")
  -tls
    	Use TLS Secure Connection
```
Ví dụ: 
`nats-bench -np 1 -n 100000 -ms 16 foo` : benchmark với 1 pub, 1 sub, 1 tr message, mỗi msg nặng 16 bytes.

KQ benchmarks: https://docs.google.com/spreadsheets/d/1_XLV_KKw3cTamAT_Lc9u16D6p0aRt87y9u8ZKQgQuAE/edit?usp=sharing`


