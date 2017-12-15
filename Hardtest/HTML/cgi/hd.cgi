#!/bin/bash

read X

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

X=$(echo $X | cut -d"=" -f2)

DIRET="/var/www/html/cgi-bin"

gravacao(){
	dd if=/dev/zero of=/tmp/output.img bs=8k count=10k &> $DIRET/staging.txt
	var=$(cat $DIRET/staging.txt | grep MB | cut -d" " -f10-11)
	echo '<h3 id="pagesuporte">Especificações de seu HD:</h3>'
	echo "<pre id="pagesuporte">A velocidade de gravação do seu HD é de $var</pre>"
}

particionamento(){
	
	lsblk > $DIRET/staging.txt
		echo '<h3 id="pagesuporte">Particionamento lsblk:</h3>'
		echo "<pre id="pagesuporte">$(cat $DIRET/staging.txt)</pre>"
		echo "<br><br>"
	
}

hdparm(){
	sudo hdparm -T /dev/sda > $DIRET/staging.txt
		var2=$(cat staging.txt | grep MB | cut -d"=" -f2)
		echo '<h3 id="pagesuporte">Especificações de seu HD com Hdparm:</h3>'
		echo "<pre id="pagesuporte">A velocidade de gravação do seu HD é de $var2</pre>"
}

case $X in
	particao) particionamento ;;
	speed) gravacao ;;
	hdparm) hdparm ;;
esac
