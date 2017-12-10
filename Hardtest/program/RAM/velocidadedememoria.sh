#!/bin/bash
USERU="$(cat "/tmp/tipo" | grep ^user: | cut -d":" -f2)"
TIPO=$(cat /tmp/tipo | grep "tipo" | cut -d":" -f2)
LOG="/var/log/Hardtest"
DIALOG="--backtitle "Hardtest" --ok-label "Selecionar" --exit-label "Sair" --cancel-label "Cancelar""
DIRET="/usr/share/Hardtest/program"

echo "[$(date)] Menu RAM teste de velocidade iniciado" >> "$LOG/hardtest$USERU.log"

pulalinha(){ echo ; } #função para pular linha

#erro(){ dialog --stdout $DIALOG --title 'sair' --msgbox 'falouuuu!!' 0 0 ; exit 0 ; }

conjunto(){

dialog                                  \
--stdout                                \
$DIALOG																	\
--title 'Status'                        \
--infobox '\nExecutando testes...' \
0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0


	$(dd if=/dev/zero of=.arquivo512E_tmp bs=1M count=512 &> '.staging512E.txt') 
escritaum=$(cat '.staging512E.txt' | grep bytes | cut -d" " -f10,11 )   
um=$(echo "Foi criado um arquivo de 512 MB na memória RAM. A velocidade de escrita foi de $escritaum" >> '.textoRAM.txt' )
	$(dd if=.arquivo512E_tmp of=/dev/null bs=1M count=512 &> '.staging512L.txt' )
	$(rm '.arquivo512E_tmp')
leituraum=$(cat '.staging512L.txt' | grep bytes | cut -d" " -f10,11 )
dois=$(echo "arquivo criado foi lido em memória RAM, velocidade de leitura de foi de $leituraum" >> '.textoRAM.txt' )
	$(echo " " >> .textoRAM.txt) #pula linha no arquivo de textosdsd
	$(rm '.staging512E.txt')
	$(rm '.staging512L.txt')


	$(dd if=/dev/zero of=.arquivo1024E_tmp bs=1M count=1024 &> '.staging1024E.txt' )
escritadois=$(cat '.staging1024E.txt' | grep bytes | cut -d" " -f10,11 )
tres=$(echo "Foi criado um arquivo de 1024 MB na memória RAM. A velocidade de escrita foi de $escritadois" >> '.textoRAM.txt' )
	$(dd if=.arquivo1024E_tmp of=/dev/null bs=1M count=1024 &> '.staging1024L.txt' )
	$(rm '.arquivo1024E_tmp')
leituradois=$(cat '.staging1024L.txt' | grep bytes | cut -d" " -f10,11 )
quatro=$(echo "arquivo criado foi lido em memória RAM, velocidade de leitura de foi de $leituradois" >> '.textoRAM.txt' )
	$(echo " " >> .textoRAM.txt) #pula linha no arquivo de texto
	$(rm '.staging1024E.txt')
	$(rm '.staging1024L.txt')


	$(dd if=/dev/zero of=.arquivo2048E_tmp bs=1M count=2048 &> '.staging2048E.txt' )
escritatres=$(cat '.staging2048E.txt' | grep bytes | cut -d" " -f10,11 )
cinco=$(echo "Foi criado um arquivo de 2048 MB na memória RAM. A velocidade de escrita foi de $escritatres" >> '.textoRAM.txt' )
	$(dd if=.arquivo2048E_tmp of=/dev/null bs=1M count=2048 &> '.staging2048L.txt' )
	$(rm '.arquivo2048E_tmp')
leituratres=$(cat '.staging2048L.txt' | grep bytes | cut -d" " -f10,11 )
seis=$(echo "arquivo criado foi lido em memória RAM, velocidade de leitura de foi de $leituratres" >> '.textoRAM.txt' )
	$(rm '.staging2048E.txt')
	$(rm '.staging2048L.txt') 

dialog --stdout $DIALOG --title 'Teste feito' --textbox ".textoRAM.txt" 0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0
	$(rm '.textoRAM.txt')
MENUP
}

escritaQDZ(){

dialog                                  \
--stdout                                \
$DIALOG																	\
--title 'Status'                        \
--infobox '\nFazendo testes aguarde...' \
0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(dd if=/dev/zero of=.arquivo512E_tmp bs=1M count=512 &> '.staging512E.txt' )
	$(rm '.arquivo512E_tmp' )
QDZEGREP=$(cat '.staging512E.txt' | grep bytes | cut -d" " -f10,11 )   
	$(echo "Foi criado um arquivo de 512 MB na memória RAM. A velocidade de escrita foi de $QDZEGREP" >> '.textoRAM.txt' ) 

dialog --stdout $DIALOG --title 'Teste feito' --textbox ".textoRAM.txt" 0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(rm '.textoRAM.txt' )
	$(rm '.staging512E.txt' )
MENUP
} #Função para fazer teste de velocidade de escrita na RAM com 512 MB

escritaMVQ(){

dialog                                  \
--stdout                                \
$DIALOG																	\
--title 'Status'                        \
--infobox '\nFazendo testes aguarde...' \
0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(dd if=/dev/zero of=.arquivo1024E_tmp bs=1M count=1024 &> '.staging1024E.txt' )
	$(rm '.arquivo1024E_tmp' )
MVQEGREP=$(cat '.staging1024E.txt' | grep bytes | cut -d" " -f10,11 )   
	$(echo "Foi criado um arquivo de 1024 MB na memória RAM. A velocidade de escrita foi de $MVQEGREP" >> '.textoRAM.txt' ) 

dialog --stdout $DIALOG --title 'Teste feito' --textbox ".textoRAM.txt" 0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(rm '.textoRAM.txt' )
	$(rm '.staging1024E.txt' )
MENUP
} #Função para fazer teste de velocidade de escrita na RAM com 1024 MB

