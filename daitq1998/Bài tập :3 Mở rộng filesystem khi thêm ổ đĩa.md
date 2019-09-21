# Mở rộng filesystem khi lắp thêm ổ đĩa
- **Sử dụng LVM(Logical Volume Manage**(là phương thức thông dụng nhất)
- LVM là phương pháp cho phép ấn định không gian đĩa cứng thành những logical volume làm cho việc mở rộng kích thước filesystem dễ dàng 
- Sau khi thêm ổ HDD tạo các phân vùng trên ổ đĩa với định dạng Linux LVM , dùng `pvcreate`để ghép một số phân vùng của đĩa thành Physical Volume (pv) sau đó `vgcreate` nhóm các physical volume lại để thành các volume group(vg) và từ volume group dùng lệnh `lvcreate` tạo thành Logical volume(lv) và định dạng lại lv. ùng lệnh`lvextend` có thể mở rộng logical volume và`resize2fs` tăng kích thước filesystem trong logical volume với filesystem định dạng `ext2,ext3,ext4` còn với filesystem định dạng `xfs`dùng `xfs_growfs`để mở rộng filesystem
- **Ưu điểm và nhược điểm của LVM**

| Ưu điểm | Nhược điểm |
|--------|------------|
| Có thể thay đổi kích thước mà không cần phải sửa lại partition table của OS | Các bước thiết lập phức tạp và khó khăn |
| Không làm hỏng dịch vụ | Khả năng mất dữ liệu cao khi một trong số các đĩa cứng bị hỏng |
| Có thể kết hợp với swap | Càng gắn nhiều đĩa thì hệ thống khởi động càng lâu |
| Có thể tạo ra các  vùng dung lượng lớn nhỏ tùy ý | Làm cho việc khôi phục dữ liệu trở nên khó khăn hơn do cấu trúc trên đĩa phức tạp hơn|
| Điều chỉnh phân vùng ổ cứng một cách linh động khả năng kiểm soát cao | |
| LVM cho phép đóng băng một Logical Volume bất cứ lúc nào, ngay cả khi hệ thống đang chạy | |
- **Sử dụng RAID0 để mở rộng filesystem**
- RAID là cách ghép hai hay nhiều đĩa cứng vật lý thành một ổ đĩa cứng logic có chức năng gia tăng tốc độ đọc ghi dữ liệu hoặc tăng thêm sự an toàn cho dữ liệu trên hệ thống
- Dùng RAID0 để mở rộng file syste sau khi thêm một ổ đĩa. Để tạo raid0 dùng lệnh `mdadm` để ghép 2 phân vùng hoặc hai ổ cúng lại với nhau 
- Như trong một server có các thiết bị ổ cứng là /dev/sdb /dev/sdc. Dùng lệnh `mdadm --create /dev/md0 --level=0 --raid-device=2 /dev/sdb /dev/sdc` để tạo raid 0
- Sau đó định dạng `ext4` cho raid0 bằng lệnh: `mkfs.ext4 /dev/md0` và mount vào `/raid`
- Kiểm tra thiết bị raid0 đã tạo `mdadm --detail /dev/md0`
- **Ưu điểm và nhược điểm của RAID0

| Ưu điểm | Nhược điểm |
|---------|------------|
| Tốc độ đọc ghi nhanh | Không thể tạo được raid0 khi khác định dạng phân vùng hoặc ổ cứng|
| Không sử dụng dữ liệu chẵn lẻ và bằng cách sử dụng tất cả dung lượng lưu trữ dữ liệu có sẵn | Khi một đĩa bị lỗi thì tất cả dữ liệu trong raid0 sẽ bị mất hết,rủi ro về dữ liệu|
|Truyền dữ liêu trên hai đĩa riêng biệt| Khả năng chịu lỗi kém và dự phòng |

