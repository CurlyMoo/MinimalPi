#!/bin/bash

SERVERS[0]="nl.pool.ntp.org"
SERVERS[1]="de.pool.ntp.org"
SERVERS[2]="be.pool.ntp.org"
SERVERS[3]="lu.pool.ntp.org"

I=0;
while [ $(date | grep 1970 | wc -l) -eq 1 ]; do
	if [ $(ifconfig | grep "wlan0" -A 1 | grep "inet addr" | wc -l) -eq 1 ] || [ $(ifconfig | grep "eth0" -A 1 | grep "inet addr" | wc -l) -eq 1 ]; then
		ntpd -q -p ${SERVERS[$I]};
		I=$(($I+1));
		if [ $I -ge 4 ]; then
			I=0;
		fi
	fi
	sleep 1;
done
