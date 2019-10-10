# Mô hình HA web server


**Số lượng server** : 6
Bao gồm: 
* 2 Loadbalancer
* 2 webserver
* 2 db
db1: 192.168.122.187
db2: 192.168.122.171
web1: 192.168.122.209
web2: 192.168.122.36
load1: 192.168.122.79
load2: 192.168.122.30
VIPload: 192.168.122.99
VIPdb:192.168.122.98

**Trong đó**:
Loadbalancer đc cấu hình dùng 2 file:
* `lb_ha.yml` để cấu hình HAproxy 
* `lb_heartbeat.yml` để cấu hình heathcheck (active-passive)

Webserver được cấu hình sử dùng 3 file: 
* `web_lemp.yml` để cài đặt lemp stack và config nginx sử dụng php và mysql-client
* `web-nfs.yml` để cài đặt NFS server cho 1 web server còn lại là client mục đích để chia sẻ chung file code web 
* `web-wp.yml` để cài đặt wordpress
         
Database được cấu hình sử dụng  3 file:
* `db_mysql.yml` để cấu hình master-master replication và tạo datatase cho wordpress
* `db_ha.yml` để cấu hình HAproxy cho db, riderect địa chỉ ip từ VIP (192.168.122.98) vào DB
* `db_hearthbeat.yml` để cấu hình heathcheck cho db (active-passive)


**Những file cần thieét ở thư mục /tmp**
