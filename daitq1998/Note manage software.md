**Manage sorfware**
  **Using debian**
  - debian sd ba tiện ich chính apt- công cụ gói năng cao trình quản lý gói chính trên các hệ thống debian đc sd để truy xuất/cài đặt, xóa hoặc tìm kiếm gói 
  Cài đặt các file `.deb` File này rất dễ cài, chỉ cần click đúp vào file và trình cài đặt phần mềm trên hệ thống tự mở, click “Install Package” và chờ quá trình cài đặt hoàn tất.
  
  -`dpkg` là công cụ cài đặt gói Debian đã có sẵn (vì nó không tải bất cứ thứ gì). Để thực hiện việc này, chúng ta sử dụng tùy chọn -i hoặc --install.
  Việc cài đặt cũng có thể được thực hiện trong hai giai đoạn: đầu tiên giải nén, sau đó cấu hình. `apt-get` tận dụng điều này, hạn chế số lượng cuộc gọi đến `dpkg` (vì mỗi cuộc gọi tốn kém, do tải cơ sở dữ liệu trong bộ nhớ , đặc biệt là danh sách các tập tin đã được cài đặt).
  
  **Using redhat packages by rpm**
  
 - Cài đặt các file `.rpm` Bạn nên sử dụng gói Alien để chuyển từ `.rpm` sang `.deb` cho dễ cài đặt  Mở Terminal lên, gõ vào `sudo apt-get install alien` đề download và cài đặt gói Alien thông qua tiện ích quản lý gói APT Gõ vào Password ứng với User bạn đang Logon. Gõ ‘y’ để đồng ý cài đặt gói Alien Sau khi cài xong Alien, bạn move file `.rpm` tới Desktop rồi mở Terminal, gõ cd Desktop Bây giờ, gõ `sudo alien -k filename.rpm` để convert từ file `.rpm` -> `.deb.` Sau đó bạn cài file `.deb` như trên
