#!/bin/bash

if [[ "$(cat /tmp/mensagem)" == "feito" ]]; then
	exit 0
fi

var2=$(lscpu | grep "Hypervisor vendor" | cut -d":" -f2 | sed 's/ //g' )
var1="KVM"

[[ $var2 == $var1 ]]

verificacao=$?

if [[ $verificacao == 0 ]] ; then

  dialog --stdout --title "OBS" --msgbox "Verificamos que você está executando nosso software em um ambiente virtual.\nPor conta disso esses testes não funcionarão:\n\nMemória:\n-Checklist de memória\n-Teste de velocidade\n-Teste de memória\n\nHD:\n-Teste de stress\n\nCPU:\n-Temperatura.\n\nAgradecemos a compreensão." 80 80

echo "feito" > /tmp/mensagem

fi

var3=$(lscpu | grep "Fabricante do hipervisor" | cut -d":" -f2 | sed 's/ //g' )
var4="KVM"

[[ $var3 == $var4 ]]

verificacao=$?

if [[ $verificacao == 0 ]] ; then

  dialog --stdout --title "OBS" --msgbox "Verificamos que você está executando nosso software em um ambiente virtual.\nPor conta disso esses testes não funcionarão:\n\nMemória:\n-Checklist de memória\n-Teste de velocidade\n-Teste de memória\n\nHD:\n-Teste de stress\n\nCPU:\n-Temperatura.\n\nAgradecemos a compreensão." 80 80

echo "feito" > /tmp/mensagem

fi

