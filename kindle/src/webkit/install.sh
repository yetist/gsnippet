#!/bin/sh
#
# $Id: install.sh 6843 2010-09-23 22:54:14Z NiLuJe $
#
# diff OTA patch script

HACKNAME="webpatch"

ORIG_LIB="/usr/lib/libwebkit-1.0.so.2.5.0"
ORIG_LIB_MD5="f00c3ef146a32cec319be2aa4beb2384 fce2f7b19138caa8cdb6e41a21ecfc15"
NEW_LIB="/mnt/us/webkit/libwebkit.so"

ORIG_BIN="/usr/bin/browserd"
ORIG_BIN_MD5="4c6fdac42ea22470e866e5cccf53bd0a"
NEW_BIN="/mnt/us/webkit/browserd"

LOG_FILE=/mnt/us/webkit/install.log
FAILED_FLAG=/mnt/us/webkit/failed.flag

_FUNCTIONS=/etc/rc.d/functions
[ -f ${_FUNCTIONS} ] && . ${_FUNCTIONS}

MSG_SLLVL_D="debug"
MSG_SLLVL_I="info"
MSG_SLLVL_W="warn"
MSG_SLLVL_E="err"
MSG_SLLVL_C="crit"
MSG_SLNUM_D=0
MSG_SLNUM_I=1
MSG_SLNUM_W=2
MSG_SLNUM_E=3
MSG_SLNUM_C=4
MSG_CUR_LVL=/var/local/system/syslog_level

logmsg()
{
    local _NVPAIRS
    local _FREETEXT
    local _MSG_SLLVL
    local _MSG_SLNUM

    _MSG_LEVEL=$1
    _MSG_COMP=$2

    { [ $# -ge 4 ] && _NVPAIRS=$3 && shift ; }

    _FREETEXT=$3

    eval _MSG_SLLVL=\${MSG_SLLVL_$_MSG_LEVEL}
    eval _MSG_SLNUM=\${MSG_SLNUM_$_MSG_LEVEL}

    local _CURLVL

    { [ -f $MSG_CUR_LVL ] && _CURLVL=`cat $MSG_CUR_LVL` ; } || _CURLVL=1

    if [ $_MSG_SLNUM -ge $_CURLVL ]; then
        /usr/bin/logger -p local4.$_MSG_SLLVL -t "ota_install" "$_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT"
    fi

    if [ "$_MSG_LEVEL" != "D" ]; then
      echo "ota_install: $_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT"
      [ -d /mnt/us/webkit ] && echo "ota_install: $_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT" >> $LOG_FILE
    fi
}

update_progressbar 10

update_percent_complete()
{
    _PERCENT_COMPLETE=$((${_PERCENT_COMPLETE} + $1))
    update_progressbar ${_PERCENT_COMPLETE}
}

stop_browser()
{
	PID=`pidof browserd`
	if [ ! -z "$PID" ]; then
		if [ -x /etc/init.d/browserd ]; then
			msg "Stopping $DESC" I
			/etc/init.d/browserd stop
		fi
	fi

	# In here, stop means start
	if mount|grep libwebkit; then
		umount ${ORIG_LIB}
	fi

	if mount|grep browserd; then
		umount ${ORIG_BIN}
	fi
}

stop_browser

update_progressbar 20

tar -zxf webkit.tar.gz -C /mnt/us

update_progressbar 40

current_lib_md5=`md5sum $ORIG_LIB |awk '{print $1}'`
if echo $ORIG_LIB_MD5 |grep $current_lib_md5 ;then
	echo "check $ORIG_LIB md5sum, passed." >> ${LOG_FILE}	
else
	[ -d /mnt/us/webkit/backup ] || mkdir -p /mnt/us/webkit/backup
	cp -f ${ORIG_LIB} /mnt/us/webkit/backup/
	echo "check $ORIG_LIB md5sum, failed: $current_lib_md5" >> ${LOG_FILE}	
fi

update_progressbar 50

current_bin_md5=`md5sum $ORIG_BIN |awk '{print $1}'`
if echo $ORIG_BIN_MD5 |grep $current_bin_md5 ;then
	echo "check $ORIG_BIN md5sum, passed." >> ${LOG_FILE}
else
	[ -d /mnt/us/webkit/backup ] || mkdir -p /mnt/us/webkit/backup
	cp -f ${ORIG_LIB} /mnt/us/webkit/backup/
	echo "check $ORIG_BIN md5sum, failed: $current_lib_md5" >> ${LOG_FILE}
fi

update_progressbar 70

ln -sf /mnt/us/webkit/webpatch /etc/rc5.d/S93webpatch
ln -sf /mnt/us/webkit/webpatch /etc/rc3.d/K07webpatch

update_progressbar 80

/etc/init.d/browserd start

update_progressbar 90

echo "Done!" >> ${LOG_FILE}

update_progressbar 100

return 0
