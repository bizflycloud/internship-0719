# Nova-cell

## Khái niệm
Nova Cell là cách để mở rộng compute workload bằng cách phần phối tải lên hạ tầng tài nguyên như DB, message queue, tới nhiều instance.
Kiến trúc Nova cell tạo ra các group compute nodes, sắp xếp theo mô hình cây, được gọi là cell. Mỗi cell có DB và message queue của nó.

Ví dụ:
![](https://github.com/bizflycloud/internship-0719/blob/master/quanlm1999/pic/Annotation%202020-04-22%20092140.png?raw=true)

Kiến trúc cell
![](https://cloudfun.vn/attachments/1571735510329-png.538/)

Ưu điểm:
- Giảm tải
- Cô lập lỗi: Nếu như 1 DB trên 1 cell bị hỏng thì vẫn có thể dùng trên cell còn lại mà không hỏng toàn bộ hể thống

Cơ chế nhóm:
-   Đồng nhất Hardware trên các cells:
    - Ví dụ: Trên 1 cell có thể dùng SSD và trên cell khác dùng HDD
    - Scale out bằng cách thêm cell vào

Kiến trúc và giới hạn của cell V1
-   Capture and replays messages
-   Race conditions
-   Two level of scheduling (chọn cell -> chọn compute)
    - top level scheduler has very limited data and has coarse data
- Thiếu tính năng
    -   Security groups
    -   Host aggregates
    -   availability zones
    -   Limited global scheduling option

### Cell v2
Cell v2 khắc phục nhược điểm đó của cell v1
Và trong khi cell v1 là tùy chọn với openstack thì cell v2 luôn dc cài đặt
![](https://github.com/bizflycloud/internship-0719/blob/master/quanlm1999/pic/Annotation%202020-04-22%20105707.png?raw=true)

![](https://docs.openstack.org/nova/latest/_images/graphviz-17c429adfdf6632f4cae2b5f8b88669039646ea3.png)
