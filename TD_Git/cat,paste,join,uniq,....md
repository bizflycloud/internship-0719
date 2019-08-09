# Content review

`Cat`

> `Cat > file` renew the whole content of the file

`Paste` Kết hợp các trường lại 

1. `-d “...”`  có sử dụng dấu phân cách trong ngoặc	
2. `(none)` dùng tab để phân cách
3. `s` nối chuỗi ( theo hàng ngang)

`Join`  giống paste nhưng có chọn lọc trường giống nhau để kết hợp

`Uniq` loại các dòng lặp lại trong file

>   `-c`: dùng motion count để đếm số lượng lặp

`Tac` display contents ngược so với cat tức là theo kiểu bottom up 

Trường hợp có phân cách ( thí dụ) echo “1 2” | tac -s “ “ ra kết quả:

>2

>1

`Nl` number list content trong file

> - `nl -b a+(filename)` numbering cả dòng trống

> - customize numbering `nl -i (số custom) (filename)`	

> - khi coi tất cả khoảng trắng là một dòng để đánh số: nl -b a -l (số dòng muốn) (filename)

> - new start number: `nl -v (số mới) (filename)`

`Head`

> - `head -c (bytes)+(filename)` list ra (bytes) entry trên đầu file

> - `head -n (số dòng)+(filename)` : list ra (số dòng) dòng trên đầu file

`Tail` sử dụng như head nhưng là list ra từ dưới lên, thường dùng để xem thay đổi diễn ra trong file

`tr` 

1. `tr + motion + set1 set2` thay thế set 1 bằng set 2 thí dụ kết hợp với cat : cat file1 | tr a A	
2. `tr -d ‘...’` tìm và xóa các ký tự trong ngoặc
3. `tr -cd +[:chuỗi số:]` lọc chuỗi số cần tìm

`wc` 

1. `wc -l  +filename` Đếm số dòng trong file	
2. `wc -w  +filename` Đếm số từ trong file
3. `wc -c  +filename` Đếm  byte trong file

=> điểm khác biệt giữa less và more đó là less cho phép cuộn lên bằng các arrow, more thì không, less cho phép cuộn ngược lên còn more thì không

`cut` cắt nội dung file theo cột 

1. `cut -c a-b filename` cắt ký tự, chỉ lấy nội dung từ vị trí thứ a đến b mỗi dòng
2. `cut -c -a filename` cắt đi a ký tự đầu trên mỗi dòng 
3. `cut -d’...’ -f1` chỉ giữ lại cột đầu tiên được ngăn cách bởi dấu ‘...’ trong ngoặc của nội dung
	
`awk`

1. `awk ‘{print $a, $b}’ +(filename)`  in ra trường a đến trường b của file tên là filename
2. `awk -F: ‘{print $a, $b}’ +(filename)` Hoặc `awk ‘BEGIN{FS=”:”}{print $1, $4}’` in trường a đến b nhưng phân cách bởi “:”	
3. `awk’{print $0}’ +(filename)` : in ra nội dung của file tên là filename giông cat filename 
4. `awk ‘điều kiện nào đó{print $}’`: in ra nội dung cột khi có điều kiện

`sed`

1. `sed ‘s/^từ trong content/một từ khác/g’ +(filename)` thay thế một từ trong content thành một từ khác 
2. `sed ’từ b/s/^từ a/từ c/g’ +(filename)` thay thể từ a bằng từ c trên các dòng chứa từ b
3. `sed (số)q +(filename)` in ra n dòng đầu rồi thoát 
4. `sed -n ‘a, bq’ +filename` in từ dong a đến dòng thứ b
