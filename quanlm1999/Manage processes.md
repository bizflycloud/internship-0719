# Manage processes
#### 'ps’, ‘top’, ‘htop'

**ps** là lệnh liệt kê các tiến trình đang chạy trên hệ thống .
**câu lênh**: ps <option>
**option** :
  * -a hiển thị các quy trình trên một thiết bị đầu cuối( ngoại trừ leader) 
  * -c hiển thị dữ liệu lịch trình -
  * -d hiển thị chon tất cả các chương trình ngoại trừ chương trinh nguồn 
  * -e hiển thị tất cả các chương trình nguồn -f hiển thị một danh sách cá chương trình hoạt động đầy đủ -
  * -j hiển thị id nhóm quá trình và id phiên 
  * -l hiển thị một danh sách dài 
  * -p hiển thị dữ liệu cho danh sách id người lãnh đạo phiên -
  * -t hiển thị dữ liệu cho danh sách các thiết bị đầu cuối 
  * -u hiển thị dữ liệu cho danh sách người dùng
 
**top** là lệnh để xem tiến trình hệ thống của linux 
**câu lệnh** top <option> 
**option**
* -b: gửi dữ liệu từ top sang 1 file hoặc program khác 
* -s: Chạy trong chế độ secure 
* -d: độ trễ mỗi lần làm mới 

**htop** là câu lệnh liệt kê các chương trình sử dụng cpu hệ thống theo dạng bảng dễ nhìn hơn. Htop là một chương trình mới hơn so với top, nó cung cấp nhiều cải tiến., có thể tương tác bằng chuột 
**câu lênh**htop <option>
**option** 
   * --d Độ trễ giữa các bản cập nhật đầu ra, tính bằng phần mười giây. 
   * --c Chạy htop ở chế độ đơn sắc -
   * --p Hiển thị đầu ra cho các PID này 
   * --s Sắp xếp đầu ra dựa trên cột
  
#### Foreground and Background Processes
**Foreground Processes** Là quy trình tiền cảnh là bất kì tác vụ nào bạn chạy trục tiếp và chờ  nó hoàn thành
**background Processes** Là quá trình nền là ta có thể nhập nhiều lệnh lần lượt để chạy lệnh dưới dạng quá trình nền nhập lệnh và thêm khoảng trắng và dấu vào cuối lệnh

#### Killing processes
**Kiliing processes** là bắt tiến trình phải dừng lại trong trường hợp phản hồi quá lâu.
**câu lệnh** kill <PID> hoặc killall <name> 

