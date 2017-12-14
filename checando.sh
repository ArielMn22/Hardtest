#!/bin/bash

var=$(lscpu | grep "Hypervisor vendor" | cut -d":" -f2 &>/dev/null)

if [[ $var == "KVM" ]] ; then

  dialog --stdout --title "OBS" --msgbox "Verificamos que você está executando nosso software em um ambiente virtual.\nPor conta disso alguns testes não funcionarão.\n\nAgradecemos a compreensão." 80 80
  exit 0

fi
