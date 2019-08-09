# Using VIM 

__Delete words__
>  `d + option` : xóa theo option
       1. e : Xóa word tại vị trí con trỏ 
       2. $ : Xóa từ vị trí con trỏ đến cuối dòng
       3. w : Xóa word tại vị trí con trỏ kèm theo space phía sau

> chỉ gõ e hoặc $ hoặc w trong normal mode sẽ đưa con trỏ đến vị trí thực tế mà nó được chỉ định tương ứng có thể thêm cả số trước motion để có thể xóa theo cụm

__Pointer Control__

> H :Left ; J :Down ; K :Up ; L :Right 

__Action__

`x`  xóa ký tự ngay chỗ con trỏ đang đứng

`i`  chèn thêm đằng trc con trỏ

`a`  thêm sau con trỏ 

`p`  patse

`r + (một ký tự)`   nó cho phép bạn thay ký tự mong muốn tại vị trí con trỏ 

`ce`  thay thế ký tự tại con trỏ bằng ký tự ta nhập vào

`c`  xóa toàn bộ nội dung đằng sau con trỏ để nhâp nội dung thay thế

*Mode*

**Vim có 2 mode**

> Mặc định thao tác bằng mode normal

**Để vào mode lệnh cần thoát mode normal bằng ESC , set command bằng `: option`**

- `w`         write

- `q`         quit

- `w!`        write no matter what

- `q!`        quit no matter what

- `wq`        write and quit

- `wq!`       write and quit no matter what

- `:set nu`        set number for lines

- `: (number)`     move to number "n"

-`Ctrl -g` display the information of the line youre standing at

-`gg` move to the top of the file

-`G` move to the bottom of the file

-`(number)+G` move back to the line at position “number”

-`/` to find a phrase from top down

> 1. `n` to find another phrase likely

> 2. `N` to find another phrase likely but with reverse direction 

> 3. `?` to find a phrase from the bottom up

- `Ctrl -o`  get back to where you stand before the search 

- `Ctrl -i` to go f

> To find a parenthesis’ matching or branket, move the cursor to it then press `%`

- `:s/old/new/g`  To globally substitue every same words to the new one in a line

- `:#,#s/old/new/g` substitue in range lines between line # to line #

- `:%s/old/new/g` substitue in the whole file

- `%s/old/new/gc` find and substitue in the whole file with confirm request

- `:! +(command)` to execute shell command 

- `v` to highlight`; `v + move the cursor between lines` to highlight part of the content of file 
then press `:w +(new filename)` to save them to new file

- `:r (filename)`  insert the content of a file named filename to the text(insert on
above the cursor)

- `o`: to open an insert-mode-line below the cursor ; `O` :above

- `e`: reach end of words + a: to append text after end of words

- `R`(at the beginning position you want to replace): to replace more than one letter

- `y` to yank

- `:set ic`  set ignore case;   

- `:set hls is`  to highlight the search result

- `set noic` : to disable set ignore case 

- `nohlsearch` : to disable highlight  

*In command mode; while typing a command, to show all command likely, press `Ctrl+d`, to complete the command with suggestion, just press `TAB`*
