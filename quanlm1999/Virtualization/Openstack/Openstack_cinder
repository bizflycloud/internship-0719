# Tổng quan về project Cinder

## Giới thiệu về Cinder
- Cinder cung cấp volume cho các VM.
- Các volume sẽ không bị xóa khi xóa bỏ VM, do đó data của người dùng sẽ được lưu lại cùng với volume đó.
- Phục vụ mục đích lưu trữ dữ liệu lâu dài.

## Các thành phần của cinder

  ![](https://docs.openstack.org/cinder/latest/_images/architecture.png)
  
* cinder-api: cung cấp các HTTP endpoint cho các API requests.
* cinder-scheduler: dịch vụ đọc các requests từ message quêu và chọn node storage phù hợp để tạo và cung cấp volume.
* cinder-volume: dịch vụ làm việc cùng với một storage back end thông qua các drivers. dịch vụ thực hiện tạo các volume.
* cinder-backup: dịch vụ backup làm việc cùng với backup back end thông qua kiến trúc driver.

# Cài đặt

*   Yêu cầu, đã cài đặt openstack và các dịch vụ trên 2 node **controller** và **compute1**

## Cài đặt môi trường cho node block1

*   Cập nhật các gói phần mềm
    `apt-get update`

*   Cài đặt repos để cài OpenStack
    `add-apt-repository cloud-archive:stein -y`

*   Cài đặt gói client của Openstack `apt install python3-openstackclient`

## Cài đặt trên node controller
#### Tạo DB và cấp quyền
*   Truy cập vào MariaDB: `mysql`
*   Tạo DB cinder: 
    ```
    MariaDB [(none)]> CREATE DATABASE cinder;
    Query OK, 1 row affected (0.000 sec)
    ```
*   Cấp quyền truy cập đến DB 
    ```
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' \
    ->   IDENTIFIED BY 'CINDER_DBPASS';
    Query OK, 0 rows affected (0.000 sec)
    
    MariaDB [(none)]> GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' \
        ->   IDENTIFIED BY 'CINDER_DBPASS';
    Query OK, 0 rows affected (0.000 sec)
    ```
    
####  Tạo credentials cho dịch vụ
*   Chạy script: `. admin-openrc`
*   Tạo user cinder: `openstack user create --domain default --password-prompt cinder`
    ```
    +---------------------+----------------------------------+
    | Field               | Value                            |
    +---------------------+----------------------------------+
    | domain_id           | default                          |
    | enabled             | True                             |
    | id                  | 170225942c784fda9f60a8fbb673320d |
    | name                | cinder                           |
    | options             | {}                               |
    | password_expires_at | None                             |
    +---------------------+----------------------------------+
    ```
    
*   Thêm role admin vào user cinder: `openstack role add --project service --user cinder admin`
*   Tạo **cinderv2** và **cinderv3** service
    *   `openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2`
        ```
        +-------------+----------------------------------+
        | Field       | Value                            |
        +-------------+----------------------------------+
        | description | OpenStack Block Storage          |
        | enabled     | True                             |
        | id          | 3e274241cc5d4bb0ad2796a07154798e |
        | name        | cinderv2                         |
        | type        | volumev2                         |
        +-------------+----------------------------------+
        ```
    *   `openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3`
        ```
        +-------------+----------------------------------+
        | Field       | Value                            |
        +-------------+----------------------------------+
        | description | OpenStack Block Storage          |
        | enabled     | True                             |
        | id          | ab3bbbef780845a1a283490d281e7fda |
        | name        | cinderv3                         |
        | type        | volumev3                         |
        +-------------+----------------------------------+
        ```

* Tạo API endpoints cho dịch vụ cinder 
`openstack endpoint create --region RegionOne volumev2 public http://controller:8776/v2/%\(project_id\)s`
    ```
    +--------------+------------------------------------------+
    | Field        | Value                                    |
    +--------------+------------------------------------------+
    | enabled      | True                                     |
    | id           | 6310a5f8c643464eaf175451f4252597         |
    | interface    | public                                   |
    | region       | RegionOne                                |
    | region_id    | RegionOne                                |
    | service_id   | 3e274241cc5d4bb0ad2796a07154798e         |
    | service_name | cinderv2                                 |
    | service_type | volumev2                                 |
    | url          | http://controller:8776/v2/%(project_id)s |
    +--------------+------------------------------------------+
    ```
`openstack endpoint create --region RegionOne volumev2 internal http://controller:8776/v2/%\(project_id\)s`
    ```
    +--------------+------------------------------------------+
    | Field        | Value                                    |
    +--------------+------------------------------------------+
    | enabled      | True                                     |
    | id           | 72ce9d718ab94818a2b73292645c714c         |
    | interface    | internal                                 |
    | region       | RegionOne                                |
    | region_id    | RegionOne                                |
    | service_id   | 3e274241cc5d4bb0ad2796a07154798e         |
    | service_name | cinderv2                                 |
    | service_type | volumev2                                 |
    | url          | http://controller:8776/v2/%(project_id)s |
    +--------------+------------------------------------------+
    ```
`openstack endpoint create --region RegionOne volumev2 admin http://controller:8776/v2/%\(project_id\)s`
    ```
    +--------------+------------------------------------------+
    | Field        | Value                                    |
    +--------------+------------------------------------------+
    | enabled      | True                                     |
    | id           | 4ac3be64010e491a99c602263537d3f7         |
    | interface    | admin                                    |
    | region       | RegionOne                                |
    | region_id    | RegionOne                                |
    | service_id   | 3e274241cc5d4bb0ad2796a07154798e         |
    | service_name | cinderv2                                 |
    | service_type | volumev2                                 |
    | url          | http://controller:8776/v2/%(project_id)s |
    +--------------+------------------------------------------+
    ```
`openstack endpoint create --region RegionOne volumev3 public http://controller:8776/v3/%\(project_id\)s`
    ```
    +--------------+------------------------------------------+
    | Field        | Value                                    |
    +--------------+------------------------------------------+
    | enabled      | True                                     |
    | id           | 8019d14383064bc5889dd73c09111e54         |
    | interface    | public                                   |
    | region       | RegionOne                                |
    | region_id    | RegionOne                                |
    | service_id   | 8e8c4b3b541842e59d82a451b948f1d8         |
    | service_name | cinderv3                                 |
    | service_type | volumev3                                 |
    | url          | http://controller:8776/v3/%(project_id)s |
    +--------------+------------------------------------------+
    ```
`openstack endpoint create --region RegionOne volumev3 internal http://controller:8776/v3/%\(project_id\)s`
    ```
    +--------------+------------------------------------------+
    | Field        | Value                                    |
    +--------------+------------------------------------------+
    | enabled      | True                                     |
    | id           | 537c2f8dfa944f40a6e01f54bb08b737         |
    | interface    | internal                                 |
    | region       | RegionOne                                |
    | region_id    | RegionOne                                |
    | service_id   | 8e8c4b3b541842e59d82a451b948f1d8         |
    | service_name | cinderv3                                 |
    | service_type | volumev3                                 |
    | url          | http://controller:8776/v3/%(project_id)s |
    +--------------+------------------------------------------+
    ```
`openstack endpoint create --region RegionOne volumev3 admin http://controller:8776/v3/%\(project_id\)s`
    ```
    +--------------+------------------------------------------+
    | Field        | Value                                    |
    +--------------+------------------------------------------+
    | enabled      | True                                     |
    | id           | 6d86398a7cbe43e58d9d61bf64f64e3d         |
    | interface    | admin                                    |
    | region       | RegionOne                                |
    | region_id    | RegionOne                                |
    | service_id   | 8e8c4b3b541842e59d82a451b948f1d8         |
    | service_name | cinderv3                                 |
    | service_type | volumev3                                 |
    | url          | http://controller:8776/v3/%(project_id)s |
    +--------------+------------------------------------------+
    ```

#### Cài đặt và cấu hình
*   Cài đặt gói: `apt install cinder-api cinder-scheduler`
*   Cấu hình file: `/etc/cinder/cinder.conf`
    *   Trong `[database]`
        *   Thêm dòng: `connection = mysql+pymysql://cinder:CINDER_DBPASS@controller/cinder`
        *   Comment dòng còn lại
    *   Trong `[DEFAULT]`
        *   Thêm dòng:
                ```
                auth_strategy = keystone
                my_ip = 10.10.10.190
                ```
    *   Trong `[keystone_authtoken]`
        *   Thêm dòng:
                ```
                auth_uri = http://controller:5000
                auth_url = http://controller:35357
                memcached_servers = controller:11211
                auth_type = password
                project_domain_name = default
                user_domain_name = default
                project_name = service
                username = cinder
                password = CINDER_PASS
                ```

    *   Trong `[oslo_concurrency]`
        *   Thêm dòng:`lock_path = /var/lib/cinder/tmp`

*   Đồng bộ vào database của Block Storage:
    `su -s /bin/sh -c "cinder-manage db sync" cinder`

#### Cấu hình Compute để sử dụng Block Storage:

*   Sửa file `/etc/nova/nova.conf`
    *   Trong `[cinder]`
    Thêm dòng: `os_region_name = RegionOne`

#### Kết thúc cài đặt

*   Restart dịch vụ Compute API:
    ```
    service nova-api restart
    Restart dịch vụ Block Storage:
    service cinder-scheduler restart
    service apache2 restart
    ```
##  Cài đặt trên node Block Storage
####   Tạo LVM

*   Cài đặt gói
    `apt install lvm2 thin-provisioning-tools`

*   Tạo LVM physical volume /dev/sdb 
    ```
    pvcreate /dev/sdb
    Physical volume "/dev/sdb" successfully created
    ```
* Tạo LVM volume group là cinder-volumes
    ```
    vgcreate cinder-volumes /dev/sdb
    Volume group "cinder-volumes" successfully created
    ```

*   Sửa file `/etc/lvm/lvm.conf.` T
*   Thêm dòng: filter trong devices{
    ```
    devices {
    ....
    filter = ["a/vdb/", "r/.*/"]
    ```
#### Cài đặt 
*   Cài đắt gói:`apt install cinder-volume`
*   Cấu hình
    *   Sửa file `/etc/cinder/cinder.conf`, **nếu không có thì tự thêm mới vào,  những section trong đây k hiện đầy đủ như các service khác.**
    *   Trong `[database]`
        Thêm dòng: `connection = mysql+pymysql://cinder:Welcome123@controller/cinder`
        Comment dòng còn lại:

    *   Trong `[DEFAULT]`
        Thêm dòng:
        ```
        transport_url = rabbit://openstack:RABBIT_PASS@controller
        auth_strategy = keystone
        my_ip = 10.10.10.192
        enabled_backends = lvm
        glance_api_servers = http://controller:9292  
         ```
    *   Trong `[keystone_authtoken]`
        Thêm dòng: 
        ```
        auth_uri = http://controller:5000
        auth_url = http://controller:35357
        memcached_servers = controller:11211
        auth_type = password
        project_domain_name = default
        user_domain_name = default
        project_name = service
        username = cinder
        password = CINDER_PASS
        ```

    *   Trong [lvm]
    Thêm dòng:
        ```
         volume_driver = cinder.volume.drivers.lvm.LVMVolumeDriver
        volume_group = cinder-volumes
        iscsi_protocol = iscsi
        iscsi_helper = tgtadm  
        ```
    *   Trong [oslo_concurrency]
    Thêm dòng: `lock_path = /var/lib/cinder/tmp  `

#### Kết thúc cài đặt

*   Restart the Block Storage volume service:
    ```
    service tgt restart
    service cinder-volume restart
    ```
*   Kiểm tra lại cài đặt. Thực hiện kiểm tra trên node controller.
    `openstack volume service list`
    ```
    +------------------+------------+------+---------+-------+----------------------------+
    | Binary           | Host       | Zone | Status  | State | Updated_at                 |
    +------------------+------------+------+---------+-------+----------------------------+
    | cinder-scheduler | controller | nova | enabled | up    | 2020-02-20T011:27:41.000000|
    | cinder-volume    | block@lvm  | nova | enabled | up    | 2020-02-20T011:27:46.000000|
    | cinder-backup    | controller | nova | enabled | up    | 2020-02-20T011:27:41.000000|
    +------------------+------------+------+---------+-------+----------------------------+
    ```

## Thao tác với volume
*   Tạo volume:
    `openstack volume create --size 5 volume_test`
    ```
    +---------------------+--------------------------------------+
    | Field               | Value                                |
    +---------------------+--------------------------------------+
    | attachments         | []                                   |
    | availability_zone   | nova                                 |
    | bootable            | false                                |
    | consistencygroup_id | None                                 |
    | created_at          | 2020-02-20T04:41:25.000000           |
    | description         | None                                 |
    | encrypted           | False                                |
    | id                  | b9ca8885-8f5d-45c6-a815-d841b0b50371 |
    | multiattach         | False                                |
    | name                | volume_test                          |
    | properties          |                                      |
    | replication_status  | None                                 |
    | size                | 5                                    |
    | snapshot_id         | None                                 |
    | source_volid        | None                                 |
    | status              | creating                             |
    | type                | None                                 |
    | updated_at          | None                                 |
    | user_id             | 62ea51b811304609ac42e51a2698c25f     |
    +---------------------+--------------------------------------+
    ```
*   Attach Volume: `openstack server add volume d1efeab5-bb3b-46d1-b1d1-6c8c7abacb78 volume_test--device /dev/sdb`
*   Detach volume: `openstack server remove volume d1efeab5-bb3b-46d1-b1d1-6c8c7abacb78 volume_test`
*   Xóa Volume: `openstack volume delete b9ca8885-8f5d-45c6-a815-d841b0b50371`
