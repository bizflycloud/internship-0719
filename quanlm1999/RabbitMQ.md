#   Giới thiệu
***

RabbitMQ là một message broker ( message-oriented middleware) sử dụng giao thức AMQP - Advanced Message Queue Protocol

RabbitMQ được lập trình bằng ngôn ngữ Erlang.

RabbitMQ sẽ nhận message đến từ các thành phần khác nhau trong hệ thống, lưu trữ chúng an toàn trước khi đẩy đến đích.

# Khả năng
****
**Độ tin cậy**

RabbitMQ hỗ trợ nhiều tính năng khác nhau cho phép bạn giao dịch các tác vụ một cách tin cậy, với thời gian lưu lâu hơn, xác nhận giao hàng, xác nhận của nhà xuất bản và tính khả dụng cao.


**Định tuyến linh hoạt**

Tin nhắn sẽ được route thông qua trao đổi trước khi chuyển đến queue. RabbitMQ cung cấp một số loại trao đổi được tích hợp sẵn cho định tuyến logic điển hình. Với các định tuyến phức tạp hơn, bạn có thể liên kết các trao đổi với nhau hoặc thậm chí có thể viết các kiểu trao đổi của riêng bạn như một plugin.

**Clustering**

Một số máy chủ RabbitMQ trên mạng cục bộ có thể được nhóm lại với nhau, hợp thành một nhà trung gian duy nhất.

**Queue có tính sẵn sàng cao**

Queue có thể được nhân bản trên một số máy trong một cluster, đảm bảo cho tin nhắn của bạn luôn an toàn ngay cả khi xảy ra tình huống lỗi phần cứng.

**Đa giao thức**

RabbitMQ hỗ trợ messaging thông qua nhiều giao thức messaging khác nhau.

**Đa dạng ngôn ngữ**

Các ứng dụng RabbitMQ hiện đã được phát triển với hệ ngôn ngữ phong phú

**Tracing**

Nếu hệ thống messaging của bạn hoạt động không đúng, RabbitMQ sẽ hỗ trợ các thao tác truy vết để giúp bạn hiểu được hệ thống đang hoạt động như thế nào và vấn đề nào đang phát sinh.


#  Mục đích sử dụng
****
*   RabbitMQ giúp các web server gửi các reponse cho các request rất nhanh thay vì bị ép buộc chạy một procedure ngốn tài nguyên trên một hệ thống
*   Giúp các thành phần giao tiếp được với nhau trong hệ thống phân tán 

#   Install
****
* Để cài đặt được rabbitMQ thì cần  cài đặt erlang trước. 
`sudo apt install erlang`
* Install RabbitMQ signing key
`curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | sudo apt-key add -`

* Add Bintray repositories that provision latest RabbitMQ and Erlang 21.x releases
    ```
    sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list <<EOF
    deb https://dl.bintray.com/rabbitmq-erlang/debian bionic erlang
    deb https://dl.bintray.com/rabbitmq/debian bionic main
    EOF
    ```

* Install rabbitmq-server and its dependencies
`sudo apt-get install rabbitmq-server -y --fix-missing`

* Khởi động: 
    `service rabbitmq-server start`

* **Cài đặt rabbitmq management plugins**
    ```
    # create a user
    rabbitmqctl add_user {user} {password}
    # tag the user with "administrator" for full management UI and HTTP API access
    rabbitmqctl set_user_tags {user} administrator
    ```
#   HA
****
#### I. Trước khi HA chúng ta cần tạo rabbitMQ cluster

Cluster cần tối thiểu 1 disk node
*   Chú ý: 
    * Tất cả các node phải cùng erlang version và rabbitmq version
    * Các node liên kết qua LAN network
    * Tất cả các node chia sẻ cùng một erlang cookie

**Thiết lập hostname cho 3 node và đứa vào`/etc/hosts`**
```
192.168.122.241 rabbitmq1
192.168.122.242 rabbitmq2
192.168.122.252 rabbitmq3
```

Khởi động rabbitmq `service rabbitmq-server start`

**Chọn 1 node làm khởi điểm, join các node còn lại vào cùng**

Đầu tiên ta thấy các node đang là các cluster riêng biệt `rabbitmqctl cluster_status`

```
quanlm@rabbitmq1:~$ sudo rabbitmqctl cluster_status

Cluster status of node rabbit@rabbitmq1
[{nodes,[{disc,[rabbit@rabbitmq1]}]},
 {running_nodes,[rabbit@rabbitmq1]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq1,[]}]}]
```

