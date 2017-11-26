#!/bin/bash
DIRET="/usr/share/Hardtest"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
TIPO=$(cat /tmp/tipo)

menu(){
	ESCOLHA=$(dialog --stdout $DIALOG --title "Listar HDs" --menu "Escolha um método:"\
	0 0 0\
	lsblk "Mostra particionamento dos HDs com lsblk"\
	fdisk "Mostra particionamento dos HDs com fdisk"\
	Voltar "Volta para o menu anterior")

	case $ESCOLHA in
		lsblk) lsblk ;;
		fdisk) fdisk ;;
	esac
}

lsblk(){
	lsblk &> "$DIRET/HD/staging.txt"
	dialog --stdout $DIALOG --msgbox "$DIRET/HD/staging.txt"
	menu
}

fdisk(){
	fdisk -l &> "$DIRET/HD/staging.txt"
	dialog --stdout $DIALOG --msgbox "$DIRET/HD/staging.txt"
	menu
}

menu
