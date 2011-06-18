#!/bin/sh

DOCPATH=/mnt/us/documents/sysinfo.txt

refresh()
{
	dbus-send --system /default com.lab126.powerd.resuming int32:1
}

removead()
{
	if [ -d /var/local/adunits ]; then
		rm -rf /var/local/adunits
		/etc/init.d/framework restart
	fi
}

updateinfo()
{
	if [ -x /etc/init.d/usbnet ]; then
		/etc/init.d/usbnet restart
		IP=`ifconfig |grep -A2 wlan0|grep "inet addr"|cut -d: -f2|awk '{print $1}'`
		if [ -f /mnt/us/sysinfo.txt ]; then
			sed -i "s/^IP.*/IP: $IP/" /mnt/us/sysinfo.txt
		fi
	fi
}

case "$1" in
	refresh)
		refresh
		;;
	removead)
		remove
		;;
	updateinfo)
		updateinfo
		;;
	*)
		echo "Usage: $0 {refresh|removead|updateinfo}"
		exit 1
		;;
esac

exit 0
