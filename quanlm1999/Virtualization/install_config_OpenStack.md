# Cài đặt và cấu hình Openstack
****
### Các bước chuẩn bị triển khai 
*   Cài đặt package sau:
```
apt install software-properties-common
add-apt-repository cloud-archive:newton
apt install python-openstackclient
```

*   Cài đặt `MariaDB` server:
```
apt install mariadb-server python-pymysql
root@controller:~# cat /etc/mysql/mariadb.conf.d/99-openstack.cnf
[mysqld]
bind-address = 10.208.130.36
default-storage-engine = innodb
innodb_file_per_table
max_connections = 4096
collation-server = utf8_general_ci
character-set-server = utf8
```

*   Cài đặt `rabbitMQ` và tạo user cho openstack
```
apt install rabbitmq-server
root@controller:~# rabbitmqctl add_user openstack lxcpassword
Creating user "openstack" ...
root@controller:~# rabbitmqctl set_permissions openstack ".*" ".*" ".*"
Setting permissions for user "openstack" in vhost "/" ...
```

*   Cài đặt và cấu hình `memcached` 
```
apt install memcached python-memcache
root@controller:~# sed -i 's/127.0.0.1/10.208.130.36/g'
/etc/memcached.conf
root@controller:~# cat /etc/memcached.conf | grep -vi "#" | sed
'/^$/d'
-d
logfile /var/log/memcached.log
-m 64
-p 11211
-u memcache
-l 10.208.130.36
```

****
### Cài đặt và cấu hình OpenStack Keystone identity service
*   Tạo CSDL cho keystone và gán quyền
```
mysql -u root -plxcpassword
MariaDB [(none)]> CREATE DATABASE keystone;
Query OK, 1 row affected (0.01 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO
'keystone'@'localhost' IDENTIFIED BY 'lxcpassword';
Query OK, 0 rows affected (0.00 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON keystone.* TO
'keystone'@'%' IDENTIFIED BY 'lxcpassword';
Query OK, 0 rows affected (0.01 sec)
MariaDB [(none)]> exit
Bye
```
*   Cài đặt keystone
*   Cấu hình tối thiểu cho keystone như sau
```
cat /etc/keystone/keystone.conf
[DEFAULT]
log_dir = /var/log/keystone
[assignment]
[auth]
[cache]
[catalog]
[cors]
[cors.subdomain]
[credential]
[database]
connection = mysql+pymysql://keystone:lxcpassword@controller/keystone
[domain_config]
[endpoint_filter]
[endpoint_policy]
[eventlet_server]
[federation]
[fernet_tokens]
[identity]
[identity_mapping][kvs]
[ldap]
[matchmaker_redis]
[memcache]
[oauth1]
[os_inherit]
[oslo_messaging_amqp]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_messaging_zmq]
[oslo_middleware]
[oslo_policy]
[paste_deploy]
[policy]
[profiler]
[resource]
[revoke]
[role]
[saml]
[security_compliance]
[shadow_users]
[signing]
[token]
provider = fernet
[tokenless_auth]
[trust]
[extra_headers]
Distribution = Ubuntu
```

