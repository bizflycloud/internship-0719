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
## Quản lý KVM sử dụng lib virt
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

## Quản lý KVM networking với libvirt
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

Với bridge này máy ảo sẽ có thể kết nối với mạng cùng subnet mà k cần NAT

**Cấu hình mạng thông qua PCI**
   *   Liệt kê tất cả thiết bị trên máy chủ: `virsh nodedev-list --tree`
*   Liệt kê các PCI enternet adapter

## Di chuyển KVM 

**Di chuyển thủ công ngoại tuyến sử dụng iSCSI storage pool**
* Trên iSCSI target cần package `iscsitarget` `iscsitarget-dkms`
* Kích hoạt chức năng   `sed -i 's/ISCSITARGET_ENABLE=false/ISCSITARGET_ENABLE=true/g' /etc/default/iscsitarge``
```
cat /etc/default/iscsitarget
ISCSITARGET_ENABLE=true
ISCSITARGET_MAX_SLEEP=3
# ietd options
# See ietd(8) for details
```
* Cấu hình block device 
```
cat /etc/iet/ietd.conf
Target iqn.2001-04.com.example:kvm
Lun 0 Path=/dev/loop1,Type=fileio
Alias kvm_lun
```
* Restart dịch vụ 
```
/etc/init.d/iscsitarget restart
* Removing iSCSI enterprise target devices: [ OK ]
* Stopping iSCSI enterprise target service: [ OK ]
* Removing iSCSI enterprise target modules: [ OK ]
* Starting iSCSI enterprise target service: [ OK ]
```

* Trên cả 2 máy ảo cài `open-iscsi`
*   Khởi động dịch vụ
```
sed -i 's/node.startup = manual/node.startup =
automatic/g' /etc/iscsi/iscsid.conf
root@kvm1/2:~# /etc/init.d/open-iscsi restart
```

* Truy vấn các iSCSI target server
```
iscsiadm -m discovery -t sendtargets -p iscsi_target
10.184.226.74:3260,1 iqn.2001-04.com.example:kvm
172.99.88.246:3260,1 iqn.2001-04.com.example:kvm
192.168.122.1:3260,1 iqn.2001-04.com.example:kvm
```
    
Tạo iSCSI storage pool trên 1 máy chủ
```
cat iscsi_pool.xml

<pool type="iscsi">
    <name>iscsi_pool</name>
    <source>
<host name="iscsi_target.example.com"/>
<device path="iqn.2001-04.com.example:kvm"/>
</source>
<target>
<path>/dev/disk/by-path</path>
</target>
</pool>
root@kvm1:~# virsh pool-define iscsi_pool.xml
Pool iscsi_pool defined from iscsi_pool.xml
```

**Di chuyển ngoại tuyến thủ công dùng glusterFS**
*   Cài đặt glusterFS trên cả 2 server `glusterfs-server`
*   Probe, tạo pool, mount volume (như các bước làm glusterFS))
*   Tạo VM trên server 1
```
virt-install --name kvm_gfs --ram 1024 --extra-args="text
console=tty0 utf8 console=ttyS0,115200" --graphics vnc,listen=0.0.0.0 --
hvm --
location=http://ftp.us.debian.org/debian/dists/stable/main/installer-
amd64/ --disk /tmp/kvm_gfs/gluster_kvm.img,size=5
```
*   dump file xml `virsh dumpxml kvm_gfs > kvm_gfs.xml`
*   Defined VM trên Máy chủ mới
```
virsh --connect qemu+ssh://kvm2/system define kvm_gfs.xml
Domain kvm_gfs defined from kvm_gfs.xml
```

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-04%2010-19-20.png)
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-04%2010-19-23.png)

**Di chuyển trực tuyến sử dụng bộ lệnh virsh với shared storage**
*   Di chuyển trực tiếp  đến server 2  (đã cấu hình iSCSI ở trên )
`virsh migrate --live iscsi_kvm qemu+ssh://kvm2/system`
*   **1 số lỗi có thể gặp phải:** 
    *   **Unsafe migration**
        * Giải pháp:   Cấu hình block device thêm thuộc tính  `cache=none` nếu chưa có .
    *   **Internal error: Attempt to migrate guest to the same host 02000100-0300-0400-0005-000600070008 .**
        * Giải pháp:    Bị trùng UUID, kiểm tra `virsh sysinfo | grep -B5 -A3 uuid` và đổi lại UUID của máy đích đến 
    *   **Unable to resolve address kvm2.localdomain service 49152: Name or service is not known**
        * Giải pháp: không phân giải được tên miền, sửa trong file hosts hoặc dùng ip  
    *   **error: internal error: unable to execute QEMU command 'drive-mirror': Failed to connect socket: Connection timed out**
        * Giải pháp:  Sửa trong file host và sử dụng lệnh `qemu+ssh://hostname` thay vì `qemu+ssh://ip`
        
**Di chuyển ngoại tuyến sử dụng bộ lệnh virsh với local image**
*   Đảm bảo có 1 VM đang chạy
*   2 server có thể liên lạc đươcj với nhau   
*   Sư dụng lệnh `   virsh migrate --offline --persistent kvm_no_sharedfs qemu+ssh://kvm2/system`
    *   Khi đó thì server 1 vẫn chạy, khi di chuyển xong thì máy ảo server 2 sẽ k khởi động luôn 

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-04%2009-57-33.png)
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-04%2009-57-36.png)
      
