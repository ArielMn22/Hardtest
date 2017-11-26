#!/bin/bash
DIRET="/usr/share/Hardtest"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
clear
ESCOLHA=$( dialog			\
	--stdout			\
	$DIALOG\
	--title 'Status'		\
 	--infobox '\nFazendo testes, isso pode demorar um pouco...'	\
	0 0 
SPEED1=$(speedtest --share | grep "Upload" | cut -d" " -f2 )					
clear 					
MBYT=$(echo "scale=1;$SPEED1/8" | bc)
	dialog 				\
	--stdout			\
	$DIALOG\
	--title 'Status'		\
	--msgbox "Sua velocidade de upload é de $SPEED1 Mbit/s $MBYT Mbyte/s" 				\
	6 40 )
. "$DIRET/REDE/rede.sh"