*   Populate the Keystone database `su -s /bin/sh -c "keystone-manage db_sync" keystone`
*   Khởi tạo Fernet key repositories: `keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone` `keystone-manage credential_setup --keystone-user keystone --keystone-group keystone`
*  Bootstrap the Keystone service: `keystone-manage bootstrap --bootstrap-password lxcpassword --bootstrap-admin-url http://controller:35357/v3/ -- bootstrap-internal-url http://controller:35357/v3/ --bootstrap-public- url http://controller:5000/v3/ --bootstrap-region-id RegionOne`
*  Thêm dòng cấu hình Apache
```
root@controller:~# cat /etc/apache2/apache2.conf
...
ServerName controller
...
root@controller:~# service apache2 restart
```
*   Xóa CSDL mặc định của keystone `rm -f /var/lib/keystone/keystone.db`
*   Cài đặt tài khoản quản trị với biến môi trường như sau:
```
root@controller:~# export OS_USERNAME=admin
root@controller:~# export OS_PASSWORD=lxcpassword
root@controller:~# export OS_PROJECT_NAME=admin
root@controller:~# export OS_USER_DOMAIN_NAME=default
root@controller:~# export OS_PROJECT_DOMAIN_NAME=default
root@controller:~# export OS_AUTH_URL=http://controller:35357/v3
root@controller:~# export OS_IDENTITY_API_VERSION=3

```
* Tạo project trong Keystone `openstack project create --domain default -- description "KVM Project" service`
* Tạo project không có đặc quyền và user `openstack project create --domain default -- description "KVM User Project" kvm`
```
openstack user create --domain default --password-
prompt kvm
User Password:
Repeat User Password:
```
*   Tạo role user và gán nó với KVM project `openstack role create user` `openstack role add --project kvm --user kvm user`
*   Cấu hình Web Service Gateway Interface (WSGI) làm đường nối trung gian cho Keystone 
```
cat /etc/keystone/keystone-paste.ini
# Keystone PasteDeploy configuration file.
[filter:debug]
use = egg:oslo.middleware#debug
[filter:request_id]
use = egg:oslo.middleware#request_id
[filter:build_auth_context]
use = egg:keystone#build_auth_context
[filter:token_auth]
use = egg:keystone#token_auth
[filter:admin_token_auth]
use = egg:keystone#admin_token_auth
[filter:json_body]
use = egg:keystone#json_body
[filter:cors]use = egg:oslo.middleware#cors
oslo_config_project = keystone
[filter:http_proxy_to_wsgi]
use = egg:oslo.middleware#http_proxy_to_wsgi
[filter:ec2_extension]
use = egg:keystone#ec2_extension
[filter:ec2_extension_v3]
use = egg:keystone#ec2_extension_v3
[filter:s3_extension]
use = egg:keystone#s3_extension
[filter:url_normalize]
use = egg:keystone#url_normalize
[filter:sizelimit]
use = egg:oslo.middleware#sizelimit
[filter:osprofiler]
use = egg:osprofiler#osprofiler
[app:public_service]
use = egg:keystone#public_service
[app:service_v3]
use = egg:keystone#service_v3
[app:admin_service]
use = egg:keystone#admin_service
[pipeline:public_api]
pipeline = cors sizelimit http_proxy_to_wsgi osprofiler url_normalize
request_id build_auth_context token_auth json_body ec2_extension
public_service
[pipeline:admin_api]
pipeline = cors sizelimit http_proxy_to_wsgi osprofiler url_normalize
request_id build_auth_context token_auth json_body ec2_extension
s3_extension admin_service
[pipeline:api_v3]
pipeline = cors sizelimit http_proxy_to_wsgi osprofiler url_normalize
request_id build_auth_context token_auth json_body ec2_extension_v3
s3_extension service_v3
[app:public_version_service]
use = egg:keystone#public_version_service
[app:admin_version_service]
use = egg:keystone#admin_version_service
[pipeline:public_version_api]
pipeline = cors sizelimit osprofiler url_normalize
public_version_service
[pipeline:admin_version_api]
pipeline = cors sizelimit osprofiler url_normalize admin_version_service
[composite:main]
use = egg:Paste#urlmap
/v2.0 = public_api
/v3 = api_v3
/ = public_version_api
[composite:admin]
use = egg:Paste#urlmap
/v2.0 = admin_api
/v3 = api_v3
/ = admin_version_api
```

* Yêu cầu token từ admin và KVM user: `openstack --os-auth-url http://controller:35357/v3 --os-project-domain-name default --os-user-domain-name default --os- project-name admin --os-username admin token issue` `openstack --os-auth-url http://controller:5000/v3 --os-project-domain-name default --os-user-domain-name default --os- project-name kvm --os-username kvm token issue`
* Tạo file lưu trữ thông tin xác thực của admin và user 
```
cat rc.admin
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=lxcpassword
export OS_AUTH_URL=http://controller:35357/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
root@controller:~#
root@controller:~# cat rc.kvm
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=kvm
export OS_USERNAME=kvm
export OS_PASSWORD=lxcpassword
export OS_AUTH_URL=http://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2
```
*   Source the admin credentials file: `. rc.admin`
*   Yêu cầu token xác nhân cho admin user: `openstack token issue`