**Di chuyển trực tuyến sử dụng bộ lệnh virsh với local image**
*   Đảm bảo cả 2 server đều đang có VM đang chạy sử dụng local image 
*   2 server đều liên lạc được với nhau
*   Chuyển file đến server: `scp /tmp/kvm_no_sharedfs.img kvm2:/tmp/kvm_no_sharedfs.img`
*   Di chuyển VM đến server mới `virsh migrate --live --persistent --verbose --copy-storage-all kvm_no_sharedfs qemu+ssh://kvm2/system`

*   Di chuyển trở lại: `virsh migrate --live --persistent --verbose --copy-storage-inc kvm_no_sharedfs qemu+ssh://kvm/system`

![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-04%2009-45-11.png)
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-04%2009-44-55.png)

    Nếu có lỗi xảy ra xem lại  **1 số lỗi có thể gặp phải ở trên**KVM

## Giám sát và sao lưu máy ảo KVM
**Thu thập tài nguyên sử dụng bằng libvirt**
*   Thông tin về lượng CPU sử dụng của hypervisor `virsh nodecpustats --percent`
*   Thông tin về lượng bộ nhớ sử dụng của hypervisor  `virsh nodememstats`
*   Kiểm tra trạng thái của máy ảo : `virsh domstate kvm1`
*   Kiểm tra số lượng vCPU của máy ảo đang dùng: `virsh vcpucount --current kvm1 --live`
*   Kiểm tra chi tiết về vCPU của máy ảo : `virsh vcpuinfo kvm1`
*   Kiểm tra thông tin chung về VM: `virsh dominfo kvm1`
*   Kiểm tra về lượng bộ nhớ đang dùng của máy ảo: `virsh dommemstat --live kvm1`
*   Kiểm tra về block device kết nối với máy ảo: `virsh domblklist kvm1`
*   Kiểm tra thông tin về kích cỡ block device:`virsh domblkinfo --device hda kvm1`
*   Kiểm tra block device bị lỗi: `virsh domblkerror kvm1`
*   In ra thống kê vè block deivce: `virsh domblkstat --device hda --human kvm1`

**Giám sát máy ảo với Sensu**
*   Cài đặt redis và và rabbitMQ `redis-server` `rabbitmq-server`
*   Tạo vHost `sensu` với rabbitMQ 
    ```
    root@kvm:~# rabbitmqctl add_vhost /sensu
    Creating vhost "/sensu" ...
    ...done.
    
    root@kvm:~# rabbitmqctl add_user sensu secret
    Creating user "sensu" ...
    ...done.
    
    root@kvm:~# rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
    Setting permissions for user "sensu" in vhost "/sensu" ...
    ...done.
    
    ```
*   Cài đặt repository, keys của nó và cài đặt sensu 
    ```
    wget -q https://sensu.global.ssl.fastly.net/apt/pubkey.gpg -
    O- | apt-key add -
    OK
    
    root@kvm:~# echo "deb https://sensu.global.ssl.fastly.net/apt sensu
    main" | tee /etc/apt/sources.list.d/sensu.list
    deb https://sensu.global.ssl.fastly.net/apt sensu main
    
    root@kvm:~# apt-get update
    ...
    
    root@kvm:~# apt-get install -y sensu
    ```
* Tạo file Sensu API( JSON)
    ```
    /etc/sensu/conf.d# cat api.json
    
    {
        "api": {
            "host": "localhost",
            "bind": "0.0.0.0",
            "port": 4567
        }
    }
    ```
* Cấu hình phương thức vận chuyển cho Sensu sử dụng rabbitMQ
    ```
    cat transport.json
    
    {
        "transport": {
            "name": "rabbitmq",
            "reconnect_on_error": true
        }
    }
    ```

*   Cấu hình rabbitMQ chấp nhận kết nối
    ```
    cat rabbitmq.json
    
    {
        "rabbitmq": {
            "host": "0.0.0.0",
            "port": 5672,
            "vhost": "/sensu",
            "user": "sensu",
            "password": "secret"
        }
    }
    ```

*   Cấu hình host và port cho dịch vụ redis theo dõi

    ```
    cat redis.json
    
    {
        "redis": {
            "host": "localhost",
            "port": 6379
        }
    }


*   Cấu hình client Sensu
```
cat client.json

{
    "client": {
        "name": "ubuntu",
        "address": "127.0.0.1",
        "subscriptions": [
            "base"
        ],
        "socket": {
            "bind": "127.0.0.1",
            "port": 3030
        }
    }
}
```

*   Cài đặt uchiwa làm web front-end cho Sensu
```
{
    "sensu": [
        {
            "name": "KVM guests",
            "host": "localhost",
            "ssl": false,
            "port": 4567,
            "path": "",
            "timeout": 5000
        }
    ],
    "uchiwa": {
        "port": 3000,
        "stats": 10,
        "refresh": 10000
    }
}
```


*   Khởi động dịch vụ sensu-server/api/client và uchiwa
    ```
    /etc/init.d/sensu-server start
    /etc/init.d/sensu-api start
    /etc/init.d/sensu-client start
    /etc/init.d/uchiwa restart
    ```
    
*   Console tới máy ảo, cầu hình sensu client
```
root@kvm:/etc/sensu/conf.d# virsh console kvm1
Connected to domain kvm1
Escape character is ^]

root@debian:~# wget -q
https://sensu.global.ssl.fastly.net/apt/pubkey.gpg -O- | apt-key add -
OK

root@debian:~# echo "deb https://sensu.global.ssl.fastly.net/apt sensu
main" | tee /etc/apt/sources.list.d/sensu.list
deb https://sensu.global.ssl.fastly.net/apt sensu main

