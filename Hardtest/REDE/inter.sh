#!/bin/bash
DIRET="/usr/share/Hardtest"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
clear
AGUARDE(){ dialog		\
	--stdout		\
	$DIALOG\
	--title	"Aguarde"	\
	--infobox '\nFazendo testes...' 0 0
}
PING(){
	AGUARDE
	ping -W 1 -c 7 8.8.8.8 &> "$DIRET/REDE/staging.txt"
	dialog					\
	--stdout 				\
	$DIALOG\
	--title 'Status'			\
	--tailbox "$DIRET/REDE/staging.txt"		\
	0 0 
[[ $? == 0 ]] && break || exit 0
}
PING
PING1=$(cat "$DIRET/REDE/staging.txt" | grep "64" | cut -d" " -f1) 
PING1=$(echo $PING1 | cut -d" " -f1)
ESCOLHA1(){ dialog		\
	--stdout		\
	$DIALOG\
	--title 'Status'	\
	--msgbox 'Você está conectado a internet' 	\
	6 40 
[[ $? == 0 ]] && break || exit 0
} 
ESCOLHA2(){ dialog			\
	--stdout		\
	$DIALOG\
	--title 'Status'	\
	--msgbox  'Você não está conectado a internet' \
	6 40 
[[ $? == 0 ]] && break || exit 0
}
if [[ $PING1 == "64" ]] ; then
	ESCOLHA1 && . "$DIRET/REDE/rede.sh"
else
	ESCOLHA2 && . "$DIRET/REDE/rede.sh"
fi
