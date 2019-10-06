# Cài đặt Apache trên Ubuntu server
- Để cài đặt apache dùng lệnh :`sudo apt-get install apache2`
- Sau khi cài đặt apache cần điều chỉnh firewall để cho phép truy cập bên ngoài đến các default web port
- Truy cập đến các `ufw` application profile bằng lệnh `sudo ufw app list` ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/ufw%20list.png)
- Thấy có 3 profile của apache :
  - Apache: Profile này chỉ mở port 80( là port truy cập web bình thường không mã hóa)
  - Apache Full: profile này mở port 80 và 443(cho phép truy cập cả web bình thường lẫn web mã hóa TLS/SSL)
  - Apache secure: profile này mở port 443 (là port truy cập web có mã hóa TLS/SSL)
  - Tùy từng trường hợp chon profile thích hợp trong trường hợp này sử dụng profile `Apache Full`: `sudo ufw allow 'Apache Full'`
  - Sau khi chọn profile tiến hành kiểm tra trạng thái của apache :`sudo systemctl status apache2`
  - Sau đó ta nhập đia chỉ ip hoặc domain lên trình duyệt nếu hiện như dười là cài đặt apache đã thành công ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/apche.png)
  # Cài đặt php trên server
  - Để cài đặt php và một số gọi phụ trợ dùng lệnh:`sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql`![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/insphp.png)
  - Sau đó chèn một `index.php` vào trong file `dir.conf` trong :`sudo vim /etc/apache2/mods-enabled/dir.conf`
  - Khởi động lại apache2: `systemctl restart apache2`
  -Để kiểm tra php trên máy chủ web : Bằng cách tạo một file `info.php` trong `/var/www/html`và thêm một số dòng và lưu lại ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/insert%20php.png)
  -Để kiểm tra ta nhập địa chỉ ip của server lên trình duyệt và thêm `/info.php` vào cuối nếu thành công sẽ hiện lên hình:![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/php2.png)
  # Cài đặt MySQL trên Ubuntu server
  - MySQL là một hệ thống quản lý cơ sở dữ liệu. Về cơ bản, nó sẽ tổ chức và cung cấp quyền truy cập vào cơ sở dữ liệu nơi trang web có thể lưu trữ thông tin
  - Để cài đặt mySQL  trên ubuntu server dùng lệnh :`sudo apt-get install mysql-server`
  - Tiếp theo dùng lệnh`sudo mysql_secure_installation`.Để thiết lập mật khẩu cho tài khoản root mySQL và thay đổi một số thiết lập ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/install%20m.png)
  # Cài đặt wordpress trên ubuntu server
  - Đầu tiên để cài đặt wordpress cần khởi tạo MySQL Database và User cho wordpress
   - Đăng nhập vào mysql:`mysql -u root -p` và nhập password vừa tạo để vào trong mysql
   - Sau đó đánh dòng lệnh `CREATE DATABASE wordpress;` để khởi tạo cơ sở dữ liệu cho wordpress
   - Để tạo user cho wordpress sử dụng dòng lệnh:`GRANT ALL PRIVILEGES ON wordpress.*TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';` và thêm dòng lệnh `FLUSH PRIVILEGES` nhập `exit` để thoát![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/dtb.png)
   **Tải mã nguồn wordpress**
   - Vào đường dẫn `/var/www/`
   - Dùng lệnh `wget https://wordpress.org/latest.tar.gz` để tải xuống file `lagest.tar.gz`và giải nén file `tar -zxvf lagest.tar.gz` Và di chuyển tất cả các file giải nén vào thư mục `/var/www/html/`
   - Tiếp theo copy file ` wp-sample-config.php` vào trong một file mới có tên `wp-config.php`và chỉnh sửa file đó:![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/pessuser.png)
   - Sau đó thay đổi quyền của toàn bộ file trong thư mục `/var/www/html/`:`chown -R www-data:www-data /var/www/html/`![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/chown.png)
   - Và xóa file chỉ mục `index.html`
   -Cuối cùng trên trình duyệt nhập địa chỉ ip để chọn ngôn ngữ để cài đặt và tạo ngừời dùng và đặt mật khẩu, và đăng nhập vào Wordpress:
   ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/test.png)
   ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/test.png)
