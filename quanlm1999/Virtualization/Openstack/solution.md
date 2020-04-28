# Giải pháp schedule VM của project vào 1 vài các node compute riêng biệt

#### Cách 1 
Chỉ định xem VM sẽ được tạo ở node compute nào: 
**Sử dụng câu lệnh:**
```
openstack --os-compute-api-version 2.74 server create --image IMAGE \
--flavor m1.nano --key-name KEY --host HOST \
--hypervisor-hostname HYPERVISOR --nic net-id=UUID SERVER
```

Trong đó, 
**Để liệt kê các node compute (host)**

`openstack compute service list --service nova-compute`
```
+----+--------------+----------+-------+---------+-------+----------------------------+
| ID | Binary       | Host     | Zone  | Status  | State | Updated At                 |
+----+--------------+----------+-------+---------+-------+----------------------------+
| 17 | nova-compute | compute1 | zone1 | enabled | up    | 2020-04-28T04:19:49.000000 |
| 19 | nova-compute | compute2 | zone2 | enabled | up    | 2020-04-28T04:19:50.000000 |
+----+--------------+----------+-------+---------+-------+----------------------------+

```
**Để liệt kê các hypervisor**

`openstack hypervisor list`
```
+----+---------------------+-----------------+-----------------+-------+
| ID | Hypervisor Hostname | Hypervisor Type | Host IP         | State |
+----+---------------------+-----------------+-----------------+-------+
|  1 | compute1            | QEMU            | 192.168.122.192 | up    |
|  2 | compute2            | QEMU            | 192.168.122.191 | up    |
+----+---------------------+-----------------+-----------------+-------+
```
#### Cách 2
Chỉ định xem VM sẽ được tạo ở Availability Zone nào: 
Để chỉ định xem VM được tạo ở AZ nào, ta cần sử dụng câu lệnh
```
openstack server create --image IMAGE --flavor m1.tiny --key-name KEY \
--availability-zone ZONE:HOST:NODE --nic net-id=UUID SERVER
```

**Liệt kê các AZ của node compute**
`root@controller:~# openstack availability zone list --compute`
```
+-----------+-------------+
| Zone Name | Zone Status |
+-----------+-------------+
| zone1     | available   |
| zone2     | available   |
+-----------+-------------+
```
Chú ý, ở đây AZ đã được tạo từ trc
Để tạo AZ, ta cần sử dụng Host aggregate
`openstack aggregate create --zone ZONE AGGREGATE`
```
root@controller:~# openstack aggregate create --zone zone1 aggregate1
+-------------------+----------------------------+
| Field             | Value                      |
+-------------------+----------------------------+
| availability_zone | zone1                      |
| created_at        | 2020-04-28T04:40:27.488201 |
| deleted           | False                      |
| deleted_at        | None                       |
| hosts             | None                       |
| id                | 1                          |
| name              | aggregate1                 |
| properties        | None                       |
| updated_at        | None                       |
+-------------------+----------------------------+
```
```
root@controller:~# openstack aggregate create --zone zone2 aggregate2
+-------------------+----------------------------+
| Field             | Value                      |
+-------------------+----------------------------+
| availability_zone | zone1                      |
| created_at        | 2020-04-28T04:40:27.488201 |
| deleted           | False                      |
| deleted_at        | None                       |
| hosts             | None                       |
| id                | 2                          |
| name              | aggregate2                 |
| properties        | None                       |
| updated_at        | None                       |
+-------------------+----------------------------+
```
Kết quả:
```
root@controller:~# openstack aggregate list
+----+------------+-------------------+
| ID | Name       | Availability Zone |
+----+------------+-------------------+
|  1 | aggregate1 | zone1             |
|  2 | aggregate2 | zone2             |
+----+------------+-------------------+
```
Tiếp đó ta sẽ add host vào aggregate
`openstack aggregate add host AGGREGATE HOST`
Kết quả
```
root@controller:~# openstack aggregate show aggregate1
+-------------------+-----------------------------------------------------+
| Field             | Value                                               |
+-------------------+-----------------------------------------------------+
| availability_zone | zone1                                               |
| created_at        | 2020-04-27T04:50:48.000000                          |
| deleted           | False                                               |
| deleted_at        | None                                                |
| hosts             | compute1                                            |
| id                | 1                                                   |
| name              | aggregate1                                          |
| properties        | filter_tenant_id='6a176b8321344768af6dcb7a6d28184c' |
| updated_at        | None                                                |
+-------------------+-----------------------------------------------------+
root@controller:~# openstack aggregate show aggregate2
+-------------------+----------------------------+
| Field             | Value                      |
+-------------------+----------------------------+
| availability_zone | zone2                      |
| created_at        | 2020-04-27T04:50:51.000000 |
| deleted           | False                      |
| deleted_at        | None                       |
| hosts             | compute2                   |
| id                | 2                          |
| name              | aggregate2                 |
| properties        |                            |
| updated_at        | None                       |
+-------------------+----------------------------+
```

