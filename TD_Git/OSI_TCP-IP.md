# Mô Hình OSI (Open Systems Interconnection Reference Model)

- Mô hình OSI (OpenSystemInterconnection): là mô hình được tổ chức ISO đề xuất từ 1977 và công bố lần đầu vào 1984. Để các máy tính và các thiết bị mạng có thể truyền thông với nhau phải có những qui tắc giao tiếp được các bên chấp nhận. Mô hình OSI là một khuôn mẫu giúp chúng ta hiểu dữ liệu đi xuyên qua mạng như thế nào đồng thời cũng giúp chúng ta hiểu được các chức năng mạng diễn ra tại mỗi lớp.

## Mô tả

- Trong mô hình OSI có bảy lớp, mỗi lớp mô tả một phần chức năng độc lập. Sự tách lớp của mô hình này mang lại những lợi ích sau:
<ul>
<li>Chia hoạt động thông tin mạng thành những phần nhỏ hơn, đơn giản hơn giúp chúng ta dễ khảo sát và tìm hiểu hơn.</li>
<li>Chuẩn hóa các thành phần mạng để cho phép phát triển mạng từ nhiều nhà cung cấp sản phẩm.</li>
<li>Ngăn chặn được tình trạng sự thay đổi của một lớp làm ảnh hưởng đến các lớp khác, như vậy giúp mỗi lớp có thể phát triển độc lập và nhanh chóng hơn.</li>
</ul>

- Mô hình tham chiếu OSI định nghĩa các qui tắc cho các nội dung sau:
<ul>
<li>Cách thức các thiết bị giao tiếp và truyền thông được với nhau.</li>
<liCác phương pháp để các thiết bị trên mạng khi nào thì được truyền dữ liệu, khi nào thì không được.</li>
<li>Các phương pháp để đảm bảo truyền đúng dữ liệu và đúng bên nhận.</li>
<li>Cách thức vận tải, truyền, sắp xếp và kết nối với nhau.</li>
<li>Cách thức đảm bảo các thiết bị mạng duy trì tốc độ truyền dữ liệu thích hợp.</li>
<li>Cách biểu diễn một bit thiết bị truyền dẫn.</li>
</ul>

## Các tầng của mô hình OSI


Mô hình tham chiếu OSI được chia thành bảy lớp với các chức năng sau:

+ Application : (ứng dụng): giao diện giữa ứng dụng và mạng (Tầng 7)

+ Presentation: (trình bày): thoả thuận khuôn dạng trao đổi dữ liệu (Tầng 6)

+ Session : (phiên): cho phép người dùng thiết lập các kết nối (Tầng 5)

+ Transport : (vận chuyển): đảm bảo truyền thông giữa hai hệ thống. (Tầng 4)

+ NetWork : (mạng):định hướng dữ liệu truyền trong liên mạng.(Tầng 3)

+ Data Link : (liên kết dữ liệu): xác định việc truy xuất đến thiết bị. (Tầng 2)

+ Physical : (vật lý): chuyển đổi dữ liệu thành các bit và truyền đi. (Tầng 1)

|   | Mô Hình OSI 7 Tầng |      Ý nghĩa các tầng           | Data Unit |
|---|--------------------|---------------------------------|-----------|
| 7 | Application | Các quá trình giao tiếp với các ứng dụng | Data |
| 6 | Presentation | Biểu diễn dữ liệu | Data |
| 5 | Session | Thông tin liên host | Data |
| 4 | Transport | Kết thúc từ đầu cuối đến đầu cuối | Segments |
| 3 | Network | Định địa chỉ và chọn đường dẫn tốt nhất | Packets |
| 2 | Data Link | Truy xuất môi trường truyền | Frames |
| 1 | Physical | Truyền dẫn nhị phân | Bits |

### Lớp ứng dụng (ApplicationLayer)

- Giao diện giữa các chương trình ứng dụng của người dùng và mạng. Lớp Application xử lý truy nhập mạng chung, kiểm soát luồng và phục hồi lỗi. Lớp này không cung cấp các dịch vụ cho lớp nào mà nó cung cấp dịch vụ cho các ứng dụng như: truyền file, gởi nhận E-mail, Telnet, HTTP, FTP, SMTP…