****
### Cài đặt và cấu hình OpenStack Glance image service
* Tạo CSDL cho Glance
```
mysql -u root -plxcpassword
MariaDB [(none)]> CREATE DATABASE glance;
Query OK, 1 row affected (0.00 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO
'glance'@'localhost' IDENTIFIED BY 'lxcpassword';
Query OK, 0 rows affected (0.00 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%'
IDENTIFIED BY 'lxcpassword';
Query OK, 0 rows affected (0.00 sec)
MariaDB [(none)]> exit
Bye
```
*   Tạo người dùng Glance và gán quyền quản trị 
```
openstack user create --domain default --password-prompt glance
User Password:
Repeat User Password:

openstack role add --project service --user glance admin
```
*   Tạo Glance service definition:
```
openstack service create --name glance --description "OpenStack Image" image
```
*   Tạo Glance API endpoint trong Keystone
```
openstack endpoint create --region RegionOne image public http://controller:9292
openstack endpoint create --region RegionOne image internal http://controller:9292
openstack endpoint create --region RegionOne image admin http://controller:9292
```
*   Cài đặt Glance `apt install glance`
*   Cầu hình: 
```
cat /etc/glance/glance-api.conf
[DEFAULT]
[cors]
[cors.subdomain]
[database]
connection = mysql+pymysql://glance:lxcpassword@controller/glance
[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/
[image_format]
disk_formats = ami,ari,aki,vhd,vhdx,vmdk,raw,qcow2,vdi,iso,root-tar
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = glance
password = lxcpassword
[matchmaker_redis]
[oslo_concurrency]
[oslo_messaging_amqp]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_messaging_zmq]
[oslo_middleware]
[oslo_policy]
[paste_deploy]
flavor = keystone
[profiler]
[store_type_location_strategy]
[task]
[taskflow_executor]
root@controller:~#

root@controller:~# cat /etc/glance/glance-registry.conf
[DEFAULT]
[database]
connection = mysql+pymysql://glance:lxcpassword@controller/glance
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = serviceusername = glance
password = lxcpassword
[matchmaker_redis]
[oslo_messaging_amqp]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_messaging_zmq]
[oslo_policy]
[paste_deploy]
flavor = keystone
[profiler]
```
*   Populate the Glance database: `su -s /bin/sh -c "glance-manage db_sync" glance`
*   Start the Glance service daemons: `service glance-registry restart` `service glance-api restart`
*   Tải 1 qcow2 img cho Ubuntu `wget https://uec-images.ubuntu.com/releases/16.04/release-20170330/ubuntu-16.04-server-cloudimg-amd64-disk1.img`
*   Thêm img đó vào dịch vụ Glance `Openstack image create "ubuntu_16.04" --file ubuntu-16.04-server-cloudimg-amd64-disk1.img --disk-format qcow2 --container-format bare --public`
*   Liệt kê img `openstack image list`

****
### Cài đặt và cấu hình OpenStack Nova compute service
* Tạo database và user cho Nova 
```
mysql -u root -plxcpassword
MariaDB [(none)]> CREATE DATABASE nova_api;
Query OK, 1 row affected (0.00 sec)
MariaDB [(none)]> CREATE DATABASE nova;
Query OK, 1 row affected (0.00 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_api.* TO
'nova'@'localhost' IDENTIFIED BY 'lxcpassword';
Query OK, 0 rows affected (0.03 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%'
IDENTIFIED BY 'lxcpassword';
Query OK, 0 rows affected (0.00 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost'
IDENTIFIED BY 'lxcpassword';
Query OK, 0 rows affected (0.00 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%'
IDENTIFIED BY 'lxcpassword';
Query OK, 0 rows affected (0.00 sec)
MariaDB
```
*   Tạo Nova user và gán quyền 
````
openstack user create --domain default --password-prompt nova
User Password:
Repeat User Password:

openstack role add --project service --user nova admin
````

*   Tạo Nova service và endpoints
`openstack service create --name nova --description"OpenStack Compute" compute`
`openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1/%(tenant_id)s`
`openstack endpoint create --region RegionOne compute internal http://controller:8774/v2.1/%(tenant_id)s`
`openstack endpoint create --region RegionOne compute admin http://controller:8774/v2.1/%(tenant_id)s`

*   Cài đặt Nova package `apt install nova-api nova-conductor nova-consoleauth nova-novncproxy nova-scheduler`

