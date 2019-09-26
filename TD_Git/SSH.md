# SSH 

### SSH hay còn gọi là Secure Shell là phương thức thiết lập đường truyền kết nối từ xa một cách an toàn. SSH gồm 2 phương thức xác thực cơ bản 

#### SSH Password Authentication

   > Để bật xác thực bằng mật khẩu cho SSH, cần cấu hình trên server đích 
   
   - Sử dụng command: `vim /etc/ssh/sshd_config`
   
   - Tìm kiếm line Password Authentication, sửa `no` thành `yes`. Lưu lại và chạy `service ssh restart` để restart dịch vụ
   
        ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/15.png)
   
   > Nhưng lưu ý khi bật xác thực bằng mật khẩu, sẽ xảy ra một trường hợp đó là ssh vào Server bị từ chối, lý do là user đó không được quyền, vì vậy ta chuyển sang bước xác thực password với root user
   
   *Mặc định login bằng root user sẽ bị disable, ta cần bật chức năng login bằng root lên* 
   
   - Vẫn trong /etc/ssh/sshd_config, tìm kiếm line PermitRootLogin, sửa từ `prohibit-password` thành `yes`. Lưu lại và chạy `service ssh restart`
   
        ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/16.png)
   
   - Login vào bằng root:
   
      Sử dụng command: `ssh root@server`
        
        ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/17.png)
   
#### SSH Key Authentication

   > Phương thức này cho phép giữa client và server khởi tạo một phiên kết nối dựa vào khóa công khai được chia sẻ từ client tới server
   
   > Đứng tại client, ta cần sinh public key và push nó lên server
   
   - Sử dụng command: `ssh-keygen`
   
   - Sau đó các key sẽ xin đường dẫn để lưu, ta chọn đường dẫn cho nó. Mặc định là ~/.ssh/
   
   - Sau khi sinh public key, ta thực hiện push nó lên server, sử dụng command: `ssh-copy-id -i ~/.ssh/id_rsa.pub root@server` 
   
   - SSH thành công, set Password Authentication thành `no`
   
        ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/18.png)
   

#### SSH Forward agent
      
   - Bình thường hàng ngày các sysadmin thường sử dụng phương pháp Key Authentication kết hợp với một passphrase giúp cho việc đăng nhập trở nên bảo mật hơn so với chỉ sử dụng password. Nhưng với số lượng server lớn mỗi lần đăng nhập vào một server là một lần phải gõ passphrase chưa kể nếu đặt passphrase phức tạp thì tỉ lệ gõ sai hoặc lại phải gõ lại. Trong tình huống này thì ssh-agent được sinh ra để giải quyết các vấn đề này.
   
   - Với mỗi session, ta chỉ cần gõ passphrase một lần sau đó ssh-agent sẽ lưu lại passphare trong một biến môi trường cho những lần đăng nhập sau và tự động điền vào mỗi khi có yêu cầu nhập passphrase. Thông tin này chỉ duy nhất được lưu trong phiên hiện tại, kết thúc phên nó sẽ bị xóa.
   
   - Để sử dụng ssh-agent ta làm như sau:
   
      - Start ssh-agent: `ssh-agent $SHELL`. Trong trường hợp sử dụng bash shell có thể dùng `ssh-agent bash`
      - Import ssh private key vào ssh-agent: `ssh-add <path_to_private_key>`
      
         ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/19.png)
      - Lần sau trong phiên hiện tại bất kể lúc nào sử dụng key kia để đăng nhập thì ta không cần gõ thêm passphrase lần nữa.
      
### Generating SSH config file

   - System-wide OpenSSH config file client configuration
   
      `/etc/ssh/ssh_config` : File này thiết lập những cấu hình mặc định cho tất cả những user của các OpenSSH client trên máy desktop và tất cả user trên hệ thống đều đọc được file này.
   - User-specific OpenSSH file client configuration
   
      `~/.ssh/config` hay `$HOME/.ssh/config` : đây là file cấu hình riêng biệt của user, nó sẽ  ghi đè các settings trong global client configuration file, `/etc/ssh/ssh_config`.
   - Tại sao cần tạo SSH custom configuration file? Ta xét ví dụ: Giả sử ta phải thiết lập ssh với setup như sau
      - Local desktop client – Apple OS X or Ubuntu Linux.
      - Remote Unix server – OpenBSD server running latest OpenSSH server.
      - Remote OpenSSH server ip/host: 75.126.153.206 (server1.cyberciti.biz)
      - Remote OpenSSH server user: nixcraft
      - Remote OpenSSH port: 4242
      - Local ssh private key file path : `/nfs/shared/users/nixcraft/keys/server1/id_rsa`
      
      Thông thường ta sẽ phải nhập :`ssh -i /nfs/shared/users/nixcraft/keys/server1/id_rsa -p 4242 nixcraft@server1.cyberciti.biz` nên sẽ rất dài và khó chịu.
      
      Chúng ta có thể tránh được cảnh gõ cả đống tham số trên lệnh ssh khi đang logging tới một remote machine hoặc khi thực thi commands trên một remote machine. Tất cả những gì chúng ta cần làm là tạo một ssh config file. 
   - Các entry trong `~/.ssh/config`:
      - Host : Định nghĩa host mà config sẽ áp dụng. Phần cấu hình host sẽ kết thúc khi một cấu hình host khác được định nghĩa hoặc kết thúc file. Dấu * được sử dụng để cấp global defaults cho mọi hosts.
      - HostName : Xác định host name thực tế để log in, được phép thay bằng IP
      - User : Định nghĩa username cho SSH connection
      - IdentityFile : Xác định file mà các phương thức xác thực danh tính của user như DSA, ECDSA hoặc DSA sẽ được đọc. Mặc định là `~/.ssh/identity` với giao thức version 1, và `~/.ssh/id_dsa`, `~/.ssh/id_ecdsa`, `~/.ssh/id_rsa` cho giao thức version 2.
      - ProxyCommand : Xác định lệnh cụ thể dùng để kết nối tới server. Command sẽ tiếp tục được khai báo đến khi xuống dòng, và được thực thi bởi user’s shell. Trong command ấy, `%h` sẽ được thay thể bởi host name để kết nối, `%p` bởi port, và `%r` bởi remote user name. 
      - LocalForward : Xác định một port TCP trong local machine sẽ được forward qua một kênh truyền bảo mật tới một host cụ thể và port của remote machine. Mệnh đề đầu tiên là [bind_address:] port và mệnh đề thứ hai là host:hostport.
      - Port : Xác định port number để connect tới the remote host.
      - Protocol : Xác định phiên bản giao thức mà ssh(1) hỗ trợ để ưu tiên. Giá trị là 1 và 2.
      - ServerAliveInterval : Sets timeout interval theo giây sau khi không có dữ liệu được nhận từ server, ssh(1) sẽ gửi một thông điệp thông qua kênh truyền đã mã hóa để yêu cầu phản hồi từ server.
      - ServerAliveCountMax : Sets số lượng tin nhắn còn sống của máy chủ có thể được gửi đi mà không cần ssh(1) nhận phản hồi từ server. Nếu khi gửi tin nhắn còn sống của máy chủ mà đạt ngưỡng này thì ssh sẽ disconnect từ server, kết thúc session.
