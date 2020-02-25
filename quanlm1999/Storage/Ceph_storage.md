# Cài đặt ceph cơ bản 3 node với ceph-deploy
## Mô hình
![](https://raw.githubusercontent.com/lmq1999/Mytest/master/ceph.jpg)

*   Chú ý: **ceph-deploy** **không** được dùng chung với **node ceph** còn lại.

#### Cài đặt 

*   Tạo user `ceph` trên các node `ceph1 ceph2 ceph3`, thêm quyền sudo cho user mới tạo
*   Trên node `ceph-deploy`, copy key ssh đến các node `ceph1 ceph2 ceph3`
*   Tạo thư mục quản lý file cấu hình khi cài đặt ceph lên các node.
```
mkdir my-cluster
cd my-cluster
```
*   Tạo cluster mới trong thư mục vừa tạo:
`ceph-deploy new node1`
*   Nếu có nhiều hơn 1 interface, cấu hình trong file `~/my-cluster/ceph.conf` trong `[global]`
    *   Thêm vào: `public network = 192.168.122.0/24`
*   Cài đặt ceph cho các node:
`ceph-deploy install node1 node2 node3`
*   Triển khai initial monitors và lấy ra các keys:
`ceph-deploy mon create-initial`, sau khi chạy sẽ thấy keyring sau:
```
ceph.client.admin.keyring
ceph.bootstrap-mgr.keyring
ceph.bootstrap-osd.keyring
ceph.bootstrap-mds.keyring
ceph.bootstrap-rgw.keyring
ceph.bootstrap-rbd.keyring
ceph.bootstrap-rbd-mirror.keyring
```
*   Triển khai file cấu hình đến các node: 
`ceph-deploy admin ceph1 ceph2 ceph3`

* Triển khai một manager daemon:
`ceph-deploy mgr create ceph1 ceph2 ceph3`

*   Thêm OSDs trên các node cài CEPH:
`ceph-deploy osd create ceph1:sdb ceph2:sdb ceph3:sdb`

*   Nếu muốn sử dụng CephFS:
```
ceph-deploy mds create ceph1
ceph-deploy mds create ceph2
ceph-deploy mds create ceph3
```
*   Kiểm tra
```
root@ceph1:~# ceph -s
  cluster:
    id:     8991e083-391e-421a-8734-c2aa167293f1
    health: HEALTH_OK
 
  services:
    mon: 3 daemons, quorum ceph3,ceph1,ceph2
    mgr: ceph1(active)
    osd: 3 osds: 3 up, 3 in
    rgw: 1 daemon active
 
  data:
    pools:   8 pools, 160 pgs
    objects: 380 objects, 240MiB
    usage:   3.36GiB used, 11.3GiB / 14.7GiB avail
    pgs:     160 active+clean
```
Thêm các node mon:
```
ceph-deploy mon add ceph2
ceph-deploy mon add ceph3

```

