#!/bin/bash
rm -rf /usr/share/Hardtest
rm -rf /usr/bin/hardtest

for x in $(echo dialog sysbench speedtest-cli dmidecode); do
	apt-get remove $x --purge -y
	apt-get purge $x -y
done

apt-get autoremove -y
