# KVM
**** 
### Giới thiệu
**KVM (Kernel-based virtual machine)** là giải pháp ảo hóa cho hệ thống linux trên nền tảng phần cứng x86 có các module mở rộng hỗ trợ ảo hóa (Intel VT-x hoặc AMD-V). 

-	Về bản chất, KVM không thực sự là một hypervisor có chức năng giải lập phần cứng để chạy các máy ảo. Chính xác KVM chỉ là một **module của kernel linux** hỗ trợ **cơ chế mapping các chỉ dẫn trên CPU ảo (của guest VM) sang chỉ dẫn trên CPU vật lý (của máy chủ chứa VM)**. Hoặc có thể hình dung KVM giống như một driver cho hypervisor để sử dụng được tính năng ảo hóa của các vi xử lý như Intel VT-x hay AMD-V, mục tiêu là tăng hiệu suất cho guest VM.

-	KVM hiện nay được thiết kế để giao tiếp với các hạt nhân thông qua một kernel module có thể nạp được. Hỗ trợ một loạt các hệ thống điều hành máy  guest như: Linux, BSD, Solaris, Windows, Haiku, ReactOS và  hệ điều hành  nghiên cứu AROS. Sử dụng  kết  hợp  với QEMU, KVM có thể chạy Mac OS X.

-	Trong kiến trúc của KVM, Virtual machine được thực hiện như là quy trình xử lý thông thường của Linux, được lập lịch hoạt động như các scheduler tiểu chuẩn của Linux. Trên thực tế, mỗi CPU ảo hoạt động như một tiến trình xử lý của Linux. Điều này cho phép KVM được hưởng lợi từ tất cả các tính năng của nhân Linux. 
  Kiến trúc KVM
