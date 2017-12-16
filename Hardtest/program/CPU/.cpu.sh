#!/bin/bash

DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)
DIRET="/usr/share/Hardtest/program"
STAGE="$DIRET/CPU/staging.txt"
LOG="/var/log/Hardtest"

echo "[$(date)] Menu CPU iniciado" >> "$LOG/hardtest$USERU.log"

textbox(){
[[ $1 == "cpuinfo" ]] && SIZE='90 80' || SIZE='0 0'
dialog --stdout $DIALOG --title "Mostrando" --textbox "$STAGE" $SIZE
	VAL=$?
[[ $VAL == 255 ]] && exit 0
}

especificacoesc(){
ESCOLHA1=$(dialog               \
	--stdout              \
	$DIALOG\
	--title "Método"      \
	--menu "Escolha um método"\
	0 0 0                 \
	lscpu "Utiliza informações do lscpu"\
	cpuinfo "Utiliza informações do cpuinfo"\
	Voltar "Volta ao menu anterior"
	VAL=$?
	[[ $VAL == 255 ]] && exit 0 
 [[ $VAL == 1 ]] && menu
)
case $ESCOLHA1 in
  "lscpu") lscpu > "$STAGE" ; textbox lscpu ; especificacoesc ;;
  "cpuinfo") cat /proc/cpuinfo > "$STAGE" ; textbox cpuinfo ; especificacoesc ;;
  "Voltar") . "$DIRET/CPU/.cpu.sh" $TIPO ;;
esac
}

especificacoesb(){
[[ $TIPO == "COMUM" ]] && MENU="menucomum" | MENU="menu"
	MODEL=$(grep "model name" /proc/cpuinfo | sort | uniq)
	CACHE=$(grep "cache size" /proc/cpuinfo | sort | uniq)
	FAMILY=$(grep "cpu family" /proc/cpuinfo | sort | uniq)
	VENDOR=$(grep "vendor_id" /proc/cpuinfo | sort | uniq)
	CORES=$(grep "cpu cores" /proc/cpuinfo | sort | uniq)
	ARCHITECTURE=$(lscpu | grep "Architecture:")
	threads(){
		NUMERO=$(lscpu | grep "Thread" | cut -d " " -f5)
		NUCLEOS=$(echo $CORES | cut -d" " -f4)
		THREADS=$(($NUMERO*$NUCLEOS))
		THREADS=$(echo "cpu threads: $THREADS")
	}
	threads
	echo -e "$MODEL\n$CACHE\n$FAMILY\n$VENDOR\n$CORES\n$ARCHITECTURE$THREADS" > "$STAGE"
	dialog --stdout $DIALOG --title "Especificações" --msgbox "$(cat "$STAGE")" 0 0 
	VAL=$?
	[[ $VAL == 255 ]] && exit 0 
 [[ $VAL == 1 ]] && menu
}

menu(){
ESCOLHA=$(dialog                \
        --stdout                \
				$DIALOG\
        --title "CPU"           \
        --menu  "Escolha uma opção:"\
        0 0 0\
        Especificações\ Completas "Mostra especificações completas do processador"\
        Especificações\ Básicas "Mostra especificações básicas do processador"\
				Testes "Mostra os testes"\
				Temperatura "Mostra a temperatura dos Núcleos"\
        Voltar "Volta para o menu anterior"
	VAL=$?
				[[ $VAL == 255 ]] && exit 0
        [[ $VAL == 1 ]] && source $DIRET/.menu.sh
)
case $ESCOLHA in
        "Especificações Completas") especificacoesc ;;
        "Especificações Básicas") especificacoesb ; menu ;;
				"Testes") . "$DIRET/CPU/.testcpu.sh" ;;
				"Temperatura") . "$DIRET/CPU/.sensors.sh" ;;
        "Voltar") echo "[$(date)] Menu CPU encerrado" >> "$LOG/hardtest$USERU.log" ; . "$DIRET/.menu.sh" $TIPO ;;
esac
}

menucomum(){
ESCOLHA=$(dialog                \
        --stdout                \
				$DIALOG\
        --title "CPU"           \
        --menu  "Escolha uma opção:"\
        0 0 0\
        Especificações\ Completas "Mostra especificações completas do processador"\
        Especificações\ Básicas "Mostra especificações básicas do processador"\
        Voltar "Volta para o menu anterior"
	VAL=$?
	[[ $VAL == 255 ]] && exit 0
        [[ $VAL == 1 ]] && source $DIRET/.menu.sh
)
case $ESCOLHA in
        "Especificações Completas") especificacoesc ;;
        "Especificações Básicas") especificacoesb ; menucomum ;;
        "Voltar") . "$DIRET/.menu.sh" $TIPO ;;
esac
}

case $TIPO in
	COMUM) menucomum ;;
	*) menu ;;
esac
