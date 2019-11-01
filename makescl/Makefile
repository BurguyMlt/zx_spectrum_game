all: maketrd

maketrd: maketrd.cpp trdfile.h trdfile.cpp sclfile.h sclfile.cpp fstools.cpp fstools.h
	g++ -g trdfile.cpp maketrd.cpp sclfile.cpp fstools.cpp -omaketrd

clean:
	rm maketrd