#!/bin/bash

USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
DIRET="/usr/share/Hardtest/program"
STAGE="$DIRET/HD/staging.txt"
STRESS="$DATE/HD/stress.txt"
LOG="/var/log/Hardtest"

echo "[$(date)] Menu HD iniciado" >> "$LOG/hardtest$USERU.log"

texto(){
 echo "Tempo de leitura em cache: $timingcache MB em 2.00 segundos =  $timecache MB/seg" > "$STAGE"
}

textoA(){
 echo "Tempo de leitura do disco em buffer: $timingbuffer MB em $timebuffer segundos = $tmb MB/seg" > "$STAGE"
}

textoB(){
echo "info: despachando hogs: $dh"
echo "info: Execução completada em $sc"
echo "info: stressor     Num. de Interações tempo $bogo  tempo usr  tempo de sistema   núm. de int/seg   núm. de int/seg"
echo "info:                 (segs) (segs) (segs) (tempo real) (usr+temp sist)"
echo "info: hdd    $a     $b  $c   $d    $e       $f" 
}

stress(){

dialog --stdout $DIALOG --title "Stress HD" --msgbox "O stress será executado por 20 (vinte) segundos e depois será encerrado." 0 0
VAL=$?
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0

dialog --stdout $DIALOG --title "Stress" --infobox "Executando testes..." 0 0

stress-ng --hdd 1 --timeout 20 --metrics-brief &> $STAGE

dh=$(cat $STAGE | grep "dispatching hogs:" | cut -d" " -f7-8)
sc=$(cat $STAGE | grep "successful run" | cut -d" " -f9)
bogo=$(cat $STAGE | grep "stressor" | cut -d" " -f13)
a=$(cat $STAGE | grep "hdd      " | cut -d" " -f19)
b=$(cat $STAGE | grep "hdd      " | cut -d" " -f24)
c=$(cat $STAGE | grep "hdd      " | cut -d" " -f30)
d=$(cat $STAGE | grep "hdd      " | cut -d" " -f36)
e=$(cat $STAGE | grep "hdd      " | cut -d" " -f42)
f=$(cat $STAGE | grep "hdd      " | cut -d" " -f47)

textoB > "$STAGE"

dialog --stdout $DIALOG --title "Stress" --textbox "$STAGE" 0 0
	VAL=$?
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0
teaste
}

stresspersonalizado(){
hogs=$(dialog --stdout $DIALOG --title "Stress HD" --inputbox "Insira o número de stressors que deseja utilizar no stress:" 0 0
)
VAL=$?
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0
time=$(dialog --stdout $DIALOG --title "Stress HD" --inputbox "Insira a duração, em algarimos númericos, do stress:" 0 0
)
VAL=$?
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0
dialog --stdout $DIALOG --title "Stress HD" --infobox "O stress será executado por $time segundos e depois será encerrado." 0 0
VAL=$?
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0
dialog --stdout $DIALOG --title "Stress" --infobox "Executando testes..." 0 0
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0
stress-ng --hdd $hogs --timeout $time --metrics-brief &> $STAGE
dh=$(cat $STAGE | grep "dispatching hogs:" | cut -d" " -f7-8)
sc=$(cat $STAGE | grep "successful run" | cut -d" " -f9)
bogo=$(cat $STAGE | grep "stressor" | cut -d" " -f13)
a=$(cat $STAGE | grep "hdd      " | cut -d" " -f19)
b=$(cat $STAGE | grep "hdd      " | cut -d" " -f24)
c=$(cat $STAGE | grep "hdd      " | cut -d" " -f30)
d=$(cat $STAGE | grep "hdd      " | cut -d" " -f36)
e=$(cat $STAGE | grep "hdd      " | cut -d" " -f42)
f=$(cat $STAGE | grep "hdd      " | cut -d" " -f47)
textoB > "$STAGE"
dialog --stdout $DIALOG --title "Stress" --textbox "$STAGE" 0 0
	VAL=$?
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0
teaste
}

cache(){
dialog --stdout $DIALOG --title "Status" --infobox '\nAguarde alguns segundos...' 6 40
	VAL=$?
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0
hdparm -T /dev/sda > "$STAGE"
timingcache=$(cat "$STAGE" | grep "^.*Timing cached reads:" | cut -d" " -f7) 
timecache=$(cat "$STAGE" | grep "^.*Timing cached reads:" | cut -d" " -f14)
texto
dialog --stdout $DIALOG --title "Cache" --msgbox "\n$(cat "$STAGE")\n" 0 0
VAL=$?
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0
teaste
}

buffer(){
dialog --stdout $DIALOG --title "Status" --infobox '\nAguarde alguns segundos...' 6 40
	VAL=$?
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0
hdparm -t /dev/sda > "$STAGE"
timingbuffer=$(cat "$STAGE" | grep "^.*Timing buffered disk reads:" | cut -d" " -f6)
timebuffer=$(cat "$STAGE" | grep "^.*Timing buffered disk reads:" | cut -d" " -f10)
tmb=$(cat "$STAGE" | grep "^.*Timing buffered disk reads:" | cut -d" " -f13) 
textoA
dialog --stdout $DIALOG --title "Buffer" --msgbox "\n$(cat "$STAGE")\n" 0 0
	VAL=$?
[[ $VAL == 1 ]] && teaste
[[ $VAL == 255 ]] && exit 0
teaste
}

teaste(){
CHOICE=$(dialog	--stdout $DIALOG --title 'Teste de HD'	--menu "Escolha uma opção: " 0 0 0	\
				1 "Teste Buffer"  			\
				2 "Teste Cache"					\
		  	3 "Teste Stress"				\
				4 "Teste Stress personalizado"\
				5 "Voltar" 
	VAL=$?
				[[ $VAL == 1 ]] && menu
				[[ $VAL == 255 ]] && exit 0
		)
case $CHOICE in
				1) buffer ;;
				2) cache ;; 
				3) stress ;;
				4) stresspersonalizado ;;
				5) menu ;;
esac
}

menu(){
ESCOLHA=$(dialog	--stdout $DIALOG --title 'HD'	--menu "Escolha uma opção: " 0 0 0	\
				1 "Listar partições"  			\
				2 "Testes"					\
				3 "Voltar" 
	VAL=$?
				[[ $VAL == 1 ]] && source $DIRET/.menu.sh
				[[ $VAL == 255 ]] && exit 0
				)
case $ESCOLHA in
				1) . $DIRET/HD/lsblk.sh ;;
				2) teaste ;;
				3) echo "[$(date)] Menu HD encerrado" >> "$LOG/hardtest$USERU.log" ; . "$DIRET/.menu.sh" $TIPO ;;

esac
}

menucomum(){
ESCOLHA=$(dialog	--stdout $DIALOG --title 'HD'	--menu "Escolha uma opção: " 0 0 0	\
				1 "Listar partições"  			\
				2 "Voltar" 
	VAL=$?
				[[ $VAL == 1 ]] && source $DIRET/.menu.sh
				[[ $VAL == 255 ]] && exit 0
				)
case $ESCOLHA in
				1) . $DIRET/HD/lsblk.sh ;;
				2) echo "[$(date)] Menu HD encerrado" >> "$LOG/hardtest$USERU.log" ; . "$DIRET/.menu.sh" $TIPO ;;

esac
}

case $TIPO in
	COMUM) menucomum ;;
	*) menu;;
esac
