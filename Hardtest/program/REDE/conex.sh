#!/bin/bash
USERUU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
LOG="/var/log/Hardtest"
DIRET="/usr/share/Hardtest/program"
echo "[$(date)] Menu REDE teste upload iniciado" >> "$LOG/hardtest$USERUU.log"
clear
dialog				\
	--stdout				\
	$DIALOG \
	--title 'Status'			\
	--infobox "Fazendo testes, isso pode demorar um pouco..."		\
	4 50
VAL=$?
[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
[[ $VAL == 255 ]] && exit 0

SPEED=$(speedtest --share | grep "Download" | cut -d" " -f2)
MBYT=$(echo "scale=1;$SPEED/8" | bc)
clear
	dialog			\
	--stdout		\
	$DIALOG\
	--title 'Status'	\
	--msgbox  "Sua velocidade de Download é $SPEED Mbit/s $MBYT Mbyte/s" 	\
	6 60
VAL=$?
	[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
	[[ $VAL == 255 ]] && exit 0

echo "[$(date)] Menu  REDE teste upload encerrado" >> "$LOG/hardtest$USERUU.log"
. "$DIRET/REDE/rede.sh"
