#!/bin/bash

USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)
LOG="/var/log/Hardtest"
DIRET="/usr/share/Hardtest/program"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""

echo "[$(date)] Menu RAM teste de memória iniciado" >> "$LOG/hardtest$USERU.log"

msg(){

	dialog --stdout $DIALOG --title "OBS" --msgbox "$1" 0 0
	
	val=$?

	[[ $val == 255 ]] && exit 0
	[[ $val == 1 ]] && source $DIRET/RAM/menuprojeto.sh

}

inputbox(){

	dialog --stdout $DIALOG --title "$1" --inputbox "$2" 0 0
	
	val=$?

	[[ $val == 255 ]] && exit 0
	[[ $val == 1 ]] && MENU

}

aguardando(){

	dialog --stdout $DIALOG --title "Teste de Memória" --infobox "$1" 0 0
	
	val=$?

	[[ $val == 255 ]] && exit 0
	
}

erro(){ 

	case $1 in
		1) msg "Você não pode utilizar um valor maior que ($NUM2P MB)". && pegando ;;
		2) msg 'Você não pode executar o teste "0" vezes.' && pegando ;;
	esac

}

NUMBER=0

pegando(){

	while : ; do
		while [[ $NUMBER -ge 2 ]] ; do
			erro 1
			erro 2
			NUMBER=0
		done	
			
			TANTOMEMO=$(inputbox "Teste de Memória" "Escolha o tanto de memória que deseja testar (Em MB)\nOBS: Memória livre utilizável para o teste: $NUM2P MB")
			TANTOVEZES=$(inputbox "Teste de Memória" "Escolha o númeo de vezes que o teste vai rodar (Vazio = Infinitamente)")
			
			NUMBER=$(($NUMBER+1))
			
			[[ $TANTOMEMO -gt $NUM2P ]] && pegando || break 1
			[[ $TANTOVEZES == 0 ]] && pegando || break 1

	done

}

MEM(){

	NUM=$(cat /proc/meminfo | grep "MemFree" | cut -d":" -f2 | cut -d"k" -f1) 
	NUM2=$(( $NUM / 1000 ))

	if [[ $NUM2 -ge "2000" ]] ; then
			aguardando "Teste iniciado isso pode levar um bom tempo..."
	elif [[ $NUM2 -lt "1000"  ]] ; then
			aguardando "Teste iniciado isso pode demorar um pouco..."
	fi

	memtester $NUM2 1 > $DIRET/RAM/resposta.txt && cat $DIRET/RAM/resposta.txt 
	ESTADO=$(echo $?)

	if [[ $ESTADO == "0" ]] ; then 
		msg "Modulo de memória OK" 
	else 
		msg "Modulo de memoria com erro"
	fi

	echo "[$(date)] Menu RAM teste de memória finalizado" >> "$LOG/hardtest$USERU.log"

}

MEMP(){
	
	NUMP=$(cat /proc/meminfo | grep "MemFree" | cut -d":" -f2 | cut -d"k" -f1)
	NUM2P=$(( $NUMP / 1000 - 200 ))

	pegando
	
	if [[ $TANTOMEMO -ge "2000" ]] ; then
		aguardando "Teste iniciado isso pode levar um bom tempo..."
	elif [[ $TANTOMEMO -lt "1000"  ]] ; then
		aguardando "Teste iniciado isso pode demorar um pouco..."
	fi

	memtester $TANTOMEMO $TANTOVEZES > $DIRET/RAM/resposta.txt  
	
	$(cat $DIRET/RAM/resposta.txt | sed 's/Random Value       /Valor Randomico      /g' > $DIRET/RAM/resposta1.txt)
	$(cat $DIRET/RAM/resposta1.txt | sed 's/Solid Bits/Bits Solidos/g' > $DIRET/RAM/resposta2.txt)
	$(cat $DIRET/RAM/resposta2.txt | sed 's/Sequential Increment/Incremento sequencial /g' > $DIRET/RAM/resposta3.txt)
	$(cat $DIRET/RAM/resposta3.txt | sed 's/Block Sequential/Sequencia de Bloco/g' > $DIRET/RAM/resposta4.txt)
	
	ESTADO=$(echo $?)
	
	if [[ $ESTADO == "0" ]] ; then 
		msg "Modulo de memória OK" 
	else 
		msg "Modulo de memoria com erro"
	fi

	echo "[$(date)] Menu RAM teste de memória finalizado" >> "$LOG/hardtest$USERU.log"

}

MENU(){

	clear

	escolha=$(dialog --stdout $DIALOG --title "Teste de Memória" --menu "Escolha um tipo de teste:" \
			0 0 0													  								 \
			1 'Teste de memória'									  								 \
			2 'Teste de memória personalizado'						  								 \
			3 'Voltar'

			val=$?

			[[ $val == 255 ]] && exit 0
			[[ $val == 1 ]] && source $DIRET/RAM/menuprojeto.sh)

	case $escolha in
		1) MEM ; MENU ;;
		2) MEMP ; MENU ;;
		3) . $DIRET/RAM/menuprojeto.sh ;;
	esac
}
MENU
