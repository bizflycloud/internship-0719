# Cài đặt salt-marter và salt-minion
- Để cài đặt satl-master và salt-minion dùng lệnh
 - `sudo apt-get install salt-master` trên server 1
 - `sudo apt-get install salt-minion` trên server 2
- Sau đó vào file cấu hình salt-minon `/etc/salt/minion` trên máy minion để thêm đỉa chỉ ip của máy master ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/ip.png)
- Dùng lệnh `sudo salt-key -A` để thêm các key máy minion vào trong master
- Dùng lệnh `sudo salt-key -L` để xem danh sách các máy minion đã được accest vào master ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/list.png)
- dùng lênh `sudo salt '*' test.ping` để ping tới các máy mà master quản lý ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/lb.png)
# Dùng salt để setup + config ejabberd cho một server
** Cài đặt ejabberd **
- Để cài đặt ejabber từ master vào minion dùng lệnh: `salt 'dainatq' pkg.install ejabberd`
**Cấu hình ejabberd**
- Để cấu hình ejabberd cho một server trên máy master ta tạo một file cấu hình ejabberd trong `/srv/salt/` với đuôi sls,![]( https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/os.png) cùng trong thư mục đấy tạo thêm một file `test.sls`
![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/lm.png)
- Trong đó:
 - souce: là nguồn là đường dẫn bắt đầu bằng `salt://` là file lưu trong `/srv/salt/`
 - name: là tên mà đường dẫn muốn lưu trong minion server
- Sau khi tạo fỉle trong `srv/salt` xong ta dùng lệnh `salt 'dainatq' state.apply test` để lưu và cập nhật cấu hình ejabberd sang server![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/chang%202.png)
- Tiếp theo ta dùng lệnh `salt 'dainatq' cmd.run 'ejabberd register <user> <domain> <password>` để tạo user ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/t%202.png)
- Sau khi tạo user thành công. Trên trình duyệt ta nhập tên domain của user với cú pháp:`https://<server:port>/admin` 
- Trong đó server là các domain 
- port là số cổng (thường là 5280)![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/nt.png)
- Tại đây có thể chỉnh sửa các hạn chế truy cập và quản lý ngừời dùng  hoặc có thể tạo thêm các user
- sau khi tạo user xong có thể test xem 2 user đó có kết nối đc với nhau hay không bằng xmpp client.sử dụng Pidgin để test 
 cấu hình 2 user và gửi một tin xem 2 máy có gửi đến cho nhau và đây là kết quá 
 ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/tip.png)
 ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/mes.png)
 ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/m.png)
