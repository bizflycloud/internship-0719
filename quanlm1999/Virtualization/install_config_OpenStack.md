#   Cài đặt và tạo máy ảo sử dụng Openstack  Stein trên Ubuntu 18.04 
#   Mô hình
*   Mô hình cài đặt Openstack-Stein này dùng tối thiểu 2 node

  | Name 	| Provider network 	| Management network  	|   	 	
|---	|---	|---	|
|   Controller	|   192.168.122.206	|   10.0.0.73	|   	
|   Compute1	|  192.168.122.144 	|  10.0.0.68 	|   	
 

#   Cài đặt môi trường

## Cài đặt cho node controller

#### Cập nhật gói phần mềm: 
* `apt update -y && apt upgrade -y`

#### Cấu hình hostname: 
*   `hostnamectl set-hostname controller`

#### Cài đặt repos để cài OpenStack
*   Cài đặt repos
`
    add-apt-repository cloud-archive:stein -y
`

*   Cài đặt gói client của Openstack
    `apt install python3-openstackclient`

#### Cài đặt SQL database
*   Cài đặt MariaDB
    `apt install mariadb-server python-pymysql`

*   Tạo và cấu hình file `/etc/mysql/mariadb.conf.d/99-openstack.cnf` 
    *   Nội dung
        ```
        [mysqld]
        bind-address = 10.0.0.73
        
        default-storage-engine = innodb
        innodb_file_per_table = on
        max_connections = 4096
        collation-server = utf8_general_ci
        character-set-server = utf8
        ```

*   Khởi động lại MariaDB
    `service mysql restart`

####    Cài đặt Message queue (RabbitMQ)
- Cài đặt gói
`
  apt install rabbitmq-server -y
`
-  Cấu hình RabbitMQ, tạo user `openstack` với mật khẩu là ` RABBIT_PASS`
`
      rabbitmqctl add_user openstack RABBIT_PASS
`
- Gán quyền cho tài khoản openstack trong RabbitMQ
`
  rabbitmqctl set_permissions openstack ".*" ".*" ".*"
`
  
 #### Cài đặt Memcached
*   Cài đặt các gói cần thiết cho memcached
      `apt install memcached python-memcache -y`
- Dùng vi sửa file `/etc/memcached.conf`, thay dòng `-l 127.0.0.1` bằng dòng dưới.
`
  -l 10.0.0.73
`
- Khởi động lại memcache.
`
  service memcached restart
`
  
#### Cài đặt Etcd
* Cài đặt gói
  `
  apt install etcd
  `

*   Cấu hình file `/etc/default/etcd `
    ```
    ETCD_NAME="controller"
    ETCD_DATA_DIR="/var/lib/etcd"
    ETCD_INITIAL_CLUSTER_STATE="new"
    ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster-01"
    ETCD_INITIAL_CLUSTER="controller=http://10.0.0.73:2380"
    ETCD_INITIAL_ADVERTISE_PEER_URLS="http://10.0.0.73:2380"
    ETCD_ADVERTISE_CLIENT_URLS="http://10.0.0.73:2379"
    ETCD_LISTEN_PEER_URLS="http://0.0.0.0:2380"
    ETCD_LISTEN_CLIENT_URLS="http://10.0.0.73:2379"
    ```
    
*   Kích hoạt và khởi động lại dịch vụ
    ```
    systemctl enable etcd
    systemctl restart etcd
    ```

## Cài đặt cho node compute1

#### Cập nhật các gói phần mềm
  * `
  apt-get update
  `

#### Cài đặt repos để cài OpenStack
*   Cài đặt repos
`
    add-apt-repository cloud-archive:stein -y
`

*   Cài đặt gói client của Openstack
    `apt install python3-openstackclient`

#   Cài đặt dịch vụ Openstack

## Dịch vụ Identity (Keystone) 
*   Cài trên node **controller**

####    Tạo DB cho keystone

*   Truy cập vào MariaDB: `mysql`
*   Tạo DB cho keystone: 
    ```
    MariaDB [(none)]> CREATE DATABASE keystone;
    Query OK, 1 row affected (0.00 sec)
    ```
*   Cấp quyền truy cập vào keystone DB:
    ```
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' \
    -> IDENTIFIED BY 'KEYSTONE_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' \
        -> IDENTIFIED BY 'KEYSTONE_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    ```

####    Cài đặt và cấu hình keystone

*   Cài đặt gói: `apt install keystone`
*   Cấu hình file `/etc/keystone/keystone.conf`
    *   Trong `[database]`
        *   Comment dòng: `connection = sqlite:////var/lib/keystone/keystone.db`
        *   Thêm dòng: `connection = mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone`
    *   Trong `[token]`
        *   Bỏ comment dòng: `provider = fernet`
*   Đồng bộ DB cho keystone `su -s /bin/sh -c "keystone-manage db_sync" keystone`
*   Thiết lập Fernet key:
    ```
    keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
    keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
    ```
*   Bootstrap the Identity service:
    ```
     keystone-manage bootstrap --bootstrap-password ADMIN_PASS \
      --bootstrap-admin-url http://controller:5000/v3/ \
      --bootstrap-internal-url http://controller:5000/v3/ \
      --bootstrap-public-url http://controller:5000/v3/ \
      --bootstrap-region-id RegionOne
    ```
