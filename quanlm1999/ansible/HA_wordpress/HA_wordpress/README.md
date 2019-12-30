# Deploy HA Wordpress.
****

**Mô hình:** 

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/ansible/HA_wordpress/HA_wordpress/group_vars/Untitled%20Diagram.png)

#### Các file cần chạy: 
`wordpress.yml` 
Cài đặt 2 server wordpress, bao gồm:
*  LAMP( apache2, mysql, php),  wordpress cho server đầu và replica code web wordpress cho server còn lại)
*  glusterFS để làm hệ thống lưu trữ  chung  chưa code web 
*  wordpress cho server đầu và replica code web wordpress cho server còn lại

`loadbalancer.yml`
Cài đặt 2 server loadbalancer, bao gồm 
* HAproxy: Cân bằng tải cho 2 server web
* Heartbeat: health check 
* VIP chung để kết nối

`mysql.yml`
Cài đặt 2 server mysql làm db cho wordpress, được replicate với nhau 

hoặc chạy file **main.yml** để thực hiện cả 3 lệnh trên


#### Các biến cấn điều chỉnh 
File `hosts`
```
[wordpress]
192.168.122.253 web_ip=192.168.122.253 
192.168.122.17 web_ip=192.168.122.17
#IP giống với host 
# Biến này sẽ đặt cho địa chỉ IP của 2 server web

[loadbalancer]
192.168.122.253 load_ip=192.168.122.17 
192.168.122.17 load_ip=192.168.122.253
 #IP đối xứng với host 
 # Biến này sẽ đặt cho địa chỉ IP của 2 server loadbalancer
 
[database]
192.168.122.253  db_id=1 wp_mysql_host=192.168.122.253 master_address=192.168.122.17
#wp_mysql_host IP giống với host 

192.168.122.17 db_id=2 wp_mysql_host=192.168.122.17 master_address=192.168.122.253 
#master_address IP đối xứng với host 
#db_id không cần chỉnh

# Biến này sẽ đặt cho địa chỉ IP của 2 server db
```


Dir `group_vars`
*   File ` database.yml`: bao gồm thông tin về cấu hình DB 
    *   **user**: tên user để replicate database
    *   **passowrd**: password của user replicate
    *   **wp_mysql_db**: tên database của wordpress
    *   **wp_mysql_user**: tên user của db wordpress
    *  **wp_mysql_password**: password của user wordpress   

*   File `loadbalancer.yml`: bao gồm thông tin cấu hình trong HAproxy
    *   **protocol**: giao thức trong HAproxy
    *   **VIP**: Virtual_IP muốn sử dụng
    *   **backend**: backend muốn sử dụng
    *   **web1_hostname**: hostname của webserver 1
    *   **web2_hostname**: hostname của webserver 2
    *   **web1_ip**: IP của webserver 1
    *   **web2_ip**: IP của webserver 2
    * **password**: password của auth ( heartbeat)
    * **load_hostname**: hostname của loadbalancer ưu tiên có VIP
    * **interface**: interface của card mạng sử để tạo  kết nối heathcheck
    * **port**: port ứng dụng muốn sử dụng (HAproxy)

* File `wordpress.yml`Bao gồm thông tin cấu hình wordpress 
    * **wp_mysql_db**: tên database của wordpress (phải giống ở trên 
    * **wp_mysql_user**: tên user của db wordpress (phải giống ở trên 
    * **wp_mysql_password**: password của user wordpress (phải giống ở trên 
    * **wp_mysql_host**: địa chỉ IP của server  mysql  mà wordpress sử dụng 
    * **web1_hostname**: hostname của webserver 1 (dành cho glusterFS)
    * **web2_hostname**: hostname của webserver 2 (dành cho glusterFS)
    * **web1_ip**: IP của webserver 1(dành cho glusterFS)
    * **web2_ip**: IP của webserver 2(dành cho glusterFS)

