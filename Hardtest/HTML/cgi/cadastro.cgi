#!/bin/bash

read X

echo "Content-type: text/html"
echo

urldecode(){
	echo -e $(sed 's/%/\\x/g')
}

X=$(echo $X | urldecode)
X=$(echo $X | tr '+' ' ')
checkdecadastro(){

	cat ./usuario.txt | grep "^$login:" &>/dev/null
	val=$?
	if [[ $val == 0 ]]
		then
		echo "<script>"
		echo 'alert("Nome de usuário indisponível.");'
		echo 'window.location="../cadastro.html";'
		echo "</script>"
		exit 0
	fi
}

cadastro(){
	checkdecadastro
	senhaa=$(echo $senhaa | sha256sum | cut -d" " -f1)
	echo "$login:$senhaa:ADMIN" 1>> ./usuario.txt 2>/dev/null
	
	echo "<script>"
	echo 'alert("Cadastro efetuado com sucesso!");'
	echo 'window.location="../cadastro.html";'
	echo "</script>"
		
}

senhadif(){
	echo "<script>"
	echo 'alert("As senhas não são iguais, tente novamente.");'
	echo 'window.location="../cadastro.html";'
	echo "</script>"
}

nome=$(echo $X | cut -d"&" -f1 | cut -d"=" -f2)
email=$(echo $X | cut -d"&" -f2 | cut -d"=" -f2)
estado=$(echo $X | cut -d"&" -f3 | cut -d"=" -f2)
login=$(echo $X | cut -d"&" -f4 | cut -d"=" -f2)
senhaa=$(echo $X | cut -d"&" -f5 | cut -d"=" -f2)
senhab=$(echo $X | cut -d"&" -f6 | cut -d"=" -f2)

[[ $senhaa == $senhab ]] && cadastro || senhadif