####   Cấu hình Apache HTTP Server 

*   File: `/etc/apache2/apache2.conf` 
    *   Cấu hình ServerName: `ServerName controller`
    
####   Kết thúc cài đặt
*   Restart Apache `service apache2 restart`
*   Cấu hình cho tài khoản quản trị:
    ```
    export OS_USERNAME=admin
    export OS_PASSWORD=ADMIN_PASS
    export OS_PROJECT_NAME=admin
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_AUTH_URL=http://controller:5000/v3
    export OS_IDENTITY_API_VERSION=3
    ```
#### Tạo domain, projects, users, và roles
*   Tạo domain "example"
    `openstack domain create --description "An Example Domain" example`
    ```
    +-------------+----------------------------------+
    | Field       | Value                            |
    +-------------+----------------------------------+
    | description | An Example Domain                |
    | enabled     | True                             |
    | id          | 519b225c218b424b997e744c7c42327a |
    | name        | example                          |
    | tags        | []                               |
    +-------------+----------------------------------+
    ```
*   Tạo project serive:
    `openstack project create --domain default \
  --description "Service Project" service`
    ```
    +-------------+----------------------------------+
    | Field       | Value                            |
    +-------------+----------------------------------+
    | description | Service Project                  |
    | domain_id   | default                          |
    | enabled     | True                             |
    | id          | 6c57c69a38a44e32b76accdedad8a583 |
    | is_domain   | False                            |
    | name        | service                          |
    | parent_id   | default                          |
    | tags        | []                               |
    +-------------+----------------------------------+
    ```
*   Tạo project demo
    `openstack project create --domain default \
  --description "Demo Project" myproject`
    ```
    +-------------+----------------------------------+
    | Field       | Value                            |
    +-------------+----------------------------------+
    | description | Demo Project                     |
    | domain_id   | default                          |
    | enabled     | True                             |
    | id          | b8f0691595f2488ebdfeb3252486b27c |
    | is_domain   | False                            |
    | name        | myproject                        |
    | parent_id   | default                          |
    | tags        | []                               |
    +-------------+----------------------------------+
    ```
*   Tạo user demo
    `openstack user create --domain default \
  --password-prompt myuser`
    ```
    User Password:
    Repeat User Password:
    +---------------------+----------------------------------+
    | Field               | Value                            |
    +---------------------+----------------------------------+
    | domain_id           | default                          |
    | enabled             | True                             |
    | id                  | 62ea51b811304609ac42e51a2698c25f |
    | name                | myuser                           |
    | options             | {}                               |
    | password_expires_at | None                             |
    +---------------------+----------------------------------+
    ```
    `
*  Tạo role demo
    `openstack role create myrole`
    ```
    +-------------+----------------------------------+
    | Field       | Value                            |
    +-------------+----------------------------------+
    | description | None                             |
    | domain_id   | None                             |
    | id          | bd9ee546cd5e4062863fa27e94fe6063 |
    | name        | myrole                           |
    +-------------+----------------------------------+
    ```
*   Thêm role user cho user demo trên project demo:
      `openstack role add --project myproject --user myuser myrole`

#### Kiểm chứng lại các bước cài đặt keystone
*   Bỏ thiết lập trong biến môi trường của OS_AUTH_URL và OS_PASSWORD bằng lệnh:
    `unset OS_AUTH_URL OS_PASSWORD` 
*   Kiểm tra mã thông báo xác thức:
`openstack --os-auth-url http://controller:5000/v3    --os-project-domain-name Default --os-user-domain-name Default    --os-project-name admin --os-username admin token issue` Password là password ADMIN ở trên

```
Password: 

+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2020-02-18T08:21:24+0000                                                                                                                                                                |
| id         | gAAAAABeS5B0rpepHn396gk0liJq8UNrNj7Riq46Ibfvphyfb1OdaFmFF4Q8O3XYMGD0-1G_Nydykp5td9dLo2W0b6SpQfnrwcBM-LiB56w_ilemQjcQTWNUoRA_AWOmCGk0WRFhNPV5WVBl-UTaLEB9yCkEWKsZJFx5c0OMx6nQJIid47yvrag |
| project_id | 67febc37693344b29481aa41325bc68b                                                                                                                                                        |
| user_id    | 30086afd36e0419397b11c636674666a                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

*   Tiếp tục kiểm tra 
`openstack --os-auth-url http://controller:5000/v3 --os-project-domain-name Default --os-user-domain-name Default --os-project-name myproject --os-username myuser token issue` Password là password userdemo vừa tạo

```
Password: 
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field      | Value                                                                                                                                                                                   |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| expires    | 2020-02-18T08:24:16+0000                                                                                                                                                                |
| id         | gAAAAABeS5EgGQ9OZ7HD1D0UeX-CtUAzhsc5m1mNrfowHD194p1oHCwTrpYju7JTMCJqxyhfVnuQecDjLCCnaqlcmCaiPj4c6YLpUwD0fVcXK8mHn-xkbgQtg_iKmgyYsSej4nE5kh_tAS_iZwXegus-oQDOsoMWQQlHYJh0TIoLen0rlsGINnc |
| project_id | b8f0691595f2488ebdfeb3252486b27c                                                                                                                                                        |
| user_id    | 62ea51b811304609ac42e51a2698c25f                                                                                                                                                        |
+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```
#### Tạo script biến môi trường cho client
*   Tạo file `admin-openrc` với nội dung sau: 
    ```
    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_NAME=admin
    export OS_USERNAME=admin
    export OS_PASSWORD=ADMIN_PASS
    export OS_AUTH_URL=http://controller:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2
    ```
    
