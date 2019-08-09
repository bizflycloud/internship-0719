### Understand ‘cat’, ‘join’, ‘paste’ command

**cat command**

1.dùng cat để hiện nội dung câu lệnh: `cat file`

2. dùng cat để gộp 2 nội dung của 2 file vào chung 1 file: `cat file1.txt file2.txt > file3.txt`

3.tìm thêm các option của cat : `cat --help`

**join command**

Để kết hợp hai tệp trên một trường chung: `join file1 file2` (lưu ý là lệnh join sẽ không bị lặp giữ liệu)

**paste command**

để kết hợp 2 tệp trên 1 trường chung: `paste file1 file2`

### Use ‘tac’, ‘sort’, ‘split’, ‘uniq’, ‘nl’

**tac command**

tương tự như cat command nhưng hiện thị ngược về trình tự nội dung

**sort command**

Dùng để sắp xếp văn bản: `sort [OPTION]... [FILE]..`

Sort hỗ trợ loại bỏ các text trùng lặp với optiopn uniq (Lệnh uniq dùng để bỏ các dòng liên tiếp trùng lặp trong một tệp văn bản rất hữu ích để đơn giản hóa hiển thị văn bản): `sort file1 file2 | uniq > file3`

**split command**

Lệnh split sử dụng để chia (hoặc tách) một tệp thành các phân đoạn có kích thước bằng nhau để xem và thao tác dễ dàng hơn và thường chỉ được sử dụng trên các tệp tương đối lớn. Theo mặc định, lệnh split tệp thành các phân đoạn 1000 dòng. Tệp gốc không thay đổi và một tập hợp các tệp mới có cùng tên cộng với tiền tố được thêm vào được tạo. Theo mặc định,tiền tố x được thêm vào. Để chia một tập tin thành các phân đoạn, sử dụng lệnh split infile.

syntax: `split infile <Tiền tố>`

**nl command**

Lệnh nl dùng để đánh số dòng trong 1 tệp: `nl [OPTION]... [FILE]...`

**head, tail command**

Xem nhanh 5 dòng đầu tiên với lệnh head:

syntax: `cat /etc/profile | head -n 5 > file1.txt`

Xem nhanh 5 dòng cuối với lệnh tail:

syntax: `cat /etc/profile | tail -n 5 > file1.txt`

**less command**

Xem nội dung file với lệnh less 

syntax: `less /etc/securetty`

Các phím thao tác trong khi mở file với less:

- SPACE BAR: để qua một trang khác

- ESC + V: để lùi lại một trang

- /<keyword> : để tìm kiếm theo từ khóa (case sensitive), nhấn n để di chuyển con trỏ đến kết quả tìm kiếm tiếp theo.

- g<line number>: để đi đến dòng mình muốn.

- q: để thoát khoi chương trình

**cut command**

Trích xuất đoạn text mong muốn với lệnh cut ( có thể phân biệt qua các kí tự như . / ....)

syntax: `cut OPTION... [FILE]...`

cut có rất nhiều option đáng chú ý 

ví dụ như

1. Select Column of Characters ( chọn cột muốn cut ra ): `cut -c2 test.txt`

2. Select Column of Characters using Range( chọn 1 khoảng muốn cut ):`cut -c1-3 test.txt`

3. Select Column of Characters using either Start or End Position: `cut -c3- test.txt` ( bắt đầu cut từ kí tự thứ 3 )

4. Select a Specific Field from a File ( chọn ra môi trường cụ thể phân cách bởi các kí hiệu ): `cut -d':' -f1 /etc/passwd`

5. Select Multiple Fields from a File : `grep "/bin/bash" /etc/passwd | cut -d':' -f1,6`

6. Select Fields Only When a Line Contains the Delimiter( chỉ chọn các trường khi 1 dòng chứa dấu phân cách):`grep "/bin/bash" /etc/passwd | cut -d'|'  -f1`

If -d option is used then it considered space as a field separator or delimiter

– complement: As the name suggests it complement the output. This option can be used in the combination with other options either with -f or with -c....


**wc command**

lệnh wc sẽ đếm các từ, dòng mới hoặc byte của mỗi tệp đầu vào và đưa ra kết quả

syntax: wc [OPTION]... [FILE]...

**grep command**

