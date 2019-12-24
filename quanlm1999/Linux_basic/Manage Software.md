# Manage Software
#### Install software from source
* Download tarball (file nén có chưa source code) cú pháp **$ wget URL**
* Giải nén file **$ tar -xvpf filename.tar.gz** hoặc **$ tar -xvjf  filename.tar.bz2**
* Sau khi giải ném, truy cập vào file **$ cd filename**
* Cấu hình **$ ./configure**
* Biên dịch **$ make**
* Cài đặt **$ make install**
#### Debian Packages
**dpkg** là lệnh cơ sở để xử lý các gói Debian trên hệ thống. Nếu bạn có gói .deb, dpkg cho phép cài đặt hoặc phân tích nội dung của gói đó
**Câu lệnh:** 
* - **dpkg -i <filename>** cài đặt gói tin .deb
* - **dpkg -l [optional pattern]** danh sách các gói có thể cài đặt được với 
* - **dpkg -r packagename** gỡ bỏi gói

**APT** là công cụ quản lý phần mềm của linux, làm đơn giản hóa các thủ tục tải về , cấu hình, cài đặt các gói phần mềm 
**Câu lệnh**
|apt            	|apt-get                	|chức năng	                                    |
|---            	|---	                    |---	                                        |
|apt install    	|  apt-get install       	| Cài đặt gói tin                              	|
|apt remove       	|  apt-get remove        	| Gõ bở gói tin          	                     |
|apt purge      	|  apt-get purge           	| Gỡ bỏ gói tin bao gồm cả cấu hình             |   
|apt update     	|  apt-get update          	| Cập nhật danh sáchphiên bản mới của gói in    |                     
| apt upgrade    	|  apt-get upgrade          | Cài đặt phiên bản mới của gói tin         	|
|apt autoremove   	|  apt-get autoremove      	| Gỡ bỏ chuương trình không cần thiết          	|
|apt full-upgrade   |  apt-get dist-upgrade 	|  nâng cấp các gói tin của hệ thống và sẽ loại bỏ các gói cài đặt cũ đang hiện có nếu điều này là cần thiết.                                          	|
|apt search     	|  apt-get search 	        | Tìm kiếm gói tin                              |

**RPM** là một trình quản lý gói tin,là một phần mềm dễ dùng  ên cạnh .deb 
**Câu lệnh** 
* **Cài đặt:**  #rpm -ivh <tên gói phần mềm>
* **Xem thông tin của gói:** #rpm -qpi <tên gói phần mềm>
* **Gỡ bỏ gói đã cài đặt:** #rpm -e <tên gói phần mềm>
* **Liệt kê danh sách tất cả các gói đã cài:** #pm -qa
* **Kiểm tra gói cài đặt:** #rpm -q <tên gói>
