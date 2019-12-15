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

O += convert/invent2zx
convert/invent2zx: convert/invent2zx.cpp convert/png.cpp convert/png.h convert/tail.cpp convert/tail.h
	g++ --std=c++11 convert/invent2zx.cpp convert/png.cpp convert/tail.cpp -oconvert/invent2zx -lpng

# --- LEVELS ---

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


O += city/state.asm
city/state.asm: city/state.c

O += city/panel.asm
city/panel.asm: city/panel.c

O += city/tools.asm
city/tools.asm: city/tools.c

O += city/city.C city/city.C.lst
city/city.C: city/city.asm city/city2.asm city/rand.asm levels/city1.asm levels/city1b.asm levels/city1s.asm city/state.asm city/tools.asm

# --- BASE ---

B += base/keyboard.asm
base/keyboard.asm: base/keyboard.c

B += base/drawtext2.asm
base/drawtext2.asm: base/drawtext2.c

B += base/graphfunctions.asm
base/graphfunctions.asm: base/graphfunctions.c

B += base/panel.asm
base/panel.asm: base/panel.c

B += base/font.asm
base/font.asm: base/font.png convert/font2zx
	./convert/font2zx $@ $<

B += base/fillrect.asm
base/fillrect.asm: base/fillrect.c

B += base/tools.asm
base/tools.asm: base/tools.c

O += base/base.bin base/base.bin.lst
base/base.bin: base/base.asm base/drawimage.asm $B

O += B

O += base/base.C base/base.C.lst
base/base.C: base/basemover.asm base/base.bin
	@echo "    savebin \"$@\", begin, $$ - begin" > save.inc
	./bin/sjasmplus --lst=$@.lst $< save.inc || rm $@


# --- DIALOG ---

D += dialog/alg.asm
dialog/alg.asm: dialog/alg.c

D += dialog/shop.asm
dialog/shop.asm: dialog/shop.c

D += dialog/tools.asm
dialog/tools.asm: dialog/tools.c

D += dialog/dialogrect.asm
dialog/dialogrect.asm: dialog/dialogrect.png convert/sprites2zx
	./convert/sprites2zx 1 $@ $<

D += dialog/panelgraph.asm
dialog/panelgraph.asm: dialog/panelgraph.png convert/png2zx
	./convert/png2zx $@ $< 45

D += dialog/inventgraph.asm
dialog/inventgraph.asm: dialog/inventgraph.png convert/invent2zx
	./convert/invent2zx $@ $<

D += dialog/invent.asm
dialog/invent.asm: dialog/invent.c

D += dialog/panel.asm
dialog/panel.asm: dialog/panel.c

D += dialog/magic.asm
dialog/magic.asm: dialog/magic.png convert/sprites2zx
	./convert/sprites2zx 2 $@ $<

O += D

O += dialog/dialog.C
dialog/dialog.C: dialog/dialog.asm dialog/div16.asm $D

# --- BOOT ---

O += boot/boot.B boot/boot.B.lst
boot/boot.B: boot/boot.asm

# --- TRD ---

O += lsttrial.trd
lsttrial.trd: boot/boot.B base/base.C menu/menu.C city/city.C dialog/dialog.C
	./bin/maketrd $@ $^

clean:
	rm -f $(O)
