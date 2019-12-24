#!/bin/bash
echo "CIDR:"
read ip #nhap CIDR 
x="$(echo $ip |cut -d "/" -f2)"
a="$(echo $ip |cut -d "." -f1)"
b="$(echo $ip |cut -d "." -f2)"
c="$(echo $ip |cut -d "." -f3)"
d="$(echo $ip |cut -d "." -f4 | cut -d "/" -f1)" #cut tung octet(a b c d) va mask (x)
if [ $x -ge 1 -a $x -le 32 -a $a -ge 0 -a $a -le 255 -a $b -ge 0 -a $b -le 255 -a $c -ge 0 -a $c -le 255 -a $d -ge 0 -a $d -le 255 ]; then
	A=$(expr 32 - $x ) #tim so bit host
	occ=4 
	while [ $A -gt 8 ]
	do 
	A=$(expr $A - 8 )
	occ=$(expr $occ - 1 ) #xac dinh octet nao bi thay doi, octet nao giu nguyen, octet nao bat dau tu 0->255
	done
	if [ $occ -eq 1 ]; then #octet 1 bi thay doi, 2 3 4 tu 0-> 255
		y=$(printf '%08d' $(echo "obase=2; $a" | bc)) #hien thi octet bi thay doi duoi dang nhi phan
		y=${y:0:-$A} #tim so bit bi thay doi o octet do
		y_zero=$y
		y_one=$y
			for((i=0;i<$A;i++))
			do
				y_zero=$y_zero"0"
				y_one=$y_one"1"
			done
		y1="$(echo "$((2#$y_zero))")" #doi lai thanh thap phan
		y2="$(echo "$((2#$y_one))")"
		echo "$y1.0.0.0 -> $y2.255.255.255" #hien thi lai dia chi
	elif [ $occ -eq 2 ]; then #octet 1 giu nguyen, 2 thay doi, 3 4 tu 0-> 255
		y=$(printf '%08d' $(echo "obase=2; $b" | bc))
		y=${y:0:-$A}
		y_zero=$y
		y_one=$y
			for((i=0;i<$A;i++))
			do
				y_zero=$y_zero"0"
				y_one=$y_one"1"
			done
		y1="$(echo "$((2#$y_zero))")"
		y2="$(echo "$((2#$y_one))")"
		echo "$a.$y1.0.0 -> $a.$y2.255.255" 
	elif [ $occ -eq 3 ]; then
		y=$(printf '%08d' $(echo "obase=2; $c" | bc))
		y=${y:0:-$A}
		y_zero=$y
		y_one=$y
			for((i=0;i<$A;i++))
			do
				y_zero=$y_zero"0"
				y_one=$y_one"1"
			done
		y1="$(echo "$((2#$y_zero))")"
		y2="$(echo "$((2#$y_one))")"
		echo "$a.$b.$y1.0 -> $a.$b.$y2.255" 
	elif [ $occ -eq 4 ]; then
		y=$(printf '%08d' $(echo "obase=2; $d" | bc))
		y=${y:0:-$A}
		y_zero=$y
		y_one=$y
		for((i=0;i<$A;i++))
			do
				y_zero=$y_zero"0"
				y_one=$y_one"1"
			done
		y1="$(echo "$((2#$y_zero))")"
		y2="$(echo "$((2#$y_one))")"
		echo "$a.$b.$c.$y1 -> $a.$b.$c.$y2" 
	fi
else
for ((i=0;i<30;i++))
	do
		echo "Input wrong, input right format of cidr: 192.168.1.0/24"
	done
fi





