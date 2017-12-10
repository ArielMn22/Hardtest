#!/bin/bash

PROGRAMAS="dialog stress-ng speedtest-cli dmidecode sysbench sendemail hdparm apache2 htop lm-sensors"
DIRET="/usr/share/Hardtest/program/"
LOG="/var/log/Hardtest/sendemail"

lugarcerto(){
	cp -R ./Hardtest /usr/share
	ln -s /usr/share/Hardtest/systemstress.sh /usr/bin/hardtest &>/dev/null
	chmod 444 /usr/share/Hardtest
}

instalacao(){
	
	mkdir -p $LOG
	touch /var/log/Hardtest/hardtest.log
	touch $LOG/sendemail.log
	touch $LOG/email.log
	chmod 447 /var/log/Hardtest/hardtest.log
	chmod 447 $LOG/sendemail.log
	chmod 447 $LOG/email.log
	mkdir -p "$DIRET/.DATA"
  
	touch "$DIRET/.DATA/.status.txt"
  ping -w 2 -c 1 'uol.com.br' >/dev/null
  [[ $? != 0 ]] && echo "Ocorreu um erro, provavelmente você está sem conexão com a internet." && echo "Saindo..." && exit 0
  echo "Preparando o ambiente para o programa, aguarde..."
  apt-get update &>/dev/null
  
	for X in $PROGRAMAS ; do
	  echo "Instalando $X..."
    apt-get install $X -y &>/dev/null
	done

	reset(){ systemctl restart apache2 &>/dev/null ; }

  a2enmod cgid &>/dev/null && reset

	echo " AddDefaultCharset UTF-8" >> /etc/apache2/conf-enabled/charset.conf && reset
	
	echo "www-data  ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers


	echo "Pacotes Instalados" >> "$DIRET/.DATA/.status.txt"
  echo "O programa foi instalado com sucesso"
	echo -e "Tente executar:\n	# hardtest"

      }

html(){
	date=$(date)
	mkdir "/var/www/html/backup_$date"
	mv /var/www/html/* "/var/www/html/backup_$date" &>/dev/null
	cp -R ./Hardtest/HTML/index/* /var/www/html/
	ln -s /usr/lib/cgi-bin /var/www/html/cgi-bin
	cp -R ./Hardtest/HTML/cgi/* /var/www/html/cgi-bin
	chown -R www-data:www-data /var/www/html
	chown -R www-data:www-data /usr/lib/cgi-bin
	chmod -R 773 /var/www/html
	chmod -R 773 /usr/lib/cgi-bin
	touch /var/www/html/cgi-bin/usuario.txt
	chmod 773 /var/www/html/cgi-bin/usuario.txt
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
				read -s -p "Opcão Inválida" 
				permissao 
				;;
   esac
}
permissao
lugarcerto
html
