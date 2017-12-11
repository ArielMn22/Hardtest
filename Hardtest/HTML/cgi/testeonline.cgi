#!/bin/bash

read X

echo "Content-type: text/html"
echo


urldecode(){
  echo -e $(sed 's/%/\\x/g')
}

sucesso(){
	echo "<script>
				alert('Login efetuado com sucesso!');
				</script>"
	escolha
}

fracasso(){
	echo "<script>"
	echo "alert('Falhou, usuário ou senha incorreto!');"
	echo "window.location="/var/www/html/testeonline.html";"
	echo "</script>"
}

escolha(){
	cat /var/www/html/escolha.html
}

X=$(echo $X | urldecode | tr '+' ' ')

user=$(echo $X | cut -d"&" -f1 | cut -d"=" -f2)
password=$(echo $X | cut -d"&" -f2 | cut -d"=" -f2)
password=$(echo $password | sha256sum | cut -d" " -f1)

SENHA=$(grep "^$user:" "/var/www/html/cgi-bin/usuario.txt" | cut -d":" -f2)

[[ $(grep "^$user:" "/var/www/html/cgi-bin/usuario.txt") ]] && [[ $SENHA == $password ]] && sucesso || fracasso
