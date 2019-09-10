# Để convert và resize một file image (xenial-server-cloudimg-amd64-disk1.img)

**Bước 1:** Đầu tiên download ubuntu-server-cloud-imange ở đường link: (https://cloud-images.ubuntu.com/releases/xenial/release/) Và chọn file image có định dạng qcow2

**Bước 2:** Sau khi dowload file image ở dạng qcow2 ta kiểm tra thông tin của file đó bằng lệnh `qemu-img info xenial-server-cloudimg-amd64-disk1.img` trước khi convert từ định dạng `qcow2` sang `raw`

**Bước 3:** Để convert file image này ta dùng lệnh ` qemu-img convert -O  raw xenial-server-cloudimg-amd64-disk1.img xenial-server-cloudimg-amd64-disk1.raw`.Sau khi convert thành công file image đó sang định dạng `raw` kiểm tra lại thông tin của file đó xem kích thước file bao nhiêu và một số thông tin khác bằng lệnh`qemu-img info xenial-server-cloudimg-amd64-disk1.raw`

**Bước 4:** Resize file image tới mức tối thiểu và không lỗi imange
- Để resize một file imange dùng `Gparted`,`fdisk`,và`truncate`
- Gparted là một ứng dụng tuyệt vời có thể xử lý các phân vùng và hệ thống tệp, (không phải các tệp đơn giản như hình ảnh)
- Đâu tiên ta phải kích hoạt loopback bằng lệnh`sudo modprobe loop` và yêu cầu một thiết bị loopback mới bằng lệnh `sudo losetup -f`
- Tạo một thiết bị image:`sudo losetup /dev/(tên loopback) file image`
- khi muốn truy cập vào các phân vùng trên image, ta cần yêu cầu kernel cũng tải những phân vùng đó:`sudo partprobe /dev/(tên loopback)` 
- Sau đó dùng Gparted để resize file image:
- Dùng lệnh:`sudo gparted /dev/loop1` để vào phân vùng `/dev/loop1` 
![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/2.png)
- Sau đó chọn phân vùng và click vào mục Resize/move và sẽ hển thị ra cửa sổ sau ![](https://github.com/bizflycloud/internship-0719/blob/master/daitq1998/image/3.png)