*   Tạo file `demo-openrc` với nội dung sau:
    ```
    export OS_PROJECT_DOMAIN_NAME=Default
    export OS_USER_DOMAIN_NAME=Default
    export OS_PROJECT_NAME=myproject
    export OS_USERNAME=myuser
    export OS_PASSWORD=MYUSER_PASS
    export OS_AUTH_URL=http://controller:5000/v3
    export OS_IDENTITY_API_VERSION=3
    export OS_IMAGE_API_VERSION=2
    ```

*   Chạy scripts: 
    `. admin-openrc `
*   Yêu cầu thông báo xác thực `openstack token issue`
    ```
        +------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | Field      | Value                                                                                                                                                                                   |
    +------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | expires    | 2020-02-18T08:28:55+0000                                                                                                                                                                |
    | id         | gAAAAABeS5I39WZ3a3w5nBDjNUZvUFcBxdT1HW36VEHdckQzyW0Ql-miPzKkVkW6K0dEzkMP5sVJpEMpf-0Hypy60wiNcKxJ9VwfLqtBy24pp6bh7cK0gjmdzIILvz7ctSjo64wQy8e4zOKyWZIUdRVomadyqX1scSbPRANZENFqNGLA9GeZK7I |
    | project_id | 67febc37693344b29481aa41325bc68b                                                                                                                                                        |
    | user_id    | 30086afd36e0419397b11c636674666a                                                                                                                                                        |
    +------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    ```

## Cài dịch vụ Image (Glance)
*   Cài trên node **controller**
    
#### Tạo database cho glance
*   Truy cập vào MariaDB: `mysql`
*   Tạo DB cho glance:
    ```
    MariaDB [(none)]> CREATE DATABASE glance;
    Query OK, 1 row affected (0.00 sec)
    ```
*   Cấp quyền truy cập cho glance:
    ```
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' \
        ->   IDENTIFIED BY 'GLANCE_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' \
        ->   IDENTIFIED BY 'GLANCE_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    ```

*   Chạy scripts `. admin-openrc` 
####   Tạo thông tin đăng nhập cho service
*   Tạo user glance:
`openstack user create --domain default --password-prompt glance`
    ```
    User Password:
    Repeat User Password:
    +---------------------+----------------------------------+
    | Field               | Value                            |
    +---------------------+----------------------------------+
    | domain_id           | default                          |
    | enabled             | True                             |
    | id                  | 3f4e777c4062483ab8d9edd7dff829df |
    | name                | glance                           |
    | options             | {}                               |
    | password_expires_at | None                             |
    +---------------------+----------------------------------+
    ```
*   Thêm role admin cho user glance trên project service
`openstack role add --project service --user glance admin`

*   Tạo dịch vụ glance
`openstack service create --name glance --description "OpenStack Image" image`
    ```
    +-------------+----------------------------------+
    | Field       | Value                            |
    +-------------+----------------------------------+
    | description | OpenStack Image                  |
    | enabled     | True                             |
    | id          | 5f55cd9876b244f68c3700616c32df6d |
    | name        | glance                           |
    | type        | image                            |
    +-------------+----------------------------------+
    ```
*   Tạo các API endpoint cho dịch vụ glance:
    `openstack endpoint create --region RegionOne image public http://controller:9292`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | 7081b8f837244270b7aa9fe4ef6312bf |
    | interface    | public                           |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | 5f55cd9876b244f68c3700616c32df6d |
    | service_name | glance                           |
    | service_type | image                            |
    | url          | http://controller:9292           |
    +--------------+----------------------------------+
    ```
    `openstack endpoint create --region RegionOne image internal http://controller:9292`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | 9173d8fe7dfe43b6a94a3e700f19db27 |
    | interface    | internal                         |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | 5f55cd9876b244f68c3700616c32df6d |
    | service_name | glance                           |
    | service_type | image                            |
    | url          | http://controller:9292           |
    +--------------+----------------------------------+
    ```
    ` openstack endpoint create --region RegionOne image admin http://controller:9292`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | 13413bd85b594ca29164bf9fb3cf4dcb |
    | interface    | admin                            |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | 5f55cd9876b244f68c3700616c32df6d |
    | service_name | glance                           |
    | service_type | image                            |
    | url          | http://controller:9292           |
    +--------------+----------------------------------+
    ```

#### Cài đặt và cấu hình cho dịch vụ glance
*   Cài đặt gói glance
    `apt install glance -y`
*   Cấu hình file: ` /etc/glance/glance-api.conf` và `/etc/glance/glance-registry.conf`
    * Trong `[database]`
    Comment dòng `sqlite_db = /var/lib/glance/glance.sqlite`
    Thêm dòng: `connection = mysql+pymysql://glance:GLANCE_DBPASS@controller/glance`
    *   Trong `[keystone_authtoken]`
    Thêm vào: 
        ```
        www_authenticate_uri = http://controller:5000
        auth_url = http://controller:5000
        memcached_servers = controller:11211
        auth_type = password
        project_domain_name = Default
        user_domain_name = Default
        project_name = service
        username = glance
        password = GLANCE_PASS
        ```
    *   Trong `[paste_deploy]`
    Thêm vào:  
        `flavor = keystone`
    *   Trong `[glance_store]` , cấu hình lưu trữ file trên hệ thống (local file system store) và vị trí của file image .  không phải làm trong file /etc/glance/glance-registry.conf):
    Thêm vào: 
        ```
        stores = file,http
        default_store = file
        filesystem_store_datadir = /var/lib/glance/images/
        ```
