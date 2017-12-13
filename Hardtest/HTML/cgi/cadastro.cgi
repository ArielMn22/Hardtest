#!/bin/bash

read X

echo "Content-type: text/html"
echo

echo "<script>"

urldecode(){
	echo -e $(sed 's/%/\\x/g')
}

X=$(echo $X | urldecode)
X=$(echo $X | tr '+' ' ')

checkdecadastro(){

	grep "Cadastrado" usuario.txt &> /dev/null
	var=$?
	
	if [[ $login == "Cadastrado" ]]; then
		echo 'alert("Você não pode cadastrar um usuário chamado Cadastrado");'
		echo 'window.location="../cadastro.html";'
	echo "</script>"
		exit 0
	fi

	if [[ $? == 0 ]] ; then
		echo 'alert("Um usuário ADMIN já foi cadastrado, para cadastrar outro usuário, primeiro remove o usuário existente e depois cadastre outro.");'
		echo 'window.location="../cadastro.html";'
	echo "</script>"
		exit 0
	fi

}

cadastro(){
	checkdecadastro
	senhaa=$(echo $senhaa | sha256sum | cut -d" " -f1)
	echo "$login:$senhaa:ADMIN" 1> ./usuario.txt 2>/dev/null
	echo "Cadastrado" 1>> ./usuario.txt 2>/dev/null
	
	echo 'alert("Cadastro efetuado com sucesso!");'
	echo 'window.location="../cadastro.html";'
	echo "</script>"
		
}

senhadif(){
	echo 'alert("As senhas não são iguais, tente novamente.");'
	echo 'window.location="../cadastro.html";'
	echo "</script>"
}

login=$(echo $X | cut -d"&" -f1 | cut -d"=" -f2)
senhaa=$(echo $X | cut -d"&" -f2 | cut -d"=" -f2)
senhab=$(echo $X | cut -d"&" -f3 | cut -d"=" -f2)

[[ $senhaa == $senhab ]] && cadastro || senhadif
