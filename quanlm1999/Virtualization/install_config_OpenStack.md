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



    


  
