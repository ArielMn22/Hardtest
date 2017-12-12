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

MEM(){

	NUM=$(cat /proc/meminfo | grep "MemFree" | cut -d":" -f2 | cut -d"k" -f1) 
	NUM2=$(( $NUM / 1000 ))

	if [[ $NUM2 -ge "2000" ]] ; then
			aguardando "Teste iniciado isso pode levar um bom tempo..."
	elif [[ $NUM2 -lt "2000"  ]] ; then
			aguardando "Teste iniciado isso pode demorar um pouco..."
	fi

	memtester $NUM2 1 > respostaMEM.txt
  ESTADO=$?
	$(cat respostaMEM.txt | sed 's/Stuck Address   /Endereço Escolhido/g' > resposta1.txt)    
	$(cat resposta1.txt | sed 's/Random Value   /Valor Randomico  /g' > resposta2.txt)
	$(cat resposta2.txt | sed 's/Compare XOR/Compare XOR  /g' > resposta3.txt)  
	$(cat resposta3.txt | sed 's/Compare SUB/Compare SUB  /g' > resposta4.txt)
	$(cat resposta4.txt | sed 's/Compare MUL/Compare MUL  /g' > resposta5.txt)
	$(cat resposta5.txt | sed 's/Compare DIV/Comapre DIV  /g' > resposta6.txt)
	$(cat resposta6.txt | sed 's/Compare OR/Compare OR  /g' > resposta7.txt)
	$(cat resposta7.txt | sed 's/Compare AND/Compare AND  /g' > resposta8.txt)
	$(cat resposta8.txt | sed 's/Sequential Increment/Incremento sequencial /g' > resposta9.txt)
	$(cat resposta9.txt | sed 's/Solid Bits/Bits Solidos/g' > resposta10.txt)
	$(cat resposta10.txt | sed 's/Block Sequential/Sequencia de Bloco/g' > resposta11.txt)
	$(cat resposta11.txt | sed 's/Checkerboard/Checkerboard  /g' > resposta12.txt)
	$(cat resposta12.txt | sed 's/Bit Spread      /Propagação De Bits/g' > resposta13.txt)
	$(cat resposta13.txt | sed 's/Bit Flip  /Giro de Bits/g' > resposta14.txt)
	$(cat resposta14.txt | sed 's/Walking Ones      /Comportamento de Uns/g' > resposta15.txt)
	$(cat resposta15.txt | sed 's/Walking Zeroes      /Procedimento de Zeros /g' > resposta16.txt)
	$(cat resposta16.txt | sed 's/8-bit Writes    /Escrita Em 8 Bits /g' > resposta17.txt)
	$(cat resposta17.txt | sed 's/16-bit Writes   /Escrita em 16 Bits/g' > resposta18.txt)
	$(cat resposta18.txt > /tmp/respostaMEM.txt)
	
	$(rm resposta1.txt) ; $(rm resposta2.txt) ; $(rm resposta3.txt) ; $(rm resposta4.txt)
	$(rm resposta5.txt) ; $(rm resposta6.txt) ; $(rm resposta7.txt) ; $(rm resposta8.txt) 
	$(rm resposta9.txt) ; $(rm resposta10.txt) ; $(rm resposta11.txt) ; $(rm resposta12.txt)
	$(rm resposta13.txt) ; $(rm resposta14.txt) ; $(rm resposta15.txt) ; $(rm resposta16.txt) 
	$(rm resposta17.txt) ; $(rm resposta18.txt) ; $(rm respostaMEM.txt)
	
	dialog \
	--title 'Final' \
	--textbox /tmp/respostaMEM.txt \
	45 80

	if [[ $ESTADO == "0" ]] ; then 
		msg "Modulo de memória OK" 
                msg "para vizualizar o ultimo relatório criado execute cat /tmp/respostaMEM.txt" 
	else 
		msg "Modulo de memoria com erro"
	fi

	echo "[$(date)] Menu RAM teste de memória finalizado" >> "$LOG/hardtest$USERU.log"

}

NUMERO=0

