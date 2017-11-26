#!/bin/bash
DIRET="/usr/share/Hardtest"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
clear
RAM=$(sudo dmidecode -t memory | grep "MB" | grep "Size" | cut -d" " -f2)
RAM0=$( echo $RAM | cut -d " " -f1 ) ; [[ -z $RAM0 ]] && RAM0=0
RAM1=$( echo $RAM | cut -d " " -f2 ) ; [[ -z $RAM1 ]] && RAM1=0
RAM2=$( echo $RAM | cut -d " " -f3 ) ; [[ -z $RAM2 ]] && RAM2=0
RAM3=$( echo $RAM | cut -d " " -f4 ) ; [[ -z $RAM3 ]] && RAM3=0
RAM4=$( echo $RAM | cut -d " " -f5 ) ; [[ -z $RAM4 ]] && RAM4=0
RAM5=$( echo $RAM | cut -d " " -f6 ) ; [[ -z $RAM5 ]] && RAM5=0
RAM6=$( echo $RAM | cut -d " " -f7 ) ; [[ -z $RAM6 ]] && RAM6=0
RAM7=$( echo $RAM | cut -d " " -f8 ) ; [[ -z $RAM7 ]] && RAM7=0
USER=100
#DEV=$(sudo dmidecode -t memory | grep "Number" | cut -d" " -f4)
SOMAUSER=$(( $RAM0 + $RAM1 + $RAM2 + $RAM3 + $RAM4 + $RAM5 + $RAM6 + $RAM7 ))
USERMAX=$(( $SOMAUSER / $USER ))

dialog --stdout $DIALOG --title 'USUARIOS MAX' --msgbox "Número aproximado de usuários que podem se conectar simultaneamente ao computador: $USERMAX." 8 50

. "$DIRET/RAM/menuprojeto.sh"
