**Note RAID**

**RAID**(*Redudant arrays Independent disks*) là hình thức ghép nhiều ổ cứng vật lý thành một hệ thống ổ cứng nhằm tăng tốc độ ghi và đọc dữ liệu ngoài ra còn tăng khả năng an toàn bảo mật dữ liệu lưu trữ

*Raid*: làm việc với các ổ cứng có dung lượng bằng nhau. Sử dụng raid sẽ tốn nhiều ổ cứng hơn bình thường nhưng độ an toàn bảo mật dữ liệu cao. Một số raid đc dùng phổ biến hiện nay là : *raid* 0 ,*raid* 1,*raid* 5,*raid* 6,*raid* 10

**Raid 0** Là raid đòi hỏi tối thiểu 2 đĩa cứng và ghi dữ liệu theo phương pháp striping *raid 0* truy xuất dữ liêu lớn tốc độ đọc rất nhanh. *raid 0* không có khả năng chịu lỗi

**Raid 1** Là raid tương tự như *raid 0*  nhưng ghi dữ liệu theo phương pháp mirroring :raid 1 là raid cơ bản nhất có khả năng đảm bảo an toàn dữ liệu. Dữ liệu được ghi trên 2 đĩa giống hệt nhau. Trong trường hợp dữ liệu ở đĩa 1 gặp sự cố thì dữ liệu ở đĩa 2 sẽ tiếp tục hđ bình thường

**Raid 5**:Là raid tương tự giống *raid 1*và *raid 0* vừa có thể tách dữ liệu lưu trữ ra riêng biệt vừa có thể dự phòng thay thế khí gặp sự cố khả năng chịu lỗi cao

**Raid 6**: Được sử dụng trong các doanh nghiệp: yêu cầu tối thiểu 4 ổ đĩa và sử dụng đên 2 khối parity nhưng khả năng chịu lỗi không bằng *raid 10* chi phí cao

**Raid 10**: là loại raid kết hợp ưu nhược điểm của cả 2 loại raid 0 và raid 1:Nhưng cần tối thiểu 4 ổ đĩa  và chi phí cao

**Note lệnh `fdisk`: 
