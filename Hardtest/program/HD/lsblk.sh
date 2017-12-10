#!/bin/bash

DIRETCOM="/usr/share/Hardtest/program"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)

partum(){

dialog                   \
--title 'Status'         \
--infobox '\nAguarde...' \
0 0

PARTICAO=$(lsblk &> "stagingP.txt")
$(cat stagingP.txt | sed 's/NAME/NOME/g' > "stagingUM.txt")
$(cat stagingUM.txt | sed 's/TYPE/TIPO/g' > "stagingDOIS.txt")
$(cat stagingDOIS.txt | sed 's/MOUNTPOINT/PONTO\ DE\ MONTAGEM/g' > "stagingTRES.txt")
$(cat stagingTRES.txt > stagingP.txt )

dialog \
--stdout \
--title 'Visualizando Partições' \
--textbox 'stagingP.txt' \
0 0

#VAL=$?
#[[ $VAL == 1 ]] && menu
#[[ $VAL == 255 ]] && exit 0 

$(rm stagingP.txt )
$(rm stagingUM.txt )
$(rm stagingDOIS.txt )
$(rm stagingTRES.txt )
menu
}

partdois(){

dialog                   \
--title 'Status'         \
--infobox '\nAguarde...' \
0 0

#VAL=$?
#[[ $VAL == 1 ]] && menu
#[[ $VAL == 255 ]] && exit 0 

particao=$( fdisk -l &> staging.txt )
$(cat staging.txt | grep "Dispositivo" > stagingP.txt )
$(cat staging.txt | grep ^/ >> stagingP.txt )
$(cat stagingP.txt | sed 's/Start/Começo/g' > stagingUM.txt )
$(cat stagingUM.txt > stagingP.txt )

dialog                            \
--stdout                          \
--title 'Visualisando Partições'  \
--textbox "stagingP.txt"          \
0 0

#VAL=$?
#[[ $VAL == 1 ]] && source $DIRETCOM/HD/teste2hd.sh
#[[ $VAL == 255 ]] && exit 0

$(rm stagingP.txt)
$(rm staging.txt)
$(rm stagingUM.txt)
menu  
}
 
menu(){
ESCOLHA=$(
dialog                                         \
--stdout $DIALOG                               \
--title "Teste HD"                           \
--menu "Selecione uma opção:"                    \
0 0 0                                          \
	1 "Mostra particionamento dos HDs com lsblk" \
	2 "Mostra particionamento dos HDs com fdisk" \
	3 "Volta para o menu anterior"
	VAL=$?
	[[ $VAL == 1 ]] && source $DIRETCOM/HD/teste2hd.sh
	[[ $VAL == 255 ]] && exit 0
)

	case $ESCOLHA in
		1) partum ;;
		2) partdois ;;
		3) . $DIRET/HD/teste2hd.sh ;;
	esac
}
menu
