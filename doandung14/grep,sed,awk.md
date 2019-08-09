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