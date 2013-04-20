#!/bin/bash
while [ 1 ]; do
	if [ -d "/sys/class/net/eth0" ]; then
		if [ $(ifconfig | grep eth0 | wc -l) -eq 1 ]; then
			if [ $(cat /sys/class/net/eth0/carrier) -eq 1 ]; then
				if [ $(ifconfig | grep "eth0" -A 1 | grep "inet addr" | wc -l) -eq 0 ]; then
				        udhcpc -i eth0 -s /etc/udhcpc/default.script -t 5 -T 5 -b
				fi
			fi
		else
			ifconfig eth0 up
		fi
	fi
	sleep 1;
done

