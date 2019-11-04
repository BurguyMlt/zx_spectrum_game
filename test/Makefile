b = build/

all: files $(b)lsttrial.trd

files:
	find . -type f -not -path "./build/*" -a -not -path "./bin/*" >test.files

$(b)logo.inc: logo.png ./bin/png2zx
	./bin/png2zx $@ $<

$(b)font.inc: font.png ./bin/font2zx
	./bin/font2zx $@ $<

$(b)lsttrial.trd: $(b)boot.B
	./bin/maketrd $@ $^

$(b)boot.bin: boot.asm $(b)logo.inc $(b)font.inc clearscreen.inc drawimage.inc drawtext.inc
	iconv --from=utf8 --to=cp1251 $< >$(b)$<.1251
	wine ./bin/sjasmplus.exe $(b)$<.1251

$(b)boot.B: boot_monoloader.asm $(b)boot.bin
	wine ./bin/sjasmplus.exe $<

clean:
	rm $(b)*