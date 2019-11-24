all: files lsttrial.trd files

.PHONY: all clean files

files:
	find . -type f >test.files

O += convert/map2zx
convert/map2zx: convert/map2zx.cpp convert/png.cpp convert/png.h convert/tail.cpp convert/tail.h
	g++ --std=c++11 convert/map2zx.cpp convert/png.cpp convert/tail.cpp -oconvert/map2zx -lpng

O += convert/png2zx
convert/png2zx: convert/png2zx.cpp convert/png.cpp convert/png.h convert/tail.cpp convert/tail.h
	g++ --std=c++11 convert/png2zx.cpp convert/png.cpp convert/tail.cpp -oconvert/png2zx -lpng

O += convert/font2zx
convert/font2zx: convert/font2zx.cpp convert/png.cpp convert/png.h convert/tail.cpp convert/tail.h
	g++ --std=c++11 convert/font2zx.cpp convert/png.cpp convert/tail.cpp -oconvert/font2zx -lpng

O += levels/city1.asm
levels/city1.asm: levels/city1.png convert/map2zx
	./convert/map2zx $@ $<

O += levels/city1b.asm
levels/city1b.asm: levels/city1b.png convert/map2zx
	./convert/map2zx $@ $<

O += menu/logo.asm
menu/logo.asm: menu/logo.png convert/png2zx
	./convert/png2zx $@ $<

O += menu/takh.asm
menu/takh.asm: menu/takh.png convert/png2zx
	./convert/png2zx $@ $< 45

O += menu/rast.asm
menu/rast.asm: menu/rast.png convert/png2zx
	./convert/png2zx $@ $< 45

O += menu/menu.7000.C menu/menu.7000.C.lst
menu/menu.7000.C: module.asm menu/intro.asm menu/logo.asm menu/takh.asm menu/rast.asm menu/spark.asm menu/menu.asm
	./bin/sjasmplus --raw=$@ --lst=$@.lst $^ || rm $@

O += base/font.asm
base/font.asm: base/font.png convert/font2zx
	./convert/font2zx $@ $<

O += menu/menu.asm
menu/menu.asm: menu/menu.c ./bin/cmm
	./bin/cmm $@ $<

O += city/city.asm
city/city.asm: city/city.c ./bin/cmm
	./bin/cmm $@ $<

O += city/city.7000.C city/city.7000.C.lst
city/city.7000.C: module.asm city/city.asm city/rand.asm levels/city1.asm levels/city1b.asm
	./bin/sjasmplus --raw=$@ --lst=$@.lst $^ || rm $@

O += base/keyboard.asm
base/keyboard.asm: base/keyboard.c ./bin/cmm
	./bin/cmm $@ $<

O += base/clearscreen.asm
base/clearscreen.asm: base/clearscreen.c ./bin/cmm
	./bin/cmm $@ $<

O += base/base.626F.C base/base.626F.C.lst
base/base.626F.C: base/base.asm base/font.asm base/clearscreen.asm base/drawimage.asm base/drawtext.asm base/keyboard.asm
	./bin/sjasmplus --raw=$@ --lst=$@.lst $^ || rm $@

O += boot/boot.B boot/boot.B.lst
boot/boot.B: boot/boot.asm
	./bin/sjasmplus --raw=$@ --lst=$@.lst $< || rm $@

O += lsttrial.trd
lsttrial.trd: boot/boot.B base/base.626F.C menu/menu.7000.C city/city.7000.C
	./bin/maketrd $@ $^

clean:
	rm -f $(O)