Ta add compute1 vào aggregate1 và compute2 vào aggregate2 đồng thời compute1 vào zone1 và compute2 và zone2

Vậy khi tạo máy ảo sẽ chỉ định xem máy ảo được tạo trên AZ nào.

#### Cách 3:
Cấu hình chỉ định Host cho project.
Để cấu hình chỉ định Host cho project, đầu tiên ta cần cấu hình file `nova.conf`
Ở trong `[filter_scheduler]`
bỏ comment dòng `enabled_filters`, thêm xuống cuối dòng 2 filter mới là: `AggregateInstanceExtraSpecsFilter,AggregateMultiTenancyIsolation` đồng thời bỏ filter `ComputeCapabilitiesFilter`
do `AggregateInstanceExtraSpecsFilter` và `ComputeCapabilitiesFilter` xung đột với nhau.

Restart dịch vụ `nova-scheduler`
Với Aggregate đã tạo ở trên, ta thêm thuộc tính `tenant id ( project id)` như sau
`nova aggregate-set-metadata aggregate1 filter_tenant_id=`
Trong đó kiểm tra project id:
```
root@controller:~# openstack project list
+----------------------------------+-----------+
| ID                               | Name      |
+----------------------------------+-----------+
| 63a1efbffc5a46768251f6f2bc8e453d | admin     |
| 6a176b8321344768af6dcb7a6d28184c | myproject |
| f3df83de7dd2408bbe4fdd454d924d49 | service   |
+----------------------------------+-----------+
```
Kết quả:
```
root@controller:~# openstack aggregate show aggregate1
+-------------------+-----------------------------------------------------+
| Field             | Value                                               |
+-------------------+-----------------------------------------------------+
| availability_zone | zone1                                               |
| created_at        | 2020-04-27T04:50:48.000000                          |
| deleted           | False                                               |
| deleted_at        | None                                                |
| hosts             | compute1                                            |
| id                | 1                                                   |
| name              | aggregate1                                          |
| properties        | filter_tenant_id='6a176b8321344768af6dcb7a6d28184c' |
| updated_at        | None                                                |
+-------------------+-----------------------------------------------------+
```
Sau khi cấu hình thế này, chỉ những user thuộc project này mới có thể tạo máy ảo ở host đó , nhưng máy ảo vẫn có thể được tạo ở host khác không nằm trong aggregate hoặc k đặt tenant_id
Để khắc phục ta cần tạo flavor có thuộc tính tương tự .
```
openstack flavor set --property aggregate_instance_extra_specs:filter_tenant_id=6a176b8321344768af6dcb7a6d28184c m1.nano
```
Kết quả:
```
root@controller:~# openstack flavor show m1.nano
+----------------------------+------------------------------------------------------------------------------------+
| Field                      | Value                                                                              |
+----------------------------+------------------------------------------------------------------------------------+
| OS-FLV-DISABLED:disabled   | False                                                                              |
| OS-FLV-EXT-DATA:ephemeral  | 0                                                                                  |
| access_project_ids         | None                                                                               |
| disk                       | 1                                                                                  |
| id                         | 0                                                                                  |
| name                       | m1.nano                                                                            |
| os-flavor-access:is_public | True                                                                               |
| properties                 | aggregate_instance_extra_specs:filter_tenant_id='6a176b8321344768af6dcb7a6d28184c' |
| ram                        | 64                                                                                 |
| rxtx_factor                | 1.0                                                                                |
| swap                       |                                                                                    |
| vcpus                      | 1                                                                                  |
+----------------------------+------------------------------------------------------------------------------------+
```
Sau khi cấu hình xong, thì những máy được tạo bởi flavor m1.nano luôn được schedule vào aggregate1  (bao gồm những node compute đã add vào) và chỉ những người thuộc project đó mới có  thể tạo được VM 

