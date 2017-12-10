#!/bin/bash
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
DIRET="/usr/share/Hardtest/program"
LOG="/var/log/Hardtest"
STAGE="$DIRET/CPU/staging.txt"
THREADS=$(lscpu | grep "^CPU(s):" | cut -d" " -f17)
echo "[$(date)] Menu CPU TESTE iniciado" >> "$LOG/hardtest$USERU.log"

menu(){
	ESCOLHAMENU=$(dialog			\
		--stdout				\
		$DIALOG\
		--title "Testes"\
		--menu "Escolha um tipo de teste:"\
		0 0 0						\
		sysbench "Realiza testes com o sysbench"\
		stress-ng "Realiza testes com o stress-ng"\
		Voltar "Volta ao menu anterior"
	VAL=$?
		[[ $VAL == 255 ]] && exit 0
        	[[ $VAL == 1 ]] && source $DIRET/CPU/.cpu.sh
	)
	case $ESCOLHAMENU in
		sysbench) menusysbench ;;
		stress-ng) menustressng ;;
		"Voltar") echo "[$(date)] Menu CPU TESTE encerrado" >> "$LOG/hardtest$USERU.log" ; . "$DIRET/CPU/.cpu.sh"
	esac
}

sysbenchdefault(){

	dialog --stdout $DIALOG --title "Aguarde" --infobox "Teste Iniciado ..." 5 40
	VAL=$?
	[[ $VAL == 255 ]] && exit 0
	[[ $VAL == 1 ]] && source $DIRET/CPU/.testcpu.sh
	
	sysbench --test=cpu --num-threads=$THREADS --cpu-max-prime=20000 run 1> "$STAGE"
	
	totaltime=$(cat "$STAGE" | grep "^.*total time:" | cut -d" " -f32)
	numberofthreads=$(cat "$STAGE" | grep "^Number of threads:" | cut -d" " -f4)
	maximumnumber=$(cat "$STAGE" | grep "^Maximum prime number" | cut -d" " -f8)
	
	texto(){
		echo "Tempo total de execução: $totaltime"
		echo "Número de threads utilizados: $numberofthreads"
		echo "Número primo máximo checado no teste de CPU: $maximumnumber"
	}

	texto > "$STAGE"

	dialog --stdout $DIALOG --title "Teste" --textbox "$STAGE" 0 0
	VAL=$?
	[[ $VAL == 255 ]] && exit 0
	[[ $VAL == 1 ]] && menusysbench
}

sysbenchpersonalizado(){
	THREADSD=$(lscpu | grep "^CPU(s):" | cut -d" " -f17)
		THREADS=$(dialog					\
			--stdout				\
			$DIALOG\
			--title "Teste"	\
			--inputbox "Insira a quantidade de threads que deseja utilizar no teste, você tem $THREADSD threads disponíveis:"			\
			0 0
	VAL=$?
			[[ $VAL == 255 ]] && exit 0
			[[ $VAL == 1 ]] && menusysbench
			[[ $VAL == 0 ]] && break
		)

	NUMBERPRIME=$(dialog			\
		--stdout				\
		$DIALOG\
		--title "Teste"	\
		--inputbox "Insira o último número da sequência em que o procesador irá procurar os números primos:"\
		0 0
	VAL=$?
		[[ $VAL == 255 ]] && exit 0
        	[[ $VAL == 1 ]] && menusysbench
		[[ $VAL == 0 ]] && break || menu
	)
	
	sysbench --test=cpu --num-threads=$THREADS --cpu-max-prime=$NUMBERPRIME run > "$STAGE"

	totaltime=$(cat "$STAGE" | grep "^.*total time:" | cut -d" " -f32)
	numberofthreads=$(cat "$STAGE" | grep "^Number of threads:" | cut -d" " -f4)
	maximumnumber=$(cat "$STAGE" | grep "^Maximum prime number" | cut -d" " -f8)
	
	texto(){
		echo "Tempo total de execução: $totaltime"
		echo "Número de threads utilizados: $numberofthreads"
		echo "Número primo máximo checado no teste de CPU: $maximumnumber"
	}

	texto > "$STAGE"

	dialog --stdout $DIALOG --title "Teste" --textbox "$STAGE" 0 0
	VAL=$?
	[[ $VAL == 255 ]] && exit 0
        [[ $VAL == 1 ]] && menusysbench
	[[ $VAL == 0 ]] && break || menu
}