root@debian:~# apt install apt-transport-https
root@debian:~# apt update && apt install sensu
...
root@debian:~# cd /etc/sensu/conf.d/
root@debian:/etc/sensu/conf.d# cat client.json
{
    "client": {
        "name": "monitor_kvm",
        "address": "10.10.10.92",
        "subscriptions": ["base"]
    }
}

root@debian:/etc/sensu/conf.d# cat rabbitmq.json
{
    "rabbitmq": {
        "host": "10.10.10.1",
        "port": 5672,
        "vhost": "/sensu",
        "user": "sensu",
        "password": "secret"
    }
}

root@debian:/etc/sensu/conf.d# cat transport.json
{
    "transport": {
        "name": "rabbitmq",
        "reconnect_on_error": true
    }
}
```

*   Cài đặt memory check `rubygems`

*   Định nghĩa memory check cho máy ảo: 

```
root@kvm:/etc/sensu/conf.d# cat check_memory.json
{
    "checks": {
        "memory_check": {
            "command": "/usr/local/bin/check-memory-percent.rb -w 80 -c 90",
            "subscribers": ["base"],
            "handlers": ["default"],
            "interval": 300
        }
    }
}
root@kvm:/etc
```
*   Cài đặt Cpu check cho máy ảo: 
```
gem install sensu-plugins-cpu-checks

root@kvm:/etc/sensu/conf.d# cat check_memory.json
{
    "checks": {
        "cpu_check": {
            "command": "/usr/local/bin/check-cpu.rb -w 80 -c 90",
            "subscribers": ["base"],
            "handlers": ["default"],
            "interval": 300
        }
    }
}
```
*   Cài check uptime 
```
gem install sensu-plugins-uptime-checks

