.PHONY: all clean files

all: files lsttrial.trd files

.PHONY: all clean files

.SUFFIXES:
.SUFFIXES: .asm .bin .B .C

files:
	rm -f save.inc
	find . -type f >test.files

%.asm: %.c ./bin/cmm
	./bin/cmm $@ $<

%.bin: %.asm
	@echo "    savebin \"$@\", begin, $$ - begin" > save.inc
	./bin/sjasmplus --lst=$@.lst $^ save.inc || rm $@

%.B: %.asm
	@echo "    savebin \"$@\", begin, $$ - begin" > save.inc
	./bin/sjasmplus --lst=$@.lst $^ save.inc || rm $@

%.C: %.asm
	@echo "    savebin \"$@\", begin, $$ - begin ; $^" > save.inc
	./bin/sjasmplus --lst=$@.lst $^ save.inc || rm $@

# --- CONVERT ---

O += convert/map2zx
convert/map2zx: convert/map2zx.cpp convert/png.cpp convert/png.h convert/tail.cpp convert/tail.h
	g++ --std=c++11 convert/map2zx.cpp convert/png.cpp convert/tail.cpp -oconvert/map2zx -lpng

O += convert/png2zx
convert/png2zx: convert/png2zx.cpp convert/png.cpp convert/png.h convert/tail.cpp convert/tail.h
	g++ --std=c++11 convert/png2zx.cpp convert/png.cpp convert/tail.cpp -oconvert/png2zx -lpng

O += convert/font2zx
convert/font2zx: convert/font2zx.cpp convert/png.cpp convert/png.h convert/tail.cpp convert/tail.h
	g++ --std=c++11 convert/font2zx.cpp convert/png.cpp convert/tail.cpp -oconvert/font2zx -lpng

O += convert/sprites2zx
convert/sprites2zx: convert/sprites2zx.cpp convert/png.cpp convert/png.h convert/tail.cpp convert/tail.h
	g++ --std=c++11 convert/sprites2zx.cpp convert/png.cpp convert/tail.cpp -oconvert/sprites2zx -lpng

# --- LEVELS ---

O += levels/dialog.asm
levels/dialog.asm: levels/dialog.png convert/sprites2zx
	./convert/sprites2zx 1 $@ $<

O += levels/city1.asm
levels/city1.asm: levels/city1.png convert/map2zx
	./convert/map2zx $@ $<

O += levels/city1b.asm
levels/city1b.asm: levels/city1b.png convert/map2zx
	./convert/map2zx $@ $<

O += levels/city1s.asm
levels/city1s.asm: levels/city1s.png convert/sprites2zx
	./convert/sprites2zx 0 $@ $<

# --- MENU ---

O += menu/menu2.asm
menu/menu2.asm: menu/menu2.c

O += menu/logo.asm
menu/logo.asm: menu/logo.png convert/png2zx
	./convert/png2zx $@ $<

O += menu/takh.asm
menu/takh.asm: menu/takh.png convert/png2zx
	./convert/png2zx $@ $< 45

O += menu/rast.asm
menu/rast.asm: menu/rast.png convert/png2zx
	./convert/png2zx $@ $< 45

O += menu/menu.C menu/menu.C.lst
menu/menu.C: menu/menu.asm menu/intro.asm menu/logo.asm menu/takh.asm menu/rast.asm menu/spark.asm menu/menu2.asm


# --- CITY ---

O += city/city2.asm
city/city2.asm: city/city2.c

O += city/fillrect.asm
city/fillrect.asm: city/fillrect.c

O += city/dialog.asm
city/dialog.asm: city/dialog.c

O += city/state.asm
city/state.asm: city/state.c

O += city/shop.asm
city/shop.asm: city/shop.c

O += city/panel.asm
city/panel.asm: city/panel.c

O += city/tools.asm
city/tools.asm: city/tools.c

O += city/city.C city/city.C.lst
city/city.C: city/city.asm city/city2.asm city/rand.asm levels/city1.asm levels/city1b.asm levels/city1s.asm city/fillrect.asm levels/dialog.asm city/dialog.asm city/shop.asm city/state.asm city/div16.asm city/panel.asm city/tools.asm

# --- BASE ---

O += base/keyboard.asm
base/keyboard.asm: base/keyboard.c

O += base/drawtext2.asm
base/drawtext2.asm: base/drawtext2.c

O += base/clearscreen.asm
base/clearscreen.asm: base/clearscreen.c

O += base/font.asm
base/font.asm: base/font.png convert/font2zx
	./convert/font2zx $@ $<

O += base/panel.asm
base/panel.asm: base/panel.png convert/png2zx
	./convert/png2zx $@ $< 45

O += base/base.C base/base.C.lst
base/base.C: base/basemover.asm base/base.bin
	@echo "    savebin \"$@\", begin, $$ - begin" > save.inc
	./bin/sjasmplus --lst=$@.lst $< save.inc || rm $@

O += base/base.bin base/base.bin.lst
base/base.bin: base/base.asm base/font.asm base/clearscreen.asm base/drawimage.asm base/keyboard.asm base/drawtext2.asm base/panel.asm

# --- BOOT ---

O += boot/boot.B boot/boot.B.lst
boot/boot.B: boot/boot.asm

# --- TRD ---

O += lsttrial.trd
lsttrial.trd: boot/boot.B base/base.C menu/menu.C city/city.C
	./bin/maketrd $@ $^

clean:
	rm -f $(O)
