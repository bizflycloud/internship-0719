# Horizon
Horizon là dashboard của openstack 

## Cài đặt

#### Cài đặt các thành phần cho dashboad
*   Cài đặt gói:
    `apt install openstack-dashboard -y`
*   Cấu hình file: `/etc/openstack-dashboard/local_settings.py`
    Sửa các dòng như sau:
    Chú ý phần `ALLOWED_HOSTS` ở dưới phần `UBUNTU` không được thay đổi  
    ```
    OPENSTACK_HOST = "controller"

    ALLOWED_HOSTS = ['*']
    
    SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
    
    CACHES = {
        'default': {
             'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
             'LOCATION': 'controller:11211',
        }
    }
    
    OPENSTACK_KEYSTONE_URL = "http://%s:5000/v3" % OPENSTACK_HOST
    
    OPENSTACK_KEYSTONE_MULTIDOMAIN_SUPPORT = True
    
    OPENSTACK_API_VERSIONS = {
      "identity": 3,
      "image": 2,
      "volume": 2,
    }
    
    OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = "Default"
    
    OPENSTACK_KEYSTONE_DEFAULT_ROLE = "user"
    
    TIME_ZONE = "Asia/Ho_Chi_Minh"`
    ```
####   Kết thúc
*   Khởi động lại apache
    `service apache2 reload`

####    Kiểm tra:
*   Truy cập vào `http://controller/horizon` hoặc `http://192.168.122.206/horizon` để sử dụng.
*   Màn hình đăng nhập:
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-19%2015-47-09.png)
Sử dụng username và password tạo trong scripts để truy cập
*   Màn hình chính:
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-19%2015-47-22.png)
*  Xem thông tin máy ảo
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-19%2015-50-21.png)
    ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-19%2015-52-23.png)
