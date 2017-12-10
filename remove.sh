#!/bin/bash
programas="dialog stress-ng speedtest-cli dmidecode sysbench sendemail hdparm apache2 htop lm-sensors"
html="/var/www/html"
html2="cgi-bin css download.html index.html suporte.html cadastro.html criacao.html download imagens sobre.html"
rm -rf /usr/share/Hardtest
rm -rf /usr/bin/hardtest

for y in $html2 ; do
	rm -rf /var/www/html/$y
done

for x in $programas ; do
	apt-get remove $x --purge -y
	apt-get purge $x -y
done

apt-get autoremove -y