menusysbench(){
	ESCOLHA=$(dialog						\
		--stdout								\
		$DIALOG\
		--title "CPU"						\
		--menu "Escolha uma opção"\
		0 0 0										\
		"Teste Padrão" 'Testa a CPU com configurações padrões'\
		"Teste Personalizado" 'Testa a CPU com configurações personalizadas'\
		"Voltar" 'Volta ao menu anterior'
	VAL=$?
		
		[[ $VAL == 255 ]] && exit 0
	        [[ $VAL == 1 ]] && menu
		[[ $VAL == 0 ]] && break || menu

	)
	
	case $ESCOLHA in
		"Teste Padrão") sysbenchdefault ; menusysbench ;;
		"Teste Personalizado") sysbenchpersonalizado ; menusysbench ;;
		"Voltar") menu ;;
	esac
}
stressdefault(){
	dialog --stdout $DIALOG --title "Stress-ng" --msgbox "\nO stress será executado por 20 (vinte) segundos e depois irá ser encerrado\n" 0 0
	VAL=$?
	[[ $VAL == 255 ]] && exit 0
  [[ $VAL == 1 ]] && menustressng
	
	stress-ng --cpu $THREADS --timeout 20 --metrics-brief &> "$STAGE" &
	
	htop
	
	dialog --stdout $DIALOG --title "Stress-ng" --textbox "$STAGE" 0 0
	VAL=$?
	[[ $VAL == 255 ]] && exit 0
        [[ $VAL == 1 ]] && menustressng
}
stresspersonalizado(){
	stressthreads=$(dialog --stdout $DIALOG --title "Stress-ng" --inputbox "Insira o número de threads em que deseja executar o teste de stress:" 0 0
	VAL=$?
	[[ $VAL == 255 ]] && exit 0
        [[ $VAL == 1 ]] && menustressng
	)
	tempostress=$(dialog --stdout $DIALOG --title "Stress-ng" --inputbox "Por quanto tempo o stress vai ser executado?" 0 0
	VAL=$?
	[[ $VAL == 255 ]] && exit 0
        [[ $VAL == 1 ]] && menustressng
	)
	dialog --stdout $DIALOG --title "Stress-ng" --msgbox "O stress será executado por $tempostress e depois será encerrado" 0 0
	VAL=$?
	[[ $VAL == 255 ]] && exit 0
  [[ $VAL == 1 ]] && menustressng
	stress-ng --cpu $stressthreads --timeout $tempostress --metrics-brief &> "$STAGE" &
	htop
	dialog --stdout $DIALOG --title "Stress-ng" --textbox "$STAGE" 0 0
	VAL=$?
	[[ $VAL == 255 ]] && exit 0
  [[ $VAL == 1 ]] && menustressng
}
menustressng(){
	ESCOLHASTRESS=$(dialog			\
			--stdout							\
			$DIALOG\
			--title "Stress-ng"		\
			--menu "Escolha um teste"\
			0 0 0									\
			Teste\ padrão "Será realizado um teste padrão"\
			Teste\ personalizado "Será realizado um teste personalizado"\
			Voltar "Volta para o menu anterior"
	VAL=$?
			[[ $VAL == 255 ]] && exit 0
			[[ $VAL == 1 ]] && menu
	)
	case $ESCOLHASTRESS in
		"Teste padrão") stressdefault ; menustressng ;;
		"Teste personalizado") stresspersonalizado ; menustressng ;;
		"Voltar") menu ;;
	esac
}
menu
