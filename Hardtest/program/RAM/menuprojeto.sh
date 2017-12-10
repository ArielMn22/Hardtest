#!/bin/bash
USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
DIRET="/usr/share/Hardtest/program"
LOG="/var/log/Hardtest"
echo "[$(date)] Menu RAM iniciado" >> "$LOG/hardtest$USERU.log"
sair(){ exit 0 ; }
menu(){
menu1=$(
dialog                     \
--stdout                   \
$DIALOG										 \
--title "Teste RAM"        \
--menu 'Escolha uma opção' \
0 0 0                      \
1 'Usuarios Logados'       \
2 'Checklist de memoria'   \
3 'Teste de velocidade'		 \
4 'Teste de memória'			 \
5 'Voltar' 
VAL=$?
[[ $VAL == 1 ]] && source $DIRET/.menu.sh
[[ $VAL == 255 ]] && exit 0
)
case $menu1 in
		1) . "$DIRET/RAM/usuarios.sh" ;;
		2) . "$DIRET/RAM/slotsteste.sh" ;;
		3) . "$DIRET/RAM/velocidadedememoria.sh" ;;
		4) . "$DIRET/RAM/testeRAM.sh" ;;
		5) echo "[$(date)] Menu RAM encerrado" >> "$LOG/hardtest$USERU.log" ; . "$DIRET/.menu.sh" ;;
esac
}
menucomum(){
menu2=$(
dialog                     \
--stdout                   \
$DIALOG										 \
--title "Teste RAM"        \
--menu 'Escolha uma opção' \
0 0 0                      \
1 'Checklist de memoria'   \
2 'Voltar' 
VAL=$?
[[ $VAL == 1 ]] && source $DIRET/.menu.sh
[[ $VAL == 255 ]] && exit 0
)
case $menu2 in
		1) . "$DIRET/RAM/slotsteste.sh" ;;
		2) echo "[$(date)] Menu RAM encerrado" >> "$LOG/hardtest$USERU.log" ; . "$DIRET/.menu.sh" ;;
esac
}

case $TIPO in
	COMUM) menucomum ;;
	*) menu ;;
esac
