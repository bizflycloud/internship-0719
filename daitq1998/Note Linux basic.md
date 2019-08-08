**Standard input,Standard output, Standard error**

*Standard input (Stdin)* là đầu vào tiêu chuẩn qua kênh này dữ liệu được đưa vào cho chương trình;

*Standard output (Stdout)* là đầu ra tiêu chuẩn qua kênh này chương trình đưa ra kết quả làm việc của mình

*Standard error (stderr)* Qua kênh này chương trình đưa ra thông tin về lỗi

**Lệnh `wc`**là lệnh in dòng mới, từ và số byte cho mỗi TỆP và tổng cộng nếu có nhiều hơn một TẬP TIN

*Tùy chọn*
`-c` in số byte
`-m` in số lượng kí tự
`l` in số lượng dòng
`L` in chiều dài dòng dài nhất
`L` In chiều dài dòng dài nhất
`-w` In số đếm từ
`-wc` hoạt động trên đầu vào tiêu chuẩn . (Một từ là một chuỗi các ký tự có độ dài khác không được phân cách bằng khoảng trắng)
Với tùy chọn `-s` dùng để phân tách nội dung của tệp dựa trên chuỗi hoặc từ khóa khỏi tệp.
**Lệnh `nl`**
- Là lệnh dùng để đánh số các dòng trong một tệp

cú pháp:`nl [option] [file]`

**Tùy chọn**:
`-b`:dùng style để đánh số các dòng
`-d`:dùng CC để phân tách các trang logic
`-h`: đánh số tương tự
`-i`:tăng số dòng ở mỗi dòng
`-n`:chèn số dòng theo format

**Lệnh `cat`**

- dùng để kết nối các tệp với nhau và in kết qủa ra màn hình
**Lệnh `tac`**
Là lệnh (cũng được đánh vần ngược) in ra từng dòng của tệp bắt đầu từ dòng dưới cùng và hoàn thiện trên dòng trên cùng cho đầu ra tiêu chuẩn của máy. Việc sử dụng lệnh `tac` quan trọng nhất là, nó có thể cung cấp một sự trợ giúp tuyệt vời để gỡ lỗi các tệp nhật ký, đảo ngược thứ tự thời gian của nội dung nhật ký.

-cú pháp:`tac [option] [file]`
**tùy chon**
`-b` before:gắn dải phân các trước
`-r` giải thích dấu phân các theo một biểu thức chính quy
**Lệnh `more`**
- để xem một tệp văn bản một trang mỗi lần, nhấn phím cách để chuyển đến trang tiếp theo

**Lệnh ``head``**
- Dùng để xem những dòng đầu của tệp tin (theo mặc định là 10 dòng đầu tiên). Chúng ta có thể thay đổi số dòng bằng cách thêm ``-n`` vào sau lệnh head. Cách dùng lệnh ``head``:

**Tùy chọn**

    • `-n`, --lines=[-]n: In số dòng n đầu tiên của mỗi tệp
    
    • `-c`, --byte=[-]n: In số byte n đầu tiên của mỗi tệp
    
    • `-q`: Không in tiêu đề xác định tên tệp
    
    • `-v`: Luôn in tiêu đề xác định tên tệp
    
    • `--help`: Hiển thị các trợ giúp
    
    • `--version`: Thông tin về phiên bản và thoát
Ngoài ra chúng ta có thể tìm hiểu thêm các tùy chọn sử dụng lệnh: `man head`

**Lệnh sort :**
Cho phép sắp xếp các dòng của văn bản theo thứ tự tăng dần
cú pháp: `sort <tùy chọn > <file>`

*Tùy chon*
`-b`:bỏ qua khoảng trống hàng đầu 

`-d`:chỉ xem xét khoảng trống và kí tự số

`-r`:xếp file theo thứ tự giảm dần

`R`: sắp xếp ngẫu nhiên

**Lệnh `uniq`**:
- dùng để bỏ các dòng liên tiếp trùng lặp trong một tệp văn bản 
cú pháp:
`sort file1 file2 | uniq > file`

*Tùy chọn*
`-c` Nó cho biết số lần lặp lại của một dòng bằng cách hiển thị một số làm tiền tố với dòng.
`-d` Nó chỉ in các dòng lặp lại chứ không in các dòng không lặp lại.
`-D` all-repeated[=METHOD]  Nó in tất cả các dòng trùng lặp và METHOD có thể là bất kỳ thứ nào sau đây:
     ~None: Không phân định các dòng trùng lặp. Đây là mặc định.
     ~prepend:Chèn một dòng trống trước mỗi bộ dòng trùng lặp.
     ~separate:Chèn một dòng trống giữa mỗi dòng trùng lặp.
 `-u` Cho phép in ra dòng duy nhất
 
