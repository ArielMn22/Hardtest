#!/bin/bash
USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
LOG="/var/log/Hardtest"
DIRET="/usr/share/Hardtest/program"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
echo "[$(date)] Menu REDE teste de conexão iniciado" >> "$LOG/hardtest$USERU.log"
clear
AGUARDE(){ dialog		\
	--stdout		\
	$DIALOG\
	--title	"Aguarde"	\
	--infobox 'Fazendo testes...' 0 0
VAL=$?
	[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
	[[ $VAL == 255 ]] && exit 0
}
PING(){
	AGUARDE
	ping -W 1 -c 7 8.8.8.8 &> "$DIRET/REDE/staging.txt"
	dialog					\
	--stdout 				\
	$DIALOG \
	--title 'Status'			\
	--tailbox "$DIRET/REDE/staging.txt"		\
	0 0
VAL=$?
	[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
	[[ $VAL == 255 ]] && exit 0 
}

PING
PING1=$(cat "$DIRET/REDE/staging.txt" | grep "64" | cut -d" " -f1) 
PING1=$(echo $PING1 | cut -d" " -f1)
ESCOLHA1(){ dialog		\
	--stdout		\
	$DIALOG \
	--title 'Status'	\
	--msgbox 'Você está conectado a internet' 	\
	6 40 

source "$DIRET/REDE/rede.sh"

VAL=$?
	#[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
	[[ $VAL == 255 ]] && exit 0
} 
ESCOLHA2(){ dialog			\
	--stdout		\
	$DIALOG \
	--title 'Status'	\
	--msgbox  'Você não está conectado a internet' \
	6 40  

source "$DIRET/REDE/rede.sh"

VAL=$?
	#[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
	[[ $VAL == 255 ]] && exit 0
}
echo "[$(date)] Menu REDE teste de conecão encerrado" >> "$LOG/hardtest$USERU.log"
if [[ $PING1 == "64" ]] ; then
	ESCOLHA1  
else
	ESCOLHA2 
fi
