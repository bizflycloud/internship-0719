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
