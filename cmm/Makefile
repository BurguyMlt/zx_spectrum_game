b = build/

all: files $(b)cmm

files:
	@mkdir -p $(b)
	find . -type f -not -path "./$(b)*" >cmm.files

$(b)cmm: parse.cc main.cpp Parser.h Parser.ih ParserPreinclude.h Scannerbase.h Scanner.h Scanner.ih
	g++ -g -o$(b)cmm main.cpp parse.cc lex.cc

parse.cc: cmm.l cmm.y
	flexc++ cmm.l
	bisonc++ cmm.y

clean:
	rm $(b)*
