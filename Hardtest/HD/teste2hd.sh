#!/bin/bash
TIPO=$(cat /tmp/tipo)
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
DIRET="/usr/share/Hardtest"
STAGE="$DIRET/HD/staging.txt"
STRESS="$DATE/HD/stress.txt"
clear
texto(){
 echo "Tempo de leitura em cache: $timingcache MB em 2.00 segundos =  $timecache MB/seg" > "$STAGE"
}
textoA(){
 echo "Tempo de leitura do disco em buffer: $timingbuffer MB em $timebuffer segundos = $tmb MB/seg" > "$STAGE"
}
textoB(){
echo "despachando hogs: $dh"
echo "Execução completada em $sc"
echo "Num. de Interações tempo $bogo  tempo usr  tempo de sistema   núm. de int/seg   núm. de int/seg"
echo "info:                 (segs) (segs) (segs) (tempo real) (usr+temp sist)"
echo "info: hdd    $a     $b  $c   $d    $e       $f" 
}
stress(){
dialog --stdout $DIALOG --title "Aguarde" --infobox "\nFazendo Testes...\n" 0 0
stress-ng --hdd 1 --timeout 10 --metrics-brief &> $STAGE 
dh=$(cat $STAGE | grep "dispatching hogs:" | cut -d" " -f7-8)
sc=$(cat $STAGE | grep "successful run" | cut -d" " -f9)
bogo=$(cat $STAGE | grep "stressor" | cut -d" " -f13)
sec=$(cat $STAGE | grep ""| cut -d" " -f40)
a=$(cat $STAGE | grep "hdd      " | cut -d" " -f19)
b=$(cat $STAGE | grep "hdd      " | cut -d" " -f24)
c=$(cat $STAGE | grep "hdd      " | cut -d" " -f30)
d=$(cat $STAGE | grep "hdd      " | cut -d" " -f36)
e=$(cat $STAGE | grep "hdd      " | cut -d" " -f42)
f=$(cat $STAGE | grep "hdd      " | cut -d" " -f47)
textoB > "$STAGE"
dialog --stdout $DIALOG --title "Stress" --textbox "$STAGE" 0 0
[[ $? == 0 ]] && break || exit 0
menu
}
cache(){
dialog --stdout $DIALOG --title "Status" --infobox '\nAguarde alguns segundos...' 6 40
hdparm -T /dev/sda > "$STAGE"
timingcache=$(cat "$STAGE" | grep "^.*Timing cached reads:" | cut -d" " -f7) 
timecache=$(cat "$STAGE" | grep "^.*Timing cached reads:" | cut -d" " -f14)
texto
dialog --stdout $DIALOG --title "Cache" --msgbox "\n$(cat "$STAGE")\n" 0 0
[[ $? == 0 ]] && break || exit 0
menu
}
buffer(){
dialog --stdout $DIALOG --title "Status" --infobox '\nAguarde alguns segundos...' 6 40
hdparm -t /dev/sda > "$STAGE"
timingbuffer=$(cat "$STAGE" | grep "^.*Timing buffered disk reads:" | cut -d" " -f6)
timebuffer=$(cat "$STAGE" | grep "^.*Timing buffered disk reads:" | cut -d" " -f10)
tmb=$(cat "$STAGE" | grep "^.*Timing buffered disk reads:" | cut -d" " -f13) 
textoA
dialog --stdout $DIALOG --title "Buffer" --msgbox "\n$(cat "$STAGE")\n" 0 0
[[ $? == 0 ]] && break || exit 0
menu
}

menu(){
CHOICE=$(dialog	--stdout $DIALOG --title 'Teste de HD'	--menu "Escolha uma opção: " 0 0 0	\
				1 "Teste Buffer"  			\
				2 "Teste Cache"						\
			  3 "Teste Stress"						\
				4 "Voltar" )
case $CHOICE in
				1) buffer ;;
				2) cache ;; 
				3) stress ;;
				4) . "$DIRET/.menu.sh" $TIPO ;;
esac
}
menu
