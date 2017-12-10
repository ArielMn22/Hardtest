#!/bin/bash

read X

#STAGE="/usr/lib/cgi-bin/staging.txt"
THREADS=$(lscpu | grep "^CPU(s):" | cut -d":" -f2)

echo "Content-type: text/html"
echo

X=$(echo $X | cut -d"=" -f2)

especificacoes(){
	var=$(lscpu | sed '/Flags/d')
		echo "<h3>Especificações do seu processador:</h3>"
		echo "<pre>$var</pre>"
}

sysbench(){
 var=$(sysbench --test=cpu --num-threads=$THREADS --cpu-max-prime=20000 run)
  
  totaltime=$(echo $var | grep "^.*total time:" | cut -d" " -f32)
  numberofthreads=$(echo $var | grep "^Number of threads:" | cut -d" " -f4)
  maximumnumber=$(echo $var | grep "^Maximum prime number" | cut -d" " -f8)
	
	echo "<h3>Teste de processamento Sysbench:</h3><br>"
	echo "<pre>$(echo $var)</pre>"  
  echo "<p>Tempo total de execução: $totaltime</p>"
  echo "<p>Número de threads utilizados: $numberofthreads</p>"
  echo "<p>Número primo máximo checado no teste de CPU: $maximumnumber</p>"

}

case $X in
	sysbench) sysbench ;;
	especificacoes) especificacoes ;;
esac
