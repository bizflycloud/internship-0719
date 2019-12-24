# LAPM
***
#### SALT
File:
*  Cài đặt LAMP: https://gist.github.com/lmq1999/4a37b2c64266a76457ef8a9508c23547
*  Apache cho wordpress: https://gist.github.com/lmq1999/c415aef7e12d9710ee219b85056e3668
*  wordpress.conf https://gist.github.com/lmq1999/bca7d7d6b8d22b5c0652c6efc3a5e00d
*  config wordpress: https://gist.github.com/lmq1999/9229d99b72301c8ea7ec1a2ba2934f45
*  file config: https://gist.github.com/lmq1999/35c0d1d9054bcc625aa6a00815d20b65

**B1** Cài đặt LAMP:
*   Sử dụng câu lệnh: `sudo salt '*' state.apply  wp_LAMP `
![LAM](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/wp_LAMP.png)

**B2** Tạo trang Apache cho wordpress:
* Sử dụng câu lệnh : `sudo salt '*' state.apply wp_apache `
* Sau khi xong dùng 2 câu lệnh: `sudo salt '*' cmd.run 'a2ensite wordpress'` và `sudo salt '*' cmd.run 'service apache2 reload'`

![a4w](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/a4w.png)

**B3** Tạo database Mysql
* Sử dụng module: `salt.modules.mysql`, yêu cầu thêm dòng sau vào file `/etc/salt/minion `: 
    * `mysql.default_file: '/etc/mysql/debian.cnf'`

* Tạo db:  `sudo salt '*' mysql.db_create 'test'`
* Tạo user:  `sudo salt '*' mysql.user_create 'quan' 'localhost' '123456'`
* Add grants: `sudo salt '*' mysql.grant_add 'SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER' 'test.*' 'quan' 'localhost'`

* Kiểm tra lại: 
![check](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/mysql_check.png)

**B4** Config WP
* Sử dụng câu lệnh: `sudo salt '*' state.apply wp_config.sls


**B5** Dùng trình duyệt web lên trang {server-ip}/blog/
Ta có
![wp](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/wp.png)

Điền nốt những thông tin còn lại để cài đặt : 
![wp_f](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/wp_final.png)
