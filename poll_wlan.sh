#!/bin/bash
# Supported:
# - WPA2 encryption
# - Realtek 8192cu wifi adapters

SSID="..."
PASSWORD="..."

while [ 1 ]; do
        GW=$(route | grep default | awk '{print $2}');
        if case $GW in
                *[!.0-9]* | *.*.*.*.* | *..* | [!0-9]* | *[!0-9] ) false ;;
                *25[6-9]* | *2[6-9][0-9]* | *[3-9][0-9][0-9]* | *[0-9][0-9][0-9][0-9]* ) false ;;
                [!1-9].*.*.* | *.*.*.[!1-9] ) false ;;
                *.*.*.* ) true ;;
                *) false ;;
        esac; then
                if [ $(ping -W 1 -w 1 $GW | grep "100% packet loss" | wc -l) -eq 1 ]; then
                        modprobe -r 8192cu
                else
                        sleep 3599;
                fi
        fi
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
	elif [ $(lsusb | grep "0bda:81[0-9]\{1,2\}" | wc -l) -ge 1 ]; then
                modprobe 8192cu
        else
                modprobe -r 8192cu
        fi
	sleep 1;
done

