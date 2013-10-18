MinimalPi
=========
Features:<br />
1. Auto (W)LAN (re)connection<br />
2. Bash<br />
3. SSH Server<br />
4. NTP client auto set datetime on network access<br />
5. Login prompt<br />
6. MySQL client library<br />
7. Samba client<br />
8. PHP client<br />
9. Hostname<br />
10. Cron<br />
11. Sendmail<br />
12. Nano<br />
13. Python2.6<br />
<br />
Requirements:<br />
A SD card of at least 32mb<br />
<br />
Step 1. Download the source when running e.g. Raspbian
```
cd ~
git clone https://github.com/CurlyMoo/MinimalPi.git
cd MinimalPi
rm -r .git
mkdir -p proc boot dev mnt sys tmp dev/pts var/log/lighthttpd var/spool/cron/crontabs
chmod 755 etc/init.d/rcS
chmod 777 var/log/lighttpd/
```

Step 2. Put the right values in `etc/wpa_supplicant/action_wpa.sh` when using wifi.

Step 3. Run this command `find . | cpio -H newc -o | gzip -9v > ~/initramfs.gz`. 
This will result in a OS image called `initramfs.gz`.

Step 4.1 Format a `whole` SD card in fat32.<br />
Step 4.2 Copy all files from the `boot/` partition including the `initramfs.gz` to the new SD card.<br />
Step 4.3 Replace the kernel.img with this version:<br />
https://raw.github.com/xbianonpi/xbian/fecfc22042ce4ea359c7c5450c588b9c7e57e4a0/boot/kernel.img<br />
Step 4.4 Replace the content of config.txt with this version:<br />
```
initramfs initramfs.gz 0x00a00000
sdtv_mode=2
framebuffer_width=800
framebuffer_height=600
overscan_left=40
overscan_right=20
overscan_top=20
overscan_bottom=20
disable_overscan=1
gpu_mem_256=32
gpu_mem_512=32
```
Step 4.5 Replace the content of the cmdline.txt with this version:<br />
```
ip=:::::wlan0:dhcp ip=:::::eth0:dhcp dwc_otg.fiq_fix_enable=1 sdhci-bcm2708.sync_after_dma=0 dwc_otg.lpm_enable=0 console=tty1
```

You can now boot MinimalPi

Default login root:root

===========
1) Add your custom script you want to run and configure them either in:<br />
`etc/init.d/`, `etc/rcS.d`, and `etc/init.d/.depend.boot`<br />
or<br />
`etc/rc.local`<br />
