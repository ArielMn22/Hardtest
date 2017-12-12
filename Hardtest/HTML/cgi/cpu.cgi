#!/bin/bash

read X

STAGE="/usr/lib/cgi-bin/staging.txt"
STAGE2="/usr/lib/cgi-bin/staging2.txt"

THREADS=$(lscpu | grep "^CPU(s):" | cut -d":" -f2)

echo "Content-type: text/html"
echo

X=$(echo $X | cut -d"=" -f2)

especificacoes(){
	var=$(lscpu | sed '/Flags/d')
		echo "<h3>Especificações do seu processador:</h3>"
		echo "<pre>$var</pre>"
}

#sysbench(){
	
#	var=$(sysbench --test=cpu --num-threads=$THREADS --cpu-max-prime=20000 run)
  
#  totaltime=$(echo $var | grep "^.*total time:" | cut -d" " -f32)
#  numberofthreads=$(echo $var | grep "^Number of threads:" | cut -d" " -f4)
#  maximumnumber=$(echo $var | grep "^Maximum prime number" | cut -d" " -f8)
	
#	echo "Tempo total de execução: $totaltime" > $STAGE2
#	echo "Número de threads utilizados: $numberofthreads" >> $STAGE2
#	echo "Sysbench procurou números primos entre: 0 e $maximumnumber" >> $STAGE2

#	echo "<h1>Teste de CPU Sysbench<h1>"
#	echo "<pre>$(echo $var2)</pre>"
#}

case $X in
#	sysbench) sysbench ;;
	especificacoes) especificacoes ;;
esac
