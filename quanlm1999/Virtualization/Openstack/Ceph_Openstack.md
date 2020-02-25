# Tích hợp ceph với openstack
## Mô hình: 
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/Ceph_openstack.jpg)

## Cài đặt ceph 3 node
https://github.com/bizflycloud/internship-0719/blob/master/quanlm1999/Storage/Ceph_storage.md

## Tích hợp ceph với openstack
Trên node ceph1 tạo 3 pool cho Glance, Cinder, Nova sử dụng:
```
ceph osd pool create images 64
ceph osd pool create volumes 64
ceph osd pool create vms 64
```
Cài đặt ceph trên các node openstack:
` apt update && apt-get install -y python3-rbd ceph-common`

Trên node ceph1, copy file cấu hình đến các node openstack
```
ssh controller sudo tee /etc/ceph/ceph.conf </etc/ceph/ceph.conf
ssh compute1 sudo tee /etc/ceph/ceph.conf </etc/ceph/ceph.conf
ssh block1sudo tee /etc/ceph/ceph.conf </etc/ceph/ceph.conf
```
Tạo user cho glance, nova và cinder phục vụ cho CEPH Client Authentication:
```
ceph auth get-or-create client.glance mon 'profile rbd' osd 'profile rbd pool=images'
ceph auth get-or-create client.cinder mon 'profile rbd' osd 'profile rbd pool=volumes, profile rbd pool=vms, profile rbd-read-only pool=images'
ceph auth get-or-create client.nova mon 'allow r' osd 'allow class-read object_prefix rbd_children, allow rwx pool=vms, allow rx pool=images'
```
Thêm lần lượt keyrings client.glance, client.cinder, client.nova lần lượt tương ứng đến node cài đặt glance-api, cinder-volume và nova-compute service, sau đó cấp quyền truy cập:

```
ceph auth get-or-create client.glance | ssh controller sudo tee /etc/ceph/ceph.client.glance.keyring
ssh controller sudo chown glance:glance /etc/ceph/ceph.client.glance.keyring

ceph auth get-or-create client.nova | ssh compute1 sudo tee /etc/ceph/ceph.client.nova.keyring
ssh compute01 sudo chown nova:nova /etc/ceph/ceph.client.nova.keyring

ceph auth get-or-create client.cinder | ssh block1 sudo tee /etc/ceph/ceph.client.cinder.keyring
ssh block1 sudo chown cinder:cinder /etc/ceph/ceph.client.cinder.keyring
ceph auth get-key client.nova | ssh compute1 tee /root/client.nova.key


ceph auth get-or-create client.cinder | ssh compute1 sudo tee /etc/ceph/ceph.client.cinder.keyring
ceph auth get-key client.cinder | ssh compute01 tee client.cinder.key
```
####    Tích hợp ceph với Glance
Trên node controller, ta thực hiện sửa file `/etc/glance/glance-api.conf `như sau:
```
  [DEFAULT]
  ...
  show_image_direct_url = True
  enable_v2_api = true
  enable_v2_registry = true
  enable_v1_api = true
  enable_v1_registry = true

  [glance_store]
  ...
  stores = file, http, swift, cinder, rbd
  default_store = rbd
  rbd_store_pool = images
  rbd_store_user = glance
  rbd_store_ceph_conf = /etc/ceph/ceph.conf
  rbd_store_chunk_size = 8
```

Lưu file lại và khởi động lại services:
```
service glance-registry restart
service glance-api restart
```

Tạo thử image:
```
openstack image create "cirros-ceph" --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare --public
```

