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

	echo '<h3 id="pagesuporte">Especificações da memória RAM</h3>'
	echo "<p id="pagesuporte">Memória Total: $number GB</p>"
	echo "<p id="pagesuporte">Memória Livre: $free MB</p>"
	echo "<p id="pagesuporte">Memória Swap Total: $swap GB</p>"
	echo "<p id="pagesuporte">Memória Swap Livre: $swapfree GB</p>"

}

teste(){
	
	free=$(cat /proc/meminfo | grep MemFree | cut -d":" -f2 | cut -d"k" -f1)
	free=$(( $free / 1000 - 200))
	
	sudo memtester $free 2 > $STAGE
	val=$?
	echo "<h3 id="pagesuporte">Teste de Memória</h3>"

	case $val in
		0) 
			echo '<p id="pagesuporte">Sua memória está OK!</p>' ;;
		x01) 
			echo '<p id="pagesuporte">Ocorreu um erro durante a alocação da memória.</p>' ;;
		x02)
			echo '<p id="pagesuporte">Ocorreu um erro durante o teste de "stuck adress" (endereço emperrado).</p>' ;;
		x04)
			echo '<p id="pagesuporte">Ocorreu um erro desconhecido durante os testes.</p>' ;;
	esac
}

case $X in
	especificacoes) especificacoes ;;
	teste) teste ;;
esac
