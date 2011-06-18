#!/bin/sh
#
# diff OTA patch script

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

    [ "$_MSG_LEVEL" != "D" ] && echo "ota_install: $_MSG_LEVEL def:$_MSG_COMP:$_NVPAIRS:$_FREETEXT"
}

if [ -z "${_PERCENT_COMPLETE}" ]; then
    export _PERCENT_COMPLETE=0
fi

update_percent_complete()
{
    _PERCENT_COMPLETE=$((${_PERCENT_COMPLETE} + $1))
    update_progressbar ${_PERCENT_COMPLETE}
}

# Hack specific config (name and when to start/stop)
HACKNAME="pinyin"
SLEVEL="73"
KLEVEL="10"

# Based on version 0.2
HACKVER="0.3.0"

# Directories
PY_BASE_DIR="/mnt/us/pinyin"
PY_DATA_DIR="${PY_BASE_DIR}/data"
PY_BIN_DIR="${PY_BASE_DIR}/bin"
PY_LIB_DIR="${PY_BASE_DIR}/lib"
PY_RCD_DIR="${PY_BASE_DIR}/rc.d"
ORIGFOLDER_LIB="/opt/amazon/ebook/lib"

PY_LOG="${PY_BASE_DIR}/pinyin_install.log"

# Result codes
OK=0
ERR=${OK}

update_percent_complete 2

update_progressbar 10

# Remove our deprecated content
# From v0.2.N
logmsg "I" "update" "removing deprecated jar libs (v0.2.N)"
if [ -f /usr/java/lib/libjni_pinyinime.so ]; then
	echo "library /usr/java/lib/libjni_pinyinime.so exists, deleting..." >> ${PY_LOG}
	rm -f /usr/java/lib/libjni_pinyinime.so >> ${PY_LOG} 2>&1 || exit ${ERR}
fi

if [ -f /opt/amazon/ebook/lib_pinyin/framework-api.jar ]; then
	echo "java jar /opt/amazon/ebook/lib_pinyin/framework-api.jar exists, deleting..." >> ${PY_LOG}
	rm -f /opt/amazon/ebook/lib_pinyin/framework-api.jar >> ${PY_LOG} 2>&1 || exit ${ERR}
fi

if [ -f /opt/amazon/ebook/lib/pinyin.jar ]; then
	echo "java jar /opt/amazon/ebook/lib/pinyin.jar exists, deleting..." >> ${PY_LOG}
	rm -f /opt/amazon/ebook/lib/pinyin.jar >> ${PY_LOG} 2>&1 || exit ${ERR}
fi

update_progressbar 20

logmsg "I" "update" "removing deprecated init scripts & symlinks (v0.2.N)"
if [ -f /etc/init.d/pinyin-init ]; then
	echo "init script /etc/init.d/pinyin-init exists, deleting..." >> ${PY_LOG}
	rm -f /etc/init.d/pinyin-init  >> ${PY_LOG} 2>&1 || exit ${ERR}
fi

if [ -f /opt/amazon/pinyin-bind ]; then
	echo "script /opt/amazon/pinyin-bind exists, deleting..." >> ${PY_LOG}
	rm -f /opt/amazon/pinyin-bind >> ${PY_LOG} 2>&1 || exit ${ERR}
fi

if [ -L /etc/rc5.d/S73pinyin-init ]; then
	echo "symlink /etc/rc5.d/S73pinyin-init exists, deleting..." >> ${PY_LOG}
	rm -f /etc/rc5.d/S73pinyin-init >> ${PY_LOG} 2>&1 || exit ${ERR}
fi

if [ -L /etc/rc3.d/K${KLEVEL}${HACKNAME} ]; then
	echo "symlink /etc/rc3.d/K${KLEVEL}${HACKNAME} exists, deleting..." >> ${PY_LOG}
	rm -f /etc/rc3.d/K${KLEVEL}${HACKNAME} >> ${PY_LOG} 2>&1 || exit ${ERR}
fi

update_progressbar 40

logmsg "I" "update" "removing lib_pinyin directory"
if [ -d /opt/amazon/ebook/lib_pinyin ]; then
	echo "directory /opt/amazon/ebook/lib_pinyin/ exists, find contents in it..." >> ${PY_LOG}
	find /opt/amazon/ebook/lib_pinyin >> ${PY_LOG} 2>&1 || exit ${ERR}
	echo "directory /opt/amazon/ebook/lib_pinyin/ exists, removint..." >> ${PY_LOG}
	rm -rf /opt/amazon/ebook/lib_pinyin >> ${PY_LOG} 2>&1 || exit ${ERR}
fi

echo "all old pinyin removing OK" >> ${PY_LOG}

update_progressbar 50

# Okay, now we can extract it.
logmsg "I" "update" "installing pinyin directory"
echo "extract ${HACKNAME}.tar.gz to /mnt/us/, extracting..." >> ${PY_LOG}
tar -xvzf ${HACKNAME}.tar.gz -C /mnt/us

update_progressbar 70

# OK, now we translate framework-api.jar
logmsg "I" "update" "translate framework-api.jar"
echo "translate framework-api.jar ..." >> ${PY_LOG}
/usr/java/bin/cvm -Xms16m -classpath ${PY_DATA_DIR}/setup.jar com.kindle.inputmethod.installation.Setup ${ORIGFOLDER_LIB}/framework-api.jar ${PY_LIB_DIR}/framework-api.jar ${PY_DATA_DIR}/SymbolPopup.class >> ${PY_LOG}
if [ $? -gt 0 ]; then
	echo "translate framework-api.jar failed." >> ${PY_LOG}
	exit 1
else
	logmsg "C" "update" "failed to verify the file hash."
	echo "translate framework-api.jar OK" >> ${PY_LOG}
fi

update_progressbar 90

# Add it to boot time
if [ -f ${PY_RCD_DIR}/pinyin ]; then
   ln -sf ${PY_RCD_DIR}/pinyin /etc/rc5.d/S${SLEVEL}${HACKNAME}
   ln -sf ${PY_RCD_DIR}/pinyin /etc/rc3.d/K${KLEVEL}${HACKNAME}
fi

logmsg "I" "update" "done"
update_progressbar 100

return 0
