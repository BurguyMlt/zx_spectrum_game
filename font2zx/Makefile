b = build/

all: files $(b)font2zx

$(b)font2zx: font2zx.cpp png.cpp png.h tail.h tail.cpp
	g++ -g -o $@ font2zx.cpp png.cpp tail.cpp -lpng

files:
	find . -type f -not -path "./build/*" -a -not -path "./bin/*" >font2zx.files

clean:
	rm $(b)*