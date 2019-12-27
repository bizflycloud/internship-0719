# Deploy HA Wordpress.
****

#### Các file cần chạy: 
`wordpress.yml`
`loadbalancer.yml`
`mysql.yml`
hoặc chạy file **main.yml**

#### Các biến cấn điều chỉnh 
`hosts`
```
[wordpress]
192.168.122.253 web_ip=192.168.122.253 
192.168.122.17 web_ip=192.168.122.17
#IP giống với host 
 
[loadbalancer]
192.168.122.253 load_ip=192.168.122.17 
192.168.122.17 load_ip=192.168.122.253
 #IP đối xứng với host 
 
[database]
192.168.122.253  db_id=1 wp_mysql_host=192.168.122.253 master_address=192.168.122.17
#wp_mysql_host IP giống với host 

192.168.122.17 db_id=2 wp_mysql_host=192.168.122.17 master_address=192.168.122.253 
#master_address IP đối xứng với host 
#db_id không cần chỉnh
```


`group_vars`
*   `database.yml`:
    *   **user**: tên user để replicate database
    *   **passowrd**: password của user replicate
    *   **wp_mysql_db**: tên database của wordpress
    *   **wp_mysql_user**: tên user của db wordpress
    *  **wp_mysql_password**: password của user wordpress   

*   `loadbalancer.yml`: 
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

* `wordpress.yml`
    * **wp_mysql_db**: tên database của wordpress (phải giống ở trên 
    * **wp_mysql_user**: tên user của db wordpress (phải giống ở trên 
    * **wp_mysql_password**: password của user wordpress (phải giống ở trên 
    * **wp_mysql_host**: địa chỉ IP của server  mysql  mà wordpress sử dụng 
    * **web1_hostname**: hostname của webserver 1 (dành cho glusterFS)
    * **web2_hostname**: hostname của webserver 2 (dành cho glusterFS)
    * **web1_ip**: IP của webserver 1(dành cho glusterFS)
    * **web2_ip**: IP của webserver 2(dành cho glusterFS)


