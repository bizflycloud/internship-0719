**Cách cài ssh**

Ubuntu 

`[root@fw:~]# apt-get install openssh-server openssh-client`

CentOS 

`[root@fw:~]# yum -y install openssh-server openssh-clients`

**1. Cách kết nối ssh server**

`#ssh (Tên user)@(Địa chỉ ip user)`

Pass server

Lưu ý : mặc định mỗi VPS đăng nhập sẽ sử dụng username root và pass root => có 2 điều cần lưu ý 

1. Mất hết thông tin khi để lộ mật khẩu

2. Các attacker có thể sử dụng Brute Force Attack để dò tìm mật khẩu.

2. Sử dụng SSH key 

2.1 Khái niệm

SSH Key đơn giản là một phương thức chứng thực người dùng truy cập bằng cách đối chiếu giữa một key cá nhân (Private Key) và key công khai(Public Key).Private key và Public key luôn có liên hệ chặt chẽ với nhau để nó có thể nhận diện lẫn nhau. Nội dung giữa Private Key và Public Key hoàn toàn khác nhau, nhưng nó vẫn sẽ nhận diện được với nhau thông qua một thuật toán riêng của nó.

2.2 Thành phần SSH key

1.Public Key (dạng file và string) – Bạn sẽ copy ký tự key này sẽ bỏ vào file ~/.ssh/authorized_keys trên server của bạn.

2.Private Key (dạng file và string) – Bạn sẽ lưu file này vào máy tính, sau đó sẽ thiết lập cho PuTTY, WinSCP, MobaXterm,..để có thể login.

3.Keypharse (dạng string, cần ghi nhớ) – Mật khẩu để mở private key, khi đăng nhập vào server nó sẽ hỏi cái này.

Lưu ý : 1 SSH key có thể sử dụng cho nhiều server khác nhau

3.Cách tạo ssh key

`#ssh-keygen -t rsa` 

Nó sẽ hỏi muốn lưu private key vào đâu. Mặc định là /home/user/.ssh (enter)

Thiết lập keypharse

có thể thấy nó có ghi đường dẫn lưu file private key (id_rsa) và file public key (id_rsa.pub)

Mở file public key và đưa lên VPS

đăng nhập vào VPS với user cần thêm key (thường thì là root, nhưng nếu VPS có nhiều user thì sẽ cần thêm key cho tất cả user đó).

tạo thư mục .ssh/ và file authorized_keys trong thư mục đó:

mkdir ~/.ssh

chmod 700 ~/.ssh

touch ~/.ssh/authorized_keys

chmod 600 ~/.ssh/authorized_keys

Sau đó mở file authorized_keys trong thư mục .ssh ở thư mục gốc của user và copy toàn bộ ký tự của public key vào.
Co 2 cach de copy public key vao server

Thực hiện copy thủ công

Thực hiện câu lệnh

ssh-copy-id -i ~/.ssh/id_rsa.pub doandung@192.168.232.129

Trong đó ~/.ssh/id_rsa.pub là thư mục chứa public key còn lại là username@<địa chỉ ip>

Lưu ý:

SSH Key sẽ không thể hoạt động nếu bạn đang bật SELinux. Hãy tắt SELinux đi bằng cách mở file /etc/selinux/config, tìm SELINUX=enforcing và thay bằng SELINUX=disabled. Sau đó gõ lệnh reboot để khởi động lại server

Trường hợp có 2 key thì để chọn key mặc định được hỏi ta dùng lệnh sau:

In your ~/.ssh/config file put:

IdentityFile /home/myuser/.ssh/keyhello
 
4.Tắt chức năng sử dụng mật khẩu

Sau khi kiểm tra, nếu thấy đã có thể đăng nhập vào server bằng SSH Key thì có thể tắt chức năng sử dụng mật khẩu đi vì nếu không tắt, các attacker vẫn brute force attack như thường và sẽ vẫn bị mất dữ liệu nếu lộ mật khẩu.
mở file /etc/ssh/sshd_config

