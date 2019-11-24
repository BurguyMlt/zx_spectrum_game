// Convert PNG image to ZX image (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#include "png.h"
#include <algorithm>
#include <vector>
#include <map>
#include <string.h>
#include <string>
#include <iostream>
#include "tail.h"

static std::string truncFileExt(const char* str)
{
    char* ext = strrchr((char*)str, '.');
    if (!ext) return str;
    if (strchr(ext, '/')) return str;
    return std::string(str, ext - str);
}

static bool png2zx(const char* outputFileName, const char* inputFileName, uint8_t default_attr)
{
    std::string name = truncFileExt(basename(inputFileName));

    Png png;
    if (!png.load(inputFileName)) return false;

    unsigned w = png.getWidth() / 8;
    unsigned h = png.getHeight() / 8;

    if (w == 0 || h == 0)
    {
        std::cerr << "Too small image " << inputFileName << std::endl;
        return false;
    }

    Tail ts[w][h];

    for (unsigned y = 0; y < h; y++)
    {
        for (unsigned x = 0; x < w; x++)
        {
            readTail(ts[x][y], png, x * 8, y * 8);
            if (ts[x][y].data[8] == 0) ts[x][y].data[8] = default_attr;
        }
    }

    FILE* fo = fopen(outputFileName, "w");
    if (!fo)
    {
        std::cerr << "Can't create file " << outputFileName << std::endl;
        return false;
    }

    fprintf(fo, "image_%s:\n", name.c_str());
    fprintf(fo, "    ; Width, height\n");
    fprintf(fo, "    db %u, %u\n", w, h);
    fprintf(fo, "    ; Black & white\n");
    for (unsigned y = 0; y < h; y++)
    {
        for (unsigned iy = 0; iy < 8; iy++)
        {
            fprintf(fo, "    db");
            for (unsigned x = 0; x < w; x++)
                fprintf(fo, "%s0%02Xh", x ? ", " : " ", ts[x][y].data[iy]);
            fprintf(fo, iy ? "\n" : " ; %u\n", y);
        }
    }
    fprintf(fo, "    ; Color attributes\n");
    for (unsigned y = 0; y < h; y++)
    {
        fprintf(fo, "    db");
        for (unsigned x = 0; x < w; x++)
            fprintf(fo, "%s0%02Xh", x ? ", " : " ", ts[x][y].data[8]);
        fprintf(fo, " ; %u\n", y);
    }

    fclose(fo);
    return true;
}

int main(int argc, char **argv)
{
    if (argc != 3 && argc != 4)
    {
        std::cerr << "png2zx (c) 3-10-2019 Alemorf" << std::endl
                  << "Syntax: " << argv[0] << " output_file.inc input_file.png default_attr_in_hex" << std::endl;;
        return 2;
    }
    unsigned default_attr = 0;
    if (argc >= 4)
    {
        char* end;
        default_attr = strtoul(argv[3], &end, 16);
        if (end[0] != 0 || default_attr > 256)
        {
            std::cerr << "Incorrect attr" << std::endl;
            return 3;
        }
    }
    return png2zx(argv[1], argv[2], (uint8_t)default_attr) ? 0 : 1;
}
