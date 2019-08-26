# Lệnh `rsync`
- Là lệnh dùng để sao lưu dữ liệu mạnh mẽ. là một công cụ dùng để sao chép và đồng bộ file/thư mục được dùng rất phổ biến. Với sự trợ giúp của rsync, bạn có thể đồng bộ dữ liệu trên local hoặc giữa các server với nhau một cách dễ dàng.
- Có hai cách khác nhau để `rsync` liên hệ với hệ thống từ xa: sử dụng chương trình shell từ xa làm phương tiện vận chuyển (như ssh hoặc rsh) hoặc liên hệ trực tiếp với daemon rsync qua TCP. Vận chuyển shell từ xa được sử dụng bất cứ khi nào đường dẫn nguồn hoặc đích chứa một dấu hai chấm đơn (:) sau một đặc tả máy chủ. Liên hệ trực tiếp với daemon rsync xảy ra khi đường dẫn nguồn hoặc đích chứa dấu hai chấm (: :) sau thông số máy chủ, HOẶC khi URL rsync: // được chỉ định (xem thêm "SỬ DỤNG TÍNH NĂNG RSYNC-DAEMON VIA A TỪ XÁC- SHELL KẾT NỐI "phần ngoại lệ cho quy tắc sau này).
- **Câu lệnh căn bản của rsync **:`rsync options source destination`
- Trong đó:
- **source**: là dữ liệu nguồn
- **option**:là các tùy chọn
- **destination**:là dữ liệu đích
- **Các tùy chọn**
- `-v`: Hiển thị trạng thái kết quả
- `-r`:copy dữ liệu recursively, nhưng không đảm bảo thông số của file và thư mục
- `-a`:cho phép copy dữ liệu recusively và dữ nguyên các thông số của thư mục và file 
- `-z`:nén dữ liệu transfer, tiết kiệm bằng thông nhưng tốn thời gian
- `-h`:human-readable output kết quả để đọc
- `--delete`: xóa dữ liệu ở destination nếu source không có dữ liệu
- `--exclude`: loại trừ những dữ liệu không muốn truyền đi nếu ta cần loại ra nhiều file hoặc nhiều folder ở nhiều đường đẫn khác nhau thì mỗi loại phải thêm một `--exclude` tương ứng
**Ví dụ**: Copy thư mục rpmpkgs trong thư mục root xem /tmp/backups/ trên local:
- `rsync -avzh /root/rpmpkgs /tmp/backups/`
- `rsync -avzh /root/rpmkgs /tmp/backups1/`
**Ví dụ**: copy thư mục rpmpkgs lên server vào thư mục home
- `rsync -avzh rpmpkgs/ root@192.168.21.145:/home/
# rsnapshot
-  Rsnapshot là một giải pháp sao lưu gọn nhẹ và cực kỳ đơn giản, nó tạo sự luân phiên backup các thư mục local hoặc điều khiển từ xa. Đây là một bản sao lưu bonus được tạo ra bằng cách sử dụng Hardlinks* để giảm không gian lưu trữ trên host. Cũng như nhiều giải pháp sao lưu khác, rsnapshot là một script được xây dựng trên nền tảng OpenSSH và Rsync – sau này được sử dụng để đồng bộ hóa nội dung thư mục mà không cần sử dụng quá nhiều băng thông. Trước đây nó được dùng để đảm bảo thông tin liên lạc được mã hóa và an toàn.
- Là phương pháp sao lưu tự động cho máy chủ linux
- Cài đặt `rsnapshot`
- Bằng lệnh `sudo apt-get install rsnapshot`.Sau khi cài đặt ta mở tập tin `/etc/rsnapshot.conf` bằng trình soạn thảo `vim` và thực hiện các chỉnh sửa phhù hợp
# Lệnh  `tar`
- Là lệnh nén và giải nén file trên linux
**cú pháp**: `tar <operation> [option]`
  
**option**
- `-c` tạo file nén .tar
- `-x` bung file nén .tar
- `-v` shơw quá trình nén hoặc giải nén ra màn hình
- `-f`: chỉ định nén thành file
- `-t` xem dữ liệu trong file nén
- `-j` tạo file nén trong bzip2 có định dạng file.tar.bz2
- `-z` tạo file nén có gzip có định dạng file.tar.gz
- `-r` thêm một file vào file nén đã tồn tại

- Nếu cùng một dữ liệu thì .tar.bz2 có tỉ lệ nén cao nhất rồi đến tar.gz cuối cùng là tar.

## Lệnh `dd`
- Câu lệnh `dd` trong linux là một trong những câu lệnh thường xuyên được sử dụng. Câu lệnh dd dùng để sử dụng trong các trường hợp sau:
- Sao lưu và phục hồi toàn bộ dữ liệu ổ cứng hoặc một partition
- Chuyển đổi định dạng dữ liệu từ ASCII sang EBCDIC hoặc ngược lại
- Sao lưu lại MBR trong máy (MBR là một file dữ liệu rất quan trong nó chứa các lệnh để LILO hoặc GRUB nạp hệ điều hanh)
- Chuyển đổi chữ thường sang chữ hoa và ngược lại
- Tạo một file với kích cơ cô định
- Tạo một file ISO
*cú pháp*: `dd if=<địa chỉ đầu vào> of=<địa chỉ đầu ra> [option]`
- Trong đó :
-*if*:là địa chỉ nguồn dữ liệu nơi nó bắt đầu đọc
-*of*:viết đầu ra của file
-*option*:tùy chọn các câu lệnh
- `bs`: quá trình đọc ghi bao nhiêu byte một lần đọc
- `cbs`: quá trình chuyển đổi bao nhiêu byte một lần
- `count`:thực  hiện bao nhiêu block trong quá trình thực thi câu lệnh
- `if` : đường dẫn đọc đầu vào
- `of`: đường dẫn ghi đầu ra
- `ibs`: chỉ ra số byte mỗi lần đọc
- `obs`:chỉ ra số byte mỗi lần ghi
- `skip`: bỏ qua bao nhiêu block đầu vào
- `conv`: chỉ ra các tác vụ cu thể của câu lệnh 

 **Trong `conv` còn có các tùy chọn**
 -`ascii`: Chuyển đôi từ mã EBCDIC sáng ASCII
 - `ebcdic` : Chuyển đổi từ mã ASCII sang EBCDIC
 - `lcase`: chuyển đổi từ chữ thường sáng chữ in hoa
 - `ucase`: chuyển đổi từ chữ hoa sang chưx thường
 - `nocreat`: không tạo ra file đầu ra
 - `noerror` : tiếp tục sao chép dữ liệu khi đầu vào bị lỗi
 - ` sync`: đồng bộ dữ liệu với ổ đang sao chép sang
**Ví dụ**: sao lưu toàn bộ dữ liệu tf ổ cứng sáng ổ cứng khác `#dd if=/dev/sda of=/dev/sdb conv=noerror,sync`
