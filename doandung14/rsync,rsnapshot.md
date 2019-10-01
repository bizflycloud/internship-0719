**rsync**

Khái niệm: Rsync (Remote Sync) là một công cụ dùng để sao chép và đồng bộ file/thư mục

**I. Tính năng nổi bật của Rsync**

Rsync hỗ trợ copy giữ nguyên thông số của files/folder như Symbolic links, Permissions, TimeStamp, Owner và Group.

Rsync nhanh hơn scp vì Rsync sử dụng giao thức remote-update, chỉ transfer những dữ liệu thay đổi mà thôi.

Rsync tiết kiệm băng thông do sử dụng phương pháp nén và giải nén khi transfer.

Rsync không yêu cầu quyền super-user.

**II. Cài đặt Rsync**

Rsync được cài đặt dễ dàng với một dòng lệnh:

– Trên Red Hat/CentOS

yum install rsync

– Trên Debian/Ubuntu

apt-get install rsysnc

**III. Sử dụng Rsync**

Câu lệnh căn bản của rsync:

rsync options source destination

Trong đó:

Source: dữ liệu nguồn

Destination: dữ liệu đích

Options: một số tùy chọn thêm

Các tham số cần biết khi dùng Rsync

-v: hiển thị trạng thái kết quả

-r: copy dữ liệu recursively, nhưng không đảm bảo thông số của file và thư mục

-a: cho phép copy dữ liệu recursively, đồng thời giữ nguyên được tất cả các thông số của thư mục và file

-z: nén dữ liệu khi transfer, tiết kiệm băng thông tuy nhiên tốn thêm một chút thời gian

-h: human-readable, output kết quả dễ đọc

--delete: xóa dữ liệu ở destination nếu source không tồn tại dữ liệu đó.

--exclude: loại trừ ra những dữ liệu không muốn truyền đi, nếu bạn cần loại ra nhiều file hoặc folder ở nhiều đường dẫn khác nhau thì mỗi cái bạn phải thêm --exclude tương ứng.

Rsync không tự động chạy nên thường được dùng kết hợp với crontab

**1. Copy file và thư mục trên local**

**copy file trên local**

`[root@hocvps]# rsync -zvh backup.tar /tmp/backups/`

**copy directory trên local**

`[root@hocvps]# rsync -avzh /root/rpmpkgs /tmp/backups/`

Câu lệnh trên copy toàn bộ file từ thư mục /root/rpmpkgs đến thư mục /tmp/backups/ trên cùng một máy..

**2. Copy file và thư mục giữa các server**

**Copy thư mục từ Local lên Remote Server**

`[root@hocvps]# rsync -avz rpmpkgs/ root@192.168.0.101:/home/`

Lệnh trên copy thư mục rpmpkgs từ Local lên Remote Server có IP 192.168.0.101, lưu ở thư mục /home/

**Copy thư mục từ Remote Server về Local**

`[root@hocvps]# rsync -avzh root@192.168.0.100:/home/tarunika/rpmpkgs /tmp/myrpms`

Lệnh trên sẽ copy dữ liệu ở thư mục /home/tarunika/rpmpkgs trên Remote Server 192.168.0.100 về máy Local lưu ở thư mục /tmp/myrpms

**3. Rsync qua SSH**

Với Rsync, bạn có thể transfer qua giao thức SSH, qua đó dữ liệu được bảo mật an toàn hơn.

Copy file từ Remote Server về Local Server qua SSH

Để xác định giao thức sẽ sử dụng với rsync, bạn cần thêm tùy chọn -e cùng với tên giao thức, ở đây là ssh.

`[root@hocvps]# rsync -avzhe ssh root@192.168.0.100:/root/install.log /tmp/`

Lệnh trên copy file /root/install.log trên Remote Server 192.168.0.100 về thư mục /tmp/ trên máy Local.

**Copy file từ Local lên Remote Server qua SSH**

`[root@hocvps]# rsync -avzhe ssh backup.tar root@192.168.0.100:/backups/`

**Nếu sử dụng port SSH custom, không phải port tiêu chuẩn 22, bạn cần chỉ rõ port muốn dùng trong câu lệnh. Ví dụ với port 2222 :**
`[root@hocvps]# rsync -avzhe "ssh -p 2222" root@192.168.0.100:/root/install.log /tmp/`

**4. Hiển thị tiến trình trong khi transfer dữ liệu với rsync**

Để hiển thị tiến độ transfer dữ liệu, bạn có thể sử dụng tùy chọn --progress**

`[root@hocvps]# rsync -avzhe ssh --progress /home/rpmpkgs root@192.168.0.100:/root/rpmpkgs`

**5. Sử dụng tùy chọn –include và –exclude**

Hai tùy chọn này cho phép chúng ta thêm hoặc bớt file hoặc thư mục trong quá trình đồng bộ dữ liệu.

`[root@hocvps]# rsync -avze ssh --include 'R*' --exclude '*' root@192.168.0.101:/var/lib/rpm/ /root/rp`

**6. Sử dụng tùy chọn –delete**

`[root@hocvps]# rsync -avz --delete**8. Tự động xóa dữ liệu nguồn sau khi đồng bộ thành công**

`[root@hocvps]# rsync --remove-source-files -zvh backup.tar /tmp/backups/`

**9. Chạy thử nghiệm Rsync**

root@192.168.0.100:/var/lib/rpm/ .`

**7. Giới hạn dung lượng tối đa của file được đồng bộ**

`[root@hocvps]# rsync -avzhe ssh --max-size='200k' /var/lib/rpm/ root@192.168.0.100:/root/tmprpm`

**8. Tự động xóa dữ liệu nguồn sau khi đồng bộ thành công**

`[root@hocvps]# rsync --remove-source-files -zvh backup.tar /tmp/backups/`

**9. Chạy thử nghiệm Rsync**

`root@hocvps]# rsync --dry-run --remove-source-files -zvh backup.tar /tmp/backups/

backup.tar`

**10. Giới hạn bandwidth**

`[root@hocvps]# rsync --bwlimit=100 -avzhe ssh  /var/lib/rpm/  root@192.168.0.100:/root/tmprpm/`

**Rsnapshot (Rsync Based) – A Local/Remote File System Backup Utility for Linux**

**Step 1: Installing Rsnapshot Backup in**

`# yum install rsnapshot` (Install and Enable EPEL Repository in RHEL/CentOS 6/5/4)

`# apt-get install rsnapshot`(On Debian/Ubuntu/Linux Mint)

**Step 2: Setting up SSH Password-less Login**

read ssh

**Step 3: Configuring Rsnapshot**

`# vi /etc/rsnapshot.conf`

Next create a backup directory, where you want to store all your backups. In my case my backup directory location is “/data/backup/”. Search for and edit the following parameter to set the backup location.

snapshot_root			 /data/backup/

Also uncomment the “cmd_ssh” line to allow to take remote backups over SSH. To uncomment the line remove the “#” in-front of the following line so that rsnapshot can securely transfer your data to a backup server.

cmd_ssh			/usr/bin/ssh

Next, you need to decide how many old backups you would like to keep, because rsnapshot had no idea how often you want to take snapshots. You need to specify how much data to save, add intervals to keep, and how many of each.

Well, the default settings are good enough, but still I would like you to enable “monthly” interval so that you could also have longer term backups in place. Please edit this section to look similar to below settings.

One more thing you need to edit is “ssh_args” variable. If you have changed the default SSH Port (22) to something else, you need to specify that port number of your remote backing up server.

ssh_args		-p 7851

Finally, add your local and remote backup directories that you want to backup
