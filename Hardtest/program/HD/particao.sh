#!/bin/bash
	PARTICAO=$(lsblk &> "stagingP.txt")
(cat stagingP.txt | sed 's/NAME/NOME/g' > "stagingUM.txt")
(cat stagingUM.txt | sed 's/TYPE/TIPO/g' > "stagingDOIS.txt")
(cat stagingDOIS.txt | sed 's/MOUNTPOINT/PONTO\ DE\ MONTAGEM/g' > "stagingP.txt")
cat stagingP.txt