root@kvm:/etc/sensu/conf.d# cat check_memory.json
{
    "checks": {
        "memory_check": {
            "command": "/usr/local/bin/check-uptime.rb",
            "subscribers": ["base"],
            "handlers": ["default"],
            "interval": 30
        }
    }
}
```
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-04%2012-12-27.png)

**Sao lưu KVM với tar và rsync**
*   Tạo thư mục back up
*   copy file `*.xml` và `.img` của máy ảo vào thư mục này 
*   Archive file `*.xml` và `*.img` của máy ảo này và đửa lên remote server
*   Để khôi phục, ta  lấy lại file về,  đưa file cấu hình và img vào lại thư mục và định nghĩa lại cho máy ảo

**Tạo snapshot**

* Convert raw image thành dạng qcow2 `qemu-img convert -f raw -O qcow2`
* Tạo snapshot internal cho máy ảo đang chạy `virsh snapshot-create kvm1`
* Tạo snapshot external cho máy ảo: `virsh snapshot-create-as kvm1 kvm1_ext_snapshot "Disk only external snapshot for kvm1" --disk-only --diskspec hda,snapshot=external,file=/var/lib/libvirt/images/kvm1_disk_external.qcow`
    *   **Internal snapshot**:  là chính img chưa trạng thái và thay đổi của máy ảo 
    *   **External snapshot**: máy ảo trở thành một hình ảnh cơ bản chỉ đọc và lớp phủ mới
hình ảnh được tạo ra để theo dõi bất kỳ thay đổi trong tương lai

**Liệt kê snapshot**
* Tất cả:`virsh snapshot-list kvm1`
* disk_base: `virsh snapshot-list --disk-only kvm1`
* internal: `virsh snapshot-list --internal kvm1`
* external:`virsh snapshot-list --external kvm1`
* hierarchical tree: `virsh snapshot-list --tree kvm1`

**Kiểm tra snapshot**
* Kiểm tra thông tin: `virsh snapshot-info kvm1 --snapshotname 1492797458`
* Kiểm tra thông tin disk snapshot `virsh snapshot-info kvm1 --snapshotname kvm1_ext_snapshot`
* Kiểm tra file xml: `virsh snapshot-dumpxml kvm1 --snapshotname kvm1_ext_snapshot --security-info`

**Chỉnh sửa snapshot**
*   Đổi tên và mô tả: `virsh snapshot-edit kvm1 --snapshotname kvm1_ext_snapshot --rename`
```
<domainsnapshot>
<name>kvm1_ext_snapshot_renamed</name>
<description>Disk only external snapshot for kvm1</description>
```

**Khôi phục sử dụng snapshot**
* Khôi phục: `virsh snapshot-revert kvm1 --snapshotname 1492802417`

**Xóa snapshot**
* Xóa snapshot theo thời gian: `virsh snapshot-delete kvm1 --snapshotname 1492802417`
* Xóa snapshot gàn nhất: `virsh snapshot-delete kvm1 --current`

****
## Triển khai máy ảo KVM với OpenStack
*   Cài đặt và cấu hình Openstack: https://github.com/bizflycloud/internship-0719/blob/master/quanlm1999/Virtualization/install_config_OpenStack.md
**Tạo máy ảo KVM sử dụng Opensack**
    *   Đảm báo đã có Glance image để dùng : `openstack image list`
    *   Tạo flavor type:`openstack flavor create --id 0 --vcpus 1 --ram 1024 --disk 5000 kvm.medium`
    *   Tạo cặp key SSH mới:   `openstack keypair create --public-key ~/.ssh/kvm_rsa.pub kvmkey`
    *   Định nghĩa rule cho phép SSH và ICMP kết nối được `Openstack security group rule create --proto icmp default` `openstack security group rule create --proto tcp --dst-port 22 default`
    *   Tạo máy ảo KVM `openstack server create --flavor kvm.medium --image ubuntu_16.04 --nic net-id=b7ccb514-21fc-4ced-b74f-026e7e358bba --security-group default --key-name kvmkey ubuntu_instance`
    *   Xem máy ảo KVM`openstack server show ubuntu_instance`
    
**Dừng máy ảo KVM với OpenStack**: `openstack server stop ubuntu_instance`
**Xóa máy ảo KVM với OpenStack**: `openstack server delete ubuntu_instance`

## Sử dụng python để tạo và  quản lý máy ảo KVM 
***
**Cài đặt và sử dụng thư viện Python libvirt** 
*   Cài đặt Python development packages `pip` và `virtualenv`
`apt-get install python-pip python-dev pkg-config build-essential autoconf libvirt-dev`
`pip install virtualenv`
*   Tạo môi trường ảo Python và kích hoạt nó:
`mkdir kvm_python`
`virtualenv kvm_python/`
`source kvm_python/bin/activate`
*   Cài đặt libvirt modules
`~/kvm_python# pip install libvirt-python`
*   Cài đặt `iPython` 
`~/kvm_python# apt-get install ipython`
    *   Trong `iPython`, import `libvirt` module
    `In [1]: import libvirt`
    *   Tạo định nghĩa máy ảo:
    ```
        In [2]: xmlconfig = """
    <domain type='kvm' id='1'>
    <name>kvm_python</name>
    <memory unit='KiB'>1048576</memory>
    <currentMemory unit='KiB'>1048576</currentMemory>
    <vcpu placement='static'>1</vcpu>
    <resource>
    <partition>/machine</partition>
    </resource>
    <os>
    <type arch='x86_64' machine='pc-i440fx-trusty'>hvm</type>
    <boot dev='hd'/>
    </os>
    <features>
    <acpi/>
    <apic/>
    <pae/>
    </features>
    <clock offset='utc'/>
    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>restart</on_crash>
    <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type='file' device='disk'>
    <driver name='qemu' type='raw'/>
    <source file='/tmp/debian.img'/>
    <backingStore/>
    <target dev='hda' bus='ide'/>
    <alias name='ide0-0-0'/>
    <address type='drive' controller='0' bus='0' target='0' unit='0'/>
    </disk>
    <controller type='usb' index='0'>
    <alias name='usb'/>
    <address type='pci' domain='0x0000' bus='0x00' slot='0x01'
    function='0x2'/>
    </controller>
    <controller type='pci' index='0' model='pci-root'>
    <alias name='pci.0'/><alias name='pci.0'/>
    </controller>
    <controller type='ide' index='0'>
    <alias name='ide'/>
    <address type='pci' domain='0x0000' bus='0x00' slot='0x01'
    function='0x1'/>
    </controller>
    <interface type='network'>
    <mac address='52:54:00:da:02:01'/>
    <source network='default' bridge='virbr0'/>
    <target dev='vnet0'/>
    <model type='rtl8139'/>
    <alias name='net0'/>
    <address type='pci' domain='0x0000' bus='0x00' slot='0x03'
    function='0x0'/>
    </interface>
    <serial type='pty'>
    <source path='/dev/pts/5'/>
    <target port='0'/>
    <alias name='serial0'/>
    </serial>
    <console type='pty' tty='/dev/pts/5'>
    <source path='/dev/pts/5'/>
    <target type='serial' port='0'/>
    <alias name='serial0'/>
    </console>
    <input type='mouse' bus='ps2'/>
    <input type='keyboard' bus='ps2'/>
    <graphics type='vnc' port='5900' autoport='yes' listen='0.0.0.0'>
    <listen type='address' address='0.0.0.0'/>
    </graphics>
    <video>
    <model type='cirrus' vram='16384' heads='1'/>
    <alias name='video0'/>
    <address type='pci' domain='0x0000' bus='0x00' slot='0x02'
    function='0x0'/>
    </video>
    <memballoon model='virtio'>
    <alias name='balloon0'/>~/kvm_python# virsh list --all
    <address type='pci' domain='0x0000' bus='0x00' slot='0x04'
    function='0x0'/>
    </memballoon>
    </devices>
    </domain>
    """
    ```
    *   Kết nối với hypervisor
    `In [3]: conn = libvirt.open('qemu:///system')`
    *   Tạo máy ảo nhưng k khở i động 
    `In [4]: instance = conn.defineXML(xmlconfig)`
    *   Liệt kê máy ảo 
    ```
    In [5]: instances = conn.listDefinedDomains()
    In [6]: print 'Defined instances: {}'.format(instances)
    Defined instances: ['kvm_python']
    ```
**Khởi động, dừng, xóa máy ảo với Python**
*   Gọi phương thức `create()` trên đối tượng
```
In [1]: instance.create()
Out[1]: 0
```
*   Đảm báo máy ảo chạy bằng cách gọi phương thức `isActive()` trên đối tượng 
```
In [2]: instance.isActive()
Out[2]: 1
```
*   Dừng máy ảo với phương thức  `destroy()`
```
In [3]: instance.destroy()
Out[3]: 0
```

*   Đảm bảo máy ảo đã dừng: 
```
In [4]: instance.isActive()
Out[4]: 0
```
*   Xóa máy ảo
```
In [5]: instance.undefine()In [5]: instance.undefine()
Out[5]: 0
In [6]: conn.listDefinedDomains()
Out[6]: []
In [7]:
```