### Lớp trình bày (PresentationLayer) 

- Chịu trách nhiệm thương lượng và xác lập dạng thức dữ liệu được trao đổi. Nó đảm bảo thông tin mà lớp ứng dụng của một hệ thống đầu cuối gởi đi, lớp ứng dụng của hệ thống khác có thể đọc được. Lớp trình bày thông dịch giữa nhiều dạng dữ liệu khác nhau thông qua một dạng chung, đồng thời nó cũng nén và giải nén dữ liệu. Thứ tự byte, bit bên gởi và bên nhận qui ước qui tắc gởi nhận một chuỗi byte, bit từ trái qua phải hay từ phải qua trái. Nếu hai bên không thống nhất thì sẽ có sự chuyển đổi thứ tự các byte bit vào trước hoặc sau khi truyền. Lớp presentationcũng quản lý các cấp độ nén dữ liệu nhằm giảm số bit cần truyền. Ví dụ: JPEG,ASCCI, EBCDIC....

### Lớp phiên (SessionLayer)

- Có chức năng thiết lập, quản lý, và kết thúc các phiên thông tin giữa hai thiết bị truyền nhận. Lớp phiên cung cấp các dịch vụ cho lớp trình bày. Lớp Session cung cấp sự đồng bộ hóa giữa các tác vụ người dùng bằng cách đặt những điểm kiểm tra vào luồng dữ liệu. Bằng cách này, nếu mạng không hoạt động thì chỉ có dữ liệu truyền sau điểm kiểm tra cuối cùng mới phải truyền lại. Lớp này cũng thi hành kiểm soát hội thoại giữa các quá trình giao tiếp, điều chỉnh bên nào truyền, khi nào, trong bao lâu. Ví dụ như: RPC,NFS,... Lớp này kết nối theo ba cách: Haft-duplex, Simplex, Full-duplex.

### Lớp vận chuyển (TransportLayer)

- Phân đoạn dữ liệu từ hệ thống máy truyền và tái thiết lập dữ liệu vào một luồng dữ liệu tại hệ thống máy nhận đảm bảo rằng việc bàn giao các thông điệp giữa các thiết bị đáng tin cậy. Dữ liệu tại lớp này gọi là segment. Lớp này thiết lập, duy trì và kết thúc các mạch ảo đảm bảo cung cấp các dịch vụ sau:
<ul>
<li>Xếp thứ tự các phân đoạn: khi một thông điệp lớn được tách thành nhiều phân đoạn nhỏ để bàn giao, lớp vận chuyển sẽ sắp xếp thứ tự các phân đoạn trước khi ráp nối các phân đoạn thành thông điệp ban đầu.</li>
<li>Kiểm soát lỗi: khi có phân đoạn bị thất bại, sai hoặc trùng lắp, lớp vận chuyển sẽ yêu cầu truyền lại.</li>
<li>Kiểm soát luồng: lớp vận chuyển dùng các tín hiệu báo nhận để xác nhận. Bên gửi sẽ không truyền đi phân đoạn dữ liệu kế tiếp nếu bên nhận chưa gởi tín hiệu xác nhận rằng đã nhận được phân đoạn dữ liệu trước đó đầy đủ.</li>
</ul>

### Lớp mạng (NetworkLayer)

- Chịu trách nhiệm lập địa chỉ các thông điệp, diễn dịch địa chỉ và tên logic thành địa chỉ vật lý đồng thời nó cũng chịu trách nhiệm gởi packet từ mạng nguồn đến mạng đích. Lớp này quyết định đường đi từ máy tính nguồn đến máy tính đích. Nó quyết định dữ liệu sẽ truyền trên đường nào dựa vào tình trạng, ưu tiên dịch vụ và các yếu tố khác. Nó cũng quản lý lưu lượng trên mạng chẳng hạn như chuyển đổi gói, định tuyến, và kiểm soát sự tắc nghẽn dữ liệu. Nếu bộ thích ứng mạng trên bộ định tuyến (router) không thể truyền đủ đoạn dữ liệu mà máy tính nguồn gởi đi, lớp Network trên bộ định tuyến sẽ chia dữ liệu thành những đơn vị nhỏ hơn, nói cách khác, nếu máy tính nguồn gởi đi các gói tin có kích thước là 20Kb, trong khi Router chỉ cho phép các gói tin có kích thước là 10Kb đi qua, thì lúc đó lớp Network của Router sẽ chia gói tin ra làm 2, mỗi gói tin có kích thước là 10Kb. Ở đầu nhận, lớp Network ráp nối lại dữ liệu. Ví dụ: một số giao thức lớp này: IP, IPX,... Dữ liệu ở lớp này gọi packet hoặc datagram.

