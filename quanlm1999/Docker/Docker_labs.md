# Labs về container và Docker
#### Container chạy wordpress
Để chạy wordpress trên container, ta cần 1 container chạy mysql và wordpress
Ta sử dụng docker-compose

Ta viết file yaml:
```
version: '3.1'

services:

  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: exampleuser
      WORDPRESS_DB_PASSWORD: examplepass
      WORDPRESS_DB_NAME: exampledb
    volumes:
      - wordpress:/var/www/html

  db:
    image: mysql:5.7
    restart: always
    environment:
      MYSQL_DATABASE: exampledb
      MYSQL_USER: exampleuser
      MYSQL_PASSWORD: examplepass
      MYSQL_RANDOM_ROOT_PASSWORD: '1'
    volumes:
      - db:/var/lib/mysql

volumes:
  wordpress:
  db:
```

Sau đó, ta chạy `docker-compose -f stack.yml up`
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-04-06%2010-29-38.png)

Ta truy cập vào IP host với port 8080 (do ánh xạ port 80 từ container ra port 8080 ở host)
Ta có 
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-04-06%2010-31-54.png)

Vậy ta đã có container chạy wordpress 
