#!/bin/bash
# Supported:
# - WPA2 encryption
# - Realtek 8192cu wifi adapters

SSID="..."
PASSWORD="..."

while [ 1 ]; do
	if [ -d "/sys/class/net/wlan0/wireless" ]; then
		if [ $(ifconfig | grep wlan0 | wc -l) -eq 1 ]; then
			if [ $(pidof wpa_supplicant | sed -e 's/ /\n/g' | wc -l) -gt 1 ] || [ $(ps | grep "udhcpc -i wlan0" | grep -v "grep" | wc -l) -gt 1 ]; then
				ps | grep "udhcpc -i wlan0" | grep -v "grep" | awk '{print $1}' | xargs -n 1 kill
				pidof wpa_supplicant | xargs -n 1 kill
				wpa_supplicant -Dwext -iwlan0 -c /etc/wpa_supplicant.conf -B
                                udhcpc -i wlan0 -s /etc/udhcpc/default.script -t 5 -T 5 -b -x "hostname:$(cat /etc/hostname)"
			fi
			if [ $(ifconfig | grep "wlan0" -A 1 | grep "inet addr" | wc -l) -eq 0 ]; then
	                        ifconfig wlan0 up
	                        iwconfig wlan0 essid $SSID
                	        wpa_passphrase $SSID $PASSWORD > /etc/wpa_supplicant.conf
	                        wpa_supplicant -Dwext -iwlan0 -c /etc/wpa_supplicant.conf -B
        	                udhcpc -i wlan0 -s /etc/udhcpc/default.script -t 5 -T 5 -b -x "hostname:$(cat /etc/hostname)"
				ifconfig eth0 down
				sleep 1;
				ifconfig eth0 up
			fi
		else
			ifconfig wlan0 up
		fi
        else
                USBPORT=$(ls /sys/bus/usb/devices/*/idVendor | xargs grep "0bda" | cut -f1 -d:);
                if [ ! -z $USBPORT ]; then
                        if [ $(dirname $USBPORT | awk '{print $1"/idProduct"}' | xargs grep "81[0-9]\{1,2\}" | wc -l) -ge 1 ]; then
                                modprobe -r 8192cu
                                sleep 1;
                                modprobe 8192cu
                        else
                                modprobe -r 8192cu
                        fi
                fi
        fi
	sleep 1;
done

