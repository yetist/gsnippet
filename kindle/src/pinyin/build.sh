#!/bin/sh
BASEDIR="`dirname \"$0\"`"
TMPDIR="$BASEDIR/tmp"

UPDATE_KINDLE="$BASEDIR/../bin/kindle_update_tool.py"

URL="http://dl.dbank.com/c0ecr34fp4"
ORIGNAME="pinyin_0.2.rar"
ORIGMD5="b7659999130e7d35f29aa7b9956ede26"

download()
{
	if [ -f $BASEDIR/$ORIGNAME ]; then
		m1=`md5sum $BASEDIR/$ORIGNAME|awk '{print $1}'`

		if [ x"$m1" == x"$ORIGMD5" ];then
			echo "$ORIGNAME checksum is OK"
		else
			echo "please download the $ORIGNAME from $URL first"
			exit 0
		fi
	else
		echo "please download the $ORIGNAME from $URL first"
		exit 0
	fi

}

unpack()
{
	[ -d $TMPDIR ] || mkdir -p $TMPDIR
	if [ -f $BASEDIR/$ORIGNAME ]; then
		unrar x $BASEDIR/$ORIGNAME $TMPDIR
	fi
	$UPDATE_KINDLE e $TMPDIR/update_*0.2_k3w*bin
	tar vxf $TMPDIR/update_*0.2_k3w*bin.tgz -C $TMPDIR
}

repack()
{
	[ -d pinyin ] || mkdir -p pinyin/
	if [ -f $TMPDIR/dict_pinyin.dat ]; then
		cp -f $TMPDIR/dict_pinyin.dat pinyin
	else
		echo "dict_pinyin.dat lost"
	fi

	[ -d pinyin/bin ] || mkdir -p pinyin/bin
	if [ -f $TMPDIR/pinyin.jar ]; then
		cp -f $TMPDIR/pinyin.jar pinyin/bin
	else
		echo "pinyin.jar lost"
	fi

	[ -d pinyin/data ] || mkdir -p pinyin/data
	if [ -f $TMPDIR/setup.jar ]; then
		cp -f $TMPDIR/setup.jar pinyin/data
	else
		echo "pinyin.jar lost"
	fi

	if [ -f $TMPDIR/SymbolPopup.class ]; then
		cp -f $TMPDIR/SymbolPopup.class pinyin/data
	else
		echo "SymbolPopup.class lost"
	fi

	[ -d pinyin/lib ] || mkdir -p pinyin/lib
	if [ -f $TMPDIR/libjni_pinyinime.so ]; then
		cp -f $TMPDIR/libjni_pinyinime.so pinyin/lib
	else
		echo "libjni_pinyinime.so lost"
	fi

	[ -d pinyin/rc.d ] || mkdir -p pinyin/rc.d
	if [ -f scripts/pinyin ]; then
		cp -f scripts/pinyin pinyin/rc.d
	else
		echo "scripts/pinyin lost"
	fi
	tar zcf pinyin.tar.gz pinyin
}

clean()
{
	[ -d $TMPDIR ] && rm -rf $TMPDIR
	[ -d pinyin ] && rm -rf pinyin
}

download
unpack
repack