### Lớp liên kết dữ liệu (Data link Layer)

- Cung cấp khả năng chuyển dữ liệu tin cậy xuyên qua một liên kết vật lý. Lớp này liên quan đến:
<ul>
<li>Địa chỉ vật lý.</li>
<li>Mô hình mạng.</li>
<li>Cơ chế truy cập đường truyền.</li>
<li>Thông báo lỗi.</li>
<li>Thứ tự phân phối frame.</li>
<li>Điều khiển dòng.</li>
</ul>

- Tại lớp datalink, các bít đến từ lớp vật lý được chuyển thành các frame dữ liệu bằng cách dùng một số nghi thức tại lớp này. Lớp data linkđược chia thành hai lớp con: Lớp con LLC (logical link control), lớp con MAC (media access control).

#### Lớp con LLC (logical link control).

- Lớp con LLC là phần trên so với các giao thức truy cập đường truyền khác, nó cung cấp sự mềm dẻo về giao tiếp. Bởi vì lớp con LLC hoạt động độc lập với các giao thức truy cập đường truyền, cho nên các giao thức lớp trên hơn (ví dụ như IP ở lớp mạng) có thể hoạt động mà không phụ thuộc vào loại phương tiện LAN. Lớp con LLC có thể lệ thuộc vào các lớp thấp hơn trong việc cung cấp truy cập đường truyền.

#### Lớp con MAC (media access control).

- Lớp con MAC cung cấp tính thứ tự truy cập vào môi trường LAN. Khi nhiều trạm cùng truy cập chia sẻ môi trường truyền, để định danh mỗi trạm, lớp cho MAC định nghĩa một trường địa chỉ phần cứng, gọi là địa chỉ MAC address. Địa chỉ MAC là một con số đơn nhất đối với mỗi giao tiếp LAN (card mạng).

### Lớp vật lý (PhysicalLayer)

Định nghĩa các qui cách về điện, cơ, thủ tục và các đặc tả chức năng để kích hoạt, duy trì và dừng một liên kết vật lý giữa các hệ thống đầu cuối. Một số các đặc điểm trong lớp vật lý này bao gồm:
<ul>
<li>Mức điện thế.</li>
<li>Khoảng thời gian thay đổi điện thế.</li>
<li>Tốc độ dữ liệu vật lý.</li>
<li>Khoảng đường truyền tối đa.</li>
<li>Các đầu nối vật lý.</li>
</ul>

# Mô hình TCP/IP

- Chuẩn mang tính kỹ thuật và lịch sử của Internet là mô hình TCP/IP. Bộ quốc phòng Hoa Kỳ (DoD: Department of Defense) đã tạo ra mô hình DoD là tiền thân của mô hình TCP/IP, bởi họ muốn thiết kế một mạng có thể tồn tại dưới bất kỳ hoàn cảnh nào, ngay cả cuộc chiến tranh hạt nhân. Trong một thế giới được kết nối bằng các loại đường truyền khác nhau như cáp đồng trục, sóng vi ba, cáp sợi quang và các liên kết vệ tinh, DoD muốn truyền dẫn các gói vào mọi lúc dưới bất kỳ điều kiện nào. Bài toán thiết kế rất khác biệt này đã dẫn đến sự phát minh ra mô hình TCP/IP.

Mô hình TCP/IP có bốn lớp sau:

|  TCP/IP  |
|----------|
| Application |
| Transport |
| Internet |
| Network Interface |

## Lớp ứng dụng.