Kết quả:
```
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field            | Value                                                                                                                                                                                                                                                                                                |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| checksum         | ba3cd24377dde5dfdd58728894004abb                                                                                                                                                                                                                                                                     |
| container_format | bare                                                                                                                                                                                                                                                                                                 |
| created_at       | 2020-02-25T02:44:45Z                                                                                                                                                                                                                                                                                 |
| disk_format      | qcow2                                                                                                                                                                                                                                                                                                |
| file             | /v2/images/ee2c580a-775c-41a8-9129-f2bbf2776144/file                                                                                                                                                                                                                                                 |
| id               | ee2c580a-775c-41a8-9129-f2bbf2776144                                                                                                                                                                                                                                                                 |
| min_disk         | 0                                                                                                                                                                                                                                                                                                    |
| min_ram          | 0                                                                                                                                                                                                                                                                                                    |
| name             | cirros-ceph                                                                                                                                                                                                                                                                                          |
| owner            | 67febc37693344b29481aa41325bc68b                                                                                                                                                                                                                                                                     |
| properties       | direct_url='rbd://8991e083-391e-421a-8734-c2aa167293f1/images/ee2c580a-775c-41a8-9129-f2bbf2776144/snap', os_hash_algo='sha512', os_hash_value='b795f047a1b10ba0b7c95b43b2a481a59289dc4cf2e49845e60b194a911819d3ada03767bbba4143b44c93fd7f66c96c5a621e28dff51d1196dae64974ce240e', os_hidden='False' |
| protected        | False                                                                                                                                                                                                                                                                                                |
| schema           | /v2/schemas/image                                                                                                                                                                                                                                                                                    |
| size             | 46137344                                                                                                                                                                                                                                                                                             |
| status           | active                                                                                                                                                                                                                                                                                               |
| tags             |                                                                                                                                                                                                                                                                                                      |
| updated_at       | 2020-02-25T02:45:03Z                                                                                                                                                                                                                                                                                 |
| virtual_size     | None                                                                                                                                                                                                                                                                                                 |
| visibility       | public                                                                                                                                                                                                                                                                                               |
+------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```

Để ý ID: `ee2c580a-775c-41a8-9129-f2bbf2776144 `

Trên node ceph1, ta kiểm tra: 
```
root@ceph1:~# rbd -p images list
ee2c580a-775c-41a8-9129-f2bbf2776144
```
#### Vậy đã tích hợp ceph với Glance.

#### Tích hợp CEPH với Cinder
Trên node compute1
Tạo UUID:
```
uuidgen
67fd705d-b567-4244-be18-9c4a1c0a59ed
```

Tạo secret client.cinder cho libvirt:
**secret.xml**
```
  <secret ephemeral='no' private='no'>
    <uuid>67fd705d-b567-4244-be18-9c4a1c0a59ed</uuid>
    <usage type='ceph'>
      <name>client.cinder secret</name>
    </usage>
  </secret>
```
```
  sudo virsh secret-define --file secret.xml
  Secret 67fd705d-b567-4244-be18-9c4a1c0a59ed created
  sudo virsh secret-set-value --secret 67fd705d-b567-4244-be18-9c4a1c0a59ed --base64 $(cat client.cinder.key) && rm client.cinder.key secret.xml
```

Trên các node block1 thực hiện sửa lội dung file /etc/cinder/cinder.conf như sau:
```
[DEFAULT]
...
enabled_backends = ceph
glance_api_version = 2
host = ceph
...
[ceph]
volume_driver = cinder.volume.drivers.rbd.RBDDriver
volume_backend_name = ceph
rbd_pool = volumes
rbd_ceph_conf = /etc/ceph/ceph.conf
rbd_flatten_volume_from_snapshot = false
rbd_max_clone_depth = 5
rbd_store_chunk_size = 4
rados_connect_timeout = -1
rbd_user = cinder
rbd_secret_uuid = 67fd705d-b567-4244-be18-9c4a1c0a59ed
report_discard_supported = true
```

Khởi động lại service:
```
service cinder-volume restart
service cinder-scheduler restart
```

tạo volume type ceph:
`openstack volume type create ceph`

tạo volume mới:
`openstack volume create --size 1 --type ceph ceph_volume_1G`