*   Đồng bộ database cho glance
`su -s /bin/sh -c "glance-manage db_sync" glance`

*   Restart dịch vụ Glance.
    ```
    service glance-registry restart
    service glance-api restart
    ```

#### Kiểm chứng lại việc cài đặt glance
*   Chạy script `. admin-openrc`
*   Tải file image: 
`wget http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img`
*   Upload file image vừa tải:
`openstack image create "cirros" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public`
    ```
        +------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        | Field            | Value                                                                                                                                                                                      |
        +------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        | checksum         | 443b7623e27ecf03dc9e01ee93f67afe                                                                                                                                                           |
        | container_format | bare                                                                                                                                                                                       |
        | created_at       | 2020-02-18T07:52:10Z                                                                                                                                                                       |
        | disk_format      | qcow2                                                                                                                                                                                      |
        | file             | /v2/images/f41b9438-bb2d-4815-b25d-f695b830b5cf/file                                                                                                                                       |
        | id               | f41b9438-bb2d-4815-b25d-f695b830b5cf                                                                                                                                                       |
        | min_disk         | 0                                                                                                                                                                                          |
        | min_ram          | 0                                                                                                                                                                                          |
        | name             | cirros                                                                                                                                                                                     |
        | owner            | 67febc37693344b29481aa41325bc68b                                                                                                                                                           |
        | properties       | os_hash_algo='sha512', os_hash_value='6513f21e44aa3da349f248188a44bc304a3653a04122d8fb4535423c8e1d14cd6a153f735bb0982e2161b5b5186106570c17a9e58b64dd39390617cd5a350f78', os_hidden='False' |
        | protected        | False                                                                                                                                                                                      |
        | schema           | /v2/schemas/image                                                                                                                                                                          |
        | size             | 12716032                                                                                                                                                                                   |
        | status           | active                                                                                                                                                                                     |
        | tags             |                                                                                                                                                                                            |
        | updated_at       | 2020-02-18T07:52:10Z                                                                                                                                                                       |
        | virtual_size     | None                                                                                                                                                                                       |
        | visibility       | public                                                                                                                                                                                     |
        +------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    ```

*   Xác nhận lại việc upload `openstack image list`
    ```
    +--------------------------------------+--------+--------+
    | ID                                   | Name   | Status |
    +--------------------------------------+--------+--------+
    | f41b9438-bb2d-4815-b25d-f695b830b5cf | cirros | active |
    +--------------------------------------+--------+--------+
    ```

## Cài đặt dịch vụ Placement

*   Cài đặt trên ndoe **controller**

*   Tạo DB cho placement:
    ```
    MariaDB [(none)]> CREATE DATABASE placement;
    Query OK, 1 row affected (0.00 sec)
    ```
*   Cấp quyền truy cập cho placement

    ```
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'localhost' \
        ->   IDENTIFIED BY 'PLACEMENT_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON placement.* TO 'placement'@'%' \
        ->   IDENTIFIED BY 'PLACEMENT_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    ```
*   Chạy scripts ` . admin-openrc`

#### Tạo thông tin đăng nhập cho service:
*   Tạo user placement
    ` openstack user create --domain default --password-prompt placement`
    ```
    User Password:
    Repeat User Password:
    +---------------------+----------------------------------+
    | Field               | Value                            |
    +---------------------+----------------------------------+
    | domain_id           | default                          |
    | enabled             | True                             |
    | id                  | fc946519434a4415866bc281389f8b38 |
    | name                | placement                        |
    | options             | {}                               |
    | password_expires_at | None                             |
    +---------------------+----------------------------------+
    ```
*   Thêm role admin cho user placement trên project service
    `openstack role add --project service --user placement admin`
*   Tạo serivce Placement: 
    `openstack service create --name placement --description "Placement API" placement`
    ```
    +-------------+----------------------------------+
    | Field       | Value                            |
    +-------------+----------------------------------+
    | description | Placement API                    |
    | enabled     | True                             |
    | id          | ea21c40499724bbe8549baaaf02bd3ce |
    | name        | placement                        |
    | type        | placement                        |
    +-------------+----------------------------------+
    ```
