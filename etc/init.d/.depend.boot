TARGETS = hostname.sh udev networking ifplugd ntp cron ssh lighttpd rc.local
INTERACTIVE =
networking: udev
ifplugd: udev
lighttpd: networking ifplugd
ssh: networking ifplugd
ntp: networking ifplugd
cron: networking ifplugd ntp
rc.local: networking ifplugd ntp
