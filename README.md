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
Preparations:<br />
1. A SD card of at least 32mb<br />
2. A single FAT partition of at least 32mb<br />
3. All files necessary for the RPi to boot: bootcode.bin, fixup.dat, start.elf, kernel.img, cmdline.txt and config.txt<br />
4. The default login is root:root<br />
<br />
In order to make this work use ( / i used) the following files<br />
<br />
__kernel__
<br />
https://raw.github.com/xbianonpi/xbian/fecfc22042ce4ea359c7c5450c588b9c7e57e4a0/boot/kernel.img<br />
<br />
__config.txt__
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
<br />
__cmdline.txt__
```
ip=:::::wlan0:dhcp dwc_otg.fiq_fix_enable=1 sdhci-bcm2708.sync_after_dma=0 dwc_otg.lpm_enable=0 console=tty1
```
<br />
__initramfs__
```
cd ~
git clone https://github.com/CurlyMoo/MinimalPi.git
cd MinimalPi
```
1) Add your custom script you want to run and configure them<br />
2) If you want to use wlan, set the right values in poll_wlan.sh<br />
`find . | cpio -H newc -o | gzip -9v > ~/initramfs.gz`
<br />
Now put the newly created initramfs.gz on your SD card and boot