*   Tạo các API endpoint cho dịch vụ placement:
    `openstack endpoint create --region RegionOne placement public http://controller:8778`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | fe16ade6e8c4438e9e57745ff6f5c627 |
    | interface    | public                           |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | ea21c40499724bbe8549baaaf02bd3ce |
    | service_name | placement                        |
    | service_type | placement                        |
    | url          | http://controller:8778           |
    +--------------+----------------------------------+
    ```
    `openstack endpoint create --region RegionOne placement internal http://controller:8778`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | 05ad3211214f4c4ca231660b736ef2ce |
    | interface    | internal                         |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | ea21c40499724bbe8549baaaf02bd3ce |
    | service_name | placement                        |
    | service_type | placement                        |
    | url          | http://controller:8778           |
    +--------------+----------------------------------+
    ```
    `openstack endpoint create --region RegionOne placement admin http://controller:8778`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | 5398087d23394e1da083aac41c30eefa |
    | interface    | admin                            |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | ea21c40499724bbe8549baaaf02bd3ce |
    | service_name | placement                        |
    | service_type | placement                        |
    | url          | http://controller:8778           |
    +--------------+----------------------------------+
    ```

####  Cài đặt và cấu hình placement
*   Cài đặt gói: `apt install placement-api`
*   Cấu hình file: `/etc/placement/placement.conf`
    * Trong `[placement_database]`
    Comment dòng: `#connection = sqlite:////var/lib/placement/placement.sqlite`
    Thêm dòng: `connection = mysql+pymysql://placement:PLACEMENT_DBPASS@controller/placement`
    *   Trong `[api]`
    Thêm dòng: `auth_strategy = keystone`
    *   Trong `[keystone_authtoken]`
    Thêm dòng: 
        ```
        auth_url = http://controller:5000/v3
        memcached_servers = controller:11211
        auth_type = password
        project_domain_name = Default
        user_domain_name = Default
        project_name = service
        username = placement
        password = PLACEMENT_PASS
        ```
*    Import database 
    `su -s /bin/sh -c "placement-manage db sync" placement`

#### Restart apache
    `service apache restart`
    
#### Kiểm chứng việc cài đặt placement
*   Chạy scripts: `. admin-openrc`
*   Thực hiển kiểm tra trạng thái đảm bảo mọi thứ vẫn hoạt động đúng: 
    `placement-status upgrade check`
    ```
    +----------------------------------+
    | Upgrade Check Results            |
    +----------------------------------+
    | Check: Missing Root Provider IDs |
    | Result: Success                  |
    | Details: None                    |
    +----------------------------------+
    | Check: Incomplete Consumers      |
    | Result: Success                  |
    | Details: None                    |
    +----------------------------------+
    ```
    
## Cài dịch vụ Compute (Nova)
* cài trên cả node `controller` và `compute1`
### Cài trên node **Controller**
#### Tạo database cho nova
*   Truy cập vào MariaDB: `mysql`
* Tạo database nova_api, nova, và nova_cell0:
    ```
    MariaDB [(none)]>  CREATE DATABASE nova_api;
    Query OK, 1 row affected (0.00 sec)
    
    MariaDB [(none)]> CREATE DATABASE nova;
    Query OK, 1 row affected (0.00 sec)
    
    MariaDB [(none)]>  CREATE DATABASE nova_cell0;
    Query OK, 1 row affected (0.00 sec)
    ```
*   Cấp quyền truy cập database:
    ```
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
    ->   IDENTIFIED BY 'NOVA_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
        ->   IDENTIFIED BY 'NOVA_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
        ->   IDENTIFIED BY 'NOVA_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
        ->   IDENTIFIED BY 'NOVA_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
        ->   IDENTIFIED BY 'NOVA_DBPASS';
    Query OK, 0 rows affected (0.01 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
        ->   IDENTIFIED BY 'NOVA_DBPASS';
    Query OK, 0 rows affected (0.01 sec)
    ```
*   Chạy scripts: `. admin-openrc`
####   Tạo thông tin đăng nhập cho compute service
*   Tạo user nova: 
    `openstack user create --domain default --password-prompt nova`
    ```
    User Password:
    Repeat User Password:
    +---------------------+----------------------------------+
    | Field               | Value                            |
    +---------------------+----------------------------------+
    | domain_id           | default                          |
    | enabled             | True                             |
    | id                  | ef6e4bf972d74cd79f2dd5d28cf39972 |
    | name                | nova                             |
    | options             | {}                               |
    | password_expires_at | None                             |
    +---------------------+----------------------------------+
    ```

*   Thêm role admin cho user nova trên project service:
    `openstack role add --project service --user nova admin`
*   Tạo dịch vụ nova:
    `openstack service create --name nova --description "OpenStack Compute" compute`
    ```
    +-------------+----------------------------------+
    | Field       | Value                            |
    +-------------+----------------------------------+
    | description | OpenStack Compute                |
    | enabled     | True                             |
    | id          | a72d6c859589467292947ccfc9c81520 |
    | name        | nova                             |
    | type        | compute                          |
    +-------------+----------------------------------+
    ```

*   Tạo các API endpoint cho dịch vụ compute
`openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | f7a81c39072f4b159b50963462bea0ea |
    | interface    | public                           |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | a72d6c859589467292947ccfc9c81520 |
    | service_name | nova                             |
    | service_type | compute                          |
    | url          | http://controller:8774/v2.1      |
    +--------------+----------------------------------+
    ```
    `openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | 1c77cb897a8a4dce904d35e353ada4e9 |
    | interface    | internal                         |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | a72d6c859589467292947ccfc9c81520 |
    | service_name | nova                             |
    | service_type | compute                          |
    | url          | http://controller:8774/v2.1      |
    +--------------+----------------------------------+
    ```
    `openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | 3e106d75e0184b5f8844dff7acd3bac6 |
    | interface    | admin                            |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | a72d6c859589467292947ccfc9c81520 |
    | service_name | nova                             |
    | service_type | compute                          |
    | url          | http://controller:8774/v2.1      |
    +--------------+----------------------------------+
    ```
