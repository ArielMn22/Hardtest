#!/bin/bash
DIRET="/usr/share/Hardtest/program"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
USERDIRET="/usr/lib/cgi-bin"
chamada(){
SENHA=$(grep ^$USERU: "/var/www/html/cgi-bin/usuario.txt" | cut -d":" -f2)
SENHAB=$(grep -R ^$USERU: $DIRET/.DATA/.usuario*.txt | cut -d":" -f2)
}

erroremove(){ echo; read -s -p "Ocorreu um erro, tente novamente." ; }

removeu(){
  
  cat $USERDIRET/usuario.txt | sed "/^$DELETEUSER:/d" > $USERDIRET/novo.txt
  
  rm -rf $USERDIRET/usuario.txt
  mv $USERDIRET/novo.txt $USERDIRET/usuario.txt
  
  chown www-data:www-data $USERDIRET/usuario.txt
  chmod 773 $USERDIRET/usuario.txt

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
  echo
	cat $USERDIRET/usuario.txt
	echo
  
  dados(){
    read -p "Qual dos usuário acima deseja remover? " DELETEUSER
    read -s -p "Qual a senha do usuário $DELETEUSER? " DELETESENHA
    [[ -z $DELETEUSER ]] && dados
    [[ -z $DELETESENHA ]] && dados
  }
  dados
  
  DELETESENHA=$(echo $DELETESENHA | sha256sum | cut -d" " -f1)
  SENHACERTA=$(grep ^$DELETEUSER: $USERDIRET/usuario.txt | cut -d":" -f2)
  
  [[ "grep ^$DELETEUSER: $USERDIRET/usuario.txt" ]] && [[ $SENHACERTA == $DELETESENHA ]] && removeu || erroremove && removeuser 
}

instalacao(){
	read -s -p "Algo deu errado com os pacotes do programa, leia o README.txt para reinstalar o programa e seus pacotes." && exit 0
}
checkdesenha(){
		grep "Pacotes" "$DIRET/.DATA/.status.txt"
		[[ $? != 0 ]] && instalacao
}

dica(){
	IP=$(ip address show | grep inet | grep -m 1 global | cut -d "/" -f1 | cut -d " " -f6)
	dialog --stdout $DIALOG --title "Cadastro" --msgbox "Para se cadastrar acesse: $IP" 0 0
	VAL=$?
	[[ $VAL == 255 ]] && exit 0 
}

erro(){ dialog --stdout $DIALOG --title "Erro" --msgbox "Usuário Incorreto\n" 0 0
	VAL=$?
	[[ $VAL == 255 ]] && exit 0 
}

coloctipo(){
		TIPOA=$(cat "/var/www/html/cgi-bin/usuario.txt" | grep "^$USERU:" | cut -d":" -f3)
		TIPOB=$(grep -R ^$USERU: $DIRET/.DATA/.usuario*.txt | cut -d":" -f3)
	case $1 in
		admin) touch /tmp/tipo && echo "tipo:$TIPOA" > "/tmp/tipo" && echo "user:$USERU" >> "/tmp/tipo" && source "$DIRET/.menu.sh" ;;
		dependente) touch /tmp/tipo && echo "tipo:$TIPOB" > "/tmp/tipo" && echo "user:$USERU" >> "/tmp/tipo" && source "$DIRET/.menu.sh" ;;
	esac
}
		
NUMERO=0

logando(){
		while : ; do
			while [[ $NUMERO -gt 2 ]] ; do
				
				dica
				NUMERO=0
			
			done

				USERU=$(dialog --stdout $DIALOG --title "Login" --inputbox "Digite seu usuário" 0 0
				VAL=$?
				[[ $VAL == 1 ]] && exit 0
				[[ $VAL == 255 ]] && exit 0
				)
				
				PASSWORD=$(dialog --stdout $DIALOG --title "Login" --passwordbox "Digite sua senha" 0 0
				VAL=$?
				[[ $VAL == 1 ]] && exit 0
				[[ $VAL == 255 ]] && exit 0 
				)
				
				PASSWORD=$(echo $PASSWORD | sha256sum | cut -d" " -f1)
				
				[[ -z $USERU ]] && logando
				[[ -z $PASSWORD ]] && logando
				
				chamada
				
				NUMERO=$(($NUMERO+1))
				
				[[ "grep ^$USERU: /var/www/html/cgi-bin/usuario.txt" ]] && [[ $SENHA == $PASSWORD ]] && X="admin" && break 3

				[[ "grep ^$USERU: $DIRET/.DATA/.usuario.txt" ]] && [[ $SENHAB == $PASSWORD ]] && X="dependente" && break 3 || erro && logando

		done

case $X in
	"admin")
		TIPOA=$(cat "/var/www/html/cgi-bin/usuario.txt" | grep "^$USERU:" | cut -d":" -f3)
		touch /tmp/tipo
		echo "tipo:$TIPOA" > "/tmp/tipo"
		echo "user:$USERU" >> "/tmp/tipo"
		source "$DIRET/.menu.sh" ;;

	"dependente")
		TIPOB=$(grep -R ^$USERU: $DIRET/.DATA/.usuario*.txt | cut -d":" -f3)
		touch /tmp/tipo
		echo "tipo:$TIPOB" > "/tmp/tipo"
		echo "user:$USERU" >> "/tmp/tipo"
		source "$DIRET/.menu.sh" ;;
esac

}

while : ; do

	[[ $USER == root ]] && break || clear ; read -s -p "Você deve estar logado como root para executar o software." ; echo && exit 0

done

[[ $1 == "-d" ]] && removeuser

checkdesenha
logando