```
quanlm@rabbitmq2:~$ sudo rabbitmqctl cluster_status

Cluster status of node rabbit@rabbitmq2
[{nodes,[{disc,[rabbit@rabbitmq2]}]},
 {running_nodes,[rabbit@rabbitmq2]},
 {cluster_name,<<"rabbit@rabbitmq2">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq2,[]}]}]
```
```
 quanlm@rabbitmq3:~$ sudo rabbitmqctl cluster_status
 
Cluster status of node rabbit@rabbitmq3
[{nodes,[{disc,[rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq3]},
 {cluster_name,<<"rabbit@rabbitmq3">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq3,[]}]}]

```
**Với node khởi điểm thì không cần cấu hình thêm nữa , ở đây ta chọn node1:**
Khởi động node sử dụng `rabbitmqctl start_app`

```
quanlm@rabbitmq1:~$ sudo rabbitmqctl start_app
Markdown
Toggle Zen Mode
Preview
Toggle Mode

Starting node rabbit@rabbitmq1
```

**Join node 2 và 3 vào cùng node 1**
```
quanlm@rabbitmq2:~$ sudo rabbitmqctl stop_app
Stopping rabbit application on node rabbit@rabbitmq2
quanlm@rabbitmq2:~$ sudo rabbitmqctl join_cluster rabbit@rabbitmq1
Clustering node rabbit@rabbitmq2 with rabbit@rabbitmq1
```

```
quanlm@rabbitmq3:~$ sudo rabbitmqctl stop_app
Stopping rabbit application on node rabbit@rabbitmq3
quanlm@rabbitmq3:~$ sudo rabbitmqctl join_cluster rabbit@rabbitmq1
Clustering node rabbit@rabbitmq3 with rabbit@rabbitmq1
```

**Status trên mỗi node:**
```
quanlm@rabbitmq1:~$ sudo rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq1
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq2,rabbit@rabbitmq3,rabbit@rabbitmq1]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq2,[]},{rabbit@rabbitmq3,[]},{rabbit@rabbitmq1,[]}]}]
```

```
quanlm@rabbitmq2:~$ sudo rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq2
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq1,rabbit@rabbitmq3,rabbit@rabbitmq2]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq1,[]},{rabbit@rabbitmq3,[]},{rabbit@rabbitmq2,[]}]}]
```

```
quanlm@rabbitmq3:~$ sudo rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq3
[{nodes,[{disc,[rabbit@rabbitmq1,rabbit@rabbitmq2,rabbit@rabbitmq3]}]},
 {running_nodes,[rabbit@rabbitmq2,rabbit@rabbitmq1,rabbit@rabbitmq3]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq2,[]},{rabbit@rabbitmq1,[]},{rabbit@rabbitmq3,[]}]}]

```
**Để tách 1 node khởi cluster**
    *   Cách 1: `rabbitmqctl reset` node muốn tách khỏi
    *   Cách 2: `rabbitmqctl forget_cluster_node rabbit@rabbitmq2` đuổi 1 node ra khỏi cluster, cách này sau khi khởi động thì node đó vẫn nghĩ mình ở trong cluster khiến cho nó bị lỗi, vẫn  phải reset lại .

**Đổi 1 disk node thành ram node**
```
 quanlm@rabbitmq2:~$ sudo rabbitmqctl change_cluster_node_type ram
Turning rabbit@rabbitmq2 into a ram node
sudo rabbitmqctl start_app
quanlm@rabbitmq2:~$ sudo rabbitmqctl start_app
Starting node rabbit@rabbitmq2
quanlm@rabbitmq2:~$ sudo rabbitmqctl cluster_status
Cluster status of node rabbit@rabbitmq2
[{nodes,[{disc,[rabbit@rabbitmq3,rabbit@rabbitmq1]},{ram,[rabbit@rabbitmq2]}]},
 {running_nodes,[rabbit@rabbitmq1,rabbit@rabbitmq3,rabbit@rabbitmq2]},
 {cluster_name,<<"rabbit@rabbitmq1">>},
 {partitions,[]},
 {alarms,[{rabbit@rabbitmq1,[]},{rabbit@rabbitmq3,[]},{rabbit@rabbitmq2,[]}]}]
```
P/s: ram node chỉ giữ metadata của nó trong memory còn bản thân các queue data vẫn lưu xuống disk. Sự khác biệt này cho phép ram node ít tạo ra các hoạt động IO hơn nên performance tốt hơn disc node