Grep là 1 lệnh hữu ích để ta tìm kiếm các file có chứa chuỗi mong muốn và trả về kết quả là tên file và (nếu là text file) dòng chứa chuỗi mà ta tìm. Lưu ý là mặc định grep biên dịch theo basic regex. Công thức cơ bản của grep:

`grep [options] regex [files]`

Các option phổ biến của grep:

- f file : lấy các chuỗi mong muốn từ 1 file khác thay vì nhập từ dòng lệnh.

- i: (ingnore case) tức không quan trọng viết in hoa hay chữ thường.

- r: (recursive) giúp tìm kiếm trong các thư mục con.

- F: (fixed string) dùng khi bạn mún tìm kiếm đơn thuần không dùng đến regex, như vậy các ký tự đặc biệt như $, *, . sẽ được hệ thống xem như 1 ký tự đơn thuần không phải là regex.

- E: (extend regex) vì Regular Expression được chia làm 2 loại: basic và extend. Mặc điịnh grep. Trong basic regex các ký tự ‘?’, ‘+’, ‘{’, ‘|’, ‘(’, và ‘)’ mất đi hiệu lực, để sử dụng ta thêm dấu escaping ở đằng trước: ‘?’, ‘+’, \‘{’, ‘|’, ‘(’, và ‘)’

**sed command**

Lệnh sed thay đổi trực tiếp nội dung, gửi những nội dung đã thay đổi ra stdout. Công thức của sed có 2 dạng:

sed [options] -f script-file [input-file] sed [options] script-text [input-file]

Trong đó:

input-file là tên file bạn muốn chỉnh sửa (Thay đổi chỉ mang tính chất tạm thời), script-text (hoặc nội dung trong script-file) là 1 dãy các lệnh mà bạn muốn sed thực hiện

- Một số câu lệnh hay dùng

1. Viewing a range of lines of a document(xem 1 loạt các dòng trong tệp): `sed -n '5,10p' myfile.txt`(câu lệnh này sẽ trả về từ dòng 5 đến 10)

2. Viewing the entire file except a given range(xem toàn bộ tệp ngoại trừ 1 số phạm vi nhất định): `sed '20,35d' myfile.txt`(loại trừ các dòng từ 20 đến 35)

3. Viewing non-consecutive lines and ranges(xem các dòng và phạm vị k liên tiếp): `sed -n -e '5,7p' -e '10,13p' myfile.txt`

4. Replacing words or characters (thay thế các từ hoặc kí tự):`sed 's/version/story/g' myfile.txt`

5. Replacing words or characters inside a range(thay thế từ hoặc kí tự trong 1 phạm vi): `sed '30,40 s/version/story/g' myfile.txt` 

6. Inserting spaces in files(chèn khoảng trắng vào tệp): `sed G myfile.txt`

**awk command**

AWK là một ngôn ngữ lập trình. Nó có thể xử lý các tác vụ liên quan đến text phức tạp chỉ với một vài dòng code. AWK là một ngôn ngữ lập trình thông dịch. Nó được thiết kế đặc biệt và mạnh mẽ cho việc xử lý text. Nó được ứng dụng để xử lý text với các file .txt, .csv với kích thước lên tới GB, các thao tác như đọc file, ghi chép theo dòng, cột,.. một cách nhanh chóng. AWK có thể sử dụng một shell scripting trong Ubuntu, có thể chạy dưới định dạng .sh

syntax: `awk [options] file ...`

Ví dụ muốn in ra cột 3 và cột 4 của file ta sử dụng lệnh sau:

`awk '{print $3 "\t" $4}' marks.txt`

- Sử dụng biến

Với awk, bạn có thể xử lý tệp văn bản. Awk gán một số biến cho từng trường dữ liệu được tìm thấy:

$ 0 cho toàn bộ dòng.

$ 1 cho trường đầu tiên.

$ 2 cho trường thứ hai.

$ n cho trường thứ n.

ARGC     Retrieves the number of passed parameters.(lấy các tham số đã truyền)

ARGV     Retrieves the command line parameters.( lấy tham số các dòng lệnh)

ENVIRON     Array of the shell environment variables and corresponding values.(Mảng của các biến môi trường shell và các giá trị tương ứng.)

FILENAME    The file name that is processed by awk

NF     Fields count of the line being processed.( Các lĩnh vực đếm của dòng đang được xử lý)

NR    Retrieves total count of processed records.(Lấy tổng số hồ sơ được xử lý.)

FNR     The record which is processed.(bản ghi đc xử lí)

IGNORECASE     To ignore the character case.

- Formatted Printing

c              Prints numeric output as a string.

d             Prints an integer value.

e             Prints scientific numbers.

f               Prints float values.

o             Prints an octal value.

s             Prints a text string.

**ps**

List All Processes in Current Shell:`ps`

Print All Processes in Different Formats(in tất cả quy trình với định dạng khác nhau):`ps -e` OR `ps -A`

Display all processes in BSD format(hiển thị tiến trình ở dạng BSD):`ps au` OR `ps axu`

Display User Running Processes: `ps -x`

Print All Processes Running as Root:`ps -U root -u root`

Display Group Processes: `ps -fG apache OR ps -fG 48`

Display Processes by PID and PPID:`ps -fp 1178` and `ps -f --ppid 1154`

Print Security Information: `ps -eM` OR `ps --context`

**top**

Câu lệnh top là một phương thức cổ điển nhất để bạn xem việc chiếm dụng tài nguyên hệ thống, và xem những tiến trình nào chiếm dụng tài nguyên nhiều nhất. Những tiến trình chiếm dụng CPU nhiều nhất sẽ được liệt kê đầu tiên

jobs: liệt kê danh sách các nhiệm vụ đang chạy

&: với việc sử dụng từ khóa này khi kết thúc câu lệnh, một chương trình có thể bắt đầu trong background thay vì foreground như mặc định.

fg <job_number>: dùng để đưa một chương trình background trở thành chương trình foreground.

Ctrl+z: ngược lại với fg, đưa một chương trình foreground trở thành chương trình background.

**htop**

là phiên bản cải thiện của top

Ý nghĩa từng cột giá trị như sau:

- PID: Số PID của tiến trình. Mỗi tiến trình sẽ có PID riêng

- USER: Chủ sở hữu tiến trình

- PRI: Độ ưu tiên của tiến trình. Số càng thấp thì mức độ ưu tiên càng cao

- NI: Giá trị nice value của tiến trình, ảnh hưởng đến độ ưu tiên của tiến trình đó

- VIRT: Bộ nhớ ảo đang được sử dụng cho tiến trình

- RES: Bộ nhớ RAM vậy lý đang được sử dụng, đo bằng kylobytes

- SHR: Bộ nhớ chia sẻ mà tiến trình đang sử dụng

- S: Trạng thái hiện tại của tiến trình (zombied, sleeping, running, uninterruptedly sleeping, traced)

- % CPU: Phần trăm tài nguyên CPU đang được tiến trình sử dụng

- % MEM: Phần trăm bộ nhớ RAM đang được tiến trình sử dụng

- TIME +: Thời gian bộ xử lý mà tiến trình đã sử dụng

- COMMAND: Tên lệnh bắt đầu tiến trình

- Di chuyển dấu nhắc trong danh sách các tiến trình theo chiều dọc hoặc ngang bằng phím mũi tên

- Kill mộ tiến trình bằng cách nhấn phím F9

- Renice một tiến trình bằng cách nhấn phím F7 hoặc F8

- Liệt kê các tập tin được sử dụng bởi một tiến trình bằng cách nhấn phím I

- Chỉ hiển thị tiến trình của một người dùng bằng cách nhấn phím U

- Hiển thị các tiến trình được sắp xếp theo một cột bất kỳ bằng cách nhấn phím F6

- Hiển thị các tiến trình trong chế độ xem dạng cây bằng cách nhấn phím F5

**Foreground Processes**

Theo mặc định, mọi tiến trình mà bạn bắt đầu chạy là Foreground Process. Nó nhận input từ bàn phím và gửi output tới màn hình.

Tiến trình chạy trong Foreground, kết quả của nó được hướng trực tiếp trên màn hình của tôi và nếu lệnh ls muốn bất kỳ đầu vào nào, nó đợi từ bàn phím.

Trong khi một chương trình đang chạy trong Foreground và cần một khoảng thời gian dài, chúng ta không thể chạy bất kỳ lệnh khác (bắt đầu một tiến trình khác) bởi vì dòng nhắc không có sẵn tới khi chương trình đang chạy kết thúc tiến trình và thoát ra.

**Background Processes**

Background Process chạy mà không được kết nối với bàn phím của bạn. Nếu tiến trình Background yêu cầu bất cứ đầu vào từ bàn phím, nó đợi.

Lợi thế của chạy một chương trình trong Background là bạn có thể chạy các lệnh khác; bạn không phải đợi tới khi nó kết thúc để bắt đầu một tiến trình mới!

Cách đơn giản nhất để bắt đầu một tiến trình Background là thêm dấu và (&) tại phần cuối của lệnh:`ls ch*.doc &`

**kill**

- câu lệnh dùng để tắt các tiến trình, bằng cách cung cấp PID của chúng. PID này có thể lấy được từ lệnh ps -A hoặc pgrep

- sd lệnh pgrep để tìm PID của 1 tiến trình trên hệ thống. vd muốn tìm PID của firefox:`pgrep firefox`

- pkill & killall

2 câu lệnh này cho phép bạn kill tiến trình bằng cách cung cấp tên của chúng

pkill firefox

killall firefox

**fsck command**

Dùng để sửa file hệ thống bị lỗi trong linux

-Option:

- A- Được sử dụng để kiểm tra tất cả các hệ thống tập tin. Danh sách được lấy từ / etc / fstab

- C – Hiển thị thanh tiến trình.

- l – Khóa thiết bị để đảm bảo không có chương trình nào khác sẽ cố gắng sử dụng phân vùng trong quá trình kiểm tra.

- M – Không kiểm tra mounted filesystems.

- N – Chỉ hiển thị những gì sẽ được thực hiện - không có thay đổi thực tế được thực hiện.

- P – Nếu bạn muốn kiểm tra các hệ thống tập tin song song, bao gồm cả root.

- R – Không kiểm tra hệ thống tập tin gốc. Điều này chỉ hữu ích với‘-A‘.

- r – Cung cấp số liệu thống kê cho từng thiết bị đang được kiểm tra.

- T – Không hiển thị tiêu đề.

- t – Chỉ định riêng các loại hệ thống tập tin sẽ được kiểm tra. Các loại có thể được phân tách bằng dấu phẩy.

- V – Cung cấp mô tả những gì đang được thực hiện.

Để chạy fsck, bạn sẽ cần đảm bảo rằng phân vùng bạn sẽ kiểm tra không được mount

Hiẻu mã của fsck

0      No errors

1      Filesystem errors corrected

2      System should be rebooted

4      Filesystem errors left uncorrected

8      Operational error

16     Usage or syntax error

32     Checking canceled by user request

128    Shared-library error

**du command**

Lệnh du (Sử dụng đĩa) là một lệnh Unix / Linux tiêu chuẩn, được sử dụng để kiểm tra thông tin sử dụng đĩa của các tệp và thư mục trên máy. Lệnh du có nhiều tùy chọn tham số có thể được sử dụng để nhận kết quả ở nhiều định dạng. Lệnh du cũng hiển thị các tệp và kích thước thư mục.

-Option 

- Sử dụng tùy chọn -h của lệnh du để hiển thị thông tin người đọc có thể dễ dàng đọc được Có nghĩa là bạn có thể thấy kích thước tính theo Byte, Kilobytes, Megabyte, Gigabyte, v.v.

- Sử dụng -A với lệnh du hiển thị việc sử dụng đĩa của tất cả các tệp và thư mục.

- Sử dụng -ah hiển thị mức độ sử dụng đĩa của tất cả các tệp và thư mục ở định dạng dễ đọc của con người. Đầu ra dưới đây dễ hiểu hơn vì nó hiển thị các tệp trong Kilobytes, Megabyte, v.v.

- Find out the disk usage of a directory tree with its subtress in Kilobyte blcoks. Use the “-k” (displays size in 1024 bytes units).

- Để có được bản tóm tắt về việc sử dụng đĩa của cây thư mục cùng với các cây con chỉ bằng Megabyte (MB). Sử dụng tùy chọn -mh . -m đếm các khối theo đơn vị MB và -h là viết tắt của định dạng con người có thể đọc được

- Hiển thị mức sử dụng đĩa dựa trên việc sửa đổi thời gian, sử dụng -time

**df command**

lệnh df trên linux sẽ giúp báo cáo về dung lượng đang sử dụng của các phân vùng ổ cứng, bên cạnh đó có thể xem được cả loại file system của partion hoặc disk với option -T
cú pháp : `df [OPTION]... [FILE]...`

1.Check File System Disk Space Usage:`df`

2.Display Information of all File System Disk Space Usage:`df -a`

3.Show Disk Space Usage in Human Readable Format:`df -h`

4.Display Information of /home File System:`df -hT /home`

5.Display Information of File System in Bytes:`df -k`

6.Display Information of File System in MB:`df -m`

7.Display File System Inodes:`df -i`

8.Display File System Type:`df -T`

9.Include Certain File System Type:`df -x ext3`

**mkfs**

Lệnh mkfs (tức là tạo hệ thống tập tin) được sử dụng để tạo một hệ thống tập tin (tức là hệ thống tổ chức phân cấp các thư mục, thư mục con và tệp) trên thiết bị lưu trữ hoặc phương tiện được định dạng, thường là phân vùng trên ổ đĩa cứng (HDD)



**mount & umount**

1.Mount là để truy cập một hệ thống tập tin trong Linux. Bạn có thể gắn hệ thống tập tin vào bất kỳ thư mục nào và truy cập nội dung bằng cách vào thư mục đó. Theo thuật ngữ Linux, các thư mục này được gọi là điểm gắn kết. Hướng dẫn này sẽ giúp bạn gắn kết và ngắt kết nối hệ thống tập tin trong hệ thống Linux.

- Sử dụng lệnh mount

Hầu hết, mỗi hệ điều hành Linux / Unix đều cung cấp lệnh mount. Lệnh này được sử dụng để gắn bất kỳ hệ thống tập tin trên bất kỳ thư mục. Sau đó, bạn có thể truy cập nội dung hệ thống tập tin.

 `mount [-t fstype] filesystem mountpoint`
 
 2.Sử dụng lệnh umount để ngắt kết nối mọi hệ thống tập tin được gắn trên hệ thống của bạn. Chạy lệnh umount với tên đĩa hoặc tên điểm gắn kết để ngắt kết nối đĩa hiện được gắn

vd: `umount /data`

**fdisk**

1.Xem tất cả phân vùng ổ đĩa trong linux

# fdisk -l

2. Xem phân vùng đĩa cụ thể trong Linux

# fdisk -l /dev/sda

3. Kiểm tra tất cả các lệnh fdisk có sẵn

[root@tecmint ~]# fdisk /dev/sda


4.In tất cả Bảng phân vùng trong Linux

`# fdisk /dev/sda`

5.Cách định dạng phân vùng trong Linux

[root@tecmint ~]# mkfs.ext4 /dev/sda4

6.Cách kiểm tra kích thước của phân vùng trong Linux

`# fdisk -s /dev/sda2`

**RAID**

Một cách định nghĩa cơ bản thì RAID (nhóm các chữ đầu của các từ tiếng Anh sau: Redundant Arrays of Independent Disks) là hình thức ghép nhiều ổ cứng vật lý thành một hệ ổ cứng có chức năng gia tăng tốc độ đọc/ghi dữ liệu hoặc nhằm tăng thêm sự an toàn của dữ liệu chứa trên hệ thống đĩa hoặc kết hợp cả hai yếu tố trên.

- RAID 0 : chia dữ liệu làm 2 ổ để có hiệu năng đọc và ghi tăng lên gấp đôi, tuy nhiên 1 ỗ bị lỗi sẽ làm mất dữ liệu trên cả 2 ổ

- RAID 1: Dữ liệu sẽ cùng 1 lúc đc lưu vào 2 ổ, tốc độ hay dung lượng vẫn là của 1 ổ => 1 phương án backup dữ liệu khi bị lỗi ổ bất ngờ

- Nếu muốn 2 điều trên thì sử dụng RAID 10, khá tốn kém khi phải cần đến 4 ổ

- RAID 5: được hướng đến để bảo vệ dữ liệu, cần tối thiểu 3 ổ , chia dữ liệu vào các ổ và để thừa 1 ổ để backup, tốc độ đọc rất tốt nhưng tốc độ ghi hay thời gian chờ khi 1 ổ bị hỏng là khá lâu 

- RAID 6:Nâng cấp của RAID 5 có 2 ổ để backup dữ liệu,thường đc sd trong hệ thống sao lưu máy chủ

**mdadm**

là tiện ích giúp tạo và quản lí RAID

mdadm có bảy chức năng. Nhưng chỉ có một số thao tác hay được sử dụng là 'create', 'assemble' và 'monitor'.

Create: Tạo một thiết bị RAID mới

Assemble: Tập hợp các thiết bị để tạo RAID.

Follow hay Monitor: theo dõi thiết bị RAID. RAID0 hay Linear không never have missing, spare, hay các ổ đĩa hỏng, vì thế 
ở đây không có gì để theo dõi cả. Thông thường bạn thực hiện thao tác này sau khi khởi động.

Build

Grow : thay đổi kích thước của mảng. Hiện tại nó hỗ trợ thay đổi kích thước cho RAID 1/4/5/6 và thay đổi số thiết bị trong RAID1.

Manage: thực hiện các thao tác với các thành phần của mảng như là thêm ổ đĩa và gỡ bỏ thiết bị sai hỏng.
Misc: thực hiện các thao tác khác như tẩy xóa các superblock cũ, thu thập thông tin.

Từ mềm ở đây ám chỉ sử dụng phần mềm chứ không phải phần cứng, do vậy máy tính của bạn không cần có thiết bị RAID. Sử dụng RAID mềm còn có một lợi thế khác là bạn sử dụng các phân vùng tham gia vào mảng đĩa thay vì sử dụng toàn bộ ổ đĩa, làm cho việc sử dụng nó trở nên linh hoạt.

Cú pháp chung:

`mdadm --create /dev/md0 <chế độ> <tùy chọn> <danh sách các thiết bị tham gia>`

- Chế độ RAID-0

$ mdadm --create --verbose /dev/md0 --level=stripe --raid-devices=2 /dev/sdb2 /dev/sdc2

- Chế độ RAID-1

Chế độ này, hai ổ đĩa có nội dung hoàn toàn giống nhau, do đó độ an toàn cho dữ liệu là rất cao.

`$ mdadm --create --verbose /dev/md0 --level=mirror --raid-devices=2 /dev/sdb1 /dev/sdc1`

`$ mdadm --create --verbose /dev/md0 --level=mirror --raid-devices=2 /dev/sdb1 /dev/sdc1 --spare-devices=1 /dev/sdd1`
--spare-devices: thiết bị dự phòng

- Chế độ RAID-4/5/6

Nếu bạn sử dụng N ổ đĩa (hay phân vùng) và cái nhỏ nhất có kích thước là S, kích thước của toàn bộ mảng ổ đĩa này sẽ là (N-1)*S. Vậy thì nếu bất kỳ một đĩa nào bị hỏng, tất cả dữ liệu vẫn còn. Nhưng nếu hai đĩa cùng hỏng thì dữ liệu sẽ bị mất. Bạn nên sử dụng các ổ đĩa hay phân vùng có cùng kích thước để tránh lãng phí.
Kích thước của mỗi "mảnh" dữ liệu phụ thuộc vào từng mục đích, 32 kB theo mặc định nhìn chung là ổn với các hệ thống thông thường. Những hệ thống có nhiều file nhỏ thì chọn kích thước này nhỏ và ngược lại.

Ví dụ tạo RAID-5:

`mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1 --spare-devices=1 /dev/sde1`

- Lưu lại cấu hình

Tệp tin lưu cấu hình ở tại các vị trí khác nhau tùy thuộc vào từng bản phân phối.

`$ mdadm --detail --scan >> /etc/mdadm/mdadm.conf`

`$ mdadm --detail --scan | tee /etc/mdadm.conf` # chỉ dùng lần đầu

- Quản lý và theo dõi

Theo dõi:

$ mdadm --monitor /dev/md0​

Để quản lý bạn sử dụng --manage.

IV. Sử dụng

1. Bật và tắt mảng đĩa

Xem các mảng đĩa:

$ cat /proc/mdstat​

Tắt một thiết bị RAID dễ dàng theo cách sau:

$ mdadm --stop /dev/md0​

Việc bật chúng lên lại không dễ dàng như vậy, bạn phải sử dụng lệnh --assemble như sau:

$ mdadm --assemble /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1​

Bạn có thể sử dụng file cấu hình là /etc/mdadm.conf để bật chúng lên khi hệ điều hành khởi động như đã nói ở phần trên. Xem manpage để có thêm chi tiết:

$ man mdadm.conf​

Hay có thể dùng:

$ mdadm --assemble --scan​

2. Định dạng

Lệnh đơn giản nhất là:

$ mkfs -t ext3 /dev/md0​











