#!/bin/bash

DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)
DIRET="/usr/share/Hardtest/program"
STAGE="$DIRET/CPU/staging.txt"
STAGE2="$DIRET/CPU/staging2.txt"
LOG="/var/log/Hardtest"

echo "[$(date)] Menu CPU Temperatura iniciado" >> "$LOG/hardtest$USERU.log"

> $STAGE2

translate(){
	
	oq="s/Core/Núcleos/g;s/Adapter/Adaptador/g;s/temp/Temperatura/g;s/high/alto/g"

	cat $STAGE | sed "$oq" >> $STAGE2

}

sensors 1> $STAGE 2>/dev/null

translate

dialog --stdout $DIALOG --title "CPU" --textbox "$STAGE2" 0 0

VAL=$?

[[ $VAL == 255 ]] && exit 0
[[ $VAL == 1 ]] && source $DIRET/CPU/.cpu.sh

echo "[$(date)] Menu CPU Temperatura encerrado" >> "$LOG/hardtest$USERU.log"

. $DIRET/CPU/.cpu.sh
