# GlusterFS cho mailserver
#### Mô hình
*   Số lượng server 3
*   Sử dụng: postfix, dovecot, squirrel mail

Storage: CephFS

![](https://raw.githubusercontent.com/lmq1999/internship-0719/master/quanlm1999/Untitled%20Diagram.png)

#### Sử dụng gluterFS 
*   Thư mục lưu trữ: `/Maildir -> /storage/Maildir//`
*   Benchmark:https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/benchmark_mail_glusterFS.png
    So sánh việc ghi file nhỏ 10000 file **(512b)** 1000 file **(5kb)** 100 file **(50kb) với 1 file 5MB
![1](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/benchmark_mail_glusterFS.png)

**Nhận xét:** Ta có thể thấy vấn đề ở đây là tốc độ ghi, Với các file nhỏ tầm  tốc độ ghi rất chậm so với tốc độ ghi của file tầm (MB) 
* File càng nhỏ số lượng ghi càng nhiều thì càng chậm

**Đánh giá** Với quy mô nhỏ thì dùng tạm được nhưng với quy mô lớn thì không hiệu quả.
https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/ceph_benchmark.png
**Giải pháp**
*   Sử dụng **NFS**
Tốc độc ghi với file nhỏ của NFS nhanh hơn so với glusterFS , phải cấu hình thêm HA NFS
*   Ceph
![ceph](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/ceph_benchmark.png)
Ta có thể thấy tốc độ ghi vượt trội so với glusterFS, gấp khoảng 15 lần với file nhỏ và nhiều ( 10000 file 512 bytes)
Nhưng với file lơn như 5MB thì tốc độ lại khá chậm, không bằng glusterFS  được 

    * Cài đặt: 
    `https://docs.ceph.com/docs/master/start/quick-start-preflight/`
    `https://docs.ceph.com/docs/master/start/quick-ceph-deploy/`
    `https://docs.ceph.com/docs/master/start/quick-cephfs/`
    
# So sánh ceph và glusterFS

#### Ceph
![ceph](https://docs.ceph.com/docs/master/_images/stack.png)
![data](https://docs.ceph.com/docs/master/_images/ditaa-518f1eba573055135eb2f6568f8b69b4bb56b4c8.png)
![ceph](https://docs.ceph.com/docs/master/_images/ditaa-ae8b394e1d31afd181408bab946ca4a216ca44b7.png)

*   **Ceph** là 1 object-base storage, dữ liệu được lưu trữ dưới dạng đối tượng trong cluster, k theo cấu trúc blocks hoặc phân cấp file

*   **Tính linh hoạt**

    *   Dữ liệu trong object storage thường được truy cập thông qua các giao thức Internet (http) bằng trình duyệt hoặc trực tiếp qua API như REST (representational state transfer)
    
    *   Cung cấp khả năng phân tích dữ liệu tốt hơn và khả năng lưu trữ một đối tượng ở bất kỳ đâu trong hồ chứa dữ liệu phân tán
    
*   **Khả năng quản lý:**
    *   Hệ thống tự quản lý, tự phục hồi sẽ giúp giảm chi phí hoạt động liên tục theo thời gian
    
    *   Sử dụng công cụ riêng, phức tạp hơn so với glusterFS 
    
*   **Tính sẵn sàng cao**
    *   Hỗ trợ tính sẵn sàng cao, yêu cầu tối thiểu 3 node osd trở lên 
    
*   **Cài đặt**
    *   Tương đối phức tạp, có thể cài đặt từ 1 node admin sang các node khác
    
*   **Khả năng mở rộng**

    *   không gian phẳng còn cho phép dễ dàng mở rộng với việc thêm nhiều bộ nhớ - storage hơn vào hồ chứa. 

*   **Tốc độ truy xuất**
    
    *   Tương đối
    *   Tốt đối với số lượng file nhiều , kích thuước nhỏ 
    *   Ngoài khả năng lưu trữ, truy xuất dữ liệu thì còn cho phép tận dụng tối đa việc phân tích dữ liệu và đạt được những lợi ích to lớn từ nguồn dữ liệu lưu trữ đó. 




#### GlusterFS 
![glusterfs](https://i0.wp.com/blogit.edu.vn/wp-content/uploads/2015/09/glusterfs-4.png?w=590)

*   **GlusterFS** Gluster sử dụng kiểu lưu trữ khối, có nghĩa là các khối dữ liệu được lưu trữ trong không gian mở trên các thiế bị cụm được kết nối. Gluster sử dụng hệ thống file để sắp xếp dữ liệu theo thứ bậc. 
 
*   **Tính linh hoạt:** Hệ thống này thích hợp lưu trữ các file có kích thước trung bình (hơn 4 MB) và truy cập một cách tuần tự

*   **Khả năng quản lý** 

    *   Khả năng tự quản lý (hệ thống lưu trữ nội bộ và của bên thứ ba cung cấp đều được quản lý từ một điểm tập trung duy nhất
    
    *    Việc quản lý GlusterFS rất dễ dàng vì nó tách biệt khỏi kernel space trong khi thực thi trên user space.
    
*   **Tính sẵn sàng cao**
    * Hỗ trợ trực tiếp, cần tối thiểu 2 gluster 
*   **Cài đặt**
    * Cài đặt thủ công trên từng máy hoặc dùng ansible để 

*   **Khả năng mở rộng**

    * Khả năng tốt, GluserFS thích nghi tốt với sự tăng giảm mạnh của dữ liệu, có khả năng lưu trữ đến hàng nghìn Petabyte và lớn hơn.
    
    * Một cụm cluster có thể chứa tối đa 64 máy chủ và có thể phát triển thêm nữa

* **Tốc độ truy xuất**
    * Với file lớn (> 4MB), tốc độ cao
    * Với file nhỏ (vài - vài chục kb), rất chậm 
    
# Kết luận

   * Với dữ liệu phi câu trúc như email, hình ảnh, video, nội dung ít thay đổi, số lương nhiều -> **ceph**
   * Với dữ liệu có cấu trúc , thường xuyên thay đổi , stream, sao lưu **glusterfs**
 
## CephFS cho mail server

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/squirrel%20mail.png)

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/mail1.png)

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/mail2.png)

2 server mail dùng chung 1 storage system nên sv1 chuyển thư vào thùng rác, sv 2 cũng có thư ở đó


