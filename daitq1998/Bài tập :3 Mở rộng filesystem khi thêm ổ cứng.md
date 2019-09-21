#Mở rộng filesystem khi lắp thêm ổ đĩa
- **Sử dụng LVM(Logical Volume Manage**
- LVM là phương pháp cho phép ấn định không gian đĩa cứng thành những logical volume làm cho việc mở rộng kích thước filesystem dễ dàng
- Sau khi thêm ổ HDD tạo các phân vùng trên ổ đĩa với định dạng Linux LVM , dùng `pvcreate`để ghép một số phân vùng của đĩa thành Physical Volume (pv) sau đó nhóm các physical volume lại để thành các volume group(vg) và từ volume group tạo thành Logical volume(lv) và định dạng lại lv từ đó dùng lệnh`lvextend` có thể mở rộng logical volume và`resize2fs` tăng kích thước filesystem trong logical volume
- **Ưu điểm và nhược điểm của LVM
| Ư điểm | Nhược điểm |
|--------|------------|