####  Cài đặt và cấu hình Nova
*   Cài đặt gói: 
    `apt install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler`
*   Cấu hình file: `/etc/nova/nova.conf`
    *   Trong `[api_database]`
    Comment: `#connection = sqlite:////var/lib/nova/nova_api.sqlite`
    Thêm dòng: `connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova_api`
    *   Trong `[database]`
    Comment: `#connection = sqlite:////var/lib/nova/nova.sqlite`
    Thêm dòng: `connection = mysql+pymysql://nova:NOVA_DBPASS@controller/nova`
    *   Trong `[DEFAULT]`
    Thêm dòng: 
        ```
        use_neutron = True
        firewall_driver = nova.virt.firewall.NoopFirewallDriver
        my_ip = 10.10.10.73
        transport_url = rabbit://openstack:Welcome123@controller
        ```
    *   Trong [vnc]:
    Thêm dòng
        ```
        enabled = true
        # ...
        vncserver_listen = $my_ip
        vncserver_proxyclient_address = $my_ip
         ```
    *   Trong [glance]
    Thêm dòng :`api_servers = http://controller:9292`
    *   Trong [oslo_concurrency]
    Thêm dòng: `lock_path = /var/lib/nova/tmp`
    *   Trong [placement]
    Thêm dòng: 
        ```
        region_name = RegionOne
        project_domain_name = Default
        project_name = service
        auth_type = password
        user_domain_name = Default
        auth_url = http://controller:5000/v3
        username = placement
        password = PLACEMENT_PASS
        ```
 #### Import database cho nova
 *  Populate the nova-api database: `su -s /bin/sh -c "nova-manage api_db sync" nova`
 *  Register the cell0 database: `su -s /bin/sh -c "nova-manage cell_v2 map_cell0" nova`
 *  Create the cell1 cell: `su -s /bin/sh -c "nova-manage cell_v2 create_cell --name=cell1 --verbose" nova`      1643b2dd-ed63-4364-bd11-9eb4560b2363
 *  Populate the nova database: `su -s /bin/sh -c "nova-manage db sync" nova`
 *  Kiểm tra cell0 và cell1 đã đăng kí đúng chưa: 
    ```
    +-------+--------------------------------------+------------------------------------+-------------------------------------------------+----------+
    |  Name |                 UUID                 |           Transport URL            |               Database Connection               | Disabled |
    +-------+--------------------------------------+------------------------------------+-------------------------------------------------+----------+
    | cell0 | 00000000-0000-0000-0000-000000000000 |               none:/               | mysql+pymysql://nova:****@controller/nova_cell0 |  False   |
    | cell1 | 1643b2dd-ed63-4364-bd11-9eb4560b2363 | rabbit://openstack:****@controller |    mysql+pymysql://nova:****@controller/nova    |  False   |
    +-------+--------------------------------------+------------------------------------+-------------------------------------------------+----------+
    ```
####  Kết thúc bước cài đặt 
*   Restart lại các dịch vụ: 
    ```
    service nova-api restart
    service nova-consoleauth restart
    service nova-scheduler restart
    service nova-conductor restart
    service nova-novncproxy restart 
    ```

# Tới đây, đã cài đặt xong nova trên controller node, tiếp tục cài đặt trên node compute1

### Cài trên node **Compute1**
*   Cài gói: `apt install nova-compute`
*   Cấu hình file: `/etc/nova/nova.conf`
    *   Trong `[DEFAULT]`
    Thêm dòng: 
        ```
        transport_url = rabbit://openstack:RABBIT_PASS@controller
        my_ip = 10.0.0.68
        use_neutron = True
        firewall_driver = nova.virt.firewall.NoopFirewallDriver
        ```
    *   Trong `[keystone_authtoken]`
    Thêm dòng:
        ```
        auth_url = http://controller:5000/v3
        memcached_servers = controller:11211
        auth_type = password
        project_domain_name = Default
        user_domain_name = Default
        project_name = service
        username = nova
        password = NOVA_PASS
        ```
    *   Trong `[api]`
    Thêm dòng: `auth_strategy = keystone`
    *   Trong `[vnc]`
    Thêm dòng: 
        ```
         enabled = true
        server_listen = 0.0.0.0
        server_proxyclient_address = $my_ip
        novncproxy_base_url = http://controller:6080/vnc_auto.html
        ```
    *   Trong `[glance]`
    Thêm dòng: `api_servers = http://controller:9292`
    *   Trong `[oslo_concurrency]`
    Thêm dòng: `lock_path = /var/lib/nova/tmp`
    *   Trong `[placement]`
    Thêm dòng: 
        ```
        region_name = RegionOne
        project_domain_name = Default
        project_name = service
        auth_type = password
        user_domain_name = Default
        auth_url = http://controller:5000/v3
        username = placement
        password = PLACEMENT_PASS
        ```
#### Kết thúc bước cài đặt
*   Xác định xem compute1 node có hỗ trợ tăng tóc phần cứng ảo hóa hay không ( nếu > 1 là có)
    `egrep -c '(vmx|svm)' /proc/cpuinfo`
    4
