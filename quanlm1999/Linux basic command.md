# Linux basic command
#### ls
* **ls**      : Hiển thị danh sách thư mục
* **ls -a**   : Hiển thị tất cả danh sách thư mục, bao gồm cả thư mục ẩn 
* **ls -l**   : Hiên thị chi tiết thông tin của các thư mục (không bao gồm thư mục ẩn )
* **ls -la**  :Hiển thị chi tiết thông t in của tất cả thư mục 
#### cd 
* **pwd** Hiển thị đường dẫn từ root đến thư mục đang làm việc
* **cd <name>** Chuyển sang thư mục khác
* **cd ..** Quay lại 1 thư mục trước đó
* **cd** quay về home
#### folder & file
* **mkdir <name>** Tạo thư mụcđó
* **mkdir <location>** Tạo thư mục tại vị trí khác
* **rm <name>** xóa têp tin/ thư mục
* **rmdir <name** xóa thư mục trống
* **cat <name>** đọc thư mục
* **cat > <name>** tạo thư mục 
* **cat <name1> <name2>** ghép 2 thư mục 
* **mv <name> <location>** Chuyển file sang vị trí khác
* **mv <name> <name1>** Đổi tên file
#### Other
* **man <command>**: Hiển thị manual của command đó
* **passwd** Đổi mật khẩu 
* **info (name)** Hiển thị thông tin của file 
* **apropos** Tìm kiếm thông tin về đối tượng 
* **history** Hiển thị các command đã sử dụng
* **sudo** Cho phép người dùng sử dụng với tư cách là superuser /root
* **clear** Dọn sạch cửa sổ terminal 
#### Stdin,Stdout,Stderr
* **STDIN** Đầu vào chuẩn, dữ liệu được đưa vào  chương trình  
* **STDOUT** Đầu ra chuẩn, dữ liệu  qua chương trình được đưa  kết quả 
* **STDERR** Đầu báo lỗi,đưa thông tin về lỗi 
#### Piping 
* **Redirect** Chuyển hướng Stdin/Stdout từ file sang program khác khác để sử dụng  
* **Piping** Chuyển dữ liệu từ program này sang program khác sử dung ký tự  |  
#### ‘cat’, ‘join’, ‘paste’ command 
**cat** nối file theo chiều dọc
 * **Option** ast
 -E : Xem dòng kết thúc ở đâu
 -n: Đánh số mỗi dòng ( -b) chưc năng tương tự, nhưng ko đánh những dòng trống 
 -s: Gộp nhiều dòng trống thành 1 dòng duy nhất 

**paste** nối file theo chiều ngang 
**join** Giống paste nhưng sử dụng 1 trường chung để nối nhằm hạn chế sai lệch dữ liệu 
#### Use ‘tac’, ‘sort’, ‘split’, ‘uniq’, ‘nl’
**tac** Hiển thị ngược lại từ dưới lên so với **cat**
**sort** Sắp xếp các dòng của văn bản trong theo thứ tự tăng dần/giảm dần / .... 
* **sort <option><file>**
* **option** 
 -f : Bỏ qua viết in hoa
 -n: THeo số
 -r: Đảo ngược thứ tự sắp xếp 
 ...

**split** Lệnh split sử dụng để chia (hoặc tách) một tệp thành các phân đoạn có kích thước bằng nhau để xem và thao tác dễ dàng hơn và thường chỉ được sử dụng trên các tệp tương đối lớn. 
 * lệnh split tệp thành các phân đoạn 1bằng nhau, mặc định là 1000 dòng Tệp gốc không thay đổi và một tập hợp các tệp mới có cùng tên cộng với tiền tố được thêm vào được tạo. Theo mặc định,tiền tố x được thêm vào. Để chia một tập tin thành các phân đoạn, sử dụng lệnh split infile.
Để chia tệp thành các phân đoạn bằng cách sử dụng tiền tố, sử dụng lệnh: split infile <Tiền tố>.

**uniq** Lệnh uniq dùng để bỏ các dòng liên tiếp trùng lặp trong một tệp văn bản 
* **-c** để hiện thị số lượng trùng lặp 