PasswordAuthentication no

UsePAM no

5. Các tiện ích của ssh

1. Ssh forward agent
Với mỗi phiên ssh-agent sẽ chỉ cần gõ passphrase một lần sau đó ssh-agent sẽ lưu lại passphare trong một biến môi trường cho những lần đăng nhập sau và tự động điền vào mỗi khi có hành động yêu cầu nhập thông tin passphrase. Thông tin này chỉ duy nhất được lưu trong phiên hiện tại, sau đó nó sẽ bị xóa nên không phải quá lo lắng về vấn đề bảo mật.

Để sử dụng ssh-agent ta làm như sau

1. Start ssh-agent bằng lệnh
`ssh-agent $SHELL`

Trong trường hợp sử dụng bash shell có thể dùng luôn lệnh ssh-agent bash

2. Import ssh private key vào ssh-agent
`ssh-add <path_to_private_key>`
Trong trường hợp key lưu ở vị trí mặc định lệnh sẽ là ssh-add ~/.ssh/id_rsa . Sau đó trương trình sẽ yêu cầu nhập vào passphrase để nó save tạm vào một biến môi trường, bạn nhập vào là xong.

Lần sau trong phiên hiện tại bất kể lúc nào sử dụng key kia để đăng nhập thì sẽ không cần phải gõ thêm passphrase lần nữa. Khi phiên kết thúc thì passphrase cũng được tự động xóa để đảm bảo vấn đề bảo mật.

Ngoài ra có thể cấu hình các thông số cho ssh-agent ví dụ như chỉ định interface sử dụng, thời gian hủy thông tin passphare đã nhập vào

Cach tat ssh-agent: export SSH_AUTH_SOCK=""

**Rsync – Công cụ đồng bộ dữ liệu**

Rsync (Remote Sync) là một công cụ dùng để sao chép và đồng bộ file/thư mục được dùng rất phổ biến

I. Tính năng nổi bật của Rsync

Rsync hỗ trợ copy giữ nguyên thông số của files/folder như Symbolic links, Permissions, TimeStamp, Owner và Group.

Rsync nhanh hơn scp vì Rsync sử dụng giao thức remote-update, chỉ transfer những dữ liệu thay đổi mà thôi.

Rsync tiết kiệm băng thông do sử dụng phương pháp nén và giải nén khi transfer.

Rsync không yêu cầu quyền super-user

**II. Cài đặt Rsync**

Rsync được cài đặt dễ dàng với một dòng lệnh:

– Trên Red Hat/CentOS

`yum install rsync`

– Trên Debian/Ubuntu
`apt-get install rsysnc`

III. Sử dụng Rsync

Câu lệnh căn bản của rsync:

`rsync options source destination`

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
 
SCP: 

Copy file from a remote host to local host SCP example:
`$ scp username@from_host:file.txt /local/directory/`
 
Copy file from local host to a remote host SCP example:
`$ scp file.txt username@to_host:/remote/directory/`
 
Copy directory from a remote host to local host SCP example:
`$ scp -r username@from_host:/remote/directory/  /local/directory/`
 
Copy directory from local host to a remote hos SCP example:
`$ scp -r /local/directory/ username@to_host:/remote/directory/`
 
Copy file from remote host to remote host SCP example:
`$ scp username@from_host:/remote/directory/file.txt username@to_host:/remote/directory/`

SCP options:

–r Recursively copy entire directories. Note that this follows symbolic links encountered in the tree traversal.

-C Compression enable. Passes the -C flag to ssh to enable compression.

-l limit – Limits the used bandwidth, specified in Kbit/s.

-o ssh_option – Can be used to pass options to ssh in the format used in ssh_config.

-P port – Specifies the port to connect to on the remote host. Note that this option is written with a capital ‘P’.

-p Preserves modification times, access times, and modes from the original file.

-q Quiet mode: disables the progress meter as well as warning and diagnostic messages from ssh.

-v Verbose mode. Print debugging messages about progress. This is helpful in debugging connection, authentication, and configuration problems.