**Lệnh `paste`**
**cú phap** `paste [option] file`
- Dùng để tạo một tệp duy nhất chứa cả ba cột cột khác nhau được xác định dựa trên dấu cách với các 

**tùy chọn** 

- `-d`: dấu phân cách: Chỉ định danh sách các dấu phân cách được sử dụng thay vì các tab để phân tách các giá trị liên tiếp trên một dòng. Mỗi dấu phân cách được sử dụng lần lượt; khi danh sách đã hết, paste bắt đầu lại ở dấu phân cách đầu tiên.
    • `-s`: Nối dữ liệu theo chuỗi chứ không phải song song. Theo chiều ngang chứ không phải theo chiều dọc.
    
**lệnh `join`**

- kiểm tra các tệp có thng tin chung hay k nếu có nó sẽ tạo ra một bảng kết hợp dũ liệu chung từ 2 bảng trên
**cú pháp** `join [option] file`

**Tùy chon**

-`a [1,2]` Chèn vào output những dòng thông tin không thể ghép nối (do không có chung 1 field giống nhau) nằm trong file tương ứng với chỉ số sau -a: 1 tương ứng với FILE1 và 2 ứng với FILE2.

`-v [1,2]` Tương tự như -a nhưng tùy chọn này chỉ xuất ra dòng thông tin dư thừa chứ không phải là trọn vẹn kết quả ghép nối.

`-e STRING` Thay thế các dòng trống trong thông tin output bằng chuổi STRING do người dùng chỉ định

`-i,  –ignore-case` Bỏ qua sự khác biệt chữ hoa/thường khi so sánh các field.

`-o FORMAT` Yêu cầu định dạng xuất của output.Định dạng thứ nhất là M.N với M là chỉ số tập tin đầu vào và N là chỉ số của field chứa trong tập tin đó. Loại định dạng này sẽ chỉ xuất ra field được chỉ định thay vì toàn bộ kết quả ghép nối. Loại định dạng thứ 2 là một số ‘0‘ với ý nghĩa là xuất ra field được dùng để kết hợp 2 tập tin đầu vào (mặc định sẽ là tương ứng 1.1 hoặc 2.1)

`-t CHAR` Như đã đề cập ở trên, tùy chọn này sẽ chỉ định kí tự phân cách field thay cho mặc định là ‘ ‘

`-1 FIELD_NUMBER` Dùng field được chỉ định của FILE1 để ghép nối

`-2 FIELD_NUMBER` Dùng field được chỉ định của FILE2 để ghép nối

`-j FIELD_NUMBER` Tương ứng với -1 FIELD_NUMBER -2 FIELD_NUMBER

**Lệnh `split`**

- dùng để chia tách một tệp thành các phân đoạn có kích thước bằng nhau

**cú pháp** `split [option] [file]`

*Tùy chọn*
`-a`, --suffix-length=N số chữ cái dùng làm tiền tố = N (mặc định là 2)
`-b`, --bytes=SIZE đặt kích thước tính bằng byte cho mỗi tệp tin đầu ra
`-C`, --line-bytes=SIZE đặt số dòng cho mỗi tệp tin đầu ra
`-d`, --numeric-suffixes sử dụng hậu tố bằng số thay vì dùng chữ cái

**Lệnh `tail`**

- cú pháp: `tail [option] file`

-Lệnh `tail`  dùng để xem những dòng đầu của tệp tin (theo mặc định là 10 dòng). Lệnh `tail` rất hữu ích khi khắc phục sự cố tệp nhật ký
**Tùy chon**
    - `-n, --lines=[-]n` :  In số dòng n cuối cùng của mỗi tệp
    - `-n, --lines=[+]n` :  In tất cả các dòng từ n về sau
    - `-c, --byte=[-]n`  :   In số byte n đầu cuối cùng mỗi tệp
    - `-q`: Không in tiêu đề đầu ra
    - `-f`: Tiếp tục đọc tập tin cho đến khi CTRL + C
    - `--help`: Hiển thị các trợ giúp
    - `--version`: Thông tin về phiên bản và thoát
    
  **Lệnh `less`**
  
  - Lệnh less dùng mở một tệp để đọc tương tác, cho phép di chuyển lên xuống và tìm kiếm. Để mở tệp tin:`less [file]`
  - Trang lên trang xuống:
    • Phím Space: di chuyển xuống trang mới
    • Phím b: di chuyển lên lại trang phía trên
