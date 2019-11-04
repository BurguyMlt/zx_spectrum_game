b = build/

all: files $(b)png2zx

$(b)png2zx: png2zx.cpp png.cpp png.h tail.h tail.cpp
	g++ -g -o $@ png2zx.cpp png.cpp tail.cpp -lpng

files:
	find . -type f -not -path "./build/*" -a -not -path "./bin/*" >png2zx.files

clean:
	rm $(b)*