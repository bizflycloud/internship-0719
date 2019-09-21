# Mở rộng filesystem khi lắp thêm ổ đĩa
- **Sử dụng LVM(Logical Volume Manage**
- LVM là phương pháp cho phép ấn định không gian đĩa cứng thành những logical volume làm cho việc mở rộng kích thước filesystem dễ dàng
- Sau khi thêm ổ HDD tạo các phân vùng trên ổ đĩa với định dạng Linux LVM , dùng `pvcreate`để ghép một số phân vùng của đĩa thành Physical Volume (pv) sau đó nhóm các physical volume lại để thành các volume group(vg) và từ volume group tạo thành Logical volume(lv) và định dạng lại lv từ đó dùng lệnh`lvextend` có thể mở rộng logical volume và`resize2fs` tăng kích thước filesystem trong logical volume
- **Ưu điểm và nhược điểm của LVM**

| Ưu điểm | Nhược điểm |
|--------|------------|
| Có thể thay đổi kích thước mà không cần phải sửa lại partition table của OS | Các bước thiết lập phức tạp và khó khăn |
| Không làm hỏng dịch vụ | Khả năng mất dữ liệu cao khi một trong số các đĩa cứng bị hỏng |
| Có thể kết hợp với swap | Càng gắn nhiều đĩa thì hệ thống khởi động càng lâu |
| Có thể tạo ra các  vùng dung lượng lớn nhỏ tùy ý | Làm cho việc khôi phục dữ liệu trở nên khó khăn hơn do cấu trúc trên đĩa phức tạp hơn|
| Điều chỉnh phân vùng ổ cứng một cách linh động khả năng kiểm soát cao | |
| LVM cho phép đóng băng một Logical Volume bất cứ lúc nào, ngay cả khi hệ thống đang chạy | |
-**Sử dụng RAID0 để mở rộng filesystem


