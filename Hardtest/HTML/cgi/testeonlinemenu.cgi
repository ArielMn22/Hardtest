#!/bin/bash

read X

echo "Content-type: text/html"
echo

HTML="/var/www/html"
X=$(echo $X | cut -d"&" -f1 | cut -d"=" -f2)

rede(){

	cat $HTML/rede.html
}

hd(){

	cat $HTML/hd.html
}

memoria(){

	cat $HTML/memory.html
}

cpu(){

	cat $HTML/cpu.html
}

case $X in
	rede) rede ;;
	hd) hd ;;
	memoria) memoria ;;
	cpu) cpu ;;
esac