PATH := bin:${PATH}

# PAGE_STYLE:: crngames defaults d-scheme rest.css revver-dev voidspace zope lsr
PAGE_STYLE := crngames

# CODE_STYLE:: autumn borland bw colorful default emacs friendly fruity manni monokai murphy native pastie perldoc tango trac vim vs
CODE_STYLE := vim

RST_DIR := .
HTML_DIR := html

RST_FILES=$(shell find $(RST_DIR) -name "*.rst")

HTML_TARGETS=$(RST_FILES:.rst=.html)

HTML_INSTALL = $(patsubst $(RST_DIR)%,$(HTML_DIR)%,$(HTML_TARGETS))

all: install

$(HTML_TARGETS): %.html: %.rst
	relpath=`dirname ./$< |sed 's#/[0-9a-zA-Z]*#/..#g'`; \
		rst2html --link-stylesheet --stylesheet=$$relpath/css/page/$(PAGE_STYLE).css,$$relpath/css/code.css,$$relpath/css/code/$(CODE_STYLE).css $< $@

$(HTML_INSTALL):$(HTML_DIR)/%:$(RST_DIR)/%
	install -Dm 644 $< $@
#	imgdir=`dirname $<`/images; \
#	       if [ -d $$imgdir ]; then \
#	       for i in $$imgdir/*.png; \
#	       do \
#	       install -Dm 755 $$i `dirname $@`/images; \
#	       done; \
#	       fi;

.PHONY: help install clean

html: $(HTML_TARGETS)

install:$(HTML_INSTALL)

clean: 
	rm -f $(HTML_TARGETS)

test:
	echo $(HTML_TARGETS)
	echo $(HTML_INSTALL)
