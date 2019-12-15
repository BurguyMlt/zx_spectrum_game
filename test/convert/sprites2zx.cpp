// Convert PNG map to ZX map (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#include "png.h"
#include <algorithm>
#include <vector>
#include <map>
#include <string.h>
#include <string>
#include "tail.h"
#include <iostream>

static std::string truncFileExt(const char* str)
{
    char* ext = strrchr((char*)str, '.');
    if (!ext) return str;
    if (strchr(ext, '/')) return str;
    return std::string(str, ext - str);
}

bool sprites2zx(int mode, const char* outputFileName, const char* inputFileName)
{
    std::string name = truncFileExt(basename(inputFileName));

    Png png;
    if (!png.load(inputFileName)) return false;

    unsigned w = png.getWidth() / 8, h = png.getHeight() / 8;

    FILE* fo = fopen(outputFileName, "w");
    if(!fo) return false;

    if (mode == 0)
    {
        fprintf(fo, "    ds (10000h - $) & 0FFh\n");
        unsigned s = 0;
        unsigned n = 0;
        for (unsigned x = 0; x < w; x++)
        {
            unsigned gx = x * 8;

            Tail t;
            readTail(t, png, x * 8, 0);
            bool tn = t.data[7] != 0;

            unsigned ix;
            for(ix = x + 1; ix < w; ix++)
            {
                Tail t;
                readTail(t, png, ix * 8, 0);
                bool tn1 = t.data[7] != 0;
                if (tn != tn1) break;
            }
            unsigned sw = ix - x;

            unsigned ss = sw * 9 * 4 + 1;
            if (s + ss >= 256)
            {
                fprintf(fo, "    ds (10000h - $) & 0FFh\n");
                s = 0;
            }

            fprintf(fo, "%s_%u: ; %x\n", name.c_str(), n, s);
            n++;
            fprintf(fo, "    db %u\n", sw);

            for (ix = x; ix < x + sw; ix++)
            {
                for (unsigned y = 1; y < h; y++)
                {
                    Tail t;
                    unsigned gy = y * 8;
                    readTail(t, png, ix * 8, gy);

                    fprintf(fo, "    db ");
                    for (unsigned i = 0; i < sizeof(t.data); i++)
                    {
                        fprintf(fo, "%s%03Xh", i == 0 ? "" : ", ", t.data[i]);
                    }
                    fprintf(fo, "\n");
                }
            }

            s += ss;
            x += sw - 1;
        }
    }
    else if (mode == 1)
    {
        unsigned n = 0;
        for (unsigned y = 0; y < h; y++)
        {
            for (unsigned x = 0; x < w; x++)
            {
                Tail t;
                readTail(t, png, x * 8, y * 8);

                if (t.data[8] != 0x5B)
                {
                    if (t.data[8] == 0) t.data[8] = 0x47;
                    fprintf(fo, "%s_%u  db ", name.c_str(), n);
                    for (unsigned i = 0; i < sizeof(t.data); i++)
                    {
                        fprintf(fo, "%s%03Xh", i == 0 ? "" : ", ", t.data[i]);
                    }
                    fprintf(fo, "\n");

                    n++;
                }
            }
        }
    }
    if (mode == 2)
    {
        unsigned s = 0;
        unsigned n = 0;
        for (unsigned x = 0; x < w; x++)
        {
            unsigned gx = x * 8;

            Tail t;
            readTail(t, png, x * 8, 0);
            bool tn = t.data[7] != 0;

            unsigned ix;
            for(ix = x + 1; ix < w; ix++)
            {
                Tail t;
                readTail(t, png, ix * 8, 0);
                bool tn1 = t.data[7] != 0;
                if (tn != tn1) break;
            }
            unsigned sw = ix - x;

            fprintf(fo, "%s_%u: ; %x\n", name.c_str(), n, s);
            n++;

            for (unsigned y = 1; y < h; y++)
            {
                for (ix = x; ix < x + sw; ix++)
                {
                    Tail t;
                    unsigned gy = y * 8;
                    readTail(t, png, ix * 8, gy);
                    if (t.type != ttEnemy)
                    {
                        fprintf(fo, "    db ");
                        for (unsigned i = 0; i < sizeof(t.data); i++)
                        {
                            fprintf(fo, "%s%03Xh", i == 0 ? "" : ", ", t.data[i]);
                        }
                        fprintf(fo, "\n");
                    }
                }
            }

            x += sw - 1;
        }
    }
    else

    fclose(fo);
    return true;
}

int main(int argc, char **argv)
{
    if (argc != 4)
    {
        std::cerr << "sprites2zx (c) 25-11-2019 Alemorf" << std::endl
                  << "Syntax: " << argv[0] << " mode output_file.inc input_file.png" << std::endl;;
        return 2;
    }
    return sprites2zx(atoi(argv[1]), argv[2], argv[3]) ? 0 : 1;
}