P/s: Trên máy ảo clone nên k cần thực hiện copy cookies:
```
1 quanlm@rabbitmq1:~$ sudo scp /var/lib/rabbitmq/.erlang.cookie root@rabbitmq2:/var/lib/rabbitmq/.erlang.cookie
The authenticity of host 'rabbitmq2 (192.168.122.17)' can't be established.
ECDSA key fingerprint is SHA256:B+AoBXEoSgmaJI53aWIHQqmOPj3Kcj29xk7ih7GLV+o.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'rabbitmq2,192.168.122.17' (ECDSA) to the list of known hosts.
root@rabbitmq2's password: 
.erlang.cookie                                                                                    100%   20    20.0KB/s   00:00    

quanlm@rabbitmq1:~$  sudo scp /var/lib/rabbitmq/.erlang.cookie root@rabbitmq3:/var/lib/rabbitmq/.erlang.cookie
The authenticity of host 'rabbitmq3 (192.168.122.3)' can't be established.
ECDSA key fingerprint is SHA256:B+AoBXEoSgmaJI53aWIHQqmOPj3Kcj29xk7ih7GLV+o.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'rabbitmq3,192.168.122.3' (ECDSA) to the list of known hosts.
root@rabbitmq3's password: 
.erlang.cookie                                                                                  100%   20    20.0KB/s   00:00    
```

RabbitMQ management:
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Screenshot%20from%202019-12-12%2009-54-29.png)

**Restart các node** 
*   **Trường hợp thứ nhất:** Tình huống xảy ra khi bạn cần restart cluster để upgrade cho rabbitmq hoặc erlang.
    *   Sau khi node 1, node 2 được bạn stop thì thảm họa xảy ra với node còn lại. Node còn lại bị down ngoài ý muốn. Trong trường hợp này việc khởi động lại cluster đòi hỏi thứ tự: Node cuối cùng bị down phải là node đầu tiên được start. Giả sử các node bị down theo thứ tự: node 3 -> node 1 -> node 2
    
*   **Trường hợp thứ hai:** Cũng giống trường hợp một nhưng đáng tiếc là node 2 bị sự cố quá nghiêm trọng không thể phục hồi được.
    *   Vậy là node cuối cùng không thể boot được. Lúc này bạn phải ép một node không phải node down cuối cùng làm node khởi điểm 
    *  Sử dụng lênh: `rabbitmqctl force_boot`

*   
#### II. Thiết lập Highly Available queues

*   các queue trong RabbitMQ cluster chỉ nằm trên một node duy nhất mà chúng được khai báo trước tiên, queue cũng có thể cấu hình để mirror trên nhiều node. Mỗi "mirrored queue" gồm 1 master và nhiều slave, và slave đầu tiên lên làm master mới nếu master cũ bị mất.
* Message được publish tới queue sẽ được replicate đến tất cả các slave. Slave sẽ drop message mà nó nhận được. Do đó Queue mirroring chỉ nâng cao tính sẵn sàng chứ không phân bố tải trên các node.


Policy match những queue với tên bắt đầu bằng "ha." sẽ mirror sang tất các node trong cluster:

`rabbitmqctl set_policy ha-all "^ha\." '{"ha-mode":"all"}'  `
```
quanlm@rabbitmq1:~$ sudo rabbitmqctl set_policy ha-all "" '{"ha-mode":"all","ha-sync-mode":"automatic"}'
Setting policy "ha-all" for pattern [] to "{\"ha-mode\":\"all\",\"ha-sync-mode\":\"automatic\"}" with priority "0"
```

#   Benchmark
***

**RabbitMQ** benchmark sử dụng RabbitMQ PerfTest
**Cài đặt**: `https://github.com/rabbitmq/rabbitmq-perf-test/releases`
**Sử dụng**:
    * Giải nén
    * Truy cập thư mục mới giải nén
    *   Chạy : `bin/runjava com.rabbitmq.perf.PerfTest`

**Option**:
1. Chaỵ test với 1 publisher, 2 costumer 
`bin/runjava com.rabbitmq.perf.PerfTest -x 1 -y 2 -u "throughput-test-1" -a --id "test 1"`

2. 2 publusher, 2 costumer
`bin/runjava com.rabbitmq.perf.PerfTest -x 2 -y 4 -u "throughput-test-2" -a --id "test 2"`

3. Constumer -> manual acknowledgement
`bin/runjava com.rabbitmq.perf.PerfTest -x 1 -y 2 -u "throughput-test-3" --id "test 3"`

4. Tăng size message từ 512B -> 4kB
`bin/runjava com.rabbitmq.perf.PerfTest -x 1 -y 2 -u "throughput-test-4" --id "test 4" -s 4000`

5. Cosumer có thể ack nhiều message mỗi lần (100)
`bin/runjava com.rabbitmq.perf.PerfTest -x 1 -y 2 -u "throughput-test-6" --id "test-6" -f persistent --multi-ack-every 100`

6. Mô phỏng lượng tải lớn
```
bin/runjava com.rabbitmq.perf.PerfTest --queue-pattern 'perf-test-%d' \
  --queue-pattern-from 1 --queue-pattern-to 1000 \
  --producers 1000 --consumers 1000 \
  --heartbeat-sender-threads 10 \
  --publishing-interval 5
```
https://docs.google.com/spreadsheets/d/11m98jM2u5VaEowbk7_AR8G9N-dkeuiie5CVev2DPuyY/edit?usp=sharing



