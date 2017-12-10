#!/bin/bash
USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
LOG="/var/log/Hardtest"
DIRET="/usr/share/Hardtest/program"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
echo "[$(date)] Menu REDE teste download iniciado" >> "$LOG/hardtest$USERU.log"
clear

ESCOLHA=$( dialog			\
	--stdout			\
	$DIALOG\
	--title 'Status'		\
 	--infobox '\nFazendo testes, isso pode demorar um pouco...'	\
	0 0
VAL=$?
	[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
	[[ $VAL == 255 ]] && exit 0 

SPEED1=$(speedtest --share | grep "Upload" | cut -d" " -f2 )					
clear 					
MBYT=$(echo "scale=1;$SPEED1/8" | bc)
	dialog 				\
	--stdout			\
	$DIALOG\
	--title 'Status'		\
	--msgbox "Sua velocidade de upload é de $SPEED1 Mbit/s $MBYT Mbyte/s" 				\
	6 40
VAL=$?
	[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
	[[ $VAL == 255 ]] && exit 0
	)

echo "[$(date)] Menu REDE teste download encerrado" >> "$LOG/hardtest$USERU.log"

. "$DIRET/REDE/rede.sh"