**Kiểm tra máy ảo với  Python**
*   Lấy tên của máy ảo: 
```
In [1]: instance.name()
Out[1]: 'kvm_python'
```
*   Kiểm tra hoạt động 
```
In [2]: instance.isActive()
Out[2]: 1
```
*   Lấy thông kê tài nguyên
```
In [3]: instance.info()
Out[3]: [1, 1048576L, 1048576L, 1, 10910000000L]
```
*   Lấy số lượng bộ nhớ tối đa phân bổ cho máy ảo **
```
In [4]: instance.maxMemory()
Out[4]: 1048576L
```
*   Lấy thông kê CPU 
```
In [5]: instance.getCPUStats(1)
Out[5]:
[{'cpu_time': 10911545901L,
'system_time': 1760000000L,
'user_time': 1560000000L}]
```
*   Xem máy ảo có dùng tăng tốc phân cứng không 
```
In [6]: instance.OSType()
Out[6]: 'hvm'
```
*   Kiểm tra trạng thái:
```
In [82]: state, reason = instance.state()
In [83]: if state == libvirt.VIR_DOMAIN_NOSTATE:
....:
print('The state is nostate')
....: elif state == libvirt.VIR_DOMAIN_RUNNING:
....:
print('The state is running')
....: elif state == libvirt.VIR_DOMAIN_BLOCKED:
....:
print('The state is blocked')
....: elif state == libvirt.VIR_DOMAIN_PAUSED:
....:
print('The state is paused')
....: elif state == libvirt.VIR_DOMAIN_SHUTDOWN:
....:
print('The state is shutdown')
....: elif state == libvirt.VIR_DOMAIN_SHUTOFF:
....:
print('The state is shutoff')
....: elif state == libvirt.VIR_DOMAIN_CRASHED:
....:
print('The state is crashed')
....: elif state == libvirt.VIR_DOMAIN_PMSUSPENDED:
....:
print('The state is suspended')
....: else:
....:
print('The state is unknown')
....:
The state is running
```
**Tạo 1 REST API server đơn giản với libvirt và bottle**
*   Cài `bottle` module
`~/kvm_python# pip install bottle`
*   Tạo file `.py`, import libvirt, bottle module và phương thức kết nối libvirt
```
~/kvm_python# vim kvm_api.py
import libvirt
from bottle import run, request, get, post, HTTPResponse
def libvirtConnect():
try:
conn = libvirt.open('qemu:///system')
except libvirt.libvirtError:
conn = None
return conn
```
*   Triên khai  hàm và lộ trình API `/define`
```
def defineKVMInstance(template):
    conn = libvirtConnect()
    
    if conn == None:
        return HTTPResponse(status=500, body='Error defining instance\n')
    else:
        try:
            conn.defineXML(template)
            return HTTPResponse(status=200, body='Instance defined\n')
    except libvirt.libvirtError:
            return HTTPResponse(status=500, body='Error defining instance\n')
            
@post('/define')
def build():
    template = str(request.headers.get('X-KVM-Definition'))
    status = defineKVMInstance(template)
    status = defineKVMInstance(template)
    
    return status
```
Triên khai  hàm và lộ trình API `/undefine`
```
def undefineKVMInstance(name):
    conn = libvirtConnect()
    
    if conn == None:
        return HTTPResponse(status=500, body='Error undefining instance\n')
    else:
        try:
            instance = conn.lookupByName(name)
            instance.undefine()
            return HTTPResponse(status=200, body='Instance undefined\n')
        except libvirt.libvirtError:
            return HTTPResponse(status=500, body='Error undefining
instance\n')

@post('/undefine')
def build():
    name = str(request.headers.get('X-KVM-Name'))
    status = undefineKVMInstance(name)
    
return status   
```

Triên khai hàm và lộ trình API `/start`
```
def startKVMInstance(name):
    conn = libvirtConnect()
        
    if conn == None:
        return HTTPResponse(status=500, body='Error starting instance\n')
    else:
        try:
            instance = conn.lookupByName(name)
            instance.create()
            return HTTPResponse(status=200, body='Instance started\n')
        except libvirt.libvirtError:
            return HTTPResponse(status=500, body='Error starting instance\n')
@post('/start')
def build():
    name = str(request.headers.get('X-KVM-Name'))
    status = startKVMInstance(name)
        
    return status
```
Triên khai hàm và lộ trình API `/stop`
```
def stopKVMInstance(name):
    conn = libvirtConnect()
    
    if conn == None:if conn == None:
        return HTTPResponse(status=500, body='Error stopping instance\n')
    else:
    try:
        instance = conn.lookupByName(name)
        instance.destroy()
        return HTTPResponse(status=200, body='Instance stopped\n')
    except libvirt.libvirtError:
        return HTTPResponse(status=500, body='Error stopping instance\n')
        
@post('/stop')
def build():
    name = str(request.headers.get('X-KVM-Name'))
    status = stopKVMInstance(name)
        
    return status
```
Triên khai hàm và lộ trình API `/list`
```
def getLibvirtInstances():
    conn = libvirtConnect()
    
    if conn == None:
        return HTTPResponse(status=500, body='Error listing instances\n')
    else:
        try:
        instances = conn.listDefinedDomains()
        return instances
    except libvirt.libvirtError:
        return HTTPResponse(status=500, body='Error listing instances\n')
        
@get('/list')
def list():
    kvm_list = getLibvirtInstances()
    
    return "List of KVM instances: {}\n".format(kvm_list)
```

*   Gọi phương thức `run()` để khởi động WSGI server khi script dược chạy 
`run(host='localhost', port=8080, debug=True)`


