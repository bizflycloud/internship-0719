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