*   Tạo file cấu hình Nova 
```
cat /etc/nova/nova.conf
[DEFAULT]
dhcpbridge_flagfile=/etc/nova/nova.conf
dhcpbridge=/usr/bin/nova-dhcpbridge
log-dir=/var/log/nova
state_path=/var/lib/nova
force_dhcp_release=True
verbose=True
ec2_private_dns_show_ip=True
enabled_apis=osapi_compute,metadata
transport_url = rabbit://openstack:lxcpassword@controller
auth_strategy = keystone
my_ip = 10.208.132.45
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
[database]
connection = mysql+pymysql://nova:lxcpassword@controller/nova
[api_database]
connection = mysql+pymysql://nova:lxcpassword@controller/nova_api
[oslo_concurrency]
lock_path = /var/lib/nova/tmp
[libvirt]
use_virtio_for_bridges=True
[wsgi]
api_paste_config=/etc/nova/api-paste.ini
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = lxcpassword
[vnc]
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip
[glance]
api_servers = http://controller:9292
```
*   Khởi động các dịch vụ sau của Nova
```
nova-api 
nova-consoleauth 
nova-scheduler 
nova-conductor 
nova-novncproxy 
```
*   Cài đặt Nova compute `nova-compute`
*   Cập nhật file cấu hình Nova
```
cat /etc/nova/nova.conf
[DEFAULT]
dhcpbridge_flagfile=/etc/nova/nova.conf
dhcpbridge=/usr/bin/nova-dhcpbridge
log-dir=/var/log/nova
state_path=/var/lib/nova
force_dhcp_release=True
verbose=True
ec2_private_dns_show_ip=True
enabled_apis=osapi_compute,metadata
transport_url = rabbit://openstack:lxcpassword@controller
auth_strategy = keystone
my_ip = 10.208.132.45
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
compute_driver = libvirt.LibvirtDriver
[database]
connection = mysql+pymysql://nova:lxcpassword@controller/nova
[api_database]
connection = mysql+pymysql://nova:lxcpassword@controller/nova_api
[oslo_concurrency]
lock_path = /var/lib/nova/tmp
[libvirt]
use_virtio_for_bridges=True
[wsgi]
api_paste_config=/etc/nova/api-paste.ini[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = lxcpassword
[vnc]
enabled = True
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html
[glance]
api_servers = http://controller:9292
```
*   Chỉ định drive ảo hóa cho Nova
```
cat /etc/nova/nova-compute.conf
[DEFAULT]
compute_driver=libvirt.LibvirtDriver
[libvirt]
virt_type=kvm
```

****
### Cài đặt và cấu hình OpenStack Neutron networking service
*   Tạo CSDL
```
mysql -u root -plxcpassword
MariaDB [(none)]> CREATE DATABASE neutron;
Query OK, 1 row affected (0.00 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO
'neutron'@'localhost' IDENTIFIED BY 'lxcpassword';
Query OK, 0 rows affected (0.00 sec)
MariaDB [(none)]> GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%'
IDENTIFIED BY 'lxcpassword';
Query OK, 0 rows affected (0.00 sec)
MariaDB [(none)]> exit
Bye
```
*   Tạo user và role admin
```
openstack user create --domain default --password-prompt neutron
User Password:
Repeat User Password: 

openstack role add --project service --user neutron admin
```
*   Tạo service và endpoints
`openstack service create --name neutron --description "OpenStack Networking" network`
`openstack endpoint create --region RegionOne network public http://controller:9696`
`openstack endpoint create --region RegionOne network internal http://controller:9696`
`openstack endpoint create --region RegionOne network admin http://controller:9696`

*   Cài đặt Neutron package:`apt install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agen`

* Tạo file cấu hình Neutron:
```
cat /etc/neutron/neutron.conf
[DEFAULT]
core_plugin = ml2
service_plugins = router
allow_overlapping_ips = True
transport_url = rabbit://openstack:lxcpassword@controller
auth_strategy = keystone
notify_nova_on_port_status_changes = True
notify_nova_on_port_data_changes = True
[agent]
root_helper = sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf
[cors]
[cors.subdomain]
[database]
connection = mysql+pymysql://neutron:lxcpassword@controller/neutron
[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = neutron
password = lxcpassword
[matchmaker_redis]
[nova]
auth_url = http://controller:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = nova
password = lxcpassword
[oslo_concurrency]
[oslo_messaging_amqp]
[oslo_messaging_notifications]
[oslo_messaging_rabbit]
[oslo_messaging_zmq]
[oslo_policy]
[qos]
[quotas]
[ssl]
```
*   Định nghĩa loại mạng và extensions dùng cho Neutron
```
cat /etc/neutron/plugins/ml2/ml2_conf.ini[DEFAULT]
[ml2]
type_drivers = flat,vlan,vxlan
tenant_network_types = vxlan
mechanism_drivers = linuxbridge,l2population
extension_drivers = port_security
[ml2_type_flat]
flat_networks = provider
[ml2_type_geneve]
[ml2_type_gre]
[ml2_type_vlan]
[ml2_type_vxlan]
vni_ranges = 1:1000
[securitygroup]
enable_ipset = True
```

