#!/bin/bash

USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
DIRET="/usr/share/Hardtest/program"
LOG="/var/log/Hardtest"
TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""

echo "[$(date)] Menu HD teste usuários iniciado" >> "$LOG/hardtest$USERU.log"

free=$(($(cat /proc/meminfo | grep "MemFree" | cut -d":" -f2 | cut -d"k" -f1)/1000)) # Em MB.

USERUMAX=$(( $free / 100 ))

dialog 																																																	 \
--stdout $DIALOG 																																												 \
--title 'USUARIOS MAX' 																																									 \
--msgbox "Número aproximado de usuários que podem se conectar simultaneamente ao computador: $USERUMAX." \
8 50

VAL=$?
[[ $VAL == 1 ]] && source $DIRET/RAM/menuprojeto.sh
[[ $VAL == 255 ]] && exit 0
echo "[$(date)] Menu HD teste usuários encerrado" >> "$LOG/hardtest$USERU.log"
. "$DIRET/RAM/menuprojeto.sh"