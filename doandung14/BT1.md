**Convert ubuntu cloud image từ dạng qcow2->raw->resize**

Bước 1: tải ubuntu cloud image dạng qcow2 (400mb) 

Bước 2: sử dụng câu lệnh `qemu-img convert {image_name}.qcow2 {image_name}.raw` để convert từ qcow2(400mb) sang raw(2.2G) ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/2.png) ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/3.pnghttps://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/3.png) 

Bước 3: sử dụng kvm để test file raw xem có xảy ra lỗi sau khi convert k

Bước 4: cài gparted ( tiện ích giúp sắp xếp và resize phân vùng ) 

Bước 5: thực hiện resize file raw từ 2.2G 

1.kích hoạt loopback nếu nó chưa được kích hoạt: `sudo modprobe loop`

2.thiết bị loopback mới `sudo losetup -f`

3.tạo một thiết bị của hình ảnh: `sudo losetup /dev/loop0 <Đường dẫn file raw>`

4.yêu cầu kernel tải những phân vùng đó: `sudo partprobe /dev/loop0`

5.Mở phân vùng bằng gparted `sudo gparted /dev/loop0`

6.Kiểm tra xem file raw biết phân vùng của chúng ta kết thúc ở đâu và phần chưa được phân bổ bắt đầu :`fdisk -l <đường dẫn file raw>`

7.Sử dụng truncate để cắt ngắn file raw . Có ends on block 3358719 (shown under End) và block-size là 512 bytes (shown as sectors of 1 * 512) : `truncate --size=$[(3358719+1)*512] <đường dẫn file raw>`


Bước 6: sử dụng kvm để kiểm tra file raw vừa resize.File raw k lỗi =>   **Resize thành công** ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/Sau%20khi%20resize)