#### Thỏa mãn yêu cầu schedule các VM của project này vào 1 vài compute node riêng biệt

Nhược điểm: Chỉ có user thuộc project mới có thể sử dụng nodes compute đó, nhưng user không thuộc không sử dụng được

Với user admin, không thuộc project thì lúc tạo VM sẽ lỗi
```
root@controller:~# . admin-openrc 
root@controller:~# openstack server create --image cirros --flavor m1.nano --nic net-id=69b3bfc1-ce0e-48ff-b59a-f8027a185e64 test
+-------------------------------------+-----------------------------------------------+
| Field                               | Value                                         |
+-------------------------------------+-----------------------------------------------+
| OS-DCF:diskConfig                   | MANUAL                                        |
| OS-EXT-AZ:availability_zone         |                                               |
| OS-EXT-SRV-ATTR:host                | None                                          |
| OS-EXT-SRV-ATTR:hypervisor_hostname | None                                          |
| OS-EXT-SRV-ATTR:instance_name       |                                               |
| OS-EXT-STS:power_state              | NOSTATE                                       |
| OS-EXT-STS:task_state               | scheduling                                    |
| OS-EXT-STS:vm_state                 | building                                      |
| OS-SRV-USG:launched_at              | None                                          |
| OS-SRV-USG:terminated_at            | None                                          |
| accessIPv4                          |                                               |
| accessIPv6                          |                                               |
| addresses                           |                                               |
| adminPass                           | 3mFm2sGu4LQg                                  |
| config_drive                        |                                               |
| created                             | 2020-04-28T05:03:05Z                          |
| flavor                              | m1.nano (0)                                   |
| hostId                              |                                               |
| id                                  | 4d5f772d-d8ff-4f97-a7f5-f0b19b1e56bd          |
| image                               | cirros (c206cf9e-740e-4587-9925-7cdc946edda1) |
| key_name                            | None                                          |
| name                                | test                                          |
| progress                            | 0                                             |
| project_id                          | 63a1efbffc5a46768251f6f2bc8e453d              |
| properties                          |                                               |
| security_groups                     | name='default'                                |
| status                              | BUILD                                         |
| updated                             | 2020-04-28T05:03:05Z                          |
| user_id                             | f97d67a2c0be4b26b802085daced4124              |
| volumes_attached                    |                                               |
+-------------------------------------+-----------------------------------------------+
root@controller:~# openstack server list
+--------------------------------------+------+--------+----------+--------+---------+
| ID                                   | Name | Status | Networks | Image  | Flavor  |
+--------------------------------------+------+--------+----------+--------+---------+
| 4d5f772d-d8ff-4f97-a7f5-f0b19b1e56bd | test | ERROR  |          | cirros | m1.nano |
+--------------------------------------+------+--------+----------+--------+---------+
```
Nếu như ta sử dụng user 'myuser', thuộc project myproject ta có
```
+-----------------------------+-----------------------------------------------+               
| Field                       | Value                                         |               
+-----------------------------+-----------------------------------------------+               
| OS-DCF:diskConfig           | MANUAL                                        |               
| OS-EXT-AZ:availability_zone |                                               |               
| OS-EXT-STS:power_state      | NOSTATE                                       |
| OS-EXT-STS:task_state       | scheduling                                    |
| OS-EXT-STS:vm_state         | building                                      |
| OS-SRV-USG:launched_at      | None                                          |
| OS-SRV-USG:terminated_at    | None                                          |
| accessIPv4                  |                                               |
| accessIPv6                  |                                               |
| addresses                   |                                               |
| adminPass                   | EBtJuQsvLMv4                                  |
| config_drive                |                                               |
| created                     | 2020-04-28T05:03:59Z                          |
| flavor                      | m1.nano (0)                                   |
| hostId                      |                                               |
| id                          | dd903871-60a2-400e-84af-75070f29f3bc          |
| image                       | cirros (c206cf9e-740e-4587-9925-7cdc946edda1) |
| key_name                    | None                                          |
| name                        | test                                          |
| progress                    | 0                                             |
| project_id                  | 6a176b8321344768af6dcb7a6d28184c              |
| properties                  |                                               |
| security_groups             | name='default'                                |
| status                      | BUILD                                         |
| updated                     | 2020-04-28T05:03:59Z                          |
| user_id                     | f5e809dd6b294ab5a3c4ea7a6fc368f1              |
| volumes_attached            |                                               |
+-----------------------------+-----------------------------------------------+

root@controller:~# openstack server list
+--------------------------------------+------+--------+------------------+--------+---------+
| ID                                   | Name | Status | Networks         | Image  | Flavor  |
+--------------------------------------+------+--------+------------------+--------+---------+
| dd903871-60a2-400e-84af-75070f29f3bc | test | ACTIVE | self=172.16.1.31 | cirros | m1.nano |
+--------------------------------------+------+--------+------------------+--------+---------+
```
Thử tạo 1 loạt VM dùng flavor m1.nano 
```
root@controller:~# openstack server show dd903871-60a2-400e-84af-75070f29f3bc
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | zone1                                                    |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:task_state       | None                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2020-04-28T05:04:07.000000                               |
| OS-SRV-USG:terminated_at    | None                                                     |
| accessIPv4                  |                                                          |
| accessIPv6                  |                                                          |
| addresses                   | self=172.16.1.31                                         |
| config_drive                |                                                          |
| created                     | 2020-04-28T05:03:59Z                                     |
| flavor                      | m1.nano (0)                                              |
| hostId                      | 487eca654e211cb28c50c0d8ee58b1e60e86450d105c65cd264c7276 |
| id                          | dd903871-60a2-400e-84af-75070f29f3bc                     |
| image                       | cirros (c206cf9e-740e-4587-9925-7cdc946edda1)            |
| key_name                    | None                                                     |
| name                        | test                                                     |
| progress                    | 0                                                        |
| project_id                  | 6a176b8321344768af6dcb7a6d28184c                         |
| properties                  |                                                          |
| security_groups             | name='default'                                           |
| status                      | ACTIVE                                                   |
| updated                     | 2020-04-28T05:04:08Z                                     |
| user_id                     | f5e809dd6b294ab5a3c4ea7a6fc368f1                         |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
root@controller:~# openstack server show 708d825f-e13c-4423-adc0-0257da6631e1
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | zone1                                                    |                              
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:task_state       | None                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2020-04-28T07:04:30.000000                               |
| OS-SRV-USG:terminated_at    | None                                                     |
| accessIPv4                  |                                                          |
| accessIPv6                  |                                                          |
| addresses                   | self=172.16.1.61                                         |
| config_drive                |                                                          |
| created                     | 2020-04-28T07:04:19Z                                     |
| flavor                      | m1.nano (0)                                              |
| hostId                      | 487eca654e211cb28c50c0d8ee58b1e60e86450d105c65cd264c7276 |
| id                          | 708d825f-e13c-4423-adc0-0257da6631e1                     |
| image                       | cirros (c206cf9e-740e-4587-9925-7cdc946edda1)            |
| key_name                    | None                                                     |
| name                        | test                                                     |
| progress                    | 0                                                        |
| project_id                  | 6a176b8321344768af6dcb7a6d28184c                         |
| properties                  |                                                          |
| security_groups             | name='default'                                           |
| status                      | ACTIVE                                                   |
| updated                     | 2020-04-28T07:04:32Z                                     |
| user_id                     | f5e809dd6b294ab5a3c4ea7a6fc368f1                         |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
root@controller:~# openstack server show 8ea2cec8-3945-46dd-84f4-0a74550e0c52
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | zone1                                                    |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:task_state       | None                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2020-04-28T07:04:37.000000                               |
| OS-SRV-USG:terminated_at    | None                                                     |
| accessIPv4                  |                                                          |
| accessIPv6                  |                                                          |
| addresses                   | self=172.16.1.90                                         |
| config_drive                |                                                          |
| created                     | 2020-04-28T07:04:26Z                                     |
| flavor                      | m1.nano (0)                                              |
| hostId                      | 487eca654e211cb28c50c0d8ee58b1e60e86450d105c65cd264c7276 |
| id                          | 8ea2cec8-3945-46dd-84f4-0a74550e0c52                     |
| image                       | cirros (c206cf9e-740e-4587-9925-7cdc946edda1)            |
| key_name                    | None                                                     |
| name                        | test                                                     |
| progress                    | 0                                                        |
| project_id                  | 6a176b8321344768af6dcb7a6d28184c                         |
| properties                  |                                                          |
| security_groups             | name='default'                                           |
| status                      | ACTIVE                                                   |
| updated                     | 2020-04-28T07:04:38Z                                     |
| user_id                     | f5e809dd6b294ab5a3c4ea7a6fc368f1                         |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
root@controller:~# openstack server show 114980ca-ff9c-4dcd-ac02-d673568b9a2f
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | zone1                                                    |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:task_state       | None                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2020-04-28T07:04:45.000000                               |
| OS-SRV-USG:terminated_at    | None                                                     |
| accessIPv4                  |                                                          |
| accessIPv6                  |                                                          |
| addresses                   | self=172.16.1.4                                          |
| config_drive                |                                                          |
| created                     | 2020-04-28T07:04:34Z                                     |
| flavor                      | m1.nano (0)                                              |
| hostId                      | 487eca654e211cb28c50c0d8ee58b1e60e86450d105c65cd264c7276 |
| id                          | 114980ca-ff9c-4dcd-ac02-d673568b9a2f                     |
| image                       | cirros (c206cf9e-740e-4587-9925-7cdc946edda1)            |
| key_name                    | None                                                     |
| name                        | test                                                     |
| progress                    | 0                                                        |
| project_id                  | 6a176b8321344768af6dcb7a6d28184c                         |
| properties                  |                                                          |
| security_groups             | name='default'                                           |
| status                      | ACTIVE                                                   |
| updated                     | 2020-04-28T07:04:46Z                                     |
| user_id                     | f5e809dd6b294ab5a3c4ea7a6fc368f1                         |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
```
Ta đều thấy có thể tạo được ở zone1
Trong trường hợp dùng flavor m2.nano (không có thuộc tính tenant id)
```
root@controller:~# openstack server show 0cb1a440-d42b-4a3e-a297-a77ea3811129
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | zone2                                                    |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:task_state       | None                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2020-04-28T07:12:28.000000                               |
| OS-SRV-USG:terminated_at    | None                                                     |
| accessIPv4                  |                                                          |
| accessIPv6                  |                                                          |
| addresses                   | self=172.16.1.7                                          |
| config_drive                |                                                          |
| created                     | 2020-04-28T07:12:15Z                                     |
| flavor                      | m2.nano (3)                                              |
| hostId                      | 54596dd10fad70978eaa6524e6acb596126267f57d0a5fd2f5847a35 |
| id                          | 0cb1a440-d42b-4a3e-a297-a77ea3811129                     |
| image                       | cirros (c206cf9e-740e-4587-9925-7cdc946edda1)            |
| key_name                    | None                                                     |
| name                        | test                                                     |
| progress                    | 0                                                        |
| project_id                  | 6a176b8321344768af6dcb7a6d28184c                         |
| properties                  |                                                          |
| security_groups             | name='default'                                           |
| status                      | ACTIVE                                                   |
| updated                     | 2020-04-28T07:12:29Z                                     |
| user_id                     | f5e809dd6b294ab5a3c4ea7a6fc368f1                         |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
root@controller:~# openstack server show 41496a1d-5416-4848-977a-edf6c409db1a
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | zone2                                                    |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:task_state       | None                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2020-04-28T07:12:34.000000                               |
| OS-SRV-USG:terminated_at    | None                                                     |
| accessIPv4                  |                                                          |
| accessIPv6                  |                                                          |
| addresses                   | self=172.16.1.43                                         |
| config_drive                |                                                          |
| created                     | 2020-04-28T07:12:21Z                                     |
| flavor                      | m2.nano (3)                                              |
| hostId                      | 54596dd10fad70978eaa6524e6acb596126267f57d0a5fd2f5847a35 |
| id                          | 41496a1d-5416-4848-977a-edf6c409db1a                     |
| image                       | cirros (c206cf9e-740e-4587-9925-7cdc946edda1)            |
| key_name                    | None                                                     |
| name                        | test                                                     |
| progress                    | 0                                                        |
| project_id                  | 6a176b8321344768af6dcb7a6d28184c                         |
| properties                  |                                                          |
| security_groups             | name='default'                                           |
| status                      | ACTIVE                                                   |
| updated                     | 2020-04-28T07:12:35Z                                     |
| user_id                     | f5e809dd6b294ab5a3c4ea7a6fc368f1                         |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
root@controller:~# openstack server show a22c0a2b-7514-443e-9f78-b41ad4c04939
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | zone1                                                    |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:task_state       | None                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2020-04-28T07:12:44.000000                               |
| OS-SRV-USG:terminated_at    | None                                                     |
| accessIPv4                  |                                                          |
| accessIPv6                  |                                                          |
| addresses                   | self=172.16.1.25                                         |
| config_drive                |                                                          |
| created                     | 2020-04-28T07:12:28Z                                     |
| flavor                      | m2.nano (3)                                              |
| hostId                      | 487eca654e211cb28c50c0d8ee58b1e60e86450d105c65cd264c7276 |
| id                          | a22c0a2b-7514-443e-9f78-b41ad4c04939                     |
| image                       | cirros (c206cf9e-740e-4587-9925-7cdc946edda1)            |
| key_name                    | None                                                     |
| name                        | test                                                     |
| progress                    | 0                                                        |
| project_id                  | 6a176b8321344768af6dcb7a6d28184c                         |
| properties                  |                                                          |
| security_groups             | name='default'                                           |
| status                      | ACTIVE                                                   |
| updated                     | 2020-04-28T07:12:45Z                                     |
| user_id                     | f5e809dd6b294ab5a3c4ea7a6fc368f1                         |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
root@controller:~# openstack server show 7e4da789-6f90-4112-a4cc-7331b8440374
+-----------------------------+----------------------------------------------------------+
| Field                       | Value                                                    |
+-----------------------------+----------------------------------------------------------+
| OS-DCF:diskConfig           | MANUAL                                                   |
| OS-EXT-AZ:availability_zone | zone1                                                    |
| OS-EXT-STS:power_state      | Running                                                  |
| OS-EXT-STS:task_state       | None                                                     |
| OS-EXT-STS:vm_state         | active                                                   |
| OS-SRV-USG:launched_at      | 2020-04-28T07:12:50.000000                               |
| OS-SRV-USG:terminated_at    | None                                                     |
| accessIPv4                  |                                                          |
| accessIPv6                  |                                                          |
| addresses                   | self=172.16.1.76                                         |
| config_drive                |                                                          |
| created                     | 2020-04-28T07:12:36Z                                     |
| flavor                      | m2.nano (3)                                              |
| hostId                      | 54596dd10fad70978eaa6524e6acb596126267f57d0a5fd2f5847a35 |
| id                          | 7e4da789-6f90-4112-a4cc-7331b8440374                     |
| image                       | cirros (c206cf9e-740e-4587-9925-7cdc946edda1)            |
| key_name                    | None                                                     |
| name                        | test                                                     |
| progress                    | 0                                                        |
| project_id                  | 6a176b8321344768af6dcb7a6d28184c                         |
| properties                  |                                                          |
| security_groups             | name='default'                                           |
| status                      | ACTIVE                                                   |
| updated                     | 2020-04-28T07:12:51Z                                     |
| user_id                     | f5e809dd6b294ab5a3c4ea7a6fc368f1                         |
| volumes_attached            |                                                          |
+-----------------------------+----------------------------------------------------------+
```
VM được tạo trên cả zone1 và zone2

