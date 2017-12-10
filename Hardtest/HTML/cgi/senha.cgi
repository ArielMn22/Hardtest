#!/bin/bash

echo "Content-type: text/html"
echo

read X

urldecode(){
  echo -e $(sed 's/%/\\x/g')
}

X=$(echo $X | cut -d"=" -f2 | cut -d"&" -f1 | urldecode)

echo $X > senha.txt