Kết quả:
```
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Field                        | Value                                                                                                                                                                                                                                                                                                           |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| attachments                  | [{'id': '6bab153d-ca84-426a-86a1-d65ceadf645b', 'attachment_id': 'a3f2ba6b-c18f-4a91-95dc-318d88c72ec6', 'volume_id': '6bab153d-ca84-426a-86a1-d65ceadf645b', 'server_id': '5ad7e434-b595-48f4-97ba-a2fa46fc3f06', 'host_name': 'compute1', 'device': '/dev/vdc', 'attached_at': '2020-02-25T03:53:44.000000'}] |
| availability_zone            | nova                                                                                                                                                                                                                                                                                                            |
| bootable                     | false                                                                                                                                                                                                                                                                                                           |
| consistencygroup_id          | None                                                                                                                                                                                                                                                                                                            |
| created_at                   | 2020-02-25T03:44:45.000000                                                                                                                                                                                                                                                                                      |
| description                  | None                                                                                                                                                                                                                                                                                                            |
| encrypted                    | False                                                                                                                                                                                                                                                                                                           |
| id                           | 6bab153d-ca84-426a-86a1-d65ceadf645b                                                                                                                                                                                                                                                                            |
| multiattach                  | False                                                                                                                                                                                                                                                                                                           |
| name                         | ceph1_volume_1G                                                                                                                                                                                                                                                                                                 |
| os-vol-tenant-attr:tenant_id | b8f0691595f2488ebdfeb3252486b27c                                                                                                                                                                                                                                                                                |
| properties                   |                                                                                                                                                                                                                                                                                                                 |
| replication_status           | None                                                                                                                                                                                                                                                                                                            |
| size                         | 1                                                                                                                                                                                                                                                                                                               |
| snapshot_id                  | None                                                                                                                                                                                                                                                                                                            |
| source_volid                 | None                                                                                                                                                                                                                                                                                                            |
| status                       | in-use                                                                                                                                                                                                                                                                                                          |
| type                         | ceph                                                                                                                                                                                                                                                                                                            |
| updated_at                   | 2020-02-25T03:53:45.000000                                                                                                                                                                                                                                                                                      |
| user_id                      | 62ea51b811304609ac42e51a2698c25f                                                                                                                                                                                                                                                                                |
+------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
```
Để ý ID: `6bab153d-ca84-426a-86a1-d65ceadf645b`
Kiểm tra trên node ceph1: 
```
root@ceph1:~# rbd -p volumes list
volume-6bab153d-ca84-426a-86a1-d65ceadf645b
```
#### Ta có thể thấy ceph cũng được tích hợp với Cinder

#### Tích hợp CEPH với Nova


Sửa lại nội dung file cấu hình /`etc/nova/nova.conf `như sau:
```
  [DEFAULT]
  ...
  force_raw_images = true
  ...
  disk_cachemodes = writeback
  ...
  [libvirt]
  images_rbd_pool = vms
  ...
  images_type = rbd
  ...
  images_rbd_ceph_conf = /etc/ceph/ceph.conf
  ...
  rbd_secret_uuid = 67fd705d-b567-4244-be18-9c4a1c0a59ed
  ...
  rbd_user = cinder
```

Lưu lại file và khởi động lại service:
`sudo service nova-compute restart`

Tạo server kiểm tra:
```
openstack server create --flavor m1.nano --image ee2c580a-775c-41a8-9129-f2bbf2776144 --nic net-id=f1f60d52-5ace-4f28-a229-d0020f5da4d6 --security-group default --key-name mykey ceph-vm
+-----------------------------+----------------------------------------------------+
| Field                       | Value                                              |
+-----------------------------+----------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                             |
| OS-EXT-AZ:availability_zone |                                                    |
| OS-EXT-STS:power_state      | NOSTATE                                            |
| OS-EXT-STS:task_state       | scheduling                                         |
| OS-EXT-STS:vm_state         | building                                           |
| OS-SRV-USG:launched_at      | None                                               |
| OS-SRV-USG:terminated_at    | None                                               |
| accessIPv4                  |                                                    |
| accessIPv6                  |                                                    |
| addresses                   |                                                    |
| adminPass                   | otcoT6dnZWyQ                                       |
| config_drive                |                                                    |
| created                     | 2020-02-25T04:01:17Z                               |
| flavor                      | m1.nano (0)                                        |
| hostId                      |                                                    |
| id                          | d82aff21-0310-40b0-bae0-fb12dd64688a               |
| image                       | cirros-ceph (ee2c580a-775c-41a8-9129-f2bbf2776144) |
| key_name                    | mykey                                              |
| name                        | ceph-vm                                            |
| progress                    | 0                                                  |
| project_id                  | b8f0691595f2488ebdfeb3252486b27c                   |
| properties                  |                                                    |
| security_groups             | name='d0f5947c-5c2a-408b-828b-748981188347'        |
| status                      | BUILD                                              |
| updated                     | 2020-02-25T04:01:17Z                               |
| user_id                     | 62ea51b811304609ac42e51a2698c25f                   |
| volumes_attached            |                                                    |
+-----------------------------+----------------------------------------------------+
```
```
root@controller:~# openstack server show d82aff21-0310-40b0-bae0-fb12dd64688a
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | nova                                                     |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:task_state       | None                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2020-02-24T06:10:28.000000                               |
| OS-SRV-USG:terminated_at    | None                                                     |
| accessIPv4                  |                                                          |
| accessIPv6                  |                                                          |
| addresses                   | selfservice=10.0.0.129                                   |
| config_drive                |                                                          |
| created                     | 2020-02-25T04:01:17Z                                     |
| flavor                      | m1.nano (0)                                              |
| hostId                      | e4a4c65761014bc479fd6d1457419846bb967607f2e6eee4e7c8215e |
| id                          | d82aff21-0310-40b0-bae0-fb12dd64688a                     |
| image                       | cirros-ceph (ee2c580a-775c-41a8-9129-f2bbf2776144)       |
| key_name                    | mykey                                                    |
| name                        | ceph-vm                                                  |
| progress                    | 0                                                        |
| project_id                  | b8f0691595f2488ebdfeb3252486b27c                         |
| properties                  |                                                          |
| security_groups             | name='default'                                           |
| status                      | ACTIVE                                                   |
| updated                     | 2020-02-25T04:01:34Z                                     |
| user_id                     | 62ea51b811304609ac42e51a2698c25f                         |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
```

