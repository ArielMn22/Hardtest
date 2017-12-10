#!/bin/bash

read X

echo "Content-type: text/html"
echo

X=$(echo $X | cut -d"=" -f2)

STAGE="/var/www/html/cgi-bin/staging.txt"

especificacoes(){

	number=$(cat /proc/meminfo | grep MemTotal | cut -d":" -f2 | cut -d"k" -f1)
	number=$(($number/1000000))

	free=$(cat /proc/meminfo | grep MemFree | cut -d":" -f2 | cut -d"k" -f1)
	free=$(( $free / 1000 ))

	swap=$(cat /proc/meminfo | grep SwapTotal | cut -d":" -f2 | cut -d"k" -f1)
	swap=$(($swap/1000000))

	swapfree=$(cat /proc/meminfo | grep SwapFree | cut -d":" -f2 | cut -d"k" -f1)
	swapfree=$(($swapfree/1000000))

	echo "<h3>Especificações da memmória RAM</h3>"
	echo "<p>Memória Total: $number GB</p>"
	echo "<p>Memória Livre: $free MB</p>"
	echo "<p>Memória Swap Total: $swap GB</p>"
	echo "<p>Memória Swap Livre: $swapfree GB</p>"

}

teste(){
	
	free=$(cat /proc/meminfo | grep MemFree | cut -d":" -f2 | cut -d"k" -f1)
	free=$(( $free / 1000 - 200))
	
	sudo memtester $free 2 > $STAGE
	val=$?
	echo "<h3>Teste de Memória</h3>"
	echo "<pre>$(cat $STAGE)</pre>"

	case $val in
		0) 
			echo "<p>Sua memória está OK!</p>" ;;
		x01) 
			echo "<p>Ocorreu um erro durante a alocação ou fechamento da memória, ou erro de invocação.</p>" ;;
		x02)
			echo "<p>Ocorreu um erro durante o teste de "stuck adress" (endereço emperrado).</p>" ;;
		x04)
			echo "<p>Ocorreu um erro desconhecido durante os testes.</p>" ;;
	esac
}

case $X in
	especificacoes) especificacoes ;;
	teste) teste ;;
esac
