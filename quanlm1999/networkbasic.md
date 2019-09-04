# Networking Basic
### Set static IP, DNS, GATEWAY
#### Debian
1. Open the following file: `/etc/network/interfaces`
2. Edit something look like this: 
    `auto eth0`
  `iface eth0 inet static `
 ` address 192.168.0.100` 
 ` netmask 255.255.255.0`
  `gateway 192.168.0.1`
 ` dns-nameservers 4.4.4.4`
 ` dns-nameservers 8.8.8.8`
3. Save the file, edit `/etc/resolv.conf`
    `nameserver 8.8.8.8 # Replace with your nameserver ip`
`nameserver 4.4.4.4 # Replace with your nameserver ip`
4. Restart networking 
    `# /etc/init.d/network restart  [On SysVinit]`
`# systemctl restart network    [On SystemD]`

#### RHEL
1. Open `/etc/sysconfig/network`and set: 
`NETWORKING=yes`
`HOSTNAME=node01.tecmint.com`
`GATEWAY=192.168.0.1`
`NETWORKING_IPV6=no`
`IPV6INIT=no`
2. Open `/etc/sysconfig/network-scripts/ifcfg-eth0` *change the file `ifcfg-eth0` with your network interface like `ifcfg-eth1`....etc* 
and edit: 
`EVICE="eth0"`
`BOOTPROTO="static"`
**`DNS1="8.8.8.8"`**
**`DNS2="4.4.4.4"`**
**`GATEWAY="192.168.0.1"`**
**`HOSTNAME="node01.tecmint.com"`**
**`HWADDR="00:19:99:A4:46:AB"`**
**`IPADDR="192.68.0.100"`**
**`NETMASK="255.255.255.0"`**
`NM_CONTROLLED="yes"`
`ONBOOT="yes"`
`TYPE="Ethernet"`
`UUID="8105c095-799b-4f5a-a445-c6d7c3681f07"`
3. Edit `/etc/resolv.conf`
`nameserver 8.8.8.8 # Replace with your nameserver ip`
`nameserver 4.4.4.4 # Replace with your nameserver ip`
4. Restart network
`# /etc/init.d/network restart  [On SysVinit]`
`# systemctl restart network    [On SystemD]`
### DNS System
* Domain name system là dịch vụ trong tcp/ip network giúp người dùng biên dịch tên thành địa chỉ IP
    * Khi người dùng hỏi một DNS server, được gọi là truy vấn (query). Khi mà người dùng truy vấn một địa chỉ IP được gọi là fowward lookup query (truy vấn tra cứu xuôi)
    * Ngược lại, hỏi tên của  host được gọi là reverse lookup query (truy vấn tra cứu ngược )
* Máy tính của người dùng cần biết được địa chỉ IP của DNS server để có thể truy vấn được. Địa chỉ IP này được cung cấp bởi DHCP server hoặc tự thêm vào
    * Linux giữ thông tin này ở trong file `/etc/resolv.conf`
    * Người dùng có thể sử dụng DNS server của google  với public name server at 8.8.8.8 and 8.8.4.4
    * THông tin này DHCP clients có thể bị ghi đè nếu như DHCP lease được làm mới.
    
* DNS namespace
    * Hệ thống cấp bậc 
       * DNS namespace được phân thành cây cấp bậc với root server ở đỉnh. Root server thường được đại diện bởi dấu "."
       * Bên dưới root server là các Top Level Domain (tld) 
     * Root server
        * Có tất cả 13 Root server trên internet, nếu như những server này sập thì không ai có thể dùng tên để kết nối đến website nữa .
    * Domains 
        * Dưới top level domains là các Domains. Các Domains có thể có Domains con nữa.
        * DNS domains được đăng ký ở tld server
        * tld server được đăng ký ở root server
    * DNS zone
        * Một zone ( vùng thẩm quyền) là phầncủa cây DNS bao phủ lên một miền hoặc miền con
        * Một DNS server có thẩm quyền lên 0 hoặc nhiều dns zone
        * Một DNS zone bao gồm những bản ghi, còn được gọi là resource records
    * DNS records
        * **A record**, còn được gọi là host record, chứa địa chỉ IPv4 của một máy. Khi DNS client truy vấn một DNS server cho 1 A record ,DNS sẽ phân giải hostname được truy vấn thành địa chỉ ip. AAAA record tương tự nhưng chứa Ipv6
        * **PTR record**, ngược lại với A record. Chứa tên của máy và dùng để phân giải địa chỉ ip thành hostname.
        * **NS record**, nameserver record là bản ghi chỉ đến một DNS name server ( trong vùng đó). Có thể liệt kê tất cả name server cho DNS zone trong bản ghi của NS recrods.
        * **glue A record**, Một A recrod mà ánh xạ một NS records với 1 ip address 
    *  caching only servers
        * Một dns server được cài đặt mà k có thâmr quyền với một zone, nhưng được kết nối với name servers khác và lưu trữ truy vấn được gọi là   caching only name servers.  Caching only name servers không có zone database với records. Thay vào đó, nó nối với name server khác và truy vấn thông tin đó
        * Có 2 loại: Sử dụng forwarder và sử dụng root server
    *  caching only servers without forwarder.
        * Một aching only server without forwarder sẽ phải lấy thông tin từ một nơi khác. Khi nó nhận được truy vấn từ clients, nó sẽ  tham khảo một trong những root server. Root server sẽ tham khảo tld server, và tld server sẽ tham khảo dns server. Server cuối cùng mà biết câu trả lời cho truy vấn hoặc tiếp tục tham khảo server khác nữa. CUối cùng, dns server sẽ tìm câu trả lời và báo lại cho client. 
    *  caching only server with forwarder.
        Một caching only server with forwarder là DNS sẽ lấy tất cả thông tin từ **forwarder**. Một **forwarder** phải là một DNS server, ví dụ như DNS server của ISP.
