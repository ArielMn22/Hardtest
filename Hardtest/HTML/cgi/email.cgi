#!/bin/bash

read X

DIRET="/usr/lib/cgi-bin"
MAIL_LOG="/var/log/Hardtest/sendemail"

urldecode(){
  echo -e $(sed 's/%/\\x/g')
}

chmod 777 $MAIL_LOG/sendemail.log
chmod 777 $MAIL_LOG/email.log

chown www-data:www-data $MAIL_LOG/sendemail.log
chown www-data:www-data $MAIL_LOG/email.log

echo "Content-type: text/html"
echo

email=$(echo $X | cut -d"&" -f1 | cut -d"=" -f2)
email=$(echo $email | urldecode )

msg=$(echo $X | cut -d"&" -f2 | cut -d"=" -f2)
msg=$(echo $msg | urldecode | tr + ' ')

email=$(echo "Email do usuário: $email") #> /home/hardtest/mail.txt 2>> email.log
msg=$(echo "Mensagem do usuário: $msg") #>> /home/hardtest/mail.txt 2>> email.log

sendemail -l $MAIL_LOG/sendemail.log          							 \
-f "contato.hardtest@gmail.com"                              \
-u "[Contato] Comentário"                                    \
-t "arielpaixao10@gmail.com"                                 \
-m "$email\n$msg"					     \
-cc "$email"                                                 \
-s "smtp.gmail.com:587"                                      \
-o tls=yes                                                   \
-xu "contato.hardtest@gmail.com"                             \
-xp "hardtest@132" >> $MAIL_LOG/email.log

val=$?

if [[ $val == 0 ]]
	then
	echo "<script>"
	echo 'alert("Email enviado com sucesso!");'
	echo 'window.location="../suporte.html";'
	echo "</script>"
else
	echo "<script>"
	echo 'alert("Ocorreu um erro, email não enviado.");'
	echo 'window.location="../suporte.html";'
	echo "</script>"
fi