- Kiểm soát các giao thức lớp cao, các chủ đề về trình bày, biểu diễn thông tin, mã hóa và điều khiển hội thoại. Bộ giao thức TCP/IP tổ hợp tất cả các ứng dụng liên quan đến các chủ đề vào trong một lớp và đảm bảo số liệu này được đóng gói thích hợp trước khi chuyển nó đến lớp kế tiếp. TCP/IP không chỉ chứa các đặc tả về lớp Internet và lớp vận chuyển, như IP và TCP, mà còn đặc tả cho các ứng dụng phổ biến. TCP/IP có các giao thức để hỗ trợ truyền file, e-mail và remote login, thêm vào các ứng dụng sau đây:

### File Transfer Protocol (FTP)

- FTP là một dịch vụ có tạo cầu nối (connection-oriented) tin cậy, nó sử dụng TCP để truyền các tập tin giữa các hệ thống có hỗ trợ FTP. Nó hỗ trợ truyền file nhị phân hai chiều và tải các file ASCII.

### Trivial File Transfer Protocol (TFTP)

- TFTP là một dịch vụ không tạo cầu nối (connectionless) dùng UDP (User Datagram Protocol). TFTP được dùng trên router để truyền các file cấu hình và các Cisco IOS image và để truyền các file giữa các hệ thống hỗ trợ TFTP. Nó hữu dụng trong một vài LAN bởi nó hoạt động nhanh hơn FTP trong một môi trường ổn định.

### Network File System (NFS)

- NFS là một bộ giao thức hệ thống file phân tán được phát triển bởi Sun Microsystems cho phép truy xuất file đến các thiết bị lưu trữ ở xa như một đĩa cứng qua mạng.

### Simple Mail Transfer Protocol (SMTP)

- SMTP quản lý hoạt động truyền e-mail qua mạng máy tính. Nó không hỗ trợ truyền dạng số liệu nào khác hơn là plaintext.

### Terminal emulation (Telnet)

- Telnet cung cấp khả năng truy nhập từ xa vào máy tính khác. Nó cho phép một user đăng nhập vào một Internet host và thực thi các lệnh. Một Telnet client được xem như một host cục bộ. Một Telnet server được xem như một host ở xa.

### Simple Network Management Protocol (SNMP)

- SNMP là một giao thức cung cấp một phương pháp để giám sát và điều khiển các thiết bị mạng và để quản lý các cấu hình, thu thập thống kê, hiệu suất và bảo mật.

### Domain Name System (DNS)

- DNS là một hệ thống được dùng trên Internet để thông dịch tên của các miền (domain) và các node mạng được quảng cáo công khai sang các địa chỉ IP.


## Lớp vận chuyển.

- Lớp vận chuyển cung ứng dịch vụ vận chuyển từ host nguồn đến host đích. Lớp vận chuyển thiết lập một cầu nối logic giữa các đầu cuối của mạng, giữa host truyền và host nhận. Giao thức vận chuyển phân chia và tái thiết lập dữ liệu của các ứng dụng lớp trên thành luồng dữ liệu giống nhau giữa các đầu cuối. Luồng dữ liệu của lớp vận chuyển cung cấp các dịch vụ truyền tải từ đầu cuối này đến đầu cuối kia của mạng.

- Lớp này vận chuyển gửi các gói từ nguồn đến đích qua mạng internet. Điều khiển end-to-end, được cung cấp bởi cửa sổ trượt (sliding windows) và tính tin cậy trong các số tuần tự và sự báo nhận, là nhiệm vụ then chốt của lớp vận chuyển khi dùng TCP. Lớp vận chuyển cũng định nghĩa kết nối end-to-end giữa các ứng dụng của host. Các dịch vụ vận chuyển bao gồm tất cả các dịch vụ sau đây:

### TCP

Thiết lập các hoạt động end-to-end.
Cửa sổ trượt cung cấp điều khiển luồng.
Chỉ số tuần tự và báo nhận cung cấp độ tin cậy cho hoạt động

### UDP
 
Phân đoạn dữ liệu ứng dụng lớp trên.
Truyền các segment từ một thiết bị đầu cuối này đến thiết bị đầu cuối khác.