*  iterative or recursive query
    * Một recursive query là DNS query mà người dùng truy vấn muốn câu trả lời đầy đủ
    * Một iterative query là DNS query mà người dùng không cần 1 câu trả lời đầy đủ.  iterative querry  tường diễn ra giữa name server. Root name server không phản hồi với recursive query.
* primary and secondary
    *   Khi mà cài đặt thẩm quyền dns server cho 1  zone, thì đó gọi là primary dns server. Server nãy sẽ có quyền đọc và ghi zone database.
    *   Khà mục đích là cân bằng tải, khả năng chịu lỗi, hiệu suất thì cần cài đặt 1  dns server khác lên zone đó. Được gọi là secondary dns server.
* master and slave
    * KHi thêm 1 secondary dns server vào 1 zone, và config nó thành slave server cho 1 primary server. Primaarry servẻ sẽ trở thành master server của slave server.
    * Thường thì primary dns server là master server của tất cả slaves server. Đôi khi 1 slave server lại thành master server của 1 slave server phía sau nó. 
* SOA record
    * SOA record chứa refresh value. Nếu để giá trị này lại 30p thì slave server sẽ yêu cầu 1 bản copy của zone file mỗi 30p. 
    * retry value được sử dụng khi master sserver k hồi đáp lại lần yêu cầu copy zone file cuối cùng
    * expiry time value sẽ cho biết bao lâu slave server sẽ trả lời cho truy vấn khi mà không nhận được zone update.
*  full or incremental zone transfers
    * incremental zone transfer được sử dụng khi toàn bộ kích cỡ thay đổi nhỏ hơn kích cỡ của zone data base , sử dụng giao thức `ixfr`
    * full zone transfer được sử dụng khi kích cỡ lớn hơn kích cỡ database, dùng giao thứ `axfr` 
*DNS delegation
    * Có thể ủy quyền  domain con cho 1 DNS  server khác. domain con trở thành 1 zone khác và thẩm quyền cho dns server mới
    * Khi ủy quyền được cài đặt, client truy vấn zone cha sẽ được phân giải ở zone con được ủy quyền

### Understanding DHCP
* Dynamic Host Configuration Protocol **(DHCP)** là một giao thức cho phép cấp phát địa chỉ IP một cách tự động cùng với các cấu hình liên quan khác như subnet mask và gateway mặc định. Nó cung cấp một database trung tâm để theo dõi tất cả các máy tính trong hệ thống mạng. Mục đích quan trọng nhất là tránh trường hợp hai máy tính khác nhau lại có cùng địa chỉ IP
* Cách thức hoạt động 
    1. Khi máy khởi động, máy client sẽ quảng bá gói tin **DHCP discorver**
    2. Tất cả các DHCP server sẽ thấy tin và gửi lại 1 tin **DHCP Offer**, trong đó sẽ có địa chỉ IP mà client sẽ sử dụng, DNS server IP address, default gateway
    3. Máy client sẽ chọn 1 trong những offer đó và gửi 1 gói **DHCP request**
    4. DHCP server phản hồi lại bằng **DHCP  ACK** (acknowledge)

* Cài đặt DHCP server
1. Cho Debian
    `debian5:~# aptitude install dhcp3-serverReading package lists...`
`DoneBuilding dependency tree`
`Reading state information...`
`DoneReading extended state information `
`Initializing package states... Done`
`Reading task descriptions... Done`
`The following NEW packages will be installed:`
`dhcp3-server`
Sẽ có 1 file config ở: `/etc/dhcp3/dhcpd.conf`

2. Cho RHEL
` root@rhel71 ~]# yum install dhcp`
Sẽ có 1 file` /etc/dhcp/dhcpd.conf `
Trong đó có đường dẫn đến file ví dụ  `dhcpd.conf.sample.`, sửa file này để phù hợp với yêu cầu sử dụng
3. Khởi động server `service dhcpd start`
### Understanding VPN
* VPN (Virtual Private Network) hay còn được gọi là mạng riêng ảo cho phép bạn tạo ra kết nối an toàn đến một mạng khác qua internet. VPN có chức năng sau: 
    * Confidentiality 
    * Authentication 
    * Integrity 
    * Anti-Replay

* **Confidentiality** là bảo mật, không ai có thể đọc dc dữ liệu bạn truyền đi.
* **Authentication** là xác thực, nhằm đảm bảo dữ liệu truyền đến đúng thiết bị, xác thực nhờ mật khẩu. 
* **Integrity** là toàn vẹn, đảm bảo không ai sửa dữ liệu . Sử dụng Hashing 
* **Anti-replay** chống phát lại, đề phòng việc kẻ tán công sao chép lại 1 số gói tin rồi  gửi lại mạo danh người dùng. Sequence number được dùng để phát hiện gói tin được nhận hay chưa.

* Cách hoạt động
    * Khi máy tính của bạn kết nối đến VPN, máy tính sẽ hoạt động giống như đang cùng mạng cục bộ với VPN. Tất cả lưu lượng mạng của bạn sẽ được gửi qua một kết nối an toàn đến VPN. Bạn sẽ có thể sử dụng internet như thể bạn đang có mặt tại vị trí của VPN




    

