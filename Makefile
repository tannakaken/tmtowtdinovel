all: docs/novel.txt docs/novel.pdf docs/novel.html

docs/novel.txt: main.txt txt.pl converter.pm
	perl txt.pl main.txt > docs/novel.txt
docs/novel.pdf: main.txt pdf.pl conf.perl converter.pm
	perl pdf.pl main.txt > docs/novel.tex
	cd docs; lualatex novel.tex
	rm docs/novel.tex docs/novel.log docs/novel.aux docs/novel.out
docs/novel.html: main.txt html.pl conf.perl converter.pm
	perl html.pl main.txt > docs/novel.html
clean:
	rm -rf docs/*
test:
	prove t
