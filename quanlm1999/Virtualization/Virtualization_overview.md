# Virtualization - Ảo hóa là gì?
***   

Ảo hóa là một công nghệ được thiết kế để tạo ra tầng trung gian giữa hệ thống phần cứng máy tính và phần mềm chạy trên nó. 

Ảo hóa (virtualization) có nghĩa là tạo một phiên bản ảo của tài nguyên nào đó, chẳng hạn như server, storage device, network hoặc thậm chí operating system nơi framework chia tài nguyên thành một hoặc nhiều môi trường thực thi.  

Ý tưởng của công nghệ ảo hóa máy chủ là từ một máy vật lý đơn lẻ có thể tạo thành nhiều máy ảo độc lập. Mỗi một máy ảo đều có một thiết lập nguồn hệ thống riêng rẽ, hệ điều hành riêng và các ứng dụng riêng


# Các loại ảo hóa
***

* ### Ảo hóa mạng (Network virtualization) 
    * Là phương pháp kết hợp các tài nguyên sẵn có trong mạng bằng cách chia băng thông sẵn có thành các kênh, mỗi kênh độc lập với các kênh khác và mỗi kênh có thể được gán (hoặc gán lại) cho một máy chủ hoặc thiết bị cụ thể theo thời gian thực. 
    
    * Ý tưởng chính của ảo hóa mạng là ảo hóa ngụy trang sự phức tạp thực sự của mạng bằng cách tách nó thành các phần có thể quản lý được, giống như ổ cứng được phân đoạn, giúp dễ dàng quản lý các tệp hơn.


- ### Ảo hóa lưu trữ (Storage virtualization) 
    *   Là tổng hợp physical storage từ nhiều thiết bị lưu trữ mạng vào chỉ một thiết bị lưu trữ được quản lý từ bảng điều khiển trung tâm. 
    
    *   Storage virtualization thường được sử dụng trong các mạng lưu trữ (SAN).


- ### Ảo hóa máy chủ (Server virtualization) 
    - Là ảo hóa tài nguyên máy chủ (bao gồm số và danh tính của máy chủ vật lý, bộ xử lý và hệ điều hành) từ server users. 
    
    - Mục đích là để người dùng tránh phải hiểu và quản lý các chi tiết phức tạp của tài nguyên máy chủ.
# Mục tiêu của ảo hóa
****
 Ảo hóa xoay quanh 4 mục tiêu chính: **Availability, Scalability, Optimization, Management.**
* ##### Availability: 
    * Giúp các ứng dụng hoạt động liên tục bằng cách giảm thiểu (bỏ qua) thời gian chết (downtime) khi phần cứng gặp sự cố, khi nâng cấp hoặc di chuyển.
    
* ##### Scalability: 
    *  Khả năng tùy biến, thu hẹp hay mở rộng mô hình server dễ dàng mà không làm gián đoạn ứng dụng.
    
* ##### Optimization: 
    *  Sử dụng triệt để nguồn tài nguyên phần cứng và tránh lãng phí bằng cách giảm số lượng thiết bị vật lý cần thiết (giảm số lượng server, switch, cáp, v.v. )
    
* ##### Management:
    * Khả năng quản lý tập trung, giúp việc quản lý trở nên dễ dàng hơn bao giờ hết.
# Các thành phần của một hệ thống ảo hóa.
****

### Một hệ thống ảo hóa bao gồm những thành phần sau:
* #### Tài nguyên vật lý
    *   Các tài nguyên vật lý trong môi trường ảo hóa cung cấp tài nguyên mà các máy ảo sẽ sử dụng tới. 
    
    *   Một môi trường tài nguyên lớn có thể cung cấp được cho nhiều máy ảo chạy trên nó và nâng cao hiệu quả làm việc của các máy ảo .Các tài nguyên vật lý có thể kể đến là là ổ đĩa cứng, ram, card mạng….
    


