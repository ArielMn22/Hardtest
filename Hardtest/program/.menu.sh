#!/bin/bash

TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)
DIRET="/usr/share/Hardtest/program"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
ADMIN(){

ESCOLHA=$(dialog						\
			--stdout					\
			$DIALOG\
			--title "Menu"				\
			--menu "Escolha uma opção"	\
			0 0 0						\
			"Memória" 'Realiza o teste de memória do PC'\
			"Hard Disk" 'Realiza o teste de HD do PC'\
			"Rede" 'Realiza testes de rede no PC'\
			"CPU" 'Realiza testes da CPU no PC'\
			"Gerenciamento" 'Gerenciamento de usuários do programa'\
			"Sair" 'Sai do programa'
	VAL=$?
	[[ $VAL == 1 ]] && exit 2 
	[[ $VAL == 255 ]] && exit 0

)

case $ESCOLHA in
	"Memória") . "$DIRET/RAM/menuprojeto.sh" ;;
	"Hard Disk") . "$DIRET/HD/teste2hd.sh" ;;
	"Rede") . "$DIRET/REDE/rede.sh" ;;
	"CPU") . "$DIRET/CPU/.cpu.sh" ;;
	"Gerenciamento") . "$DIRET/.MANAGE/manager.sh" ;;
	"Sair") clear ; echo "Até logo!" ; echo ; exit 0 ;;
esac
}

TEC(){
ESCOLHA=$(dialog						\
			--stdout					\
			$DIALOG\
			--title "Menu"				\
			--menu "Escolha uma opção"	\
			0 0 0						\
			"Memória" 'Realiza o teste de memória do PC'\
			"Hard Disk" 'Realiza o teste de HD do PC'\
			"Rede" 'Realiza testes de rede no PC'\
			"CPU" 'Realiza testes da CPU no PC'\
			"Sair" 'Sai do programa'
	VAL=$?
	[[ $VAL == 1 ]] && exit 0
	[[ $VAL == 255 ]] && exit 0
)

case $ESCOLHA in
	"Memória") . "$DIRET/RAM/menuprojeto.sh" ;;
	"Hard Disk") . "$DIRET/HD/teste2hd.sh" ;;
	"Rede") . "$DIRET/REDE/rede.sh" ;;
	"CPU") . "$DIRET/CPU/.cpu.sh" ;;
	"Sair") clear ; echo "Até logo!" ; echo ; exit 0 ;;
esac
}

COMUM(){
ESCOLHA=$(dialog						\
			--stdout\
			$DIALOG					\
			--title "Menu"				\
			--menu "Escolha uma opção"	\
			0 0 0						\
			"Memória" 'Realiza o teste de memória do PC'\
			"Hard Disk" 'Realiza o teste de HD do PC'\
			"Rede" 'Realiza testes de rede no PC'\
			"CPU" 'Realiza testes da CPU no PC'\
			"Sair" 'Sai do programa'
	VAL=$?
	[[ $VAL == 1 ]] && exit 0
	[[ $VAL == 255 ]] && exit 0
)

case $ESCOLHA in
	"Memória") . "$DIRET/RAM/menuprojeto.sh" ;;
	"Hard Disk") . "$DIRET/HD/teste2hd.sh" ;;
	"Rede") . "$DIRET/REDE/rede.sh" ;;
	"CPU") . "$DIRET/CPU/.cpu.sh" ;;
	"Sair") clear ; echo "Até logo!" ; echo ; exit 0 ;;
esac
}



case $TIPO in
	"ADMIN") source $DIRET/.checando.sh ; ADMIN ;;
	"TEC") source $DIRET/.checando.sh ; TEC ;;
	"COMUM") source $DIRET/.checando.sh ; COMUM ;;
esac
