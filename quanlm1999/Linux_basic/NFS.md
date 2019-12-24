#### NFS
 NFS là một hệ thống giao thức chia sẻ file phát triển bởi Sun Microsystems từ năm 1984, cho phép một người dùng trên một máy tính khách truy cập tới hệ thống file chia sẻ thông qua một mạng máy tính giống như truy cập trực tiếp trên ổ cứng.
 
#### Cài đặt NFS Server

**B1**
Download: 
* Trên server: `sudo apt-get install nfs-kernel-server`
* Trên client: `sudo apt-get install nfs-common`

**B2**
Tạo thư mục để exports 
* Trên server: `sudo mkdir -p /mnt/sharedfolder`
    * Để client có thể truy cập vào toàn bộ thư mục ta bỏ owner :
        * Câu lệnh: `sudo mkdir -p /mnt/sharedfolder`
        * Câu lệnh: `sudo chmod 777 /mnt/sharedfolder`

**B3** 
* Truy cập vào `/etc/exports`
* Thêm Client có thể nhận dc file theo format sau: 
    * `directory_to_share    client(share_option1,...,share_optionN)`
    * Cụ thể: `/mnt/sharedfolder 192.168.66.64(rw,sync,no_subtree_check)`
        * Trong đó: 
            * `rw` : client có thể read và write
            * `sync`: Viết lên disk trước khi phản hồi lại 
            * `no_subtree_check`: Ngăn ngừa subtree check 
        

**B4**
* Exports: `sudo exportfs -a`
* Restart service: `sudo systemctl restart nfs-kernel-server`

**B5** 
Mở tường lửa để  client có thể truy cập vào thư mục được chia sẻ 
* Câu lệnh: `sudo ufw allow from [clientIP or clientSubnetIP] to any port nfs`
* Cụ thể:`sudo ufw allow from 192.168.122.82 to any port nfs

#### Phần server đã xong, giờ ta config client: 
**B1** 
* Tạo thư mục để mount: `sudo mkdir -p /mnt/sharedfolder_client`

**B2** 
* Mount tới thư mục được chia sẻ ở server: `sudo mount serverIP:/exportFolder_server /mnt/mountfolder_client`
* Cụ thể: `sudo mount 192.168.122.82:/exportFolder_server /mnt/mountfolder_client`

**B3**
Kiểm tra hoạt động.



## Salt:

file NFS_install.sls (sv): https://gist.github.com/lmq1999/92ccfab44ffe5a43b28fb189ab5d6abf
file NFS_client_install.sls (client): https://gist.github.com/lmq1999/720835dfd206f99c40a26267dab0b650
file NFS_dir.sls(sv): https://gist.github.com/lmq1999/f185b18d7cfe81c54b607d286be2937d

**B1:** 
Cài đặt nfs sử dụng câu lệnh: `salt '*' state.apply NFS_install`
![install](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/nfsinstall.png)
**B2:**
Taọ thư mục để chia sẻ sử dụng câu lệnh: `salt '*' state.apply NFS_dir` 
![dir](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/NFS_CreateDir.png)
**B3:**
Đẩy file export vào: `salt'*' state.apply NFS_export`
![export](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/NFS_export.png)

* Chạy câu lệnh `sudo exportfs -a` trên minion sử dụng : `salt '*' cmd.run 'sudo exportfs -a'` rồi restart lại service 
* Cho quyền truy cập dùng ufw: `salt '*' cmd.run 'sudo ufw allow from 192.168.66.64 to any port nfs'` Ta thấy trả về rules updated là được

**Còn lại cài đặt cho client như trên** 

* Kiểm tra mount trong client: 
![nfsdf](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/nfs_df.png)

* Kiểm tra hoạt động:
    ![test1](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/nfs_test2.png)
    ![test2](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/nfs_test1.png)
