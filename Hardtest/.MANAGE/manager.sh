#!/bin/bash
DIRET="/usr/share/Hardtest"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""

TIPO=$(cat /tmp/tipo)

criar(){
	SUCESSO(){
		dialog --stdout $DIALOG --msgbox "\nUsuário criado com sucesso!\n" 0 0
	}
	USER=$(dialog --stdout $DIALOG --title "Criação" --inputbox "Adicione um usuário:" 0 0)
	[[ $? == 0 ]] && break || menu
	senhas(){
		PASSA=$(dialog --stdout $DIALOG --title "Criação" --passwordbox "Adicione uma senha para o usuário:" 0 0)
	[[ $? == 0 ]] && break || menu
		PASSB=$(dialog --stdout $DIALOG --title "Criação" --passwordbox "Confirme a senha do usuário:" 0 0)
	[[ $? == 0 ]] && break || menu
	}
	senhas
	[[ $PASSA != $PASSB ]] && senhas
	[[-z $USER ]] && criar
	[[-z $PASSA ]] && criar
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
	[[ $? == 0 ]] && break || menu
	case $TYPE in
		"Admin") echo "$USER:$PASSA:ADMIN" >> "$DIRET/.DATA/.usuario.txt" ; SUCESSO ;;
		"Técnico") echo "$USER:$PASSA:TEC" >> "$DIRET/.DATA/.usuario.txt" ; SUCESSO ;;
		"Comum") echo "$USER:$PASSA:COMUM" >> "$DIRET/.DATA/.usuario.txt" ; SUCESSO ;;
	esac
	menu
}

remover(){
	REMOCAO(){
		dialog --stdout $DIALOG --msgbox "\nUsuário removido com sucesso!\n" 0 0
	}
	USER=$(dialog --stdout $DIALOG --title "Remoção" --inputbox "Coloque o nome do usuário que deseja remover:" 0 0)
	[[ $? == 0 ]] && break || menu
	dialog --stdout $DIALOG --title "Confirmação" --yesno "Tem certeza que deseja remover o usuário $USER?" 0 0
	[[ $? == 0 ]] && break || menu
	cat "$DIRET/.DATA/.usuario.txt" | sed "/^$USER:/d" > "$DIRET/.DATA/.novo.txt"
	rm -rf "$DIRET/.DATA/.usuario.txt"
	mv "$DIRET/.DATA/.novo.txt" "$DIRET/.DATA/.usuario.txt"
	REMOCAO
	menu
}

listar(){
	cat "$DIRET/.DATA/.usuario.txt" > "$DIRET/.MANAGE/.staging.txt"
	dialog --stdout $DIALOG --title "Usuários" --textbox "$DIRET/.MANAGE/.staging.txt" 0 0
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
	[[ $? == 0 ]] && break || . "$DIRET/.menu.sh" $TIPO

	case $ACAO in
		"Criar usuário") criar ;;
		"Remover usuário") remover ;;
		"Listar usuários") listar ;;
		"Voltar") . "$DIRET/.menu.sh" $TIPO ;;
	esac
}
menu