Để ý ID của server: `d82aff21-0310-40b0-bae0-fb12dd64688a `
Kiểm tra ceph`:
```
root@ceph1:~# rbd -p vms list
d82aff21-0310-40b0-bae0-fb12dd64688a_disk
```
#### Ta có thể thấy ceph cũng đã được tích hợp với Nova 
#### Kiểm tra hoạt động:
*   Tạo máy ảo sử dụng image vừa tạo: 
```
openstack server create --flavor m1.nano --image ee2c580a-775c-41a8-9129-f2bbf2776144 --nic net-id=f1f60d52-5ace-4f28-a229-d0020f5da4d6 --security-group default --key-name mykey ceph-vm
+-----------------------------+----------------------------------------------------+
| Field                       | Value                                              |
+-----------------------------+----------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                             |
| OS-EXT-AZ:availability_zone |                                                    |
| OS-EXT-STS:power_state      | NOSTATE                                            |
| OS-EXT-STS:task_state       | scheduling                                         |
| OS-EXT-STS:vm_state         | building                                           |
| OS-SRV-USG:launched_at      | None                                               |
| OS-SRV-USG:terminated_at    | None                                               |
| accessIPv4                  |                                                    |
| accessIPv6                  |                                                    |
| addresses                   |                                                    |
| adminPass                   | otcoT6dnZWyQ                                       |
| config_drive                |                                                    |
| created                     | 2020-02-25T04:01:17Z                               |
| flavor                      | m1.nano (0)                                        |
| hostId                      |                                                    |
| id                          | d82aff21-0310-40b0-bae0-fb12dd64688a               |
| image                       | cirros-ceph (ee2c580a-775c-41a8-9129-f2bbf2776144) |
| key_name                    | mykey                                              |
| name                        | ceph-vm                                            |
| progress                    | 0                                                  |
| project_id                  | b8f0691595f2488ebdfeb3252486b27c                   |
| properties                  |                                                    |
| security_groups             | name='d0f5947c-5c2a-408b-828b-748981188347'        |
| status                      | BUILD                                              |
| updated                     | 2020-02-25T04:01:17Z                               |
| user_id                     | 62ea51b811304609ac42e51a2698c25f                   |
| volumes_attached            |                                                    |
+-----------------------------+----------------------------------------------------+
```
```
root@controller:~# openstack server show d82aff21-0310-40b0-bae0-fb12dd64688a
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | nova                                                     |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:task_state       | None                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2020-02-24T06:10:28.000000                               |
| OS-SRV-USG:terminated_at    | None                                                     |
| accessIPv4                  |                                                          |
| accessIPv6                  |                                                          |
| addresses                   | selfservice=10.0.0.129                                   |
| config_drive                |                                                          |
| created                     | 2020-02-25T04:01:17Z                                     |
| flavor                      | m1.nano (0)                                              |
| hostId                      | e4a4c65761014bc479fd6d1457419846bb967607f2e6eee4e7c8215e |
| id                          | d82aff21-0310-40b0-bae0-fb12dd64688a                     |
| image                       | cirros-ceph (ee2c580a-775c-41a8-9129-f2bbf2776144)       |
| key_name                    | mykey                                                    |
| name                        | ceph-vm                                                  |
| progress                    | 0                                                        |
| project_id                  | b8f0691595f2488ebdfeb3252486b27c                         |
| properties                  |                                                          |
| security_groups             | name='default'                                           |
| status                      | ACTIVE                                                   |
| updated                     | 2020-02-25T04:01:34Z                                     |
| user_id                     | 62ea51b811304609ac42e51a2698c25f                         |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
```
Console đến máy ảo vừa tạo: 
```
+-------+-------------------------------------------------------------------------------------------+
| Field | Value                                                                                     |
+-------+-------------------------------------------------------------------------------------------+
| type  | novnc                                                                                     |
| url   | http://controller:6080/vnc_auto.html?path=%3Ftoken%3Da3dc01f8-1071-4273-b1d8-88bd247d8f91 |
+-------+-------------------------------------------------------------------------------------------+
```
Gán volume vào máy ảo vừa tạo: 
```
root@controller:~# openstack server add volume  d82aff21-0310-40b0-bae0-fb12dd64688a 6bab153d-ca84-426a-86a1-d65ceadf645b
root@controller:~# openstack volume list
+--------------------------------------+-----------------+--------+------+-----------------------------------------------+
| ID                                   | Name            | Status | Size | Attached to                                   |
+--------------------------------------+-----------------+--------+------+-----------------------------------------------+
| edfe2926-2487-47ad-b357-96b0a078a568 |                 | error  |    1 |                                               |
| 6bab153d-ca84-426a-86a1-d65ceadf645b | ceph1_volume_1G | in-use |    1 | Attached to ceph-vm on /dev/vdb               |
| c7d52379-8ebd-4969-a9cb-e985e8047891 |                 | in-use |    1 | Attached to 2 on /dev/vda                     |
| 610d1f4a-216f-4346-bff1-6c1c201b2fa7 | 1.1             | in-use |    1 | Attached to 1 on /dev/vdb                     |
| 49478726-33c3-4a05-a5db-0699d62b5f91 | cirros1         | in-use |    1 | Attached to 1 on /dev/vda                     |
| 0ee4f31d-c78b-482e-89c5-7bfb9c4355ac | volume_demo     | in-use |    5 | Attached to selfservice-instance on /dev/vdb  |
+--------------------------------------+-----------------+--------+------+-----------------------------------------------+
```
Kiểm tra: 
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-25%2014-58-13.png)

Tháo volume:
```
root@controller:~# openstack server remove volume d82aff21-0310-40b0-bae0-fb12dd64688a 6bab153d-ca84-426a-86a1-d65ceadf645b
root@controller:~# openstack volume list
+--------------------------------------+-----------------+-----------+------+-----------------------------------------------+
| ID                                   | Name            | Status    | Size | Attached to                                   |
+--------------------------------------+-----------------+-----------+------+-----------------------------------------------+
| edfe2926-2487-47ad-b357-96b0a078a568 |                 | error     |    1 |                                               |
| 6bab153d-ca84-426a-86a1-d65ceadf645b | ceph1_volume_1G | available |    1 |                                               |
| c7d52379-8ebd-4969-a9cb-e985e8047891 |                 | in-use    |    1 | Attached to 2 on /dev/vda                     |
| 610d1f4a-216f-4346-bff1-6c1c201b2fa7 | 1.1             | in-use    |    1 | Attached to 1 on /dev/vdb                     |
| 49478726-33c3-4a05-a5db-0699d62b5f91 | cirros1         | in-use    |    1 | Attached to 1 on /dev/vda                     |
| 0ee4f31d-c78b-482e-89c5-7bfb9c4355ac | volume_demo     | in-use    |    5 | Attached to selfservice-instance on /dev/vdb  |
+--------------------------------------+-----------------+-----------+------+-----------------------------------------------+
```
Kiểm tra: 
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-25%2015-01-39.png)


```
root@ceph1:~# rbd -p images list
ee2c580a-775c-41a8-9129-f2bbf2776144

root@ceph1:~# rbd -p images list
ee2c580a-775c-41a8-9129-f2bbf2776144

root@ceph1:~# rbd -p vms list
d82aff21-0310-40b0-bae0-fb12dd64688a_disk
```
