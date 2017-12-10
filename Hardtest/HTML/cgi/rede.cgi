#!/bin/bash

stage="/var/www/html/cgi-bin/staging.txt"

read X

X=$(echo $X | cut -d"=" -f2)

echo "Content-type: text/html"
echo

conexao(){
	
	echo "<h3>Teste de conexão</h3>"
	echo "<pre>$(ping -c 5 uol.com.br)</pre>"
	val=$?
	if [[ $? == 0 ]];then
		echo "<h4>Você está conectado a internet.</h4>"
	else
		echo "<h4>Você não está conectado a internet.</h4>"
	fi

}

speed(){

	SPEED1=$(speedtest --share > $stage)
	
	SPEEDUP=$(cat $stage | grep "Upload" | cut -d" " -f2-3)
	SPEEDDOWN=$(cat $stage | grep "Download" | cut -d" " -f2-3)

	echo "<h3>Especificações da rede</h3>"
	echo "<p>Velocidade de Download: $SPEEDDOWN</p>"
	echo "<p>Velocidade de Upload: $SPEEDUP</p>"
}

case $X in
	conexao) conexao ;;
	speed) speed ;;
esac
