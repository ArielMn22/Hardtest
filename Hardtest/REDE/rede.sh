#!/bin/bash
DIRET="/usr/share/Hardtest"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
TIPO=$(cat /tmp/tipo)
clear
menurede(){
ESCOLHA=$(dialog\
	--stdout\
	$DIALOG\
	--title 'Teste de rede'		\
	--menu "Escolha uma opção: "	\
	0 0 0				\
	1 "Testar se estou conectado na internet"\
	2 "Testar velocidade de conexão" 	\
	3 "Testar velocidade de upload "	\
	4 "Teste de Latência"			\
	5 "Voltar")
[[ $? == 0 ]] && break || exit 0
case $ESCOLHA  in 
	1) . "$DIRET/REDE/inter.sh" ;;
	2) . "$DIRET/REDE/conexd.sh" ;;
	3) . "$DIRET/REDE/conex.sh"  ;;
	4) . "$DIRET/REDE/latencia.sh" ;;
	5) clear ; dialog $DIALOG --title "Saindo" --infobox  "Ate mais" 0 0 ; . "$DIRET/.menu.sh" $TIPO ;;

esac

}
menurede

