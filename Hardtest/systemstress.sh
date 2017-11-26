#!/bin/bash
DIRET="/usr/share/Hardtest"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
chamada(){
SENHA=$(grep ^$USERU: "$DIRET/.DATA/.usuario.txt" | cut -d":" -f2)
}
cadastrando(){
		
	touch "$DIRET/.DATA/.usuario.txt"
		
		USUARIOCRIAR=$(dialog					 											 \
		 		 --stdout\
					$DIALOG\
			 	 --title "Adicionar Usuário"												 \
			  	--inputbox "Digite o nome de usuário que deseja adicionar para o programa:"	 \
			  	0 0)
		[[ $? == 0 ]] && break || exit 0
		
		senhas(){
		SENHAA=$(dialog																	 \
				--stdout\
				$DIALOG\
				--title "Adicionar Senha"														 \
				--passwordbox "Adicione uma senha para o usuário $USUARIOCRIAR:"			 \
				0 0)
		SENHAB=$(dialog																	 \
				--stdout																	 \
				$DIALOG\
				--title "Confirmar Senha"														 \
				--passwordbox "Confirme sua senha para o usuário $USUARIOCRIAR:"			 \
				0 0)
		[[ $SENHAA == $SENHAB ]] && break || senhas
		[[ -z $USUARIOCRIAR ]] && cadastrando
		[[ -z $SENHAA ]] && cadastrando

		SENHAA=$(echo $SENHAA | sha256sum | cut -d" " -f1)
		echo "$USUARIOCRIAR:$SENHAA:ADMIN" >> "$DIRET/.DATA/.usuario.txt"
		dialog --stdout $DIALOG --msgbox "\nUsuário criado com sucesso!\n" 0 0
		echo "Programa Instalado" >> "$DIRET/.DATA/.status.txt"
		}
		
		senhas
}

instalacao(){
	grep "Pacotes" "$DIRET/.DATA/.status.txt"
	[[ $? != 0 ]] && echo "Algo deu errado com os pacotes do programa, leia o README.txt para reinstalar o programa e seus pacotes." && exit 0
}
checkdesenha(){
		grep "Pacotes" "$DIRET/.DATA/.status.txt"
		[[ $? != 0 ]] && instalacao
		grep "Programa" "$DIRET/.DATA/.status.txt"
		[[ $? != 0 ]] && cadastrando
}

logando(){
		USERU=$(dialog --stdout $DIALOG --title "Login" --inputbox "Digite seu usuário" 0 0)
		[[ $? == 0 ]] && break || exit 0
		PASSWORD=$(dialog --stdout $DIALOG --title "Login" --passwordbox "Digite sua senha" 0 0)
		PASSWORD=$(echo $PASSWORD | sha256sum | cut -d" " -f1)
		[[ -z $USERU ]] && logando
		[[ -z $PASSWORD ]] && logando
		TIPO=$(cat "$DIRET/.DATA/.usuario.txt" | grep "^$USERU:" | cut -d":" -f3)
		touch /tmp/tipo
		echo "$TIPO" > /tmp/tipo
		chamada
		[[ "grep ^$USERU: $DIRET/.DATA/.usuario.txt" ]] && [[ $SENHA == $PASSWORD ]] && . "$DIRET/.menu.sh" $TIPO || logando
}
while : ; do

[[ $USER == root ]] && break || clear ; read -s -p "Você deve estar logado como root para executar o software." ; echo && exit 0

done

[[ $1 == "-r" ]] && echo "" > "$DIRET/.DATA/.usuario.txt" && echo "" > "$DIRET/.DATA/.status.txt"

checkdesenha
logando
