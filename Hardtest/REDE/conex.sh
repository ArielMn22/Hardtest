#!/bin/bash
DIRET="/usr/share/Hardtest"
clear
dialog				\
	--stdout				\
	$DIALOG\
	--title 'Status'			\
	--infobox "Fazendo testes, isso pode demorar um pouco..."		\
	4 50
SPEED=$(speedtest --share | grep "Download" | cut -d" " -f2)
MBYT=$(echo "scale=1;$SPEED/8" | bc)
clear
	dialog			\
	--stdout		\
	$DIALOG\
	--title 'Status'	\
	--msgbox  "Sua velocidade de Download é $SPEED Mbit/s $MBYT Mbyte/s" 	\
	6 60 
. "$DIRET/REDE/rede.sh"
