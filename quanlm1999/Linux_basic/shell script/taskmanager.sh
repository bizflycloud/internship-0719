#!/bin/bash
#add
function add()
{
	echo "bash task_manager.sh add"
	read a
        echo $a >> task.txt
}
#remove
function remove()
{
	echo "bash task_manager.sh remove"
	read a
        if grep -i "$a" -q task.txt ; then
        	sed -i "/^$a/d" task.txt
        fi
}
# menu
PS3="select task "
select task in "add" "delete" "list" "quit"; do
    case "$task" in
    "add")
        add
        ;;
    "delete")
        remove
        ;;
    "list")
	cat -b task.txt #list
        ;;
    "quit")
        break
        ;;
    esac
done
