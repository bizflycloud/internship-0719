# Introducing to LAMP

   LAMP (Linux, Apache, MySQL, PHP) is an archetypal model of web service stacks, named as an acronym of the names of its original four open-source components: the Linux operating system, the Apache HTTP Server, the MySQL relational database management system (RDBMS), and the PHP programming language. The LAMP components are largely interchangeable and not limited to the original selection. As a solution stack, LAMP is suitable for building dynamic web sites and web applications.

   *For more information, checking [LAMP_Wikipedia](https://en.wikipedia.org/wiki/LAMP_(software_bundle)).*

   - WordPress is one of the world’s most popular content management systems (CMS). It is a free and open-source platform, which is used by millions of people for running blogs, business websites, e-commerce stores and much more.

# Build a Web Server

  - Step 1: Connect to your server and update your system
    - Connect to your VPS via SSH as user root and update your system software to the latest available version: `apt-get update` `apt-get upgrade`
  - Step 2: Install Apache Web Server
  
    Apache is a fast and secure web server and one of the most popular and widely used web server in the world.
    - To install the Apache web server, use command: `apt-get install apache2`
    - Start and enable Apache to start automatically upon server reboot with: `systemctl start apache2` and `systemctl enable apache2`
    - Check the status of your Apache server and make sure it is up and running, use command: `systemctl status apache2`
    - To verify that Apache is running, you can also open your web browser and enter your server IP address. If Apache is successfully installed you should see the Apache default welcome page.
    
      ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/32.png)
      
  - Step 3: Install MySQL Database server
    - MySQL database server is used for the data storage of your WordPress site. MySQL is one of the most popular database management systems. 
      
      To install MySQL on your system, execute the following command and press Y to continue: `apt-get install mysql-server`
    - During the installation, you will be asked to enter a password for the MySQL root user. Make sure you enter a strong password.
    - In order to improve the security of your MySQL server, it is highly recommended that the `mysql_secure_installation` script should be run using command: `mysql_secure_installation`
    - This script will help you to perform important security tasks like setting up a root password, disable remote root login, remove anonymous users etc. The anonymouse user just for testing, no further purpose so that explained why it should be remove for good.
    - Go ahead and start the database server and enable it to automatically start upon boot, with: `systemctl start mysql` and `systemctl enable mysql`
  - Step 4: Install PHP
    - WordPress is a PHP based CMS, so we need PHP for processing the dynamic content of our WordPress site.
    - We will also include some additional modules, in order to help PHP to connect with our Apache and MySQL, as well as some additional modules which will be required by our WordPress site. To do this, use command: `apt-get install php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-curl php7.0-mbstring php7.0-gd php7.0-xml php7.0-xmlrpc php7.0-intl php7.0-soap php7.0-zip`
    - To test if PHP is working properly, we can create a file called `info.php` inside Apache web server root directory (/var/www/html/): `vim /var/www/html/info.php`
    - With that file open with VIM, Add content inside the file and save it: 
        
          <?php
          phpinfo();
          ?>

    - Restart the Apache server by typing: `systemctl restart apache2`
      
      When this is done, you can open web browser with your server IP, and you will see a page showing your current PHP configuration (this file can be removed later): 
        
        ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/30.png)
      
      That means PHP is working properly. 
  - Step 5: Install WordPress
    - Download and put the WordPress installation in the default web server document root directory (/var/www/html):
      - Move to `/var/www/html`, using command: `cd /var/www/html`  
      - Download the latest WordPress installation from the official wordpress.org site with `wget`: `wget -c http://wordpress.org/latest.tar.gz`
      - Extract the file with: `tar -xzvf latest.tar.gz`
    - Set the correct permissions of this directory so our Apache web server can access these files. To give ownership of the WordPress files to our Apache web server using command: `chown -R www-data:www-data /var/www/html/wordpress`
  - Step 6: Create a database for WordPress
    - Login to your MySQL server with the following command and enter your MySQL root password: `mysql -u root -p`
    - To create a new database for our WordPress installation, run the following commands:
          
          CREATE DATABASE wordpress_db;
          GRANT ALL PRIVILEGES ON wordpress_db.* TO 'dungnt'@'localhost' IDENTIFIED BY 'matkhau';
          FLUSH PRIVILEGES;
          exit;
         
    - Once the database is created, we will need to add this information to the WordPress configuration file.
      - Make sure you are inside the `/var/www/html/wordpress` directory and run command to rename the sample configuration file: `mv wp-config-sample.php wp-config.php`
      - Open the `wp-config.php` file, update the database settings, replacing `database_name_here`, `username_here` and `password_here` with your own details. Save and exit the file.
    - Restart your Apache and MySQL server with: `systemctl restart apache2` and `systemctl restart mysql`
    - Access your WordPress and finish the installation by following the on-screen instructions in your browser at http://server_ip/wordpress
          ![](https://github.com/bizflycloud/internship-0719/blob/master/TD_Git/PIC/31.png)



  
 
