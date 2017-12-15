#!/bin/bash

read X

STAGE="/usr/lib/cgi-bin/staging.txt"
STAGE2="/usr/lib/cgi-bin/staging2.txt"

THREADS=$(lscpu | grep "^CPU(s):" | cut -d":" -f2)

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

especificacoes(){
	var=$(lscpu | sed '/Flags/d')
		echo '<h3 id="pagesuporte">Especificações do seu processador:</h3>'
		echo "<pre id="pagesuporte">$var</pre>"
}

case $X in
	especificacoes) especificacoes ;;
esac