![](http://imgur.com/JevJgt7.jpg)


  
### Các tính năng của ảo hóa KVM

**Security – Bảo mật**

* Vì KVM được coi như một tiến trình xử lý của Linux, nên nó tận dụng được mô hình bảo mật tiêu chuẩn của Linux để cung cấp khả năng điều khiển và cô lập tài nguyên. 
    * Nhân Linux sử dụng SELinux (Security-Enhanced Linux) để thêm quyền điều khiển truy cập, bảo mật đa mức và bảo mật đa tiêu chí, và thực thi các chính sách bắt buộc.
    * SELinux cung cấp cơ chế cách ly tài nguyên nghiêm ngặt và hạn chế cho các tiến trình chạy trong nhân Linux.

* Dự án Svirt tích hợp bảo mật Mandatory Access Control (MAC) với KVM – xây dựng trên SELinux để cung cấp một nền tảng ảo hóa cho phép người quản trị định nghĩa các chính sách cho sự cô lập máy ảo. 
    * Svirt đảm bảo máy ảo không thể bị truy cập bởi các tiến trình khác (hoặc máy ảo khác), việc này có thể được mở rộng thêm bởi người quản trị hệ thống định nghĩa ra các quyền hạn đặc biệt: như là nhóm các máy ảo chia sẻ chung nguồn tài nguyên.

**Memory management – Quản lý bộ nhớ**

* KVM thừa kế tính năng quản lý bộ nhớ mạnh mẽ của Linux. 
    * Vùng nhớ của máy ảo được lưu trữ trên cùng một vùng nhớ dành cho các tiến trình Linux khác và có thể swap.
    * KVM hỗ trợ NUMA (Non-Uniform Memory Access - bộ nhớ thiết kế cho hệ thống đa xử lý) cho phép tận dụng hiệu quả vùng nhớ kích thước lớn.

* KVM hỗ trợ các tính năng ảo của mới nhất từ các nhà cung cấp CPU như EPT (Extended Page Table) của Microsoft, Rapid Virtualization Indexing (RVI) của AMD để giảm thiểu mức độ sử dụng CPU và cho thông lượng cao hơn.

* Việc chia sẻ bộ nhớ được hỗ trợ thông qua một tính năng của nhân gọi là Kernel Same-page Merging (KSM). 
    * KSM quét tất cả các yêu cầu về vùng nhớ cần thiết cho máy ảo và định danh cho từng máy ảo, sau đó tổ hợp vào thành một yêu cầu về vùng nhớ duy nhất để chia sẻ chung cho các máy ảo, lưu trữ vào một bản copy.

**Storage – Lưu trữ**

* KVM sử dụng khả năng lưu trữ hỗ trợ bởi Linux để lưu trữ các images máy ảo, bao gồm các local dish với chuẩn IDE, SCSI và SATA, Network Attached Storage (NAS) bao gồm NFS và SAMBA/CIFS, hoặc SAN được hỗ trợ iSCSI và Fibre Chanel.

* KVM là một phần trong nhân Linux, nên nó có thể tận dụng hạ tầng lưu trữ đã được chứng minh và đáng tin cậy với sự hỗ trợ từ tất cả các nhà cung cấp hàng đầu trong lĩnh vực Storage.

* KVM cũng hỗ trợ các image của máy ảo trên hệ thống chia sẻ tập tin như GFS2 cho phép các image máy ảo được chia sẻ giữa các host hoặc các logical volumn.

* Định dạng image tự nhiên của KVM là QCOW2 – hỗ trợ việc snapshot cho phép snapshot nhiều mức, nén và mã hóa dữ liệu.

**Live migration**

* KVM hỗ trợ live migration cung cấp khả năng di chuyển ác máy ảo đang chạy giữa các host vật lý mà không làm gián đoạn dịch vụ. 
    * Khả năng live migration là trong suốt với người dùng, các máy ảo vẫn duy trì trạng thái bật, kết nối mạng vẫn đảm bảo và các ứng dụng của người dùng vẫn tiếp tục duy trì trong khi máy ảo được đưa sang một host vật lý mới.

* KVM cũng cho phép lưu lại trạng thái hiện tại của máy ảo để cho phép lưu trữ và khôi phục trạng thái đó vào lần sử dụng tiếp theo.

**Performance and scalability**

* KVM kế thừa hiệu năng và khả năng mở rộng của Linux, hỗ trợ các máy ảo với 16 CPUs ảo, 256GB RAM và hệ thống máy chủ lên tới 256 cores và trên 1TB RAM.

# QEMU
****

### Giới thiệu
**QEMU là một trình ảo hóa** người dùng type 2(tức là chạy trên hệ điều hành máy chủ) để thực hiện ảo hóa phần cứng (không bị nhầm lẫn với ảo hóa hỗ trợ phần cứng), chẳng hạn như đĩa, mạng, VGA, PCI, USB, cổng nối tiếp / song song, v.v. Nó linh hoạt ở chỗ nó có thể mô phỏng CPU thông qua dịch nhị phân động (DBT) cho phép mã được viết cho một bộ xử lý nhất định được thực thi trên một bộ xử lý khác (ví dụ ARM trên x86 hoặc PPC trên ARM). 
    * Mặc dù QEMU có thể tự chạy và mô phỏng tất cả các tài nguyên của máy ảo, vì tất cả các mô phỏng được thực hiện trong phần mềm, nó cực kỳ chậm.

### Tính năng 
**QEMU có thể lưu và khôi phục trạng thái của máy ảo với tất cả các chương trình đang chạy**. 
* Hệ điều hành khách không cần patching để chạy bên trong QEMU.

**Tiny Code Generator**
Tiny Code Generator (TCG) nhằm loại bỏ sự thiếu sót của việc dựa vào một phiên bản cụ thể của GCC hoặc bất kỳ trình biên dịch nào, thay vào đó kết hợp trình biên dịch (trình tạo mã) vào các tác vụ khác do QEMU thực hiện trong thời gian chạy.


**Cấu trúc ảo hóa KVM kết hợp QEMU**

Cấu trúc
![](https://camo.githubusercontent.com/35ed680bfee92e09ae2377055f0cddcef96921b5/687474703a2f2f696d6775722e636f6d2f777341356846372e6a7067)
**Trong đó** 
* **User-facing tools:** Là các công cụ quản lý máy ảo hỗ trợ KVM. Các công cụ có giao diện đồ họa (như virt-manager) hoặc giao diện dòng lệnh như (virsh) và virt-tool (Các công cụ này được quản lý bởi thư viện libvirt).

- **Management layer:** Lớp này là thư viện libvirt cung cấp API để các công cụ quản lý máy ảo hoặc các hypervisor tương tác với KVM thực hiện các thao tác quản lý tài nguyên ảo hóa, bởi vì KVM chỉ là một module của nhân hỗ trợ cơ chế mapping các chỉ dẫn của CPU ảo để thực hiện trên CPU thật, nên tự thân KVM không hề có khả năng giả lập và quản lý tài nguyên ảo hóa. Mà phải dùng nhờ các công nghệ hypervisor khác, thường là QEMU.

- **Virtual machine:** Chính là các máy ảo người dùng tạo ra. Thông thường, nếu không sử dụng các công cụ như virsh hay virt-manager, KVM sẽ sử được sử dụng phối hợp với một hypervisor khác điển hình là QEMU.

- **Kernel support:** Chính là KVM, cung cấp một module làm hạt nhân cho hạ tầng ảo hóa (kvm.ko) và một module kernel đặc biệt chỉ hỗ trợ các vi xử lý VT-x hoặc AMD-V (kvm-intel.ko hoặc kvm-amd.ko) để nâng cao hiệu suất ảo hóa.

#### Tác vụ với qemu
* **Quản lý disk image với QEMU**
*   Tạo 1 img: `qemu-img create -f {type} {name}.img {size} `
    *   Trong đó: `type` có thể là `raw` `qcow2` `qcow` `dmg` `nbd` `vdi` `vmdk` `vhdx`
*   Tăng giảm dung lượng của 1 img: `qemu-img resize -f {type}{name}.img {+-}{size}`
*   Xem thông tin thêm về image:    `qemu-img info {name}.img`
*   **Chạy máy ảo với qemu** : 
    `qemu-system-x86_64 -name debian -vnc 146.20.141.254:0 -cpu Nehalem -m 1024 -drive format=raw,index=2,file=debian.img -daemonize`

    *   Trong đó:
        * `qemu-system-x86_64`: gỉa lập kiến trúc `x86-64` CPU,
        
        * `-cpu Nehalem`  giả lập kiến trúc mẫu Nehalem CPU ( codename for an Intel processor microarchitecture released in November 2008)
        
        * `-vnc` khởi động VNC server với địa chỉ IP đã đặt để có thể kết nối đến máy  VM`
        
        *   `-m` lượng memory khởi tạo (MB)
        
        * `format=raw` format của disk img
        
        *   `file`: vị trí của img
        
        *   `index`: chỉ định xem load từ phân vùng nào của disk img (nơi chưa bootloader và root) ( nếu có nhiều)
        
        *   `-daemonize` để chạy trên background        
        
*   **Chạy máy ảo với qemu-kvm**
    `qemu-system-x86_64 -name debian -vnc 146.20.141.254:0 -m 1024 -drive format=raw,index=2,file=debian.img` **`-enable-kvm`** `-daemonize`
    
    *   Trong đó: Giống như trên, thêm `-enable-kvm`

    Hoặc
    
    khi có cài đặt: `qemu-kvm` có thể chạy lệnh :
    `kvm -name debian -vnc 146.20.141.254:0 -cpu Nehalem -m 1024 -drive format=raw,index=2,file=debian.img -daemonize`
    
    Trong đó `kvm` đã bao gồm cả `qemu-system-x86_64` và `-enable-kvm`, 2 câu lệnh chức năng như nhau
    

**Tại sao cần kết hợp KVM-QEMU**

* **KVM** là driver cho hypervisor để sử dụng được virtualization extension của physical CPU nhằm boost performance cho guest VM. KVM như định nghĩa trên trang chủ thì là core virtualization infrastructure mà thôi, nó được các hypervisor khác lợi dụng làm back-end để tiếp cận được các công nghệ hardware acceleration (Dịch code để mô phỏng phần cứng)

* **QEMU** là một Emulator nên nó có bộ dịch của nó là TCG (Tiny Code Generate) để xử lý các yêu cầu trên CPU ảo và giả lập kiến trúc của máy ảo. 
    *  QEMU là một hypervisor type 2 . Nhằm nâng cao hiệu suất của VM. Cụ thể, lúc tạo VM bằng QEMU có VirtType là KVM thì khi đó các instruction có nghĩa đối với virtual CPU sẽ được QEMU sử dụng KVM để mapping thành các instruction có nghĩa đối với physical CPU. Làm như vậy sẽ nhanh hơn là chỉ chạy độc lập QEMU, vì nếu không có KVM thì QEMU sẽ phải quay về (fall-back) sử dụng translator của riêng nó là TCG để chuyển dịch các instruction của virtual CPU rồi đem thực thi trên physical CPU.

=> Khi QEMU/KVM kết hợp nhau thì tạo thành type-1 hypervisor.

# Tóm tắt
***
*   QEMU đã là một type-2 hypervisor với đầy đủ khả năng tạo ra guest VM có các hardware được giả lập. Không cần đến KVM
*   KVM không thực sự là một hypervisor có chức năng giả lập hardware để có thể chạy guest VM.

=>   QEMU cần KVM để boost performance và ngược lại KVM cần QEMU (modified version) để cung cấp giải pháp full virtualization hoàn chỉnh.

# libvirt
****
### Giới thiệu

**Libvirt** là một bộ các phần mềm mà cung cấp các cách thuận tiện để quản lý máy ảo và các chức năng của ảo hóa, như là chức năng quản lý lưu trữ và giao diện mạng. Những phần mềm này bao gồm một thư viện API, daemon (libvirtd) và các gói tiện tích giao diện dòng lệnh (virsh).

 **Mục đích chính của Libvirt** là cung cấp một cách duy nhất để quản lý ảo hóa từ các nhà cung cấp và các loại hypervisor khác nhau. Ví dụ, dòng lệnh virsh list –all có thể được sử dụng để liệt kê ra các máy ảo đang tồn tại cho một số hypervisor được hỗ trợ (KVM, Xen, Vmware ESX, … ). Không cần thiết phải học một tool xác định cho từng hypervisor.

### Các chức năng chính

**VM management** – Quản lý máy ảo: Quản lý vòng đời các domain như là start, stop, pause, save, restore và migrate. Các hoạt động hotplug cho nhiều loại thiết bị bao gồm disk và network interfaces, memory, và cpus.

**Remote machine support**: Tất cả các chức năng của libvirt có thể được truy cập trên nhiều máy chạy libvirt deamon, bao gồm cả các remote machine. Hỗ trợ kết nối từ xa, với cách đơn giản nhất là dùng SSH – không yêu cầu cấu hình thêm gì thêm. 
* Nếu example.com đang chạy libvirtd và truy cập SSH được cho phép, câu lệnh sau sẽ cung cấp khả năng truy cập tới tất cả câu lệnh virsh trên remote host cho các máy ảo qemu/kvm: `virsh --connect qemu+ssh://root@example.com/system`



**Storage management:** bất kì host nào đang chạy libvirt daemon có thể được sử dụng để quản lý nhiều loại storage: tạo file image với nhiều định dạng phong phú (qcow2, vmdk, raw, …), mount NFS shares, liệt kê các nhóm phân vùng LVM, tạo nhóm phân cùng LVM mới, phân vùng ổ cứng, mount iCSI shares, và nhiều hơn nữa. vì libvirt làm tốt việc truy cập từ xa nên những tùy chọn này là có sẵn trên remote host. 

**Network interface management:** bất kì host nào chạy libvirt daemon có thể được sử dụng để quản lý các interface netowork vật lý và logic. Liệt kê các interface đang tồn tại, cũng như là cấu hình (hoặc tạo, xóa) các interfaces, bridge, vlans, và bond devices.

**Virtual NAT and Route based networking:** Quản lý và tạo các mạng ảo, Libvirt virtual network sử dụng firewall để hoạt động như là router, cung cấp các máy ảo trong suốt truy cập tới mạng của host.

# virt – virsh command tool
****

### Giới thiệu
Là bộ công cụ dòng lệnh để tương tác với libvirtd có hỗ trợ quản lý KVM.

Một số khác biệt giữa bộ dòng lệnh virt và virsh:

* virsh là bộ công cụ quản lý libvirtd đi kèm sẵn khi cài đặt libvirt-bin, còn bộ công cụ virt cần phải cài đặt riêng.

* Virsh không thể tương tác trực tiếp tới libvirtd để sử dụng tài nguyên mà chỉ có thể sử dụng tài nguyên hypervisor thông qua việc thực thi các file xml. Ngược lại, bộ công cụ virt với virt-install có thể triển khai trực tiếp máy ảo thông qua câu lệnh.

* Virsh có nhiều tùy chọn hơn dùng để quản lý (bật, tắt, sửa, xóa, …) các thành phần ảo hóa (máy ảo, mạng ảo, storage ảo, …) trong libvirt – tất nhiên thông qua tương tác với file xml. Còn bộ công cụ virt tập trung chủ yếu vào quản lý các máy ảo.

* Bộ công cụ virt có tùy chọn –c / --connect URI nên có thể quản lý libvirt server trên các host khác nhau, còn virsh chỉ quản lý trên local host.

### virsh command tool
* Cấu trúc câu lệnh: `virsh [OPTION]... <command> <domain> [ARG]...`

**Một số ví dụ thường dùng:**

- Liệt kê các máy ảo đang chạy: (liệt kê hết các máy ảo dù chạy hay không thêm tùy chọn `--all`):
`virsh list`

    ```
    quanlm@quanlm-laptop:~$ virsh list
     Id    Name                           State
    ----------------------------------------------------
    quanlm@quanlm-laptop:~$ virsh list --all
     Id    Name                           State
    ----------------------------------------------------
     -     rabbit1                        shut off
     -     rabbit2                        shut off
     -     rabbit3                        shut off
    ```
* Tạo máy ảo:
    *   Tạo file {name}.xml để làm file xml cho máy ảo 
    Ví dụ: 
    ```
    <domain type='kvm' id='1'>
    <name>kvm1</name>
    <memory unit='KiB'>1048576</memory>
    <vcpu placement='static'>1</vcpu>
    <os>
        <type arch='x86_64' machine='pc-i440fx-trusty'>hvm</type>
        <boot dev='hd'/>
    </os>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>restart</on_crash>
    <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
        <driver name='qemu' type='raw'/>
        <source file='/tmp/debian.img'/>
        <target dev='hda' bus='ide'/>
        <alias name='ide0-0-0'/>
        <address type='drive' controller='0' bus='0' target='0' unit='0'/>
    </disk>
    <interface type='network'>
        <source network='default'/>
        <target dev='vnet0'/>
        <model type='rtl8139'/>
        <alias name='net0'/>
        <address type='pci' domain='0x0000' bus='0x00' slot='0x03'
    function='0x0'/>
        </interface>
        <graphics type='vnc' port='5900' autoport='yes'
    listen='146.20.141.158'>
            <listen type='address' address='146.20.141.158'/>
        </graphics>
        </devices>
        <seclabel type='none'/>
    </domain>
    ```
    Trong đó:
        *   `type` & `id`: loại và id của máy ảo
        *   `name`: tên máy ảo sẽ hiển thị 
        *   `memory`: lượng memory của máy ảo 
        *   `vcpu`: số lượng cpu của máy ảo
        *   `os`
            *   `type arch`: kiến trúc cpu là `x86_64`
            *   `hvm`: full virtualize
            *   `boot dev` chỉ định boot device
        * 3 thông số tiếp theo chỉ định hành động khi máy ảo tắt, khởi động lại hoặc bị crash.
        *   Định nghĩa các device của máy ảo như disk, card mạng, .....
        
    
*   Định nghĩa máy ảo mới tạo với file `.xml`
    `virsh define kvm1.xml`

- Bật máy ảo:
`virsh start <VM_name>`
    ```
    quanlm@quanlm-laptop:~$ virsh start rabbit1
    Domain rabbit1 started
    
    quanlm@quanlm-laptop:~$ virsh list
     Id    Name                           State
    ----------------------------------------------------
     2     rabbit1                        running
    
    ```
- Tự động bật máy ảo khi khởi động hệ thống: ( thêm `--disable` để hủy tự động bật)
`virsh autostart <VM_name>`
    ```
    quanlm@quanlm-laptop:~$ virsh autostart rabbit1
    Domain rabbit1 marked as autostarted
    
    quanlm@quanlm-laptop:~$ virsh autostart rabbit1 --disable
    Domain rabbit1 unmarked as autostarted
    ```

- Reboot máy ảo:
`virsh reboot <VM_name>`
    ```
    quanlm@quanlm-laptop:~$ virsh reboot rabbit1
    Domain rabbit1 is being rebooted
    ```
* Tắt máy ảo:
`virsh destroy <VM_name>`

* Xóa máy ảo:
`virsh undefined <VM_name>`

- Lưu lại trạng thái đang hoạt động của máy ảo vào một file và sau này restore lại:
    `virsh save <VM_name> <VM_name_time>.state ( time tùy chọn để sau này dễ nhớ)`
    ```
    quanlm@quanlm-laptop:~$ virsh save rabbit1 rabbit1.state
    Domain rabbit1 saved to rabbit1.state
    ```
- Để restore lại máy ảo vừa lưu:
    `virsh restore <VM_name_time>.state`
    ```
    quanlm@quanlm-laptop:~$ virsh restore rabbit1.state 
    Domain restored from rabbit1.state
    ```

* Để quản lý các thành phần ảo khác như mạng ảo, pool ảo, volumn ảo, … thì sẽ dùng với cú pháp chung như sau:
`virsh <object>-<command> <object_name>`


* Để console tới máy ảo
`virsh console <VM_name>`

```
quanlm@quanlm-laptop:~$ virsh console rabbit1
error: The domain is not running

quanlm@quanlm-laptop:~$ virsh console rabbit1
Connected to domain rabbit1
Escape character is ^]
[    0.000000] Linux version 4.15.0-72-generic (buildd@lcy01-amd64-026) (gcc version 7.4.0 (Ubuntu 7.4.0-1ubuntu1~18.04.1)) #81-Ubuntu SMP Tue Nov 26 12:20:02 UTC 2019 (Ubuntu 4.15.0-72.81-generic 4.15.18)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-4.15.0-72-generic root=UUID=995a2cb8-7ebb-4e32-9c4a-312146cdce74 ro console=tty1 console=ttyS0
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
[    0.000000] x86/fpu: Enabled xstate features 0x7, context size is 832 bytes, using 'standard' format.
[    0.000000] e820: BIOS-provided physical RAM map:

...
...
...

Ubuntu 18.04.3 LTS rabbitmq1 ttyS0

rabbitmq1 login: root
Password: 
Last login: Fri Jan  3 09:13:13 UTC 2020 on ttyS0
Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-72-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 System information disabled due to load higher than 1.0

 * Overheard at KubeCon: "microk8s.status just blew my mind".

     https://microk8s.io/docs/commands#microk8s.status

 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch

0 packages can be updated.
0 updates are security updates.


root@rabbitmq1:~# 
```





### virt command tool

Bộ câu lệnh virt gồm rất nhiều câu lệnh để quản lý máy ảo có hỗ trợ quản lý KVM như: virt-install (cài đặt máy ảo), virt-viewer (console tới máy ảo), virt-log (đọc log của máy ảo), virt-xml (dùng để sửa các cấu hình trong file xml), virt-edit (sửa cấu hình máy ảo), …

* **virt-install**
    * Là công cụ dòng lệnh dùng để tạo các máy ảo KVM, Xen, hoặc LXC sử dụng libvirt để quản lý hypervisor.
    * Hỗ trợ giao diện đồ họa cho máy ảo sử dụng VNC hoặc SPICE, cũng như là chế độ text thông qua console. Máy ảo có thể được cấu hình sử dụng một hoặc nhiều ổ đĩa ảo, nhiều interface mạng, physical USB, PCI devices, …

    * Cấu trúc câu lệnh: `virt-install [OPTION]... `
        * Ví dụ: Tạo máy ảo từ 1 img có sẵn:
 ```
        quanlm@quanlm-laptop:/works/home/quan/Downloads$ virt-install \
>               --connect qemu:///system \
>               --name kvm1 \
>               --memory 512 \
>               --vcpus 1 \
>               --disk   /works/home/quan/Downloads/xenial-server-cloudimg-amd64-disk1.img \
>               --import \
>               --network network=default \
>               --graphics vnc,listen='0.0.0.0'   
    Error setting up logfile: No write access to logfile /home/quan/.cache/virt-manager/virt-install.log
    WARNING  No operating system detected, VM performance may suffer. Specify an OS with --os-variant for optimal results.
    
    Starting install...
```
Trong đó, 1 số thông số như: 
   * name: Tên máy ảo
   * description: Mô tả server
   * os-type: loại hệ điều hành: linux, unix, windows
   * os-variant: Biến thể của hđh, 
        * với linux có thể là rhel6, centos6, ubuntu14, suse11, fedora6 , etc.
        * với  windows, có thể là win10, win8, win7, ....
   * ram: Bộ nhớ cho VM ( MB))
   * vcpu: tổng số Virtual CPU cho VM
   * disk: Đường dẫn đến file img
   * network default:
        
* Ta có thể thấy sẽ có 1 virt-viewer hiện lên console tới máy ảo: 
        ![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-01-07%2010-14-44.png)
* Hoặc kết nối đến với máy ảo mới tạo sử dụng `visrh console kvm1`
    ```
    quanlm@quanlm-laptop:~$ virsh console kvm1
    Connected to domain kvm1
    Escape character is ^]
    
    Ubuntu 16.04.6 LTS ubuntu ttyS0
    
    ubuntu login: 
    Ubuntu 16.04.6 LTS ubuntu ttyS0
    
    ubuntu login: 
    ```
### Quản lý KVM sử dụng lib virt
*   Tăng memory máy ảo lên: `virsh setmem <name> --size <size>`
*   Tăng max mem lên: `virsh setmaxmem <name> --size <size>`
*   Tăng vCPU lên: `virsh edit kvm1`
    * Chỉnh sửa thông số sau  `<vcpu placement='static'>4</vcpu>`
*   Gắn  thêm đĩa vào máy ảo: `virsh attach-disk <VM_name> <disk_location> vda --live` thay `--live` = `--persist` nếu như muốn lưu lại sau khi máy restart
    *   Disk này có thể được tạo = lệnh dd: `dd if=/dev/zero of=/<disk_location> bs=1M count=1024`
    *    Ngoài ra còn có thể tạo file xml `<disk>.xml`
    ```
    <disk type='file' device='disk'>
    <driver name='qemu' type='raw' cache='none'/>
    <source file='<disk_location>'/>
    <target dev='vdb'/>
      </disk>
    ```    
    Sau đó: `virsh attach-device <VM_name> --live <disk_location>`
*   Bỏ đĩa khỏi máy ảo: `virsh detach-disk <VM_name> <target dev> --live`
*   Tạo 1 mount directory để chuyển file giữa máy ảo và máy chủ 
    *   Trên máy chủ: `mkdir /tmp/shared`
        *   Chỉnh sửa file xml của máy ảo, thêm 
        ```
        <filesystem type='mount' accessmode='passthrough'>
        <source dir='/tmp/shared'/>
        <target dir='tmp_shared'/>
        </filesystem>
        ```
    *   Trên máy ảo: 
        *   Tạo mount point: `mount -t 9p -o trans=virtio tmp_shared /mnt`
    
*   Tạo storage pool:
    *   Tạo thư mục làm pool
    *   Định nghĩa pool với file xml: 
    ```
    cat file_storage_pool.xml
    <pool type="dir">
    <name>file_virtimages</name>
    <target>
    <path>/var/lib/libvirt/images</path>
    </target>
    </pool>
    ```
    `virsh pool-define file_storage_pool.xml`
    * Xem thông tin về pool: `virsh pool-info file_virtimages`
    * Khỏi động pool: 
        *   `virsh pool-start file_virtimages`
        *   `virsh pool-autostart file_virtimages`
    *   Xem thông tin về volume trong pool: `virsh vol-info /var/lib/libvirt/images/kvm1.img`
        
*   Volume
    *   Tạo volume `virsh vol-create-as <pool> <vol> <size>`
    *   Resize volume `virsh vol-resize <vol> <size> --pool <pool>`
    *   Delete volume `virsh vol-delete <vol> --pool <pool>`
    *   Clone volume `virsh vol-clone <vol1> <vol2> --pool <pool>`
    
*   Quản lý secret (là đối tượng chưa thông tin nhạy cảm như mật khẩu,....)
    *   Định nghĩa secret: 
    ```
    cat volume_secret.xml
    <secret ephemeral='no'>
        <description>Passphrase for the iSCSI iscsi-target.linux-admins.net
    target server</description>
        <usage type='iscsi'>
            <target>iscsi_secret</target>
           </usage>
    </secret>   
    ```
        
    *   Tạo secret: `virsh secret-define volume_secret.xml`
    *   Đặt giá trị cho secret: `virsh secret-set-value 7ad1c208-c2c5-4723-8dc5-e2f4f576101a`
    *   Tạo 1 pool sử dụng secret đã tạo : 
    ```
    cat iscsi.xml
    <pool type='iscsi'>
        <name>iscsi_virtimages</name><source>
    <source>    
        <host name='iscsi-target.linux-admins.net'/>
        <device path='iqn.2004-04.ubuntu:ubuntu16:iscsi.libvirtkvm'/>
        <auth type='chap' username='iscsi_user'>    
            <secret usage='iscsi_secret'/>
        </auth>
    </source>
        <target>
            <path>/dev/disk/by-path</path>
        </target>
    </pool>
        ```
****

### Quản lý KVM networking với libvirt
**Linux bridge**
*  Để có thể thao tác với Linux bridge, ta cần package: `bridge-utils`
    *  Liệt kê bridge: `brctl show`
    *  Tắt virtual bridge: `ifconfig virbr0 down`
    *  Xóa : `brctl delbr virbr0`
    *  Tạo mới: `brctl addbr virbr0`
    *   Bật: `ifconfig virbr0 up`
    *   Gán địa chỉ: `ip addr add 192.168.122.1 dev virbr0`
    *   Gán interface ảo vào brigde: `brctl addif virbr0 vnet0`
    *   Kích hoạt STP (spanning tree protocol) `brctl stp virbr0 on`
      
**Open vSwitch**
Nhiều tính năng hơn Linux bridge như: chính sách định tuyến, ACLs,chính sách QoS, giám sát, taggìg VLAN, ....
* Để có thể thao tác với OVS ta cần  package: `openvswitch-switch`
    *   Tạo OVS switch: `ovs-vsctl add-br virbr1`
    *   Xóa OVS switch: `ovs-vsctl del-br virbr1`
    *   Thêm interface vào OVS switch: `ovs-vsctl add-port virbr1 vnet0`
    *   Bỏ interface: `ovs-vsctl del-port virbr1 vnet0`
    *   Cấu hình IP cho OVS switch: `ip addr add 192.168.122.1/24 dev virbr1`

**Cấu hình NAT forwarding** 
*  Tạo file xml định nghĩa NAT network : 
```
cat nat_net.xml
    
<network>
   <name>nat_net</name>
    <bridge name="virbr1"/>
    <forward/>
   <ip address="10.10.10.1" netmask="255.255.255.0">
        <dhcp>
            <range start="10.10.10.2" end="10.10.10.254"/>
        </dhcp>
     </ip>
</network>
```
  Trong đó: `<foward/>` sẽ định nghĩa kết nối NAT ra với máy chủ, nếu k có thì sẽ tạo ra 1 mạng độc lập  
* Định nghĩa mạng mới tạo: `virsh net-define nat_net.xml`
* Khởi động: `virsh net-start nat_net`
* Tự động: `virsh net-autostart nat_net`
* Xem thông tin: `virsh net-info nat_net`
* Cấu hình cho máy ảo dùng mạng mới: 
    ```
    <interface type='network'>
    ...
    <source network='nat_net'/>
    ...
    </interface>
    ```
*   Kiểm tra routing của mạng  mới:`iptables -L -n -t nat`

**Cấu hình bridge network**
    *   Tắt interface định bridge `ifdown eth1`
    *   Đặt IP tĩnh cho interface đó: 
    ```
    auto virbr2
    iface virbr2 inet static
        address 192.168.1.2
        netmask 255.255.255.0
        network 192.168.1.0
        broadcast 192.168.1.255
        gateway 192.168.1.1
        bridge_ports eth1
        bridge_stp on
        bridge_maxwait 0
    ```
    *  Khởi động lại interface: `ifup virbr2`
    *  Bỏ gưir packet qua `iptables`: `sysctl -w net.bridge.bridge-nf-call-iptables=0`
    *  Cho máy ảo dùng bridge: 
    ```
    <interface type='bridge'>
        <source bridge='virbr2'/>
    </interface>
    ```
    



