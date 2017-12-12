#!/bin/bash

USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)
LOG="/var/log/Hardtest"
DIRET="/usr/share/Hardtest/program"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""

echo "[$(date)] Menu HD teste slots iniciado" >> "$LOG/hardtest$USERU.log"

pulalinha(){ echo ; }
		
		BANKS=$(dmidecode -t memory | grep "Bank" | cut -d ":" -f2)
			BANK0=$(echo $BANKS | cut -d" " -f1-2) ; [[ -z $BANK0 ]] && BANK0="(Not Found)"
			BANK1=$(echo $BANKS | cut -d" " -f3-4) ; [[ -z $BANK1 ]] && BANK1="(Not Found)"
			BANK2=$(echo $BANKS | cut -d" " -f5-6) ; [[ -z $BANK2 ]] && BANK2="(Not Found)"
			BANK3=$(echo $BANKS | cut -d" " -f7-8) ; [[ -z $BANK3 ]] && BANK3="(Not Found)"
			BANK4=$(echo $BANKS | cut -d" " -f9-10) ; [[ -z $BANK4 ]] && BANK4="(Not Found)"
			BANK5=$(echo $BANKS | cut -d" " -f11-12) ; [[ -z $BANK5 ]] && BANK5="(Not Found)"
			BANK6=$(echo $BANKS | cut -d" " -f13-14) ; [[ -z $BANK6 ]] && BANK6="(Not Found)"
			BANK7=$(echo $BANKS | cut -d" " -f15-16) ; [[ -z $BANK7 ]] && BANK7="(Not Found)"

		SPEEDS=$(dmidecode -t memory | grep "^.Speed" | cut -d":" -f2 | cut -d"M" -f1)
			SPEED0=$(echo $SPEEDS | cut -d" " -f1) ; [[ -z $SPEED0 ]] && SPEED0="(Not Found)"
			SPEED1=$(echo $SPEEDS | cut -d" " -f2) ; [[ -z $SPEED1 ]] && SPEED1="(Not Found)"
			SPEED2=$(echo $SPEEDS | cut -d" " -f3) ; [[ -z $SPEED2 ]] && SPEED2="(Not Found)"
			SPEED3=$(echo $SPEEDS | cut -d" " -f4) ; [[ -z $SPEED3 ]] && SPEED3="(Not Found)"
			SPEED4=$(echo $SPEEDS | cut -d" " -f5) ; [[ -z $SPEED4 ]] && SPEED4="(Not Found)"
			SPEED5=$(echo $SPEEDS | cut -d" " -f6) ; [[ -z $SPEED5 ]] && SPEED5="(Not Found)"
			SPEED6=$(echo $SPEEDS | cut -d" " -f7) ; [[ -z $SPEED6 ]] && SPEED6="(Not Found)"
			SPEED7=$(echo $SPEEDS | cut -d" " -f8) ; [[ -z $SPEED7 ]] && SPEED7="(Not Found)"

		SIZE=$(dmidecode -t memory | grep Size | cut -d":" -f2 | cut -d" " -f2)
			SIZE0=$(echo $SIZE | cut -d" " -f1) ; [[ -z $SIZE0 ]] && SIZE0="(Not Found)"
			SIZE1=$(echo $SIZE | cut -d" " -f2) ; [[ -z $SIZE1 ]] && SIZE1="(Not Found)"
			SIZE2=$(echo $SIZE | cut -d" " -f3) ; [[ -z $SIZE2 ]] && SIZE2="(Not Found)"
			SIZE3=$(echo $SIZE | cut -d" " -f4) ; [[ -z $SIZE3 ]] && SIZE3="(Not Found)"
			SIZE4=$(echo $SIZE | cut -d" " -f5) ; [[ -z $SIZE4 ]] && SIZE4="(Not Found)"
			SIZE5=$(echo $SIZE | cut -d" " -f6) ; [[ -z $SIZE5 ]] && SIZE5="(Not Found)"
			SIZE6=$(echo $SIZE | cut -d" " -f7) ; [[ -z $SIZE6 ]] && SIZE6="(Not Found)"
			SIZE7=$(echo $SIZE | cut -d" " -f8) ; [[ -z $SIZE7 ]] && SIZE7="(Not Found)"

DEV=$(dmidecode -t memory | grep "^.Number" | cut -d" " -f4)
MAXRAM=$(dmidecode -t memory | grep "Maximum" | cut -d" " -f3)
DDR=$(dmidecode -t memory | grep "DDR" | uniq | cut -d" " -f2)

memoriatotal=$(echo $(sudo dmidecode -t memory | grep "MB" | grep "Size" | cut -d" " -f2) | tr ' ' +)
memoriatotal=$(($memoriatotal)) # Em MB.
memoriatotalGB=$(($memoriatotal/1000))

NUM=$(cat /proc/meminfo | grep "MemFree" | cut -d":" -f2 | cut -d"k" -f1) 
NUM2=$(( $NUM / 1000 ))

texto(){ 
echo "Slots de memoria: $DEV"
echo "Capacidade maxima de RAM: $MAXRAM GB"
echo "O padrão de memoria da sua maquina é: $DDR"
echo "Total de memória da máquina: $memoriatotal MB / $memoriatotalGB GB"
echo "Memória RAM livre: $NUM2 MB"
pulalinha
echo "Banco $BANK0:"
echo "$SPEED0 MHz"
echo "A quantidade de memoria é $SIZE0 MB"
pulalinha
echo "Banco $BANK1:"
echo "$SPEED1 MHz"
echo "A quantidade de memoria é $SIZE1 MB"
pulalinha
echo "Banco $BANK2:"
echo "$SPEED2 MHz"
echo "A quantidade de memoria é $SIZE2 MB" 
pulalinha
echo "Banco $BANK3:"
echo "$SPEED3 MHz"
echo "A quantidade de memoria é $SIZE3 MB"
pulalinha
echo "Banco $BANK4:"
echo "$SPEED4 MHz"
echo "A quantidade de memoria é $SIZE4 MB"
pulalinha
echo "Banco $BANK5:"
echo "$SPEED5 MHz"
echo "A quantidade de memoria é $SIZE5 MB"
pulalinha
echo "Banco $BANK6:"
echo "$SPEED6 MHz"
echo "A quantidade de memoria é $SIZE6 MB"
pulalinha
echo "Banco $BANK7:"
echo "$SPEED7 MHz"
echo "A quantidade de memoria é $SIZE7 MB"
}

novotexto=$(texto | sed '/(Not Found)/d')
echo "$novotexto" > "$DIRET/RAM/.texto.txt"

dialog 															\
	$DIALOG 													\
	--title 'Slots' 											\
	--textbox "$DIRET/RAM/.texto.txt" 							\
0 0

VAL=$?
[[ $VAL == 1 ]] && source $DIRET/RAM/menuprojeto.sh
[[ $VAL == 255 ]] && exit 0
echo "[$(date)] Menu HD teste slots encerrado" >> "$LOG/hardtest$USERU.log"
. "$DIRET/RAM/menuprojeto.sh"
