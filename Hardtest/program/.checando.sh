#!/bin/bash

var2=$(lscpu | grep "Hypervisor vendor" | cut -d":" -f2 | sed 's/ //g' )
var1="KVM"

[[ $var2 == $var1 ]]

verificacao=$?

if [[ $verificacao == 0 ]] ; then

  dialog --stdout --title "OBS" --msgbox "Verificamos que você está executando nosso software em um ambiente virtual.\nPor conta disso esse teste não funcionará.\n\nAgradecemos a compreensão." 80 80

else
  echo "continuando"
fi
echo $verificacao
