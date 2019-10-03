# Cài đặt Apache trên Ubuntu server
- Để cài đặt apache dùng lệnh :`sudo apt-get install apache2`
- Sau khi cài đặt apache cần điều chỉnh firewall để cho phép truy cập bên ngoài đến các default web port
- Truy cập đến các `ufw` application profile bằng lệnh `sudo ufw app list` ![](
- Thấy có 3 profile :
  - Apache: Profile này chỉ mở port 80( là port truy cập web bình thường không mã hóa)
  - Apache Full: profile này mở port 80 và 443(cho phép truy cập cả web bình thường lẫn web mã hóa TLS/SSL)
  - Apache secure: profile này mở port 443 (là port truy cập web có mã hóa TLS/SSL)
  - Tùy từng trường hợp chon profile thích hợp trong trường hợp này sử dụng profile `Apache Full`: sudo ufw allow 'Apache Full'
  - Sau khi chọn profile tiến hành kiểm tra trạng thái của apache :`sudo systemctl status apache2`
  - Sau đó ta nhập đia chỉ ip hoặc domain lên trình duyệt nếu hiện lên ntn  thì cài đặt apache đã thành công ![](
  
  **Thiết lập máy chủ ảo**
  - Đầu tiên tạo thư mục `adai.com` trong `/var/www/`
  - Sau đó phân quyền và gán quyền user cho thư mục:  `chmod -R 755 /var/www/adai.com` `chown -R daina98tq:daina98tq /var/www/adai.com`
  - Tạo môt index.html và thêm vào trong đó ![](
  *Tạo một máy chủ ảo mới*
  - Tạo một máy chủ ảo mới tại : `/etc/apache2/sites-available/adai.com.conf`
  - Thêm vào trong file vừa tạo ![](
  - sau đó kích hoạt tệp với a2ensite `a2ensite adai.com.conf`
  - Vô hiệu hóa trang web đc mặc định trong `000-default.conf`:`a2disstite 000-default.conf`
  - kiểm tra lỗi cấu hình `apache2ctl configtest` và khởi động lại apache
  - sau đó kiểm tra trên trình duyệt và kết quả ![](
  # Cài đặt MySQL trên Ubuntu server
  - MySQL là một hệ thống quản lý cơ sở dữ liệu. Về cơ bản, nó sẽ tổ chức và cung cấp quyền truy cập vào cơ sở dữ liệu nơi trang web có thể lưu trữ thông tin
  - Để cài đặt mySQL  trên ubuntu server dùng lệnh :`sudo apt-get install mysql-server`
  - Tiếp theo dùng lệnh`sudo mysql_secure_installation`.Để thiết lập mật khẩu cho tài khoản root mySQL và thay đổi một số thiết lập
  # Cài đặt wordpress trên ubuntu server
  - Đầu tiên để cài đặt wordpress cần khởi tạo MySQL Database và User cho wordpress
   - Đăng nhập vào mysql:`mysql -u root -p` và nhập password vừa tạo để vào trong mysql
   - Sau đó đánh dòng lệnh `CREATE DATABASE wordpress;` để khởi tạo cơ sở dữ liệu cho wordpress
   - Để tạo user cho wordpress sử dụng dòng lệnh:`GRANT ALL PRIVILEGES ON wordpress.*TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';` và thêm dòng lệnh `FLUSH PRIVILEGES` nhập `exit` để thoát
   **Tải mã nguồn wordpress**
   - Vào đường dẫn `/var/www/`
   - Dùng lệnh `wget https://wordpress.org/latest.tar.gz` để tải xuống file `lagest.tar.gz`và giải nén
   - 
