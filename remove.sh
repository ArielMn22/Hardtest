#!/bin/bash
while : ; do

	[[ $USER == root ]] && break || echo "Você deve estar logado como root para remover a ferramenta Hardtest." ; echo && exit 0

done
DIRET="/usr/lib/cgi-bin"
programas="dialog stress-ng speedtest-cli dmidecode sysbench sendemail hdparm apache2 htop lm-sensors memtester"
html="/var/www/html"
html2="cgi-bin css download.html index.html suporte.html cadastro.html criacao.html download imagens sobre.html"

erro(){ echo; echo Ocorreu um erro, tente novamente. ; }

removeu(){
	
	cat $DIRET/usuario.txt | sed "/^$DELETEUSER:/d" > $DIRET/novo.txt
	
	rm -rf $DIRET/usuario.txt
	mv $DIRET/novo.txt $DIRET/usuario.txt
	
	chown www-data:www-data $DIRET/usuario.txt
	chmod 773 $DIRET/usuario.txt

	if [[ $? == 0 ]]; then
		echo ;echo "Usuário $DELETEUSER removido com sucesso!"
		exit 0
	else
		erro
		removeuser
	fi

}
removeuser(){
	clear
	echo "Estes são os usuários ADMINISTRADORES cadastrados no programa:"
	echo; cat $DIRET/usuario.txt; echo
	
	dados(){
		read -p "Qual dos usuário acima deseja remover? " DELETEUSER
		read -s -p "Qual a senha do usuário $DELETEUSER? " DELETESENHA
		[[ -z $DELETEUSER ]] && dados
		[[ -z $DELETESENHA ]] && dados
	}
	dados
	
	DELETESENHA=$(echo $DELETESENHA | sha256sum | cut -d" " -f1)
	SENHACERTA=$(grep ^$DELETEUSER: $DIRET/usuario.txt | cut -d":" -f2)
	
	[[ "grep ^$DELETEUSER: $DIRET/usuario.txt" ]] && [[ $SENHACERTA == $DELETESENHA ]] && removeu || erro && removeuser 
}
[[ $1 == -d ]] && removeuser
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
