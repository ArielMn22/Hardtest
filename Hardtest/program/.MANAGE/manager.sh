#!/bin/bash
USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
DIRET="/usr/share/Hardtest/program"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""

TIPO=$(cat /tmp/tipo)
echo "[$(date)] Menu Gerenciamento iniciado" >> "$DIRET/.MANAGER/log$USERU.txt"

cadastroecho(){
echo "[$(date)] Usuário '$USERU' adicionado" >> "$DIRET/.MANAGER/log$USERU.txt"
}
remocaoecho(){
echo "[$(date)] Usuário '$USERU' removido" >> "$DIRET/.MANAGER/log$USERU.txt"
}

checkuser(){
	cat $DIRET/.DATA/.usuario$USERU.txt | grep ^$USERUB:
	VAL=$?
	if [[ $VAL == 0 ]]
		then
		dialog --stdout $DIALOG --title "ERRO" --msgbox "Nome de usuário indisponível." 0 0
		val=$?
		[[ $val == 255 ]] && exit 0
		criar
	fi
}

criar(){
	SUCESSO(){
		dialog --stdout $DIALOG --msgbox "\nUsuário criado com sucesso!\n" 0 0
		VAL=$?
		[[ $VAL == 255 ]] && exit 0
	}
	USERUB=$(dialog --stdout $DIALOG --title "Criação" --inputbox "Adicione um usuário:" 0 0)
		VAL=$?
		[[ $VAL == 255 ]] && exit 0
	[[ $VAL == 0 ]] && break || menu
	senhas(){
		PASSA=$(dialog --stdout $DIALOG --title "Criação" --passwordbox "Adicione uma senha para o usuário:" 0 0)
		VAL=$?
		[[ $VAL == 255 ]] && exit 0
	[[ $VAL == 0 ]] && break || menu
		PASSB=$(dialog --stdout $DIALOG --title "Criação" --passwordbox "Confirme a senha do usuário:" 0 0)
		VAL=$?
		[[ $VAL == 255 ]] && exit 0
	[[ $VAL == 0 ]] && break || menu
	}
	senhas
	[[ $PASSA != $PASSB ]] && senhas
	[[-z $USERUB ]] && criar
	[[-z $PASSA ]] && criar

	checkuser
	
	PASSA=$(echo $PASSA | sha256sum | cut -d" " -f1)
	TYPE=$(dialog \
				--stdout \
				$DIALOG\
				--title "Criação" \
				--menu "Escolha um tipo de permissão para o usuário:"\
				0 0 0 \
				Admin "Tem permissão para tudo." \
				Técnico "Tem permissão para executar os testes." \
				Comum "Somente tem permissão para ver as especificações do PC.")
		VAL=$?
		[[ $VAL == 255 ]] && exit 0
	[[ $VAL == 0 ]] && break || menu
	case $TYPE in
		"Admin") echo "$USERUB:$PASSA:ADMIN" >> "$DIRET/.DATA/.usuario$USERU.txt" ; SUCESSO ;;
		"Técnico") echo "$USERUB:$PASSA:TEC" >> "$DIRET/.DATA/.usuario$USERU.txt" ; SUCESSO ;;
		"Comum") echo "$USERUB:$PASSA:COMUM" >> "$DIRET/.DATA/.usuario$USERU.txt" ; SUCESSO ;;
	esac
	menu
}

remover(){
	REMOCAO(){
		dialog --stdout $DIALOG --msgbox "\nUsuário removido com sucesso!\n" 0 0
		VAL=$?
		[[ $VAL == 255 ]] && exit 0
	}
	USERUB=$(dialog --stdout $DIALOG --title "Remoção" --inputbox "Coloque o nome do usuário que deseja remover:" 0 0)
		VAL=$?
		[[ $VAL == 255 ]] && exit 0
	[[ $VAL == 0 ]] && break || menu
	dialog --stdout $DIALOG --title "Confirmação" --yesno "Tem certeza que deseja remover o usuário $USERUB?" 0 0
		VAL=$?
		[[ $VAL == 255 ]] && exit 0
	[[ $VAL == 0 ]] && break || menu
	cat "$DIRET/.DATA/.usuario$USERU.txt" | sed "/^$USERUB:/d" > "$DIRET/.DATA/.novo.txt"
	rm -rf "$DIRET/.DATA/.usuario$USERU.txt"
	mv "$DIRET/.DATA/.novo.txt" "$DIRET/.DATA/.usuario$USERU.txt"
	REMOCAO
	menu
}

listar(){
	cat "$DIRET/.DATA/.usuario$USERU.txt" > "$DIRET/.MANAGE/.staging.txt"
	dialog --stdout $DIALOG --title "Usuários" --textbox "$DIRET/.MANAGE/.staging.txt" 0 0
		VAL=$?
		[[ $VAL == 255 ]] && exit 0
	menu
}

menu(){
	ACAO=$(dialog							\
		--stdout						\
		$DIALOG\
		--title "Gerenciamento"\
		--menu "Escolha uma ação:"\
		0 0 0\
		Criar\ usuário "Cria um usuário para o programa"\
		Remover\ usuário "Remove um usuário do programa"\
		Listar\ usuários "Lista os usuários existentes"\
		Voltar "Volta ao menu anterior"
	)
		VAL=$?
		[[ $VAL == 255 ]] && exit 0
		[[ $VAL == 0 ]] && break || . "$DIRET/.menu.sh" $TIPO

	case $ACAO in
		"Criar usuário") criar ;;
		"Remover usuário") remover ;;
		"Listar usuários") listar ;;
		"Voltar") echo "[$(date)] Menu Gerenciamento encerrado" >> "$DIRET/.MANAGER/log$USERU.txt" ; . "$DIRET/.menu.sh" $TIPO ;;
	esac
}
menu
