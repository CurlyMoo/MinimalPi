#!/bin/sh

# Action script to enable/disable wpa-roam interfaces in reaction to
# ifplugd events.
#
# Copyright: Copyright (c) 2008-2010, Kel Modderman <kel@otaku42.de>
# License:   GPL-2
#

PATH=/sbin:/usr/sbin:/bin:/usr/bin

if [ ! -x /sbin/wpa_action ]; then
	exit 0
fi

# ifplugd(8) - <iface> <action>
#
# If an ifplugd managed interface is brought up, disconnect any
# wpa-roam managed interfaces so that only one "roaming" interface
# remains active on the system.

IFPLUGD_IFACE="${1}"
SSID="xxxx"
PASSWD="xxxx"

case "${2}" in
	up)
		ps -x | grep -v ps | grep "udhcpc -i $IFPLUGD_IFACE" | grep -v grep | awk '{print $1}' | xargs -n 1 kill
		if [ $IFPLUGD_IFACE = "wlan0" ]; then
			pkill wpa_supplicant
			iwconfig $IFPLUGD_IFACE essid $SSID
	                wpa_passphrase $SSID $PASSWD > /etc/wpa_supplicant.conf
	                wpa_supplicant -Dwext -i$IFPLUGD_IFACE -c /etc/wpa_supplicant.conf -B
		fi
	        udhcpc -i $IFPLUGD_IFACE -s /etc/udhcpc/default.script -t 5 -T 5 -b -x "hostname:$(cat /etc/hostname)"
		;;
	down)
		#COMMAND=reconnect
		echo;
		;;
	*)
		echo "$0: unknown arguments: ${@}" >&2
		exit 1
		;;
esac

#for CTRL in /var/run/wpa_supplicant/*; do
#	[ -S "${CTRL}" ] || continue
#
#	IFACE="${CTRL#/var/run/wpa_supplicant/}"
#
#	# skip if ifplugd is managing this interface
#	if [ "${IFPLUGD_IFACE}" = "${IFACE}" ]; then
#		continue
#	fi
#
#	if wpa_action "${IFACE}" check; then
#		wpa_cli -i "${IFACE}" "${COMMAND}"
#	fi
#done
