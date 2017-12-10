#!/bin/bash
USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
DIRET="/usr/share/Hardtest/program"
LOG="/var/log/Hardtest"
TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
echo "[$(date)] Menu REDE iniciado" >> "$LOG/hardtest$USERU.log"
clear
menurede(){
ESCOLHA=$(dialog \
	--stdout \
	$DIALOG \
	--title 'Teste de rede'		\
	--menu "Escolha uma opção:"	\
	0 0 0				\
	1 "Testar se estou conectado na internet" \
	2 "Testar velocidade de download" 	\
	3 "Testar velocidade de upload "	\
	4 "Teste de Latência"			\
	5 "Voltar"
	VAL=$?
	[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
	[[ $VAL == 255 ]] && exit 0
)

case $ESCOLHA  in 
	1) . "$DIRET/REDE/inter.sh" ;;
	2) . "$DIRET/REDE/conex.sh" ;;
	3) . "$DIRET/REDE/conexd.sh"  ;;
	4) . "$DIRET/REDE/latencia.sh" ;;
	5) echo "[$(date)] Menu REDE iniciado" >> "$LOG/hardtest$USERU.log" ; source "$DIRET/.menu.sh" $TIPO ;;
esac

}

menuredecomum(){
ESCOLHA=$(dialog\
	--stdout\
	$DIALOG\
	--title 'Teste de rede'		\
	--menu "Escolha uma opção: "	\
	0 0 0				\
	1 "Testar se estou conectado na internet"\
	2 "Teste de Latência"			\
	3 "Voltar"
	VAL=$?
	[[ $VAL == 1 ]] && source $DIRET/REDE/rede.sh
	[[ $VAL == 255 ]] && exit 0
)

case $ESCOLHA  in 
	1) . "$DIRET/REDE/inter.sh" ;;
	2) . "$DIRET/REDE/latencia.sh" ;;
	3) echo "[$(date)] Menu REDE iniciado" >> "$LOG/hardtest$USERU.log" ; source "$DIRET/.menu.sh" ;;
esac

}

case $TIPO in
	COMUM) menuredecomum ;;
	*) menurede ;;
esac


