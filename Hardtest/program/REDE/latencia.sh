#!/bin/bash

USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
LOG="/var/log/Hardtest"
DIRET="/usr/share/Hardtest/program"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""

echo "[$(date)] Menu REDE teste latência iniciado" >> "$LOG/hardtest$USERU.log"

dialog                                  \
--stdout                                \
$DIALOG																\
--title "Status"	\
--infobox "Fazendo testes..."         \
0 0

VAL=$?
[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh

PRIMEIRA=$(ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
SEGUNDA=$(   ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
TERCEIRA=$(   ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
QUARTA=$(   ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
QUINTA=$(   ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
SEXTA=$(   ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
SETIMA=$(   ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)

resultado=$(echo "scale=2;($PRIMEIRA + $SEGUNDA + $TERCEIRA + $QUARTA + $QUINTA + $SEXTA + $SETIMA) / 7" | bc)

PRIMEIRA=$(   ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
SEGUNDA=$(   ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
TERCEIRA=$(   ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
QUARTA=$(   ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
QUINTA=$(   ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
SEXTA=$(   ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
SETIMA=$(   ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)

resultado2=$(echo "scale=2;($PRIMEIRA + $SEGUNDA + $TERCEIRA + $QUARTA + $QUINTA + $SEXTA + $SETIMA) / 7" | bc)
dialog                   \
--stdout                \
$DIALOG								\
--title "Rede"        \
--msgbox "Latência the new york time(USA) : $resultado ms ; Latência uol : $resultado2 ms" \
6 70 
VAL=$?
[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
[[ $VAL == 255 ]] && exit 0

echo "[$(date)] Menu REDE teste latência encerrado" >> "$LOG/hardtest$USERU.log"
. "$DIRET/REDE/rede.sh"
