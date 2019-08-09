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