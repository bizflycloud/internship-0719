# BASIC THINGS TO KNOW:

______Common______

~:	Root

$: Stands for common privileged right

______Listing things______

`ls` list folder

`ls -a`  you show every directories, every files you want to see

`ls -l`  you just see detail information of whats not hidden

`ls -la`  show you detail info of every directories, every files you want to see

_______Directory_______

`pwd` you show the path from root to where you stand in the system

`cd` change directory 

`cd ..` move up to the previous directory ( just one level )

> you can go back home with (just to know for redundant) `cd ~`

`pushd` & `popd`  move from one directory to another and get back 

______Interact with command and terminal______
`locate (file)` show file location, need to update database with a new system first

`which`  find a command

`history`  show all commands that were used before

`whatis` to understand the meaning of a command or what it does

`apropos + (smt)`  show commands to intertact directly with something

`man + (command)`  gives the mannual of the command 

_____Folders & Files_____
 
`mkdir + (name)`  create a folder

`touch`  create a file (if file doesnt exist) or update date of file or force a backup

`rm  *`  means all (be cautious)

`rmdir` (only to delete emty folder)	 |

`cat filename`  read file

`cat >> filename`  write file

`cat file1 file2`  combine contents 2 files

`diff file1 file2`  compare 2 files

`ls -al +(file/folder)   (newfile)` >: export all information of one file or everything in one folder

_____Progress and command_____

`ctrl C` kill the process 

`killall + (appname)`  Kill program

`|` (pipe): combine commands

`grep`  tìm kiếm theo chuỗi các ký tự (hoặc theo văn bản) và in ra kết qủa chúng ta có thể piping với grep thuận tiện hơn cho việc list ra những kết qủa

`sort`  cơ bản là để sắp xếp theo thứ tự, mặc định là theo bảng chữ cái 
	-n: là theo number;	-r: là theo bảng chữ cái đảo ngược  -f: hoa thường 