*   ĐỊnh nghĩa interface sẽ gán cho bridge và IP mà brigde đc gasnws vào 
```
cat /etc/neutron/plugins/ml2/linuxbridge_agent.ini
[DEFAULT]
[agent]
[linux_bridge]
physical_interface_mappings = provider:eth1
[securitygroup]
enable_security_group = True
firewall_driver =
neutron.agent.linux.iptables_firewall.IptablesFirewallDriver
[vxlan]
enable_vxlan = True
local_ip = 10.208.132.45
l2_population = True
```
*   Cấu hình Layer 3 Agent
```
cat /etc/neutron/l3_agent.ini
[DEFAULT]
interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriver
[AGENT]
```

*   Cấu hình DHCP
```
cat /etc/neutron/dhcp_agent.ini
[DEFAULT]
interface_driver = neutron.agent.linux.interface.BridgeInterfaceDriverdhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = True
[AGENT]
```
*   Tạo file cấu hình cho metadata agents
```
cat /etc/neutron/metadata_agent.ini
[DEFAULT]
nova_metadata_ip = controller
metadata_proxy_shared_secret = lxcpassword
[AGENT]
[cache]
```
*   Cập nhật cấu hình file cho Nova để bao gồm cả Neutron
```
cat /etc/nova/nova.conf
[DEFAULT]
dhcpbridge_flagfile=/etc/nova/nova.conf
dhcpbridge=/usr/bin/nova-dhcpbridge
log-dir=/var/log/nova
state_path=/var/lib/nova
force_dhcp_release=True
verbose=True
ec2_private_dns_show_ip=True
enabled_apis=osapi_compute,metadata
transport_url = rabbit://openstack:lxcpassword@controller
auth_strategy = keystone
my_ip = 10.208.132.45
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
compute_driver = libvirt.LibvirtDriver
scheduler_default_filters = RetryFilter, AvailabilityZoneFilter,
RamFilter, ComputeFilter, ComputeCapabilitiesFilter,
ImagePropertiesFilter, ServerGroupAntiAffinityFilter,
ServerGroupAffinityFilter
[database]
connection = mysql+pymysql://nova:lxcpassword@controller/nova
[api_database]
connection = mysql+pymysql://nova:lxcpassword@controller/nova_api
[oslo_concurrency]
lock_path = /var/lib/nova/tmp
[libvirt]
use_virtio_for_bridges=True
[wsgi]
api_paste_config=/etc/nova/api-paste.ini[keystone_authtoken]
auth_uri = http://controller:5000
auth_url = http://controller:35357
memcached_servers = controller:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = nova
password = lxcpassword
[vnc]
enabled = True
vncserver_listen = $my_ip
vncserver_proxyclient_address = $my_ip
novncproxy_base_url = http://controller:6080/vnc_auto.html
[glance]
api_servers = http://controller:9292
[libvirt]
virt_type = kvm
[neutron]
url = http://controller:9696
auth_url = http://controller:35357
auth_type = password
project_domain_name = default
user_domain_name = default
region_name = RegionOne
project_name = service
username = neutron
password = lxcpassword
service_metadata_proxy = True
metadata_proxy_shared_secret = lxcpassword
```

*   Populate CSDL Neutron
```
su -s /bin/sh -c "neutron-db-manage --config-file
/etc/neutron/neutron.conf --config-file
/etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
INFO [alembic.runtime.migration] Context impl MySQLImpl.
INFO [alembic.runtime.migration] Will assume non-transactional DDL.
Running upgrade for neutron ...
INFO [alembic.runtime.migration] Context impl MySQLImpl.
INFO [alembic.runtime.migration] Will assume non-transactional DDL.
INFO [alembic.runtime.migration] Running upgrade -> kilo, kilo_initial  
```
*   Khởi động lại các dịch vụ của Nova nà Neutron
```
neutron-server
neutron-linuxbridge-agent
neutron-dhcp-agent
neutron-metadata-agent
neutron-l3-agent
nova-api
nova-compute
```
*   Tạo mạng  `openstack network create nat`
*   Chỉ định DNS server, default gateway, subnet range: `openstack subnet create --network nat --dns-nameserver 8.8.8.8 --gateway 192.168.0.1 --subnet-range 192.168.0.0/24 nat`
*   Cập nhật thông tin về subnet: `neutron net-update nat --router:external Updated network: nat`
*   Tạo  software router: `openstack router create router`

*   Với quyền admin, gán subnet vào router vừa tạo
```
. rc.admin
root@controller:~# neutron router-interface-add router nat
Added interface 2e1e2fd3-1819-489b-a21f-7005862f9de7 to router router.
```

*   Liệt kê không gian tên mạng vừa tạo
`ip netns`
*   Liệt kê các port trên router `neutron router-port-list router`
*   Liệt kê các mạng: `openstack network list`