![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-04%2009-32-39.png) 
![](https://raw.githubusercontent.com/bizflycloud/internship-0719/master/quanlm1999/pic/Screenshot%20from%202020-02-04%2009-32-09.png)

## Tunning hiệu năng máy ảo
**Tunning kernel for low I/O latency**
*   Liệt kê lịch trình I/O đang sử dụng 
    ```
    cat /sys/block/sda/queue/scheduler
    noop deadline [cfq]
    ```
*   Thay đổi lịch trình I/O
    ```
    echo deadline > /sys/block/sda/queue/scheduler
    root@kvm:~# cat /sys/block/sda/queue/scheduler
    noop [deadline] cfq
    ```
*   Để lưu trữ khi restart server
    ```
    echo 'GRUB_CMDLINE_LINUX="elevator=deadline"' >>
    /etc/default/grub
    root@kvm:~# tail -1 /etc/default/grub
    GRUB_CMDLINE_LINUX="elevator=deadline"
    root@kvm:~# update-grub2
    Generating grub configuration file ...
    Found linux image: /boot/vmlinuz-3.13.0-107-generic
    Found initrd image: /boot/initrd.img-3.13.0-107-generic
    done
    root@kvm:~# cat /boot/grub/grub.cfg | grep elevator
    linux /boot/vmlinuz-3.13.0-107-generic root=/dev/md126p1 ro
    elevator=deadline rd.fstab=no acpi=noirq noapic cgroup_enable=memory
    swapaccount=1 quietrovide more cruisers with a similar protection as tier X ones: on the distance and at the right angle, cruiser plating will be able to cause ricochet of the battleship shells, while 
    linux /boot/vmlinuz-3.13.0-107-generic root=/dev/md126p1 ro
    elevator=deadline rd.fstab=no acpi=noirq noapic cgroup_enable=memory
    swapaccount=1 quiet
    linux /boot/vmlinuz-3.13.0-107-generic root=/dev/md126p1 ro recovery
    nomodeset elevator=deadline
    root@kvm:~#
    ```
* For the KVM instance, set up the noop I/O scheduler persistently:
    ```
    root@kvm:~# virsh console kvm1
    Connected to domain kvm1
    Escape character is ^]root@kvm1:~# echo 'GRUB_CMDLINE_LINUX="elevator=noop"' >>
    /etc/default/grub
    root@kvm1:~# tail -1 /etc/default/grub
    GRUB_CMDLINE_LINUX="elevator=noop"
    root@kvm1:~# update-grub2
    Generating grub configuration file ...
    Found linux image: /boot/vmlinuz-3.13.0-107-generic
    Found initrd image: /boot/initrd.img-3.13.0-107-generic
    done
    root@kvm1:~# cat /boot/grub/grub.cfg | grep elevator
    linux /boot/vmlinuz-3.13.0-107-generic root=/dev/md126p1 ro
    elevator=noop rd.fstab=no acpi=noirq noapic cgroup_enable=memory
    swapaccount=1 quiet
    linux /boot/vmlinuz-3.13.0-107-generic root=/dev/md126p1 ro
    elevator=noop rd.fstab=no acpi=noirq noapic cgroup_enable=memory
    swapaccount=1 quiet
    linux /boot/vmlinuz-3.13.0-107-generic root=/dev/md126p1 ro recovery
    nomodeset elevator=noop
    root@kvm1:~#
    ```
*   Set a weight of 100 for the KVM instance using the blkio cgroup controller:
    ```
    root@kvm:~# virsh blkiotune --weight 100 kvm
    root@kvm:~# virsh blkiotune kvm
    weight : 100
    device_weight :
    device_read_iops_sec:
    device_write_iops_sec:
    device_read_bytes_sec:
    device_write_bytes_sec:
    root@kvm:~#
    ```
* Find the cgroup directory hierarchy on the host:
    ```
    root@kvm:~# mount | grep cgroup
    none on /sys/fs/cgroup type tmpfs (rw)
    systemd on /sys/fs/cgroup/systemd type cgroup
    (rw,noexec,nosuid,nodev,none,name=systemd)
    root@kvm:~#
    ```
* Ensure that the cgroup for the KVM instance contains the weight that we
set up earlier on the blkio controller:
    ```
    root@kvm:~# cat /sys/fs/cgroup/blkio/machine/kvm.libvirt-
    qemu/blkio.weight
    100
    root@kvm:~#
    ```
    
**Memory tuning for KVM guests**
*   Check the current HugePages settings on the host OS:
    ```
    root@kvm:~# cat /proc/meminfo | grep -i huge
    AnonHugePages: 509952 kB
    HugePages_Total: 0
    HugePages_Free: 0
    HugePages_Rsvd: 0
    HugePages_Surp: 0
    Hugepagesize: 2048 kB
    root@kvm:~#
    ```
*   Connect to the KVM guest and check the current HugePages settings:
    ```
    root@kvm1:~# cat /proc/meminfo | grep -i huge
    HugePages_Total: 0
    HugePages_Free: 0
    HugePages_Rsvd: 0
    HugePages_Surp: 0
    Hugepagesize: 2048 kB
    root@kvm1:~#
    ```
* Increase the size of the pool of HugePages from 0 to 25000 on the
hypervisor and verify the following:
    ```
    root@kvm:~# sysctl vm.nr_hugepages=25000
    vm.nr_hugepages = 25000
    root@kvm:~# cat /proc/meminfo | grep -i huge
    AnonHugePages: 446464 kB
    HugePages_Total: 25000
    HugePages_Free: 24484
    HugePages_Rsvd: 0
    HugePages_Surp: 0
    Hugepagesize: 2048 kB
    root@kvm:~# cat /proc/sys/vm/nr_hugepages
    25000
    root@kvm:~#
    ```
    
* Check whether the hypervisor CPU supports 2 MB and 1 GB
    HugePages sizes:
    ```
    root@kvm:~# cat /proc/cpuinfo | egrep -i "pse|pdpe1" | tail -1
    flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmovpat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
    pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
    xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
    ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2
    x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm
    abm arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept
    vpid fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms invpcid
    root@kvm:~#
    ```

* Set 1 GB HugePages size by editing the default GRUB configuration and
rebooting:
    ```
    root@kvm:~# cat /etc/default/grub
    ...
    GRUB_CMDLINE_LINUX_DEFAULT="rd.fstab=no acpi=noirq noapic
    cgroup_enable=memory swapaccount=1 quiet hugepagesz=1GB hugepages=1"
    ...
    root@kvm:~# update-grub
    Generating grub configuration file ...
    Found linux image: /boot/vmlinuz-3.13.0-107-generic
    Found initrd image: /boot/initrd.img-3.13.0-107-generic
    done
    root@kvm:~# cat /boot/grub/grub.cfg | grep -i huge
    linux /boot/vmlinuz-3.13.0-107-generic root=/dev/md126p1 ro
    elevator=deadline rd.fstab=no acpi=noirq noapic cgroup_enable=memory
    swapaccount=1 quiet hugepagesz=1GB hugepages=1
    linux /boot/vmlinuz-3.13.0-107-generic root=/dev/md126p1 ro
    elevator=deadline rd.fstab=no acpi=noirq noapic cgroup_enable=memory
    swapaccount=1 quiet hugepagesz=1GB hugepages=1
    root@kvm:~# reboot
    ```
    
* Install the HugePages package:
`root@kvm:~# apt-get install hugepages`
* Check the current HugePages size:
    ```
    root@kvm:~# hugeadm --pool-list
    Size
    Minimum Current Maximum Default
    2097152
    25000
    25000
    25000
    *
    root@kvm:~#
    ```

* Enable HugePages support for KVM:
    ```
    root@kvm:~# sed -i 's/KVM_HUGEPAGES=0/KVM_HUGEPAGES=1/g'
    /etc/default/qemu-kvm
    root@kvm:~# root@kvm:~# /etc/init.d/libvirt-bin restart
    libvirt-bin stop/waiting
    libvirt-bin start/running, process 16257
    root@kvm:~#
    ```
* Mount the HugeTable virtual filesystem on the host OS:
    ```
    root@kvm:~# mkdir /hugepages
    root@kvm:~# echo "hugetlbfs /hugepages hugetlbfs mode=1770,gid=2021 0 0"
    >> /etc/fstab
    root@kvm:~# mount -a
    root@kvm:~# mount | grep hugepages
    hugetlbfs on /hugepages type hugetlbfs (rw,mode=1770,gid=2021)
    root@kvm:~#
    ```
* Edit the configuration for the KVM guest and enable HugePages:
    ```
    root@kvm:~# virsh destroy kvm1
    Domain kvm1 destroyed
    root@kvm:~# virsh edit kvm1
    ...
    <memoryBacking>
    <hugepages/>
    </memoryBacking>
    ...
    Domain kvm1 XML configuration edited.
    root@kvm:~# virsh start kvm1
    Domain kvm1 started
    root@kvm:~#
    ```



* Update the memory hard limit for the KVM instance and verify, as follows:
    ```
    root@kvm:~# virsh memtune kvm1
    hard_limit : unlimited
    soft_limit : unlimited
    swap_hard_limit: unlimited
    root@kvm:~# virsh memtune kvm1 --hard-limit 2GB
    root@kvm:~# virsh memtune kvm1
    hard_limit : 1953125
    soft_limit : unlimited
    swap_hard_limit: unlimited
    root@kvm:~#
    ```

**CPU performance options**
*   Obtain information about the available CPU cores on the hypervisor:
    ```
    root@kvm:~# virsh nodeinfo
    CPU model: x86_64
    CPU(s): 40
    CPU frequency: 2593 MHz
    CPU socket(s): 1
    Core(s) per socket: 10
    Thread(s) per core: 2
    NUMA cell(s): 2
    Memory size: 131918328 KiB
    root@kvm:~#
    ```
* Get information about the CPU allocation for the KVM guest:
    ```
    root@kvm:~# virsh vcpuinfo kvm1
    VCPU: 0
    CPU: 2
    State: running
    CPU time: 9.1s
    CPU Affinity: yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
    root@kvm:~#
    ```

* Pin the KVM instance CPU ( VCPU: 0 ) to the first hypervisor CPU ( CPU: 0 )
    and display the result:
    ```
    root@kvm:~# virsh vcpupin kvm1 0 0 --live
    root@kvm:~# virsh vcpuinfo kvm1
    VCPU: 0
    CPU: 0
    State: running
    CPU time: 9.3s
    CPU Affinity: y---------------------------------------
    root@kvm:~#
    ```

* List the share of runtime that is assigned to a KVM instance:
    ```
    root@kvm:~# virsh schedinfo kvm1
    Scheduler : posixcpu_shares : 1024
    vcpu_period : 100000
    vcpu_quota : -1
    emulator_period: 100000
    emulator_quota : -1
    root@kvm:~#
    ```

* Modify the current CPU weight of a running virtual machine:
    ```
    root@kvm:~# virsh schedinfo kvm cpu_shares=512
    Scheduler : posix
    cpu_shares : 512
    vcpu_period : 100000
    vcpu_quota : -1
    emulator_period: 100000
    emulator_quota : -1
    root@kvm:~#
    ```

* Check the CPU shares in the CPU cgroups subsystem:
    ```
    root@kvm:~# cat /sys/fs/cgroup/cpu/machine/kvm1.libvirt-qemu/cpu.shares
    512
    root@kvm:~#
    ```

* Examine the updated XML instance definition:
    ```
    root@kvm:~# virsh dumpxml kvm1
    ...
    <vcpu placement='static'>1</vcpu>
    <cputune>
    <shares>512</shares>
    <vcpupin vcpu='0' cpuset='0'/>
    </cputune>
    ...
    root@kvm:~#
    ```

**NUMA tuning with libvirt**
*   Install the numactl package and check the hardware configuration of the
hypervisor:
`apt-get install numactl` `numactl --hardware`
*   Display the current NUMA placement for the KVM guest: `numastat -c kvm1`
*   Edit the XML instance definition, set the memory mode to strict, and select
the second NUMA node
    ```
    virsh edit kvm1
    ...
    <vcpu placement='static' cpuset='10-11'>2</vcpu>
    <numatune>
    <memory mode='strict' nodeset='1'/></numatune>
    ...
    Domain kvm1 XML configuration edited.
    root@kvm:~# virsh destroy kvm1
    Domain kvm1 destroyed
    root@kvm:~# virsh start kvm1
    Domain kvm1 started
    root@kvm:~#
    ```
*   Get the NUMA parameters for the KVM instance:`virsh numatune kvm1`
*   Print the current virtual CPU affinity:`virsh vcpuinfo kvm1`
*   Print the NUMA node placement for the KVM instance:`numastat -c kvm1`

**Tuning the kernel for network performance**
*   Increase the max TCP send and receive socket buffer size:
    ```
    root@kvm:~# sysctl net.core.rmem_max
    net.core.rmem_max = 212992
    root@kvm:~# sysctl net.core.wmem_max
    net.core.wmem_max = 212992
    root@kvm:~# sysctl net.core.rmem_max=33554432
    net.core.rmem_max = 33554432
    root@kvm:~# sysctl net.core.wmem_max=33554432
    net.core.wmem_max = 33554432
    ```
*   Increase the TCP buffer limits: min, default, and max number of bytes. Set max to 16 MB for 1 GE NIC, and 32 M or 54 M for 10 GE NIC:
```
root@kvm:~# sysctl net.ipv4.tcp_rmem
net.ipv4.tcp_rmem = 4096 87380 6291456
root@kvm:~# sysctl net.ipv4.tcp_wmem
net.ipv4.tcp_wmem = 4096 16384 4194304
root@kvm:~# sysctl net.ipv4.tcp_rmem="4096 87380 33554432"
net.ipv4.tcp_rmem = 4096 87380 33554432
root@kvm:~# sysctl net.ipv4.tcp_wmem="4096 65536 33554432"
net.ipv4.tcp_wmem = 4096 65536 33554432
```

*   Ensure that TCP window scaling is enabled:
```
root@kvm:~# sysctl net.ipv4.tcp_window_scaling
net.ipv4.tcp_window_scaling = 1
```

*   To help increase TCP throughput with 1 GB NICs or larger, increase the
length of the transmit queue of the network interface. For paths with more
than 50 ms RTT, a value of 5000-10000 is recommended:
`root@kvm:~# ifconfig eth0 txqueuelen 5000`

*   Reduce the tcp_fin_timeout value:

```
root@kvm:~# sysctl net.ipv4.tcp_fin_timeout
net.ipv4.tcp_fin_timeout = 60
root@kvm:~# sysctl net.ipv4.tcp_fin_timeout=30
net.ipv4.tcp_fin_timeout = 30
```

*   Reduce the tcp_keepalive_intvl value:
```
root@kvm:~# sysctl net.ipv4.tcp_keepalive_intvl
net.ipv4.tcp_keepalive_intvl = 75
root@kvm:~# sysctl net.ipv4.tcp_keepalive_intvl=30
net.ipv4.tcp_keepalive_intvl = 30
root@kvm:~#
```

* Enable fast recycling of TIME_WAIT sockets. The default value is 0 (disabled):
```
root@kvm:~# sysctl net.ipv4.tcp_tw_recycle
net.ipv4.tcp_tw_recycle = 0
root@kvm:~# sysctl net.ipv4.tcp_tw_recycle=1
net.ipv4.tcp_tw_recycle = 1
root@kvm:~#
```

* Enable the reusing of sockets in the TIME_WAIT state for new connections.
The default value is 0 (disabled):
```
root@kvm:~# sysctl net.ipv4.tcp_tw_reuse
net.ipv4.tcp_tw_reuse = 0
root@kvm:~# sysctl net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_tw_reuse = 1
```

*   To enable more pluggable congestion control algorithms, load the kernel
modules:
```
modprobe tcp_htcp
modprobe tcp_bic
modprobe tcp_vegas
modprobe tcp_westwood
sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = cubic reno htcp bic vegas
westwood
```

*   If the hypervisor is overwhelmed with SYN connections, the following
options might help in reducing the impact:
```
root@kvm:~# sysctl net.ipv4.tcp_max_syn_backlog
net.ipv4.tcp_max_syn_backlog = 2048
root@kvm:~# sysctl net.ipv4.tcp_max_syn_backlog=16384
net.ipv4.tcp_max_syn_backlog = 16384
root@kvm:~# sysctl net.ipv4.tcp_synack_retries
net.ipv4.tcp_synack_retries = 5
root@kvm:~# sysctl net.ipv4.tcp_synack_retries=1
net.ipv4.tcp_synack_retries = 1
```

*   increase the max file descriptors, execute the following:
```
root@kvm:~# sysctl fs.file-max=10000000
fs.file-max = 10000000
root@kvm:~# sysctl fs.file-nr
fs.file-nr = 1280 0 10000000
```
https://docs.google.com/spreadsheets/d/1a_5E4SI-oa9KsugYLt54vMrNCaNSm8ehd7ryBvTbYQs/edit?usp=sharing
