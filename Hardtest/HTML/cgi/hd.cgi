#!/bin/bash

read X

echo "Content-type: text/html"
echo

X=$(echo $X | cut -d"=" -f2)

DIRET="/var/www/html/cgi-bin"

gravacao(){
	dd if=/dev/zero of=/tmp/output.img bs=8k count=10k &> $DIRET/staging.txt
	var=$(cat $DIRET/staging.txt | grep MB | cut -d" " -f10-11)
	echo "<h3>Especificações de seu HD:</h3>"
	echo "<pre>A velocidade de gravação do seu HD é de $var</pre>"
}

particionamento(){
	
	lsblk > $DIRET/staging.txt
		echo "<h3>Particionamento lsblk:</h3>"
		echo "<pre>$(cat $DIRET/staging.txt)</pre>"
		echo "<br><br>"
	
}

hdparm(){
	sudo hdparm -T /dev/sda > $DIRET/staging.txt
		var2=$(cat staging.txt | grep MB | cut -d"=" -f2)
		echo "<h3>Especificações de seu HD com Hdparm:</h3>"
		echo "<pre>A velocidade de gravação do seu HD é de $var2</pre>"
}

case $X in
	particao) particionamento ;;
	speed) gravacao ;;
	hdparm) hdparm ;;
esac