escritaDQO(){

dialog                                  \
--stdout                                \
$DIALOG																	\
--title 'Status'                        \
--infobox '\nExecutando testes...' \
0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(dd if=/dev/zero of=.arquivo2048E_tmp bs=1M count=2048 &> '.staging2048E.txt' )
	$(rm '.arquivo2048E_tmp' )
DQOEGREP=$(cat '.staging2048E.txt' | grep bytes | cut -d" " -f10,11 )   
	$(echo "Foi criado um arquivo de 2048 MB na memória RAM. A velocidade de escrita foi de $DQOEGREP" >> '.textoRAM.txt' ) 

dialog --stdout $DIALOG --title 'Teste feito' --textbox ".textoRAM.txt" 0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(rm '.textoRAM.txt' )
	$(rm '.staging2048E.txt' )
MENUP
} #Função para fazer teste de velocidade de escritra na RAM com 2048 MB 

leituraQDZ(){

dialog                                  \
--stdout                                \
$DIALOG																	\
--title 'Status'                        \
--infobox '\nFazendo testes aguarde...' \
0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(dd if=/dev/zero of=.arquivo512E_tmp bs=1M count=512 &> /dev/null )
	$(dd if=.arquivo512E_tmp of=/dev/null bs=1M count=512 &> '.staging512L.txt' )
	$(rm '.arquivo512E_tmp' )
QDZLGREP=$(cat '.staging512L.txt' | grep bytes | cut -d" " -f10,11 )
	$(echo "Um arquivo criado foi lido em memória RAM, velocidade de leitura de foi de $QDZLGREP" >> '.textoRAM.txt' )

dialog --stdout $DIALOG --title 'Teste feito' --textbox '.textoRAM.txt' 0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(rm '.textoRAM.txt')
	$(rm '.staging512L.txt' )
MENUP
} #Função para fazer teste de velociade de leitura da RAM com 512 MB

leituraMVQ(){

dialog                                  \
--stdout                                \
$DIALOG																	\
--title 'Status'                        \
--infobox '\nFazendo testes aguarde...' \
0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(dd if=/dev/zero of=.arquivo1024E_tmp bs=1M count=1024 &> /dev/null )
	$(dd if=.arquivo1024E_tmp of=/dev/null bs=1M count=1024 &> '.staging1024L.txt' )
	$(rm '.arquivo1024E_tmp' )
MVQLGREP=$(cat '.staging1024L.txt' | grep bytes | cut -d" " -f10,11 )
	$(echo "Um arquivo criado foi lido em memória RAM, velocidade de leitura de foi de $MVQLGREP" >> '.textoRAM.txt' )

dialog --stdout $DIALOG --title 'Teste feito' --textbox '.textoRAM.txt' 0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(rm '.textoRAM.txt')
	$(rm '.staging1024L.txt' )
MENUP
} #Função para fazer teste de velociade de leitura da RAM com 1024 MB

leituraDQO(){

dialog                                  \
--stdout                                \
$DIALOG																	\
--title 'Status'                        \
--infobox '\nFazendo testes aguarde...' \
0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(dd if=/dev/zero of=.arquivo2048E_tmp bs=1M count=2048 &> /dev/null )
	$(dd if=.arquivo2048E_tmp of=/dev/null bs=1M count=2048 &> '.staging2048L.txt' )
	$(rm '.arquivo2048E_tmp' )
DQOLGREP=$(cat '.staging2048L.txt' | grep bytes | cut -d" " -f10,11 )
	$(echo "Um arquivo criado foi lido em memória RAM, velocidade de leitura de foi de $DQOLGREP" >> '.textoRAM.txt' )

dialog --stdout $DIALOG --title 'Teste feito' --textbox '.textoRAM.txt' 0 0
VAL=$?
[[ $VAL == 1 ]] && MENUP
[[ $VAL == 255 ]] && exit 0

	$(rm '.textoRAM.txt')
	$(rm '.staging2048L.txt' )
MENUP
} #Função para fazer teste de velociade de leitura da RAM com 2048 MB

MENUP(){
menu=$( 
dialog --stdout                                     \
				$DIALOG																			\
       --title 'teste de Velocidade Escrita na RAM' \
       --menu 'Escolha uma opção:'          \
      0 0 0                                 \
      1 'Fazer testes de escrita (512 MB)'  \
      2 'Fazer testes de leitura (512 MB)'  \
      3 'Fazer testes de escrita (1024 MB)' \
      4 'Fazer testes de leitura (1024 MB)' \
      5 'Fazer testes de escrita (2048 MB)' \
      6 'Fazer testes de leitura (2048 MB)' \
      7 'Fazer todos os testes'             \
      0 'Voltar'
VAL=$?
	[[ $VAL == 1 ]] && source $DIRET/RAM/menuprojeto.sh
	[[ $VAL == 255 ]] && exit 0
)
case $menu in
    1) escritaQDZ ;;
    2) leituraQDZ ;;
    3) escritaMVQ ;;
    4) leituraMVQ ;;
    5) escritaDQO ;;
    6) leituraDQO ;;
    7) conjunto ;;
    0) echo "[$(date)] Menu RAM teste de velocidade encerrado" >> "$LOG/hardtest$USERU.log" ; . "$DIRET/RAM/menuprojeto.sh" ;;
		#*) erro ;; 
esac
}

MENUP