## Lớp Internet.

- Chọn một đường dẫn tốt nhất đi qua mạng cho các gói di chuyển tới đích. Giao thức chính hoạt động tại lớp này là Internet Protocol (IP). Sự xác định đường dẫn tốt nhất và chuyển mạch gói diễn ra tại lớp này.

Các giao thức sau đây hoạt động tại lớp Internet của mô hình TCP/IP.

### IP 

Cung cấp connectionless, định tuyến chuyển phát gói theo best-offort. IP không quan tâm đến nội dung của các gói nhưng tìm kiếm đường đẫn cho gói tới đích.

Thực hiện các nhiệm vụ chính sau:
<ul>
<li>Định nghĩa một gói là một lược đồ đánh địa chỉ.</li>
<li>Trung chuyển số liệu giữa lớp Internet và lớp truy nhập mạng.</li>
<li>Định tuyến chuyển các gói đến host ở xa.</li>
</ul>

### ICMP (Internet Control Message Protocol)

Cung cấp khả năng điều khiển và chuyển thông điệp.

### ARP (Address Resolution Protocol)

Xác định địa chỉ lớp liên kết số liệu (MAC address) khi đã biết trước địa chỉ IP.

### RARP (Reverse Address Resolution Protocol) 

Xác định các địa chỉ IP khi biết trước địa chỉ MAC.

## Lớp truy nhập mạng.

- Lớp truy nhập mạng cũng còn được gọi là lớp host-to-network. Lớp này liên quan đến tất cả các chủ đề mà gói IP cần để thực sự tạo ra một liên kết vật lý đến môi trường truyền của mạng. Nó bao gồm các chi tiết của công nghệ LAN và WAN và tất cả các chi tiết được chứa trong lớp vật lý và lớp liên kết số liệu của mô hình OSI các driver cho các ứng dụng, các modem card và các thiết bị khác hoạt động tại lớp truy nhập mạng này. 
- Các tiêu chuẩn giao thức modem như SLIP (Serial Line Internet Protocol) và PPP (Point-to-Point) cung cấp truy xuất mạng thông qua một kênh kết nối dùng modem. Bởi sự ảnh hưởng qua lại khá rắc rối của phần cứng, phần mềm và đặc tả môi trường truyền, nên có nhiều giao thức hoạt động tại lớp này. Điều này có thể dẫn đến sự rối rắm cho người dùng. Hầu hết các giao thức được công nhận hoạt động tại lớp vận chuyển và lớp Internet của mô hình TCP/IP.

- Các chức năng của lớp truy nhập mạng bao gồm ánh xạ địa chỉ IP sang địa chỉ vật lý và đóng gói (encapsulation) các gói IP thành các frame. Căn cứ vào dạng phần cứng và giao tiếp mạng, lớp truy nhập mạng sẽ xác lập kết nối với đường truyền vật lý của mạng.

# So sánh mô hình OSI và mô hình TCP/IP

## Giống nhau
<ul>
<li>Cả hai đều phân lớp.</li>
<li>Cả hai đều có lớp ứng dụng, từ đó chúng có thể có các dịch vụ rất khác biệt.</li>
<li>Cả hai đều có lớp mạng và lớp vận chuyển gần giống nhau.</li>
<li>Các chuyên viên mạng đều phải hiểu biết cả hai mô hình này.</li>
<li>Cả hai đều cho các gói được chuyển mạch. Các gói riêng biệt có thể đi theo các đường dẫn độc lập để đến cùng một đích.</li>
</ul> 

## Khác nhau

<ul>
<li>TCP/IP kết hợp lớp trình bày và lớp phiên vào lớp ứng dụng.</li>
<li>TCP/IP kết hợp các lớp liên kết dữ liệu và lớp vật lý thành lớp truy nhập mạng.</li>
<li>TCP/IP đơn giản hơn vì có ít lớp hơn.</li>
<li>Các giao thức TCP/IP là các tiêu chuẩn mà Internet dùng để phát triển, như vậy mô hình TCP/IP có được sự tín nhiệm chỉ bởi các giao thức của nó.</li>
</ul>
