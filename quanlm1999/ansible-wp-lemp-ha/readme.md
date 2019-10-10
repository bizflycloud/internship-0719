# Mô hình HA web server


**Số lượng server** : 6
Bao gồm: 
* 2 Loadbalancer
* 2 webserver
* 2 db

**Trong đó**:
Loadbalancer đc cấu hình dùng 2 file:
* `lb_ha.yml` để cấu hình HAproxy 
* `lb_heartbeat.yml` để cấu hình heathcheck (active-passive)

Webserver được cấu hình sử dùng 3 file: 
* `web_lemp.yml` để cài đặt lemp stack và config nginx sử dụng php
* `web-nfs.yml` để cài đặt NFS server cho 1 web server còn lại là client mục đích để chia sẻ chung file code web 
* `web-wp.yml` để cài đặt wordpress
         
Database được cấu hình sử dụng  3 file:
* `db_mysql.yml` để cấu hình master-master replication và tạo datatase cho wordpress
* `db_ha.yml` để cấu hình HAproxy cho db, riderect địa chỉ ip từ VIP (192.168.122.98) vào DB
* `db_hearthbeat.yml` để cấu hình heathcheck cho db (active-passive)


**Những file cần thieét ở thư mục /tmp**
