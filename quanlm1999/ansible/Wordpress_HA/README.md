# Deploy HA Wordpress.
****

**Mô hình:** 

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/ansible/Wordpress_HA/group_vars/Untitled%20Diagram(2).png)

#### Các file cần chạy: 
**wordpress.yml** `ansible-playbook wordpress.yml -i hosts -u root` (server ảnh hưởng: web-1 web-2)

Cài đặt 2 server wordpress, bao gồm:
*  LAMP( apache2, mysql, php)
*  glusterFS để làm hệ thống lưu trữ  chung  chưa code web 
*  wordpress cho server web-1 và replica code web wordpress cho server web-2

**loadbalancer.yml** `ansible-playbook loadbalancer.yml -i hosts -u root` (server ảnh hưởng: load-1 load-2)

Cài đặt 2 server loadbalancer, bao gồm 
* HAproxy: Cân bằng tải cho 2 server web
* Heartbeat: health check cho 2 server load-1 load-2
* Virtual IP

**mysql.yml** `ansible-playbook mysql.yml -i hosts -u root` (server ảnh hưởng: db-1 db-2)

Cài đặt 2 server mysql làm db cho wordpress, được replicate với nhau theo Master-Master

hoặc chạy file **main.yml** `ansible-playbook main.yml -i hosts -u root` để thực hiện cả 3 lệnh trên


#### Các biến cấn điều chỉnh 
File `hosts`
```
[wordpress]
web-1 ansible_host=192.168.122.253 web_ip=192.168.122.253 
web-2 ansible_host=192.168.122.17 web_ip=192.168.122.17

#IP giống với host 
# Biến này sẽ đặt cho địa chỉ IP của 2 server web

[loadbalancer]
load-1 ansible_host=192.168.122.253 load_ip=192.168.122.17 
load-2 ansible_host=192.168.122.17 load_ip=192.168.122.253

 #IP đối xứng với host 
 # Biến này sẽ đặt cho địa chỉ IP của 2 server loadbalancer
 
[database]
db-1 ansible_host=192.168.122.253  db_id=1 wp_mysql_host=192.168.122.253 master_address=192.168.122.17 

db-2 ansible_host=192.168.122.17 db_id=2 wp_mysql_host=192.168.122.17 master_address=192.168.122.253 

#master_address IP đối xứng với host 
#db_id không cần chỉnh
#wp_mysql_host IP giống với host 
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