- Lệnh less có thể dùng phím mũi tên trên bàn phím để scroll lên xuống.
- Di chuyển đến cuối, bắt đầu tập tin:
    • Phím G: di chuyển đến cuối tập tin
    
    **9. Lệnh `Grep`**
    
    - Cú pháp: `grep [option] file`
    - GREP (Global regular expression print) là lệnh tìm kiếm các dòng có chứa một chuỗi hoặc từ khóa trong file
    
    **Tùy chọn**
    `-i`:tìm kiếm từ trong file nếu bạn không biết kí tự nào là viết hoa hay viết thường
  `-c`: Đếm số lần xuất hiện của từ tìm kiếm trong file
  `-n`: hiển thị số dòng ủa từ timd kiếm
  `-v` hiển thị các dòng không có chứa từ tìm kiếm trong file
  `^P` Hiển thị các dòng có từ tìm kiếm đứng đầu trong file
  `-i`Bỏ qua trường hợp
  `-o`:Hiển thị phân đoạn khớp dòng
  
  **Lệnh `sed`**
  Là viết tắt của trình soạn thảo luồng và nó có thể thực hiện rất nhiều chức năng trên tệp như, tìm kiếm, tìm và thay thế, chèn hoặc xóa.người dùng có thể chỉnh sửa các tệp ngay cả khi không mở nó, đây là cách nhanh hơn để tìm và thay thế một cái gì đó trong tệp, so với lần đầu mở tệp đó trong VI Editor và sau đó thay đổi nó.
  
  -Cú pháp:`sed [option] script input file`
  
  **Tùy chọn**
  
  -`-n`:Bỏ qua dòng in không gian mẫu
  -`e` script , --expression = script: Thêm lệnh script vào các lệnh đc thực thi
  -`f` script-file , --file = script-file : Thêm nội dung của tệp script vào các lệnh sẽ được thực thi.
  -`r`:thêm biểu thức chính quy mở rộng tập lệnh
  -`s`: xem set cá tệp riêng biệt
  
  **Lệnh awk**
  Là lệnh dùng để tìm và thay thế văn bản trong unix. Lệnh Awk trong Unix cũng được sử dụng để sắp xếp và xác thực cơ sở dữ liệu.Lệnh Awk trong unix chủ yếu được sử dụng để thao tác dữ liệu bằng cách sử dụng tệp và tạo các báo cáo được chỉ định. Ngôn ngữ lập trình lệnh awk không yêu cầu biên dịch và cho phép người dùng sử dụng các biến, hàm số, hàm chuỗi và toán tử logic. Lệnh Awk trong unix giống như một ngôn ngữ kịch bản được sử dụng để xử lý văn bản.
  
  -cú pháp: `awk [option] programfile`
  
  **Tùy chon:
  `-F` để chỉ định một dấu cách tệp tin
  -`-f` để chỉ định tập tin có chứa tập lệnh awk
  -`v` khai báo một biến
  
**VIM**

-Vim là một trình soạn thảo văn bản tương thích với Vi. Nó có thể được sử dụng để chỉnh sửa tất cả các loại văn bản đơn giản. Nó đặc biệt hữu ích cho việc chỉnh sửa các chương trình. Có rất nhiều cải tiến trên Vi: đa cấp hoàn tác, đa thắng cảm xạ và bộ đệm, tô sáng cú pháp, chỉnh sửa dòng lệnh, tên tệp hoàn thành, trợ giúp trực tuyến, lựa chọn trực quan, v.v.

-Cú pháp: vim [option] [file]

 **Tùy chọn vim**

 `-t`Tệp để chỉnh sửa và vị trí con trỏ ban đầu phụ thuộc vào "thẻ", một loại nhãn goto. {tag} được tìm kiếm trong tệp thẻ, tệp liên quan trở thành tệp hiện tại và lệnh liên quan được thực thi.

 `-q` Bắt đầu trong chế độ quickFix. Tệp [errorfile] được đọc và lỗi đầu tiên được hiển thị. Nếu [errorfile] bị bỏ qua, tên tệp được lấy từ tùy chọn 'errorfile'(mặc định là "AztecC.Err" cho Amiga, "lỗi.err" trên các hệ thống khác). Lỗi tiếp theo có thể được nhảy đến với
age