MEMP(){
NUMERO=$(($NUMERO+1))	

	NUMP=$(cat /proc/meminfo | grep "MemFree" | cut -d":" -f2 | cut -d"k" -f1)
	NUM2P=$(( $NUMP / 1000 ))
	
	[[ $NUMERO -ge 3 ]] && msg "1. Você não pode colocar um número maior que $NUM2P MB.\n\n2. Você não pode executar o teste "0" vezes."
	
		TANTOMEMO=$(dialog --stdout $DIALOG --title "Teste de Memória" --inputbox "Escolha o tanto de memória que deseja testar (Em MB)\nOBS: Memória livre utilizável para o teste: $NUM2P MB" 0 0)
								val=$?
								[[ $val == 255 ]] && exit 0
								[[ $val == 1 ]] && MENU
		
		TANTOVEZES=$(dialog --stdout $DIALOG --title "Teste de Memória" --inputbox "Insira quantas vezes deseja que o teste seja executado:" 0 0)
								val=$?
						  	[[ $val == 255 ]] && exit 0
								[[ $val == 1 ]] && MENU

	[[ $TANTOMEMO -gt 2000 ]] && MEMP

	[[ $TANTOVEZES -eq 0 ]] && MEMP

	if [[ $TANTOMEMO -ge "2000" ]] ; then
		aguardando "Teste iniciado isso pode levar um bom tempo..."
	elif [[ $TANTOMEMO -lt "2000"  ]] ; then
		aguardando "Teste iniciado isso pode demorar um pouco..."
	fi

	memtester $TANTOMEMO $TANTOVEZES > respostaMEMP.txt
	ESTADO=$?
$(cat respostaMEMP.txt | sed 's/Stuck Address   /Endereço Escolhido/g' > resposta1.txt)    
$(cat resposta1.txt | sed 's/Random Value   /Valor Randomico  /g' > resposta2.txt)
$(cat resposta2.txt | sed 's/Compare XOR/Compare XOR  /g' > resposta3.txt)  
$(cat resposta3.txt | sed 's/Compare SUB/Compare SUB  /g' > resposta4.txt)
$(cat resposta4.txt | sed 's/Compare MUL/Compare MUL  /g' > resposta5.txt)
$(cat resposta5.txt | sed 's/Compare DIV/Comapre DIV  /g' > resposta6.txt)
$(cat resposta6.txt | sed 's/Compare OR/Compare OR  /g' > resposta7.txt)
$(cat resposta7.txt | sed 's/Compare AND/Compare AND  /g' > resposta8.txt)
$(cat resposta8.txt | sed 's/Sequential Increment/Incremento sequencial /g' > resposta9.txt)
$(cat resposta9.txt | sed 's/Solid Bits/Bits Solidos/g' > resposta10.txt)
$(cat resposta10.txt | sed 's/Block Sequential/Sequencia de Bloco/g' > resposta11.txt)
$(cat resposta11.txt | sed 's/Checkerboard/Checkerboard  /g' > resposta12.txt)
$(cat resposta12.txt | sed 's/Bit Spread      /Propagação De Bits/g' > resposta13.txt)
$(cat resposta13.txt | sed 's/Bit Flip  /Giro de Bits/g' > resposta14.txt)
$(cat resposta14.txt | sed 's/Walking Ones      /Comportamento de Uns/g' > resposta15.txt)
$(cat resposta15.txt | sed 's/Walking Zeroes      /Procedimento de Zeros /g' > resposta16.txt)
$(cat resposta16.txt | sed 's/8-bit Writes    /Escrita Em 8 Bits /g' > resposta17.txt)
$(cat resposta17.txt | sed 's/16-bit Writes   /Escrita em 16 Bits/g' > resposta18.txt)
$(cat resposta18.txt > /tmp/respostaMEMP.txt)

$(rm resposta1.txt) ; $(rm resposta2.txt) ; $(rm resposta3.txt) ; $(rm resposta4.txt)
$(rm resposta5.txt) ; $(rm resposta6.txt) ; $(rm resposta7.txt) ; $(rm resposta8.txt) 
$(rm resposta9.txt) ; $(rm resposta10.txt) ; $(rm resposta11.txt) ; $(rm resposta12.txt)
$(rm resposta13.txt) ; $(rm resposta14.txt) ; $(rm resposta15.txt) ; $(rm resposta16.txt) 
$(rm resposta17.txt) ; $(rm resposta18.txt) ; $(rm respostaMEMP.txt) 
dialog \
--title 'Final' \
--textbox /tmp/respostaMEMP.txt \
45 80
	
	NUMERO=0

	echo "[$(date)] Menu RAM teste de memória finalizado" >> "$LOG/hardtest$USERU.log"

	case $ESTADO in
		0) msg "Modulo de memória OK" ; msg "para vizualizar o ultimo relatório criado execute cat /tmp/respostaMEMP.txt" ; MENU ;;
		x01) msg "Erro durante alocação ou fechamento da memória." ; MENU ;;
		x02) msg "Erro durante o teste: Stuck Address" ; MENU ;;
		x04) msg "Erro durante teste inespecífico" ; MENU ;;
		*) msg "Modulo de memoria com erro desconhecido." ; MENU ;;
	esac


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
		*) exit 0 ;;
	esac
}
MENU
