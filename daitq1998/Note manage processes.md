***Manage Processes***
 
 **Lệnh `ps`**

 - Lệnh `ps` là lệnh liệt kê các tiến trình đang chạy trên hệ thống
 
 *cú pháp*: `ps [option]`
 
 **Tùy chon**
`-a` hiển thị các quy trình trên một thiết bị đầu cuối( ngoại trừ leader)
`-c` hiển thị dữ liệu lịch trình 
`-d` hiển thị chon tất cả các chương trình ngoại trừ chương trinh nguồn
`-e` hiển thị tất cả các chương trình nguồn
`-f` hiển thị một danh sách cá chương trình hoạt động đầy đủ
`-j` hiển thị id nhóm quá trình và id phiên
`-l` hiển thị một danh sách dài
`-p` hiển thị dữ liệu cho danh sách id người lãnh đạo phiên 
`-t` hiển thị dữ liệu cho danh sách các thiết bị đầu cuối
`-u` hiển thị dữ liệu cho danh sách người dùng 

**Lệnh `top`**

- là câu lệnh dùng để xem việc sử dụng tài nguyên hệ thống với các quy trình sử dụng nhiều cpu hệ thống nhất
cú pháp: `top [option]`

**Tùy chọn**

-`-b`Bắt đầu hàng đầu trong mode Chế độ hàng loạt ', có thể hữu ích để gửi đầu ra từ đầu đến các chương trình khác hoặc đến một tệp. Trong chế độ này, top sẽ không chấp nhận đầu vào và chạy cho đến khi giới hạn lặp bạn đã đặt với tùy chọn dòng lệnh '-n' hoặc cho đến khi bị giết.
-`-d`Chỉ định độ trễ giữa các bản cập nhật màn hình và ghi đè giá trị tương ứng trong tệp cấu hình cá nhân của một người hoặc mặc định khởi động. Sau đó, điều này có thể được thay đổi bằng các lệnh tương tác 'd' hoặc 's'.
 -`-p` PID: Chỉ giám sát các quy trình với ID quy trình được chỉ định. Tùy chọn này có thể được cung cấp tối đa 20 lần hoặc bạn có thể cung cấp danh sách được phân tách bằng dấu phẩy với tối đa 20 pids. Phối hợp cả hai cách tiếp cận được cho phép.
 **Lệnh `htop`**
 
 - là câu lệnh liệt kê các chương trình sử dụng cpu hệ thống theo dạng bảng dễ nhìn hơn. Htop là một chương trình mới hơn so với đầu trang , nó cung cấp nhiều cải tiến. htop hỗ trợ hoạt động của chuột, sử dụng màu sắc trong đầu ra của nó và đưa ra các chỉ dẫn trực quan về bộ xử lý, bộ nhớ và sử dụng trao đổi. htop cũng in các dòng lệnh đầy đủ cho các quy trình và cho phép một người cuộn cả theo chiều dọc và chiều ngang cho các quy trình và dòng lệnh tương ứng

 cú pháp `htop [option]`
 
 **Tùy chọn**
 -`-d` Độ trễ giữa các bản cập nhật đầu ra, tính bằng phần mười giây.
 -`-c` Chạy htop ở chế độ đơn sắc
 -`-p` Hiển thị đầu ra cho các PID này
  -`-s` Sắp xếp đầu ra dựa trên cột
  
  **Lệnh `kill`**
  -Là câu lệnh dùng để dừng một tiến trình đang chạy trên hệ thống
  cú pháp: `kill [option]`
  **tùy chọn**
  -`-l`Liệt kê tên tín hiệu. Tùy chọn này có đối số tùy chọn, trong đó sẽ chuyển đổi số tín hiệu thành tên tín hiệu, hoặc ngược lại.
  -`-L`liệt kê tín hiệu trong một table

**Foreground and Background Processes**

  *Foreground*

  - Là quy trình tiền cảnh là bất kì tác vụ nào bạn chạy trục tiếp và chờ cho nó hoàn thành một quy trình nền hiển thị một số loại giao diện người dùng hỗ trợ tương tác người dùng đang diễn ra trong các quy trình khác thực thi một tác vụ và đóng băng máy tính khi hoàn thành nhiệm vụ
  
  *Background Processes*

  -là quá trình nền là ta có thể nhập nhiều lệnh lần lượt để chạy lệnh dưới dạng quá trình nền nhập lệnh và thêm khoảng trắng và dấu vào cuối lệnh
