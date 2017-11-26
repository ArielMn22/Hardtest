#!/bin/bash
DIRET="/usr/share/Hardtest"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
clear
AGUARDE(){
       dialog                                  \
      --stdout                                \
			$DIALOG\
     --title 'Status'                        \
    --infobox '\nFazendo testes...'         \
   0 0
}

PRIMEIRA=$(AGUARDE && ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
SEGUNDA=$(AGUARDE && ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
TERCEIRA=$(AGUARDE && ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
QUARTA=$(AGUARDE && ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
QUINTA=$(AGUARDE && ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
SEXTA=$(AGUARDE && ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)
SETIMA=$(AGUARDE && ping nytimes.com -w 1 | grep icmp_seq | cut -d" " -f7 | cut -d"=" -f2)

resultado=$(echo "scale=2;($PRIMEIRA + $SEGUNDA + $TERCEIRA + $QUARTA + $QUINTA + $SEXTA + $SETIMA) / 7" | bc)

PRIMEIRA=$(AGUARDE && ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
SEGUNDA=$(AGUARDE && ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
TERCEIRA=$(AGUARDE && ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
QUARTA=$(AGUARDE && ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
QUINTA=$(AGUARDE && ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
SEXTA=$(AGUARDE && ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)
SETIMA=$(AGUARDE && ping uol.com.br -w 1 | grep icmp_seq | cut -d" " -f8 | cut -d"=" -f2)

resultado2=$(echo "scale=2;($PRIMEIRA + $SEGUNDA + $TERCEIRA + $QUARTA + $QUINTA + $SEXTA + $SETIMA) / 7" | bc)
INFO=$(dialog                   \
        --stdout                \
				$DIALOG\
        --title "Status"        \
        --msgbox "Latência the new york time(USA) : $resultado ms \
		             Latência uol : $resultado2 )."    \
       6 70 )
. "$DIRET/REDE/rede.sh"
