## Bind9

    bind9 là dịch vụ cache server sẽ ghi nhớ những câu trả lời mỗi khi DNS Server xuất hiện truy vấn hostname và trả lời vào những lần sau. Dịch vụ này đặc biệt hữu ích trong những môi trường có kết nối Internet chậm. Bằng cách sử dụng Cache Server, bạn sẽ giảm thiểu được lưu lượng bang thông và độ trễ mỗi khi máy xuất hiện truy vấn.
    
#### B1: Download 
**Sử dụng câu lệnh sau** 

    sudo apt-get update
    sudo apt-get install bind9 bind9utils bind9-doc
    
**Có thể dùng salt để cài đặt** 

**File dnsinstall.sls**         https://gist.github.com/lmq1999/28601465ac0955f07eb6a74d14f722e3
**File named.conf.options**     https://gist.github.com/lmq1999/9c5525b73b4888ab4eafe02140586dfb
**File dnsconfig.sls**          https://gist.github.com/lmq1999/9fcb1edcf17a13d4bb3c8e3c99c31cc2

* Dùng câu lệnh: `salt '*' state.apply dnsinstall` để thực hiện cài bind9 cho minion : 
![install](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202019-09-25%2015-35-15.png)

#### B2: Config dns foward server nằm ở /etc/bind/named.conf.options

* Thêm dòng

        . . .
        options {
        directory "/var/cache/bind";
        
        forwarders {
              8.8.8.8;
              8.8.4.4;
        };
        . . .
        
    * Ta sẽ foward đến public DNS server của google 

* Có thể thêm 

    forward only;
    
	dnssec-enable yes;
    dnssec-validation yes;
        
    * Để server chỉ foward mà không tư phân giải request
    * dnssec để cung cấp cơ chế xác thực giữa các máy chủ với nhau 
    
    
**Salt**
* Dùng câu lệnh: `salt '*' stale.apply dnsconfig` để đưa file config lên minion và restart bind9 

    ![filemanaged](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202019-09-25%2015-52-11.png)
    
### B3: Kiểm tra hoạt động của dịch vụ 
**Truy cập vào `/etc/resolv.conf`**
**Thêm `nameserver 192.168.122.82`** 

![dig](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202019-09-25%2015-58-09.png)

![dig2](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202019-09-25%2015-59-55.png)

*   Ta có thể thấy DNS server cũng là 1 DNS cache server và đã lưu giữ lại thông tin từ lần truy vấn trước đó  
    *   Query time lần 1: 1067 msec
    *   Query time lần 2: 0 msec