Vậy là có, nếu như không thì cấu hình file `/etc/nova/nova-compute.conf` chuyển  `virt_type = kvm` thành `virt_type = qemu`

*   Restart the Compute service: `service nova-compute restart`
### Bước tiếp theo sẽ tiến hành trên node **Controller**
#### Thêm compute node vào trong database cell 
*   Chạy scripts:  . admin-openrc
*   Xác nhận xem có compute host trong database: `openstack compute service list --service nova-compute`
    ```
    +----+--------------+----------+------+---------+-------+----------------------------+
    | ID | Binary       | Host     | Zone | Status  | State | Updated At                 |
    +----+--------------+----------+------+---------+-------+----------------------------+
    |  7 | nova-compute | compute1 | nova | enabled | up    | 2020-02-18T09:04:51.000000 |
    +----+--------------+----------+------+---------+-------+----------------------------+
    ```
*   Discover compute hosts:
    `su -s /bin/sh -c "nova-manage cell_v2 discover_hosts --verbose" nova`
    ```
    Skipping cell0 since it does not contain hosts.
    Getting computes from cell 'cell1': 1643b2dd-ed63-4364-bd11-9eb4560b2363
    Checking host mapping for compute host 'compute1': b8d2cf6b-fcc9-4075-b5e9-adc7917314ca
    Creating host mapping for compute host 'compute1': b8d2cf6b-fcc9-4075-b5e9-adc7917314ca
    Found 1 unmapped computes in cell: 1643b2dd-ed63-4364-bd11-9eb4560b2363 
    ```
####  Kiểm tra kết quả cài đặt nova.
*   Chạy scripts: `. admin-openrc`
*   Liệt kê ra các dịch vụ:
    `openstack compute service list`
    ```
    +----+------------------+------------+----------+---------+-------+----------------------------+
    | ID | Binary           | Host       | Zone     | Status  | State | Updated At                 |
    +----+------------------+------------+----------+---------+-------+----------------------------+
    |  1 | nova-scheduler   | controller | internal | enabled | up    | 2020-02-18T09:06:23.000000 |
    |  2 | nova-consoleauth | controller | internal | enabled | up    | 2020-02-18T09:06:32.000000 |
    |  3 | nova-conductor   | controller | internal | enabled | up    | 2020-02-18T09:06:24.000000 |
    |  7 | nova-compute     | compute1   | nova     | enabled | up    | 2020-02-18T09:06:31.000000 |
    +----+------------------+------------+----------+---------+-------+----------------------------+
    ```
    
    `nova-status upgrade check`
    ```
    +--------------------------------+
    | Upgrade Check Results          |
    +--------------------------------+
    | Check: Cells v2                |
    | Result: Success                |
    | Details: None                  |
    +--------------------------------+
    | Check: Placement API           |
    | Result: Success                |
    | Details: None                  |
    +--------------------------------+
    | Check: Ironic Flavor Migration |
    | Result: Success                |
    | Details: None                  |
    +--------------------------------+
    | Check: Request Spec Migration  |
    | Result: Success                |
    | Details: None                  |
    +--------------------------------+
    | Check: Console Auths           |
    | Result: Success                |
    | Details: None                  |
    +--------------------------------+
    ```

## Cài đặt Networking service (NEUTRON)
*   Cài đặt trên cả 2 node **controller** và **compute1**
### Cài đặt trên node Controller.
#### Tạo database cho neutron
*   Truy cập vào MariaDB: `mysql`
*   Tạo DB neutron: 
    ```
    MariaDB [(none)]> CREATE DATABASE neutron;
    Query OK, 1 row affected (0.00 sec)
    ```
*   Cấp quyền truy cập vào neutron database
    ```
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
    ->   IDENTIFIED BY 'NEUTRON_DBPASS';
    Query OK, 0 rows affected (0.00 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
        ->   IDENTIFIED BY 'NEUTRON_DBPASS';
    Query OK, 0 rows affected (0.01 sec)
    ```
*   Chạy scripts: `. admin-openrc`
#### Tạo user, dịch vụ và các endpoint API cho neutron
*   Tạo user neutron 
    ` openstack user create --domain default --password-prompt neutron`
    ```
    User Password:
    Repeat User Password:
    +---------------------+----------------------------------+
    | Field               | Value                            |
    +---------------------+----------------------------------+
    | domain_id           | default                          |
    | enabled             | True                             |
    | id                  | 8f4fbc0020314017854169d4fb6d3f6d |
    | name                | neutron                          |
    | options             | {}                               |
    | password_expires_at | None                             |
    +---------------------+----------------------------------+
    ```
*   Gán role admin cho tài khoản neutron
    `openstack role add --project service --user neutron admin`
*   Tạo dịch vụ tên là neutron
    ` openstack service create --name neutron --description "OpenStack Networking" network`
    ```
    +-------------+----------------------------------+
    | Field       | Value                            |
    +-------------+----------------------------------+
    | description | OpenStack Networking             |
    | enabled     | True                             |
    | id          | 680bb3c3b38d4ca3b88c5b52bb48fa63 |
    | name        | neutron                          |
    | type        | network                          |
    +-------------+----------------------------------+
    ```
