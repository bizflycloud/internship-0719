# Note RAID

**RAID**(*Redudant arrays Independent disks*) là hình thức ghép nhiều ổ cứng vật lý thành một hệ thống ổ cứng nhằm tăng tốc độ ghi và đọc dữ liệu ngoài ra còn tăng khả năng an toàn bảo mật dữ liệu lưu trữ

*Raid*: làm việc với các ổ cứng có dung lượng bằng nhau. Sử dụng raid sẽ tốn nhiều ổ cứng hơn bình thường nhưng độ an toàn bảo mật dữ liệu cao. Một số raid đc dùng phổ biến hiện nay là : *raid* 0 ,*raid* 1,*raid* 5,*raid* 6,*raid* 10

**Raid 0** Là raid đòi hỏi tối thiểu 2 đĩa cứng và ghi dữ liệu theo phương pháp striping *raid 0* truy xuất dữ liêu lớn tốc độ đọc rất nhanh.

**Ưu điểm** của RAID0 là cải thiện hiệu năng. RAID0 tránh tình trạng nghe lỏm bằng cách không sử dụng dữ liệu parity và bằng cách sử dụng tất cả dung lượng lưu trữ dữ liệu có sẵn. RAID0 có chi phí thấp nhất trong tất cả các cấp RAID và được hỗ trợ bởi tất cả các bộ điều khiển phần cứng

**Nhược điểm** của RAID0 là khả năng phục hồi thấp. Nó không nên được sử dụng để lưu trữ quan trọng.

**Raid 1** Là raid tương tự như *raid 0*  nhưng ghi dữ liệu theo phương pháp mirroring :raid 1 là raid cơ bản nhất có khả năng đảm bảo an toàn dữ liệu. Dữ liệu được ghi trên 2 đĩa giống hệt nhau. Trong trường hợp dữ liệu ở đĩa 1 gặp sự cố thì dữ liệu ở đĩa 2 sẽ tiếp tục hđ bình thường. RAID1 là một lựa chọn tốt cho các ứng dụng đòi hỏi hiệu năng cao và tính sẵn sàng cao, như các ứng dụng giao dịch, email,... Cả hai đĩa đều hoạt động, dữ liệu có thể được đọc từ chúng đồng thời làm cho hoạt động đọc khá nhanh. Tuy nhiên, thao tác ghi chậm hơn vì thao tác ghi được thực hiện hai lần.

**Raid 5**:được sử dụng ở cấp doanh nghiệp. RAID5 hoạt động theo phương pháp parity. Thông tin chẵn lẻ sẽ được sử dụng để xây dựng lại dữ liệu. Nó xây dựng lại từ thông tin còn lại trên các ổ đĩa tốt còn lại. Điều này sẽ bảo vệ dữ liệu của chúng ta khi ổ đĩa bị lỗi. Dử liệu trên RAID5 có thể tồn tại sau một lỗi ổ đĩa duy nhất, nếu các ổ đĩa bị lỗi nhiều hơn 1 sẽ gây mất dữ liệu.
 *Một số ưu điểm của RAID5*:

- Đọc sẽ cực kỳ rất tốt về tốc độ.

- Ghi sẽ ở mức trung bình, chậm nếu chúng tôi không sử dụng card điều khiển RAID.

- Xây dựng lại từ thông tin parity từ tất cả các ổ đĩa.

RAID5 Có thể được sử dụng trong các máy chủ tập tin, máy chủ web, sao lưu rất quan trọng.

**Raid 6**: giống như RAID5 hoạt động theo phương pháp parity. Chủ yếu được sử dụng trong một số lượng lớn các mảng. Chúng ta cần tối thiểu 4 ổ đĩa, khi có 2 ổ đĩa bị lỗi, chúng ta có thể xây dựng lại dữ liệu trong khi thay thế các ổ đĩa mới.
**Ưu và nhược điểm của RAID6**:

- Hiệu suất kém.

- Hiệu suất đọc sẽ tốt.

- Hiệu suất ghi sẽ kém nếu chúng tôi không sử dụng card điều khiển RAID.

- Xây dựng lại từ 2 ổ đĩa parity.

- Không gian 2 đĩa sẽ nằm dưới parity.

- Có thể được sử dụng trong mảng lớn.

- Có thể được sử dụng trong mục đích sao lưu, truyền phát video, được sử dụng ở quy mô lớn.

**Raid 10**: có thể được gọi là RAID1 + RAID0 hoặc RAID0 + RAID1. RAID10 sẽ làm cả hai công việc của Mirror và Striping. Mirror sẽ là đầu tiên và Stripe sẽ là thứ hai trong RAID10. Stripe sẽ là đầu tiên và mirror sẽ là thứ hai trong RAID01. RAID10 tốt hơn so với RAID01.
**Ưu và nhược điểm của RAID10**:

- Hiệu suất đọc và viết tốt.

- Nửa không gian sẽ bị mất trong tổng công suất.

- Xây dựng lại nhanh chóng từ sao chép dữ liệu.

- Có thể được sử dụng trong lưu trữ cơ sở dữ liệu cho hiệu suất cao và tính sẵn sàng.

# mdadm


