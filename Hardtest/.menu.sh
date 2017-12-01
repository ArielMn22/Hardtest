#!/bin/bash
DIRET="/usr/share/Hardtest"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
ADMIN(){
touch "/tmp/.tipo"
echo "ADMIN" > "/tmp/.tipo"

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
			"Sair" 'Sai do programa')

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
			"Sair" 'Sai do programa')

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
			"Sair" 'Sai do programa')

case $ESCOLHA in
	"Memória") . "$DIRET/RAM/menuprojeto.sh" ;;
	"Hard Disk") . "$DIRET/HD/teste2hd.sh" ;;
	"Rede") . "$DIRET/REDE/rede.sh" ;;
	"CPU") . "$DIRET/CPU/.cpu.sh" ;;
	"Sair") clear ; echo "Até logo!" ; echo ; exit 0 ;;
esac
}

case $1 in
	"ADMIN") ADMIN ;;
	"TEC") TEC ;;
	"COMUM") COMUM ;;
esac