* #### Các phần mềm ảo hóa .
    * Lớp phần mềm ảo hóa này cung cấp sự truy cập cho mỗi máy ảo đến tài nguyên hệ thống. 
    * Chịu trách nhiệm lập kế hoạch và phân chia tài nguyên vật lý cho các máy ảo.
        *   Phần mềm ảo hóa là nền tảng của một môi trường ảo hóa. 
        *   Nó cho phép tạo ra các máy ảo cho người sử dụng, quản lý các tài nguyên và cung cấp các tài nguyên này đến các máy ảo..
        
        *   Ngoài ra phần mềm ảo hóa còn cung cấp giao diện quản lý và cấu hình cho các máy ảo.


*   #### Máy ảo 
    *   Thuật ngữ máy ảo được dùng chung khi miêu tả cả máy ảo (lớp 3) và hệ điều hành ảo (lớp 4). 
    *   Máy ảo thực chất là một phần cứng ảo, một môi trường hay một phân vùng trên ổ đĩa. 
        *   Trong môi trường này có đầy đủ thiết bị phần cứng như một máy thật . 
        *   Đây là một kiểu phần mềm ảo hóa dựa trên phần cứng vật lý. 
        
        *   Các hệ điều hành khách mà chúng ta cài trên các máy ảo này không biết phần cứng mà nó nhìn thấy là phần cứng ảo.
    *   ##### Hệ điều hành khách
        *   Hệ điều hành khách được xem như một phần mềm (lớp 4) được cài đặt trên một máy ảo (lớp 3) giúp ta có thể sử dụng dễ dàng và xử lý các sự cố trong môi trường ảo hóa. 
        
        *   Nó giúp người dùng có những thao tác giống như đang thao tác trên một lớp phần cứng vật lý thực sự.