**nl** Đánh số dòng trong file (nl <option> <filename>)
#### ‘head’, ‘tail’, ‘less’, ‘cut’, ‘wc’
**head** Hiển thị ra 10 dòng đầu trên file
* **Option**head -n <số dòng> <filename> để hiện thị n dòng đầu tiên trên file

**tail** Hiện thị ra 10 dòng dưới cùng trên file
* **Option** Tail -n <số dòng><filename> Hiển thị ra n dòng cuối cùng trên file

**less** Hiển thị file theo từng trang, có thể quay lại trang đã đọcbằng phím "b"
* **Option** Cú pháp: cat <filename>| less <option> 
  * -E: kết thúc khi đến trang cuối cùng
  * -i: Tìm kiếm bỏ qua viết hoa 
  * -F: exit nếu như có thể hiển thị cả file trong trang đầu tiên .
  * -s: Các dòng trông liên tiếp được biến thành 1 dòng
  
**cut** cắt nội dung file theo cột 
* **Option** cut <option> <filename>, nếu như không có option sẽ báo lỗi
    * -b: Cắttheo byte
    * -c: cắt theo ký tự
    * cut -d " " -f -1 <filename> giữ lại cột đầu tiên ngăn cách bở dấu phân cách 
**wc** Đém các phần tử trong file 
* **Option** wc <option> <filename>
 - -l: đếm số dòng 
 - -w: đếm số ttừ
 - -c: đếm số byte 
 - -m: đếm số ký tự 

#### ‘grep’, ‘sed’, ‘awk'
**grep** Tìm kiếm các dòng có chứa từ khóa trong file 
* **Option** grep <option> pattern <filename>
* -i tìm kiếm từ trong file nếu bạn không biết kí tự nào là viết hoa hay viết thường -
* -c Đếm số lần xuất hiện của từ tìm kiếm trong file 
* -n hiển thị số dòng củc từ tìm kiếm 
* -v hiển thị các dòng không có chứa từ tìm kiếm trong file 

**sed** Trình soạn thảo văn bản luồng, hỗ trợ chhc năng như tìm kiếm, find & replace , chèn , xóa 
* **Option**
* **sed 's/<từ cần thay thé>/<từ  dùng để thay thế >/<option> <filename>**
* - <number> thay thế từ cần thay thế số 2 trong dòng
* - g thay thế toàn bộ trong file 
* - p lặp lại dòng 
* - sed -n <option> <filename> chỉ in ra dòng được sửa 
* - sed 'nd' <filename> xóa dòng n trong file, dòng cuối thì n=$

**awk** Là ngôn ngữ lập trình thôn dịch dùng để thao tác với tệp, tạo các báo cáo 
* **Option** awk <option> 'Lựa chọn {hành động cần làm}' <filename _input> > <filename_output>
- Muốn ốn in ra cột 1,4 ta dùng: $ awk '{print $1,$4}' <filename>
 - In ra dòng có từ linux: $ awk '/linux/ {print}' test.txt 

#### VIM
**VIM** Vim là một trình soạn thảo văn bản tương thích với Vi. Nó có thể được sử dụng để chỉnh sửa tất cả các loại văn bản đơn giản.
**Các mode trong Vim**
* Insert mode: Mode này cho phép bạn nhập, chèn các kí tự.
* Command mode: Mode này giúp bạn thực hiện các command, tương tác với text object. Vd như nếu bạn gõ d trong Insert mode sẽ tạo ra kí tự "d" trên màn hình, nhưng trong Command mode nó hiểu đây là 1 lệnh xóa(delete) một text object nào đó.

**Điều khiển con trỏ**
* H:Trái
* J :Xuống 
* K :Lên 
* L :Phải

**Cấu trúc**

* [number][command][motion/ text object]
x 	Xóa 1 kí tự sau con trỏ
r   Thay thế 1 kí tự sau con trỏ
s 	Xóa kí tự dưới con trỏ và chuyển sang chế độ insert mode.
d   Dlete - Xóa text được định nghĩa bởi motion.
c   Change - Xóa text được định nghĩa theo motion sau đó tự chuyển về chế độ insert.
y    Yank - Copy text được định nghĩa bởi motion.


 

