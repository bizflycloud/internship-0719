**bt2:dùng Salt để setup+config ejabberd cho một server**

**1.Cài salt-master và salt-minion**

`sudo apt install salt-master` cài trên pc

`sudo apt install salt-minion` cài trên server

vào file /etc/salt/minion trên minion để thêm ip master ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/them%20key%20master.png)

kiểm tra trên master đã accept minion chưa ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/accept%20key%20minion.png)

**2.Cài ejabberd trên minion**

sudo salt 'doandung' pkg.install ejabberd

**3.cấu hình ejabberd**

vào file /etc/ejabberd/ejabberd.yml để cấu hình domain và user 

sau đó sử dụng lệnh `ejabberdctl register <user> <domain> <password>>` để tạo user

**4.Đẩy file cấu hình lên minion**

  tạo 1 file trong thư mục /srv/salt có đuôi sls trong hình là file demo.sls ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/demo%20.png)
  
  trong đó name: là tên file và thử mục sẽ được push vào minion
  
  còn source: là file lấy từ master
  
  sau đó dùng lệnh `salt 'doandung' state.apply demo` để push lên minion ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/push.png)
  
  Dùng salt để thực hiện câu lệnh trên minion 
  
  `salt 'doandung' cmd.run 'ejabberdctl register dungdn 192.168.232.129 123456'`
  
  ![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/t%E1%BA%A1o%20tr%C3%AAn%20minion%20th%C3%A0nh%20c%C3%B4ng.png)

![](https://github.com/bizflycloud/internship-0719/blob/master/doandung14/PIC/dang%20nhap%20thanh%20cong.png)
  
  
  




