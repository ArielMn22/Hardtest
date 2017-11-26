#!/bin/bash
TIPO=$(cat /tmp/tipo)
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
DIRET="/usr/share/Hardtest"
clear
sair(){ exit 0 ; }
menu(){
menu1=$(
dialog                     \
--stdout                   \
$DIALOG										 \
--title "TESTE RAM"        \
--menu 'Escolha uma opção' \
0 0 0                      \
1 'Usuarios Logados'       \
2 'Checklist de memoria'   \
3 'Voltar' 
[[ $? == 0 ]] && break || exit 0
)
case $menu1 in
		1) . "$DIRET/RAM/usuarios.sh" ;;
		2) . "$DIRET/RAM/slotsteste.sh" ;;
		3) . "$DIRET/.menu.sh" $TIPO ;;
		*) dialog --stdout $DIALOG --title "ERRO" --msgbox "Opção Inválida" 0 0 && menu ;;
esac
}
menucomum(){
menu1=$(
dialog                     \
--stdout                   \
$DIALOG\
--title "TESTE RAM"        \
--menu 'Escolha uma opção' \
0 0 0                      \
1 'Checklist de memoria'   \
2 'Voltar' 
[[ $? == 0 ]] && break || exit 0
)
case $menu1 in
		1) . "$DIRET/RAM/slotsteste.sh" ;;
		2) . "$DIRET/.menu.sh" $TIPO ;;
		*) dialog --stdout $DIALOG --title "ERRO" --msgbox "Opção Inválida" 0 0 && menu ;;
esac
}

case $TIPO in
	COMUM) menucomum ;;
	*) menu ;;
esac
