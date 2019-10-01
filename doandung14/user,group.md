**Quản lý User và Group**
   
   1. Quản lý user:

Các file lưu thông tin:
    
    • User: /etc/passwd
    
    • Pass: /etc/shadow

Cat /etc/passwd 

hungtn:x:1000:1000:hungtn:/home/hungtn:/bin/bash

chú thích: 
   
   • hungtntên login
   
   • x: pass chứa trong file shadow
   
   • 1000: id của user (mạc định uid của user do file login default quyết định: /etc/login.defs  cụ thể dòng 33,34    “UID_MIN                  1000” sửa lại dòng này rồi thử tạo user mới và kiểm tra uid)
   
   • 1000: gid (primary group: mạc định tạo ra 1 primary group trùng tên với user và user nằm trong nhóm này luôn)
   
   • Hungtn (-c) comment: mô tả cho user hay tên hiển thị của user ở cửa sổ login
   
   • /home/hungtn: thư mục profile của user (trong thư mục này chứa các thư mục con vd như .bash_profile  .bashrc… các thư mục này lấy từ thư mục mẫu  /etc/skel
   
   • /bin/bash: kiểu shell mà user dung sau khi tạo 

Cat /etc/shadow

hungtn:$6$aybJQ2vZ4ZTl.qUq$VeyEqQaf9tp2ZZlTJiagsWxjosgxL7V8nTZMV7PaZrbYh2TCy9Nt2L92e31Nrqot.UHjY7MwsfRkiilH0nsEl1:17516:0:99999:7:::

chú thích:
   
   • hungtn: tên user
   
   • :$6$aybJQ2vZ4ZTl.qUq$VeyEqQaf9tp2ZZlTJiagsWxjosgxL7V8nTZMV7PaZrbYh2TCy9Nt2L92e31Nrqot.UHjY7MwsfRkiilH0nsEl1 password của user được mã hóa sha512 . dong 71 của file /etc/login.defs  hoặc dung lệnh xem: authconfig --test | grep hashing ; dung lệnh đổi: authconfig --passalgo=sha512 --update
   
   • 17516: số ngày thay đổi pass lần cuối tính từ thời điểm đổi đến 1/1/1970
   
   • 0: số ngày tối thiểu để sau đó được đổi pass.: VD đặt là 1 cho user u1: chage -m 1 u1 sau đó su về u1 hay login vào u1 và thực hiện đổi pass thành Hungtn@qwe thì ko thành công (trước đó giá trị này bằng 0 thì đổi OK) Nếu set giá trị này cho các user mới thì /etc/login.defs sửa lại.
   
   • 99999: số ngày tối đa dung passsau đó phải đổi lại pass mới. chage -M 111 u1. Cho các user mới thì vào file /etc/login.defs sửa lại)
   
   • 7: warning: trước khi hết hạn pass 7 ngày nó sẽ cảnh báo người dung là pas sắp hết hạn
   
   • 7: inactivesau khi hết hạn pass 7 ngày user sẽ bị khóa, mạc định là khóa luôn vì trường này không được set.
   
   • Trường “:” tiếp theo thì chưa dung

Còn nhiều policy cho pass nữa VD:

Pass không chứa các từ khóa trong list:

vi /etc/security/pwquality.conf 

them dòng vào cuối file: badwords = Hungtn@qwe

Sau đó tạo user u1 và su u1 để u1 đổi pass sang Hungtn@qwe thì ko được, nhưng Vietlq@qwe thì OK

Lệnh tạo Users: useradd

-u UID user ID (default: next available number)

-g GID default (primary) group ( mặc định tạ group cùng tên với user )

-c comment Mô tả về user ( default: blank )

-d directory Đường dẫn home directory ( default /home/username )

-m Tự tạo home directory

-k skel_dir Thư mục chứa template mẫu ( default /etc/skel )

-s shell login shell ( default /bin/bash )

VD: useradd -u 1100 -c "Le Quoc Viet" -m -d /vietlq -s /bin/bash vietlq

Với lệnh trên sẽ tạo ra user Vietlq với uid 1100 và profile của user /vietlq (default cái này là /home/vietlq) kiểu shell user dung là bash

Muốn thay đổi profile thì chown cho user trong thư mục profile đó 

Usermod -d /u1 u1

Chown u1:u1 /u1

Hoặc: usermod -m -d /data u1

Thuộc tính: Usermod

# usermod –g users –c “Ngoc Hung” hungtn

# usermod –u 1234 –s /bin/sh hungtn #change id

# usermod –f 10 hungtn #disable tài khoản sau 10 ngày kể từ khi password hết hạn

# usermod –e 2018-2-20 hungtn #expire_date

# usermod –L hungtn #lock user

# usermod –U hungtn #unlock user

Usermod -G IT u1  add user vào nhóm

Xóa user: userdel

Userdel -r “username”

Tìm và xóa file user:

# find / -user hungtn -type f -exec rm -f {} \;

# find / -user hungtn -type d -exec rmdir {} \;

Set các policy default cho các user khi tạo mới
thì vào /etc/login.defs Set cho các user đã tồn tại rồi

chage [options] <user>     set cho từng user

Options:

-m <mindays> Minimum days

-M <maxdays> Maximum days

-d <lastdays> Day last changed  thay đổi mốc time từ 1/1/1970 change time

-I <inactive> Inactive lock, sau khi mật khẩu hết hạn bao lâu sẽ lock tài khoản.

-E <expiredate> Expiration (YYYY-MM-DD or MM/DD/YY)

-W <warndays> Warning days

2. Quản lý Group:

2 file lưu thông tin:

• /etc/group thông tin group

• /etc/shadow thông tin passwd group

Tạo group: Groupadd

• groupadd IT

Lệnh sửa thông tin: Groupmod 

• groupmod -n newname -g gid groupname  đổi gid và name

Lệnh gpasswd

Gpasswd(đặt pass cho group để mượn tạm quyền và giấy phép của nhóm, add thành viên, add nhiều thành viên

Gpasswd -a hungtn IT  add them hungtn vào nhóm IT

Gpasswd -d hungtn IT Xóa hungtn khởi nhóm IT

Gpasswd IT  pass cho IT

Gpasswd -r IT  xóa pass cho nhóm IT

Gpasswd -M u1,u2,u3 IT  add nhiều thành viên


Groupdel: Groupdel IT
