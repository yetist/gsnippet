all: README
	rst2html.py --language=zh_cn README README.html

clean:
	rm README.html
