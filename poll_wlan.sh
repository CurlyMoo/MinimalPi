#!/bin/bash
# Supported:
# - WPA2 encryption
# - Realtek 8192cu wifi adapters

SSID="..."
PASSWORD="..."

while [ 1 ]; do
	if [ -d "/sys/class/net/wlan0/wireless" ]; then
		if [ $(ifconfig | grep wlan0 | wc -l) -eq 1 ]; then
			if [ $(ifconfig | grep "wlan0" -A 1 | grep "inet addr" | wc -l) -eq 0 ]; then
	                        ifconfig wlan0 up
	                        iwconfig wlan0 essid $SSID
                	        wpa_passphrase $SSID $PASSWORD > /etc/wpa_supplicant.conf
	                        wpa_supplicant -Dwext -iwlan0 -c /etc/wpa_supplicant.conf -B
        	                udhcpc -i wlan0 -s /etc/udhcpc/default.script -t 5 -T 5 -b
				ifconfig eth0 down
				sleep 1;
				ifconfig eth0 up
			fi
		else
			ifconfig wlan0 up
		fi
	elif [ $(dmesg | tail | grep Realtek | wc -l) -ge 1 ]; then
                modprobe -r 8192cu
                sleep 1;
                modprobe 8192cu
	fi
	sleep 1;
done

