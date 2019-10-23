## Cấu trúc
**NFS**
![nfs](https://camo.githubusercontent.com/bb2737e84fca45ae886ad1b0d458848a09872bea/68747470733a2f2f692e696d6775722e636f6d2f416738667846332e6a7067)
*   **`Phía client:`**

    *   Client truy cập file system bằng các cuộc gọi hệ thống (system call)
    *   Giao diện hệ thống UNIX được thay thế bằng giao diện cho hệ thống tệp ảo (VFS) (các hệ điều hành hiện đại đều cung cấp VFS)
    *   Các hoạt động trên giao diện VFS được chuyển đến hệ thống tệp cục bộ (Local file) hoặc được chuyển đến 1 thành phần riêng biệt gọi là NFS Clientệm
    
    *   NFS client đảm nhiệm việc xử lý quyền truy cập vào các tệp được lưu trữ tại máy chủ từ xa
    Trong NFS, tất cả giao tiếp giữa máy khách và máy chủ được thực hiện thông qua RPC (cuộc gọi thủ tục)

*   **`Phía Server:`**
    *   NFS server xử lý các yêu cầu từ client
    *   Từ RPC stub unmarshals request (yêu cầu sơ khai), Server chuyển chúng thành các hoạt động tệp VFS

    *   VFS chịu trách nhiệm triển khai 1 hệ thống tệp cục bộ.

**GlusterFS**

![glusterfs](https://i0.wp.com/blogit.edu.vn/wp-content/uploads/2015/09/glusterfs-4.png?w=590)

*   Trong đó :
    *   `Node`: các máy chủ lưu trữ được cài đặt Gluster.
    *   `Brick`: Là một folder / mount point / file system trên một node để chia sẻ với các node tin cậy khác trong hệ thống (trusted storage pool) – Trên một node có thể có nhiều Brick (s). – Brick được dùng để gán (assign) vào các vùng dữ liệu (volume). – Các brick trong một volume nên có dung lượng lưu trữ (size) bằng nhau.
    *   `Volume:` là một khối logic chứa nhiều Brick, Gluster đóng vai trò như một LVM (Logical Volume Manager) bằng cách quản lý các brick phân tán trên các máy chủ như là một điểm kết nối lưu trữ duy nhất trên mạng.
    
    *   `Client:` là các máy tính kết nối với hệ thống lưu trữ của Gluster. Đó có thể là các Windows client chuẩn (thông qua CIFS), NFS client, hay sử dụng Gluster client cải tiến hơn so với NFS, đặc biệt là tính sẵn sàng cao.
## Khả năng mở rộng

**NFS**
*   Khả năng mở rộng kém, tập trung tất cả tập tin truy cập trên một máy chủ duy nhất
*   Các biện pháp nhân rộng, chuyển đổi dự phòng và khôi phục sau lỗi bị giới hạn, quá trình tùy chỉnh và các tiến trình cồng kềnh với một máy chủ đơn duy nhất sẽ gây ra hiện tượng nút thắt cổ chai hiệu suất.
*   NFS bị chậm trong khi lưu lượng mạng lớn

**GlusterFS** 
* Khả năng tốt, GluserFS thích nghi tốt với sự tăng giảm mạnh của dữ liệu, có khả năng lưu trữ đến hàng nghìn Petabyte và lớn hơn.
* Một cụm cluster có thể chứa tối đa 64 máy chủ và có thể phát triển thêm nữa


## Khả năng quản lý:
**NFS**
*   Cho phép quản lý trung tâm, giảm nhu cầu thêm phần mềm cũ và dụng lượng đĩa trên các hệ thống người dùng cá nhân

**GlusterFS**
*   Khả năng tự quản lý (hệ thống lưu trữ nội bộ và của bên thứ ba cung cấp đều được quản lý từ một điểm tập trung duy nhất)
*   Việc quản lý GlusterFS rất dễ dàng vì nó tách biệt khỏi kernel space trong khi thực thi trên user space.

## Độ an toàn
**NFS**
*   NFS vốn không an toàn, chỉ nên sử dụng trên 1 mạng đáng tin cậy sau Firewall
*   Client và server tin tưởng lần nhau vô điều kiện
*   Tên máy chủ có thể là giả mạo (tự xưng là máy khác)

**GlusterFS**
*   An toàn, bên thứ 3 không thể truy cập vào cluster nếu không được mời vào 
*   Sử dụng TLS để truyền dữ liệu 

## Cài đặt
**NFS**
*   Dễ cài đặt vì nó sử dụng cơ sở hạ tầng IP hiện có

**GlusterFS**
*   Khó cài đặt hơn

## Chi phí
**NFS** & **GlusterFS**
*   Chi phí thấp, không cần thiết bị chuyên biệt nào
*   Có thể cài đặt trên bất cứ máy chủ Linux na


## Tính sẵn sàng cao 
**NFS** 
*    Không hỗ trợ trực tiếp, máy chủ hỏng sẽ khiến cho client không sử dụng được, phải cấu hình thêm mới có đạt được tính sẵn sàng cao.

**GlusterFS**
*   Tính sẵn sàng cao được tích hợp và không có máy chủ siêu dữ liệu tập trung, không có điểm chịu lỗi duy nhất