![](https://voer.edu.vn/media/transforms/20140306-214626-tong-quan-ve-ao-hoa-may-chu/Picture%203.png)

#   Các kiến trúc ảo hóa. 
****

#### Kiến trúc ảo hóa Hosted-based.
![](https://patterns.arcitura.com/wp-content/uploads/2019/03/05fig08.png)
* Còn gọi là kiến trúc **hosted hypervisor**, kiến trúc này sử dụng một lớp hypervisor chạy trên nền tảng hệ điều hành, sử dụng các dịch vụ được hệ điều hành cung cấp để phân chia tài nguyên tới các máy ảo. Nếu ta xem hypervisor này là một lớp phần mềm riêng biệt, thì các hệ điều hành khách của máy ảo sẽ nằm trên lớp thứ 3 so với phần cứng máy chủ.  
   
* Một hệ thống ảo hóa sử dụng Mô hình Hosted-based được chia làm 4 lớp hoạt động như sau:
    * **Nền tảng phần cứng:** Bao gồm các thiết bị nhập xuất, thiết bị lưu trữ (Hdd, Ram), bộ vi xử lý CPU, và các thiết bị khác (các thiết bị mạng, vi xử lý đồ họa, âm thanh…)
    * **Hệ điều hành Host:** Hệ điều hành này thực hiện việc liên lạc trực tiếp với phần cứng, qua đó cung cấp các dịch vụ và chức năng thông qua hệ điều hành này.
    
    * **Hệ thống virtual machine monitor (hypervisor)** : Chạy trên nền tảng hệ điều hành Host, các hệ thống này lấy tài nguyên và dịch vụ do hệ điều hành host cung cấp, thực hiện việc quản lý, phân chia trên các tài nguyên này.
    * **Các ứng dụng máy ảo:** Sử dụng tài nguyên do hypervisor quản lý.
        
* Mối liên lạc giữa phần cứng và trình điều khiển thiết bị trên hệ điều hành trong kiểu ảo hóa VMM được mô tả như sau :
    *   **Bước đầu tiên mô phỏng phần cứng:** Lớp ảo hóa hypervisor sẽ tạo ra một phân vùng trên ổ đĩa cho các máy ảo. Phân vùng này bao gồm các phần cứng ảo như ổ đĩa, bộ nhớ….
    *   **Hypervisor xây dựng mối liên lạc giữa lớp ảo hóa với hệ điều hành: K**hi một máy ảo truy xuất tài nguyên thì lớp hypervisor sẽ thay thế máy ảo đó gởi các yêu cầu tới hệ điều hành máy chủ để yêu cầu thực hiện,
    *   **Khi hệ điều hành nhận được các yêu cầu này.** Nó liên lạc với trình điều khiển thiết bị phần cứng.
    *   **Các trình điều khiển thiết bị phần cứng liên lạc** đến các phần cứng trên máy thực.
    
    *   **Quá trình này sẽ xảy ra ngược lại** khi có các trả lời từ các phần cứng đến hệ điều hành chủ.

* Một số hệ thống hypervisor dạng Hosted-base có thể kể đến như **Vmware Server,Microsoft Virtual PC, máy ảo Java ..**

#### Kiến trúc ảo hóa Hypervisor-based
*   Còn gọi là kiến trúc **bare-metal hypervisor**. Trong mô hình này, lớp phần mềm hypervisor chạy trực tiếp trên nền tảng phần cứng của máy chủ, không thông qua bất kì một hệ điều hành hay một nền tảng nào khác. 
*   Qua đó, các hypervisor này có khả năng điều khiển, kiểm soát phần cứng của máy chủ. 

*   Đồng thời, nó cũng có khả năng quản lý các hệ điều hành chạy trên nó. 
![](https://voer.edu.vn/media/transforms/20140306-214626-tong-quan-ve-ao-hoa-may-chu/Picture%205.png)

* Một hệ thống ảo hóa máy chủ sử dụng nền tảng Bare-metal hypervisor bao gồm 3 lớp chính:
    * **Nền tảng phần cứng:** Bao gồm các thiết bị nhập xuất, thiết bị lưu trữ (Hdd, Ram), bộ vi xử lý CPU, và các thiết bị khác (các thiết bị mạng, vi xử lý đồ họa, âm thanh…)
    * **Lớp nền tảng ảo hóa Virtual Machine Monitor (còn gọi là hypervisor),** thực hiện việc liên lạc trực tiếp với nền tảng phần cứng phía dưới, quản lý và phân phối tài nguyên cho các hệ điều hành khác nằm trên nó
    
    * **Các ứng dụng máy ảo:** Các máy ảo này sẽ lấy tài nguyên từ phần cứng, thông qua sự cấp phát và quản lý của hypervisor.

* Khi một hệ điều hành thực hiện truy xuất hoặc tương tác tài nguyên phần cứng trên hệ điều hành chủ thì công việc của một Hypervisor sẽ là:
    * **Hypervisor mô phỏng phần cứng.** nó làm cho các hệ điều hành tưởng rằng mình đang sử dụng tài nguyên vật lý của hệ thống thật.
    * **Hypervisor liên lạc với các trình điều khiển thiết bị**
    
    * **Các trình điều khiển thiết bị phần cứng liên lạc** trực tiếp đến phần cứng vật lý.

* ##### Mô hình Hypervisor - Base có 2 dạng là Monothic Hypervisor và Microkernel Hypervisor.
    * **Monolithic Hypervisor.**
        *   Monolithic Hypervisor là một hệ điều hành máy chủ. 
        *   Nó chứa những trình điều khiển (Driver) hoạt động phần cứng trong lớp Hypervisor để truy cập tài nguyên phần cứng bên dưới.
        
        *   Khi các hệ điều hành chạy trên các máy ảo truy cập phần cứng thì sẽ thông qua lớp trình điều khiển thiết bị của lớp hypervisor.

    *   Mô hình này mang lại hiệu quả cao, nhưng cũng giống như bất kì các giải pháp khác, bên cạnh mặt ưu điểm thì nó cũng còn có những nhược điểm.
        *   Vì trong quá trình hoạt động, nếu lớp trình điều khiển thiết bị phần cứng của nó bị hư hỏng hay xuất hiện lỗi thì các máy ảo cài trên nó đều bị ảnh hưởng và nguy hại.
    
        *   Phần cứng ngày nay rất đa dạng, nhiều chủng loại và do nhiều nhà cung cấp khác nhau, nên trình điều khiển của Hypervisor trong loại ảo hóa này có thể sẽ không thể hỗ trợ điều khiển hoạt động của phần cứng này một cách đúng đắn và hiệu suất chắc chắn cũng sẽ không được như mong đợi. 
        
        *  Một trình điều khiển không thể nào điều khiển tốt hoạt động của tất cả các thiết bị nên nó cũng có những thiết bị phần cứng không hỗ trợ. 
        ![](https://voer.edu.vn/media/transforms/20140306-214626-tong-quan-ve-ao-hoa-may-chu/Picture%206.png)
    
    *   **Microkernelized Hypervisor.**
        * **Microkernelized Hypervisor** là một kiểu ảo hóa giống như Monolithic Hypervisor. 
        * Điểm khác biệt giữa hai loại này là trong Microkernelized **trình nh điều khiển thiết bị phần cứng bên dưới** được **cài trên một máy ảo và được gọi là trình điều khiển chính,**  tình điều khiển chính này tạo **và quản lý các trình điều khiển con cho các máy ảo**.
        
        * Khi máy ảo có nhu cầu liên lạc với phần cứng thì trình điều khiển con sẽ liên lạc với trình điều khiển chính và trình điều khiển chính này sẽ chuyển yêu cầu xuống lớp Hypervisor để liên lạc với phần cứng.
        ![](https://voer.edu.vn/media/transforms/20140306-214626-tong-quan-ve-ao-hoa-may-chu/Picture%207.png)
        
####  Kiến trúc ảo hóa Hybrid.
*   Hybrid là một kiểu ảo hóa mới hơn và có nhiều ưu điểm. 
    *   Trong đó lớp ảo hóa hypervisor chạy song song với hệ điều hành máy chủ. 
    *   Tuy nhiên trong cấu trúc ảo hóa này, các máy chủ ảo vẫn phải đi qua hệ điều hành máy chủ để truy cập phần cứng nhưng khác biệt ở chỗ cả hệ điều hành máy chủ và các máy chủ ảo đều chạy trong chế độ hạt nhân. 
    
    *   Khi một trong hệ điều hành máy chủ hoặc một máy chủ ảo cần xử lý tác vụ thì CPU sẽ phục vụ nhu cầu cho hệ điều hành máy chủ hoặc máy chủ ảo tương ứng. 
        
    ![](https://voer.edu.vn/media/transforms/20140306-214626-tong-quan-ve-ao-hoa-may-chu/Picture%208.png)


* Một số ví dụ về các hệ thống Bare-metal hypervisor như là: **Oracle VM, Vmware ESX Server, IBM's POWER Hypervisor (PowerVM), Microsoft's Hyper-V, Citrix XenServer…**

# Các mức độ ảo hóa. 
****
#### Ảo hóa toàn phần - Full Virtualization.   
*   **Đây là loại ảo hóa mà ta không cần chỉnh sửa hệ điều hành khách (guest OS) cũng như các phần mềm đã được cài đặt trên nó để chạy trong môi trường hệ điều hành chủ (host OS).**
    *   Khi một phần mềm chạy trên guest OS, các đoạn code của nó không bị biến đổi mà chạy trực tiếp trên host OS và phần mềm đó như đang được chạy trên một hệ thống thực sự. 
    *   Bên cạnh đó, ảo hóa toàn phần có thể gặp một số vấn đề về hiệu năng và hiệu quả trong sử dụng tài nguyên hệ thống.
    *   Trình điều khiển máy ảo phải cung cấp cho máy ảo một “ảnh” của toàn bộ hệ thống, bao gồm BIOS ảo, không gian bộ nhớ ảo, và các thiết bị ảo. 
    
    *   Trình điều khiển máy ảo cũng phải tạo và duy trì cấu trúc dữ liệu cho các thành phần ảo(đặc biệt là bộ nhớ), và cấu trúc này phải luôn được cập nhật cho mỗi một truy cập tương ứng được thực hiện bởi máy ảo.
    ![](https://lh3.googleusercontent.com/-7AWPDfie-IU/W9GkOvfoE-I/AAAAAAAAPIQ/Ht2TwJDw7VYy1uFHD47Pi9NNMjNcyTb-gCHMYCw/image_thumb%255B8%255D?imgmax=800)

#### Paravirtualization - Ảo hóa song song
*   **Là một phương pháp ảo hóa máy chủ mà trong đó, thay vì mô phỏng một môi trường phần cứng hoàn chỉnh, phần mềm ảo hóa này là một lớp mỏng dồn các truy cập các hệ điều hành máy chủ vào tài nguyên máy vật lý cơ sở, sử dụng môt kernel đơn để quản lý các Server ảo và cho phép chúng chạy cùng một lúc (có thể ngầm hiểu, một Server chính là giao diện người dùng được sử dụng để tương tác với hệ điều hành).**
    * Ảo hóa song song đem lại tốc độ cao hơn so với ảo hóa toàn phần và hiệu quả sử dụng các nguồn tài nguyên cũng cao hơn. 
        * Nhưng nó yêu cầu các hệ điều hành khách chạy trên máy áo phải được chỉnh sửa. 
        * Điều này có nghĩa là không phải bất cứ hệ điều hành nào cũng có thể chạy ảo hóa song song được (trái với Ảo hóa toàn phần). XP Mode của Windows 7 là một ví dụ điển hình về ảo hóa song song.
            
    * **Ưu điểm:**  
        * Thứ nhất, giảm chi phí hoạt động do số lượng mã rất ít.*
        *   Ưu điểm thứ hai của ảo hóa song song song là nó không giới hạn các trình điều khiển thiết bị trong phần mềm ảo hóa;

    *  **Nhược điểm:** 
        *  Ảo hóa song song yêu cầu các hệ điều hành chủ phải được thay đổi để tương tác với giao diện của nó. 
        *   Công việc này chỉ có thể được thực hiện khi truy cập mã nguồn của hệ điều hành
            
    ![](https://img.tfd.com/cde/PARVIRT2.GIF)
        
# Ưu điểm, nhược điểm của ảo hoá máy chủ.
****
#### Ưu điểm.
* ##### Giúp tận dụng tối đa tài nguyên phần cứng của máy chủ vật lí, tiết kiệm chi phí đầu tư hệ thống.

*   ##### Máy ảo có thể được sử dụng để tạo ra hệ điều hành, hay môi trường thực thi với tài nguyên giới hạn, mang lại một lịch trình đúng, bảo đảm tài nguyên.

*   ##### Máy ảo có thể cung cấp ảnh ảo của phần cứng, hay cấu hình phần cứng mà bạn không có (chẳng hạn như thiết bị SCSI, đa xử lý,...). 
    *   Ảo hóa cũng có thể được sử dụng để mô phỏng mạng hay các máy tính độc lập.
 
*   ##### Máy ảo có thể được sử dụng để chạy nhiều hệ điều hành cùng một lúc

*   ##### Máy ảo cho phép cơ chế sửa lỗi mạnh mẽ và giám sát hiệu năng. 

*   ##### Máy ảo có thể cách ly với những gì nó chạy, ngăn chặn thiếu sót và lỗi. 

*   ##### Ảo hóa có thể khởi tạo hệ điều hành có sẵn để chạy trên những bộ nhớ đa xử lý được chia sẻ.

*   ##### Máy ảo có thể được sử dụng để tạo ra các kịch bản test tùy ý

*   ##### Ảo hóa có thể tạo ra các tác vụ như là di chuyển hệ thống, sao lưu, phục hồi & quản lí dễ dàng, thuận tiện hơn.

#### Nhược điểm:

* ##### Giải pháp ảo hóa có điểm nút sự cố (single point of failure): 
    * Ở một máy, mà trên đó, mọi giải pháp ảo hóa đang chạy, gặp sự cố hay khi chính giải pháp ảo hóa gặp sự cố, sẽ làm crash mọi thứ. 
    
    * Tăng sức chứa và thường xuyên sao lưu hệ điều hành ảo (cùng với ứng dụng ảo) là một cách thức giúp giảm thiểu nguy cơ mất dữ liệu và thời gian chết do single point of failure

* ##### Ảo hóa yêu cầu những cỗ máy mạnh mẽ:
    * Nếu cỗ máy được sử dụng không đủ mạnh, vẫn có thể triển khai các giải pháp ảo hóa nhưng khi mà không có đủ sức mạnh CPU và RAM cho chúng, nó sẽ thực sự làm gián đoạn công việc.

* ##### Ảo hóa có thể dẫn đến hiệu năng thấp: 
    * Một trong những thực tế gặp phải đó là một ứng dụng khi chạy trên môi trường không ảo hóa thì hoạt động tốt nhưng lại gặp vấn đề khi chạy trên hệ thống ảo hóa. 

* ##### Ứng dụng ảo hóa không phải luôn luôn khả dụng: 

* ##### Rủi ro lỗi vật lý cao: 
    * Vỡi 1 lỗi vật lý, có thể sẽ khiến cho  tất cả các server bị offline 

# Lợi ích khi ảo hóa máy chủ 
****
*   #### Tiết kiệm năng lượng
    *   Di chuyển các máy chủ vật lý thành các máy ảo và hợp nhất chúng vào số lượng ít các máy chủ vật lý hơn sẽ giúp bạn giảm chi phí điện và chi phí làm mát hàng tháng trong datacenter. 


*   #### Máy chủ hoạt động nhanh hơn
    * Ảo hóa máy chủ cho phép khả năng mở rộng hoặc thu hẹp quy mô trong quá trình triển khai hệ thống tại thời điểm có nhu cầu.
    
    * Có thể nhanh chóng sao chép một image, master template, hoặc virtual machine hiện có để có thể khởi chạy ngay một server trong vòng chỉ vài phút.
    

*   #### Tăng uptime
    *  Cung cấp một số tính năng nâng cao mà máy chủ vật lý không có, giúp cải thiện tính liên tục và tăng uptime. 
    *  Các tính năng như: live migration, storage migration, fault tolerance, high availability, và distributed resource scheduling.
    
    *   Những công nghệ cung cấp khả năng phục hồi nhanh chóng từ các sự cố cúp điện không có kế hoạch. 
    *   Khả năng di chuyển một máy ảo từ máy chủ này sang máy chủ khác nhanh chóng và dễ dàng 
    
*   #### Khắc phục thảm họa tốt hơn 
    *  Khả năng hardware abstraction. 
        *  Bằng cách loại bỏ sự phụ thuộc vào một nhà cung cấp phần cứng hoặc mô hình máy chủ cụ thể, một disaster recovery site không còn cần phải giữ phần cứng giống nhau để phù hợp với production environment và IT có thể tiết kiệm tiền bằng cách mua phần cứng rẻ hơn.  
        
    *   Hợp nhất các máy chủ thành ít các máy vật lý hơn trong production, một tổ chức có thể dễ dàng tạo ra một replication site có giá cả phải chăng. 
    *   Có phần mềm có thể giúp tự động chịu lỗi khi xảy ra thảm họa. Các phần mềm tương tự cũng cung cấp một cách để kiểm tra disaster recovery failover
    
# Lợi ích chính của ảo hóa trong Trung tâm dữ liệu 
****

*   ####  Ít nhiệt tích tụ
    * Ảo hóa máy chủ sẽ giúp bạn sử dụng ít phần cứng vật lý hơn. Sử dụng ít phần cứng vật lý hơn do đó nhiệt lượng tỏa ra sẽ ít hơn. 
    * GIảm đi một loạt các vấn đề phát sinh do nhiệt độ cao.  
    

*   #### Giảm chi phí
    *   Giảm lượng phần cứng cần dùng, giảm chi phí 
    *   Tiết kiệm chi phí hơn nữa bởi downtime ít đi, bảo trì dễ dàng hơn, ít điện năng tiêu thụ hơn. 


*   #### Sao lưu dễ dàng hơn
    *   Không những có thể sao lưu toàn bộ virtual server, bạn còn có thể backup và snapshot các virtual machinne .
    *   Các virtual machine này có thể được chuyển từ máy chủ này sang máy chủ khác và triển khai lại dễ dàng và nhanh chóng. 
        *   Snapshot có thể được chụp lại nhiều lần trong ngày, đảm bảo dữ liệu được cập nhật hơn nhiều, cắt giảm thời gian downtime 
