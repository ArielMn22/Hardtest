#!/bin/bash

PROGRAMAS="dialog stress-ng speedtest-cli dmidecode sysbench hdparm"

lugarcerto(){
	cp -R ./Hardtest /usr/share
	ln -s /usr/share/Hardtest/systemstress.sh /usr/bin/hardtest &>/dev/null
}
instalacao(){
	mkdir -p /usr/share/Hardtest/.DATA
  touch "/usr/share/Hardtest/.DATA/.status.txt"
  ping -w 2 -c 1 'uol.com.br' >/dev/null
  [[ $? != 0 ]] && echo "Ocorreu um erro, provavelmente você está sem conexão com a internet." && echo "Saindo..." && exit 0
  echo "Preparando o ambiente para o programa, aguarde..."
  apt-get update 1>/dev/null
  
	for X in $PROGRAMAS ; do
	  echo "Instalando $X"
    apt-get install $X -y &>/dev/null
	done
  
	echo "Pacotes Instalados" >> "/usr/share/Hardtest/.DATA/.status.txt"
  echo "O programa foi instalado com sucesso" 
      }

permissao(){ 
	clear
  echo "Para a utilização do programa, será necessária a instalação dos seguintes pacotes:"
	
	for x in $PROGRAMAS ; do
		echo "- $x"
	done
	
	echo ; read -p "Podemos instalar os pacotes citados acima? " AUTORIZACAO
	AUTORIZACAO=$(echo $AUTORIZACAO | tr A-Z a-z)

	case $AUTORIZACAO in
  	"y"|"sim"|"yes"|"ss"|"s") 
				instalacao 
				;;
		"n"|"nao"|"não"|"no") 
				echo "Programa não foi instalado" && exit 0 
				;;
		*) 
				echo "Opcão Inválida" 
				permissao 
				;;
   esac
}
permissao
lugarcerto