*   Tạo API endpoint cho dịch vụ neutron
    ` openstack endpoint create --region RegionOne network public http://controller:9696`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | 3e5b3889796c48f9b543aa988fb20d82 |
    | interface    | public                           |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | 680bb3c3b38d4ca3b88c5b52bb48fa63 |
    | service_name | neutron                          |
    | service_type | network                          |
    | url          | http://controller:9696           |
    +--------------+----------------------------------+
    ```
    `openstack endpoint create --region RegionOne  network internal http://controller:9696`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | 837e540eeda34622952dca8d7e1a7971 |
    | interface    | internal                         |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | 680bb3c3b38d4ca3b88c5b52bb48fa63 |
    | service_name | neutron                          |
    | service_type | network                          |
    | url          | http://controller:9696           |
    +--------------+----------------------------------+
    ```
    `openstack endpoint create --region RegionOne network admin http://controller:9696`
    ```
    +--------------+----------------------------------+
    | Field        | Value                            |
    +--------------+----------------------------------+
    | enabled      | True                             |
    | id           | 891e8ec3c69842fd9cbd577a83fddefe |
    | interface    | admin                            |
    | region       | RegionOne                        |
    | region_id    | RegionOne                        |
    | service_id   | 680bb3c3b38d4ca3b88c5b52bb48fa63 |
    | service_name | neutron                          |
    | service_type | network                          |
    | url          | http://controller:9696           |
    +--------------+----------------------------------+
    ```
#### Cài đặt và cấu hình neutron
*   Sử dụng **self-service network**
*   Cài đặt gói: `apt install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent`
*   Cấu hình file: `/etc/neutron/neutron.conf`
    *  Trong  `[database]`
    Comment dòng:`connection = sqlite:////var/lib/neutron/neutron.sqlite`
    Thêm dòng: `mysql+pymysql://neutron:NEUTRON_DBPASS@controller/neutron`
    * Trong `[DEFAULT]`
    Thêm dòng(nếu dòng nào có rồi k cần thêm):
        ```
        core_plugin = ml2
        service_plugins = router
        allow_overlapping_ips = true
        transport_url = rabbit://openstack:RABBIT_PASS@controller
        auth_strategy = keystone
        notify_nova_on_port_status_changes = true
        notify_nova_on_port_data_changes = true
        ```
    *   Trong `[keystone_authtoken]`
    Thêm dòng: 
    ```
    www_authenticate_uri = http://controller:5000
    auth_url = http://controller:5000
    memcached_servers = controller:11211
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    project_name = service
    username = neutron
    password = NEUTRON_PASS
    ```
    *   Trong `[nova]`
    Thêm dòng: 
    ```
    auth_url = http://controller:5000
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    region_name = RegionOne
    project_name = service
    username = nova
    password = NOVA_PASS
    ```
    *   Trong `[oslo_concurrency]`
    Thêm dòng: `lock_path = /var/lib/neutron/tmp`

*   Cài đặt và cấu hình plug-in Modular Layer 2 (ML2) file: `/etc/neutron/plugins/ml2/ml2_conf.ini`
    *   Trong `[ml2] `
    Thêm dòng:
        ```
        type_drivers = flat,vlan,vxlan
        tenant_network_types = vxlan
        mechanism_drivers = linuxbridge,l2population
        extension_drivers = port_security
        ```
    *   Trong `[ml2_type_flat]`
    Thêm dòng:
    `flat_networks = provider`

    *   Trong `[ml2_type_vxlan]`
    Thêm dòng:
    `vni_ranges = 1:1000`

    *   Trong ` [securitygroup]`
    Thêm dòng: 
    `enable_ipset = true`

*   Cấu hình linuxbridge agent: file `/etc/neutron/plugins/ml2/linuxbridge_agent.ini`
*   Trong `[linux_bridge]`
    Thêm dòng:
    `physical_interface_mappings = provider:ens3`

*   Trong `[vxlan]`
    Thêm dòng: 
    ```
    enable_vxlan = true
    local_ip = 10.0.0.73
    l2_population = true
    ```
    
*   Trong `[securitygroup] `
    Thêm dòng: 
    ```
    enable_security_group = true
    firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
    ```
* Cấu hình L3 Agent file: ` /etc/neutron/l3_agent.ini`
    *   Trong `[DEFAULT]`
    Thêm dòng: 
    `interface_driver = linuxbridge`

*   Cấu hình DHCP Agent file ` /etc/neutron/dhcp_agent.ini`
    *   Trong `[DEFAULT] `
    Thêm dòng:
        ```
        interface_driver = linuxbridge
        dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
        enable_isolated_metadata = true
        ```
*   Cấu hình metadata agent file `/etc/neutron/metadata_agent.ini`
*   Trong `[DEFAULT]`
    Thêm dòng:
    ```
    nova_metadata_host = controller
    metadata_proxy_shared_secret = METADATA_SECRET
    ``` 
#### Cấu hình compute Service sử dụng Network service 
File cấu hình: ` /etc/nova/nova.conf `
*   Trong `[neutron]`
    Thêm dòng:
    ```
    url = http://controller:9696
    auth_url = http://controller:5000
    auth_type = password
    project_domain_name = default
    user_domain_name = default
    region_name = RegionOne
    project_name = service
    username = neutron
    password = NEUTRON_PASS
    service_metadata_proxy = true
    metadata_proxy_shared_secret = METADATA_SECRET
    ```

####  Đồng bộ database cho neutron
`su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron`



