all: dist/novel.txt dist/novel.pdf dist/novel.html

dist/novel.txt: main.txt txt.pl
	perl txt.pl main.txt > dist/novel.txt
dist/novel.pdf: main.txt pdf.pl
	perl pdf.pl main.txt > dist/novel.tex
	cd dist; lualatex novel.tex
	rm dist/novel.tex dist/novel.log dist/novel.aux
dist/novel.html: main.txt html.pl
	perl html.pl main.txt > dist/novel.html
clean: 
	rm -rf dist/*
