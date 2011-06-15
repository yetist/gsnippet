#!/bin/sh
#
# $Id: install.sh 7327 2011-03-01 15:09:54Z NiLuJe $
#
# diff OTA patch script

HACKNAME="pinyin"
ORIGFOLDER_LIB=/opt/amazon/ebook/lib
DESTFOLDER_LIB=/opt/amazon/ebook/lib_pinyin
LOG_FILE=/mnt/us/pinyin/install.log
FAILED_FLAG=/mnt/us/pinyin/failed.flag

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
      [ -d /mnt/us/pinyin ] && echo "ota_install: $_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT" >> $LOG_FILE
    fi
}

update_progressbar 10

# Unbind folders to original locations
logmsg "I" "update" "restore bindings"
[ -f /opt/amazon/ebook/lib_pinyin/framework-api.jar ] && umount /opt/amazon/ebook/lib/framework-api.jar
[ -f /opt/amazon/ebook/lib_pinyin/framework-api.jar ] && rm -f /opt/amazon/ebook/lib_pinyin/framework-api.jar
[ -f /usr/java/lib/libjni_pinyinime.so ] && umount /usr/java/lib/libjni_pinyinime.so
[ -f /usr/java/lib/libjni_pinyinime.so ] && rm -f /usr/java/lib/libjni_pinyinime.so
[ -f /opt/amazon/ebook/lib/pinyin.jar ] && umount /opt/amazon/ebook/lib/pinyin.jar
[ -f /opt/amazon/ebook/lib/pinyin.jar ] && rm -f /opt/amazon/ebook/lib/pinyin.jar

update_progressbar 15

#Create dirs
[ -d /mnt/us/pinyin ] || mkdir /mnt/us/pinyin
[ -d /opt/amazon/ebook/lib_pinyin ] || mkdir /opt/amazon/ebook/lib_pinyin

# Translate all JARs in 'lib' folder

update_progressbar 30

logmsg "I" "update" "translate framework-api.jar"
/usr/java/bin/cvm -Xms16m -classpath setup.jar com.kindle.inputmethod.installation.Setup $ORIGFOLDER_LIB/framework-api.jar $DESTFOLDER_LIB/framework-api.jar SymbolPopup.class >> $LOG_FILE 2>FAILED_FLAG
if [ -s $FAILED_FLAG ]; then
  logmsg "C" "update" "failed to verify the file hash."
  exit 1
fi

update_progressbar 80

logmsg "I" "update" "add dict_pinyin.dat"
mv -f dict_pinyin.dat /mnt/us/pinyin/dict_pinyin.dat
logmsg "I" "update" "add libjni_pinyinime.so"
mv -f libjni_pinyinime.so /usr/java/lib/libjni_pinyinime.so
logmsg "I" "update" "add pinyin.jar"
mv -f pinyin.jar /opt/amazon/ebook/lib/pinyin.jar

update_progressbar 90

logmsg "I" "update" "init scripts"
# Almost done, copy init scripts and initialize it
# Move init script
mv -f pinyin-init /etc/init.d/pinyin-init
# Make it runnable
chmod +x /etc/init.d/pinyin-init
# Add it to boot time
if [ ! -h /etc/rcS.d/S73pinyin-init ]
then
   ln -fs /etc/init.d/pinyin-init /etc/rcS.d/S73pinyin-init
fi 
mv -f pinyin-bind /opt/amazon/pinyin-bind
chmod +x /opt/amazon/pinyin-bind

/opt/amazon/pinyin-bind

logmsg "I" "update" "done"
update_progressbar 100

return 0
