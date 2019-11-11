// Convert PNG font to ZX font (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

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

bool font2zx(const char* outputFileName, const char* inputFileName)
{
    std::string name = truncFileExt(basename(inputFileName));

    Png png;
    if (!png.load(inputFileName)) return false;

    FILE* fo = fopen(outputFileName, "w");
    if (!fo)
    {
        std::cerr << "Can't create file " << outputFileName << std::endl;
        return false;
    }
    
    fprintf(fo, "image_%s:\n", name.c_str());
    unsigned n = 0;
    for (unsigned y = 0; y < 9 * 5; y += 9)
    {
        for (unsigned x = 0; x < 7 * 32; x += 7)
        {
            fprintf(fo, "    db");
            uint8_t total_mask = 0;
            for (unsigned iy = 1; iy < 9; iy++)
            {
                uint8_t b = 0;
                for (unsigned ix = 0; ix < 6; ix++)
                {
                    unsigned c = png.getPixel(x + ix, y + iy);
                    if (c != 0) b |= (1 << (7 - ix));
                }
                total_mask |= b;
                fprintf(fo, " 0%02Xh,", b);
            }
            unsigned w = 8;
            for (;w > 0; w--)
                if (total_mask & (1 << (8 - w)))
                    break;
            if (w == 0)
            {
                w = 3;
            }
            else
            {
                unsigned lp = 0;
                for (;lp < 4; lp++)
                    if (total_mask & (1 << (7 - lp)))
                        break;
                w += lp;
            }
            fprintf(fo, " %u ; %u\n", w + 1, n);
            n++;
        }
    }

    fclose(fo);

    return true;
}

int main(int argc, char **argv)
{    
    if (argc != 3)
    {
        std::cerr << "font2zx (c) 3-10-2019 Alemorf" << std::endl
                  << "Syntax: " << argv[0] << " output_file.inc input_file.png" << std::endl;;
        return 2;
    }
    return font2zx(argv[1], argv[2]) ? 0 : 1;
}
