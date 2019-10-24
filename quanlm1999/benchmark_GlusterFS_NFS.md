# Benchmark
* Máy 1: Hostname: web1 NFS server
![w1](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/VM1.png)

* Máy 2: Hostname: web2 NFS client
![w2](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/VM2.png)


### Lantency
* Trên NFS client:
![client](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/lantency_client.png)

* Trên NFS server: 
![server](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/lantency_server.png)

# Nhận xét:
*   GlusterFS trên 2 server chênh nhau gần như không đáng kể
*   NFS trên client vì được chia sẻ sang nên chậm hơn trên đĩa của server 


### IOPS/Bandwidth

* NFS
**Client**
    *   Write:
    `tên file : randwrite, kích cỡ: 512MB, chạy 4 jobs và 2 process (tổng cộng 4GB)`
    `write: io=690236KB, bw=2743.9KB/s, iops=685, runt=251556msec`

    ![nfs_w2](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/nfs-w2.png)
    
    *   Read:
    `Đọc file ngẫu nhiên tổng cộng 2GB`
    `read : io=527056KB, bw=2184.7KB/s, iops=546, runt=241252msec`
    ![nfs_r1](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/nfs-r.png)
**Server**
    * Write
    `tên file : randwrite, kích cỡ: 512MB, chạy 4 jobs và 2 process (tổng cộng 4GB)`
    `write: io=1024.0MB, bw=4735.1KB/s, iops=1183, runt=221411msec`
    ![nfs_sv_w](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/NFS_SV_W.png)
    
    * Read:
    `Đọc file ngẫu nhiên tổng cộng 2GB`
    `read : io=5440.0KB, bw=23115B/s, iops=5, runt=240987msec`
    ![nfs_sv_r](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/NFS_SV_R.png)
    
* GlusterFS
    *   Write
    `write: io=526928KB, bw=2193.7KB/s, iops=548, runt=240210msec`
    ![glusterfs_W](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/glusterFS_W.png)
    *   Read
    `read : io=99140KB, bw=422905B/s, iops=103, runt=240052msec`
    ![glusterFS_R](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/glusterFS_R.png)
    
## Đọc ghi tuần tự
*   GlusterFS
   ![ddgfs](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/ddglusterfs.png)
*   Disk
    ![dd](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/dd_normal.png)
*   NFS
![dd_NFS](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/dd_NFS.png)

# Ta có thể thấy với các file lớn thì tốt độ đọc ghi nhanh, Nhưng với nhiều file nhỏ thì rất chậm     
