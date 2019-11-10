b = build/

all: files $(b)lsttrial.trd

files:
	find . -type f -not -path "./build/*" -a -not -path "./bin/*" >test.files

$(b)map2zx: convert/map2zx.cpp convert/png.cpp convert/png.h convert/tail.cpp convert/tail.h
	g++ --std=c++11 convert/map2zx.cpp convert/png.cpp convert/tail.cpp -o$(b)map2zx -lpng

$(b)city1graph.inc: city1.png $(b)map2zx
	$(b)map2zx $@ $<

$(b)logo.inc: logo.png ./bin/png2zx
	./bin/png2zx $@ $<

$(b)takh.inc: takh.png ./bin/png2zx
	./bin/png2zx $@ $< 45

$(b)rast.inc: rast.png ./bin/png2zx
	./bin/png2zx $@ $< 45

$(b)font.inc: font.png ./bin/font2zx
	./bin/font2zx $@ $<

$(b)lsttrial.trd: $(b)boot.B
	./bin/maketrd $@ $^

$(b)boot.bin: boot.asm $(b)logo.inc $(b)font.inc clearscreen.inc drawimage.inc drawtext.inc $(b)rast.inc $(b)city1graph.inc $(b)takh.inc spark.inc intro.inc scroll.inc
	./bin/sjasmplus $< || rm $@

$(b)boot.B: boot_monoloader.asm $(b)boot.bin
	./bin/sjasmplus $< || rm $@

clean:
	rm $(b)*