#!/bin/bash

stage="/var/www/html/cgi-bin/staging.txt"

read X

X=$(echo $X | cut -d"=" -f2)

echo "Content-type: text/html"
echo

echo '<html lang="pt-br">
  <head>
    <link rel="stylesheet" type="text/css" href="../css/estilos.css">
    <meta charset="utf-8">
    <title>Download</title>
    
  </head>
  <body>
    <div id="menu">
      <nav>
        <ul>
    <li><a href="../index.html">Início</a></li>
    <li><a href="../download.html">Download</a></li>
    <li><a href="../sobre.html">Sobre nós </a></li>
    <li><a href="../suporte.html">Contato</a></li>
    <li><a href="../cadastro.html">Cadastro</a></li>
    <li><a href="../testeonline.html">Teste Online</a></li>
      </ul>
        </nav>
      </div>
      <header class="bgimg w3-display-container w3-grayscale-min" id="home">
</header> 
'
conexao(){
	
	echo '<h3 id="pagesuporte">Teste de conexão</h3>'
	echo "<pre id="pagesuporte">$(ping -c 5 uol.com.br)</pre>"
	val=$?
	if [[ $? == 0 ]];then
		echo '<h4 id="pagesuporte">Você está conectado a internet.</h4>'
	else
		echo '<h4 id="pagesuporte">Você não está conectado a internet.</h4>'
	fi

}

speed(){

	SPEED1=$(speedtest --share > $stage)
	
	SPEEDUP=$(cat $stage | grep "Upload" | cut -d" " -f2-3)
	SPEEDDOWN=$(cat $stage | grep "Download" | cut -d" " -f2-3)

	echo '<h3 id="pagesuporte">Especificações da rede</h3>'
	echo "<p id="pagesuporte">Velocidade de Download: $SPEEDDOWN</p>"
	echo "<p id="pagesuporte">Velocidade de Upload: $SPEEDUP</p>"
}

case $X in
	conexao) conexao ;;
	speed) speed ;;
esac
