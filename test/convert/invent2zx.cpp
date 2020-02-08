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

class TailId
{
public:
    unsigned id = 0;
};

class TailById
{
public:
    unsigned cnt = 0;
    Tail tail;
    unsigned firstX = 0, firstY = 0;
};

class Enemy
{
public:
    unsigned x, y, type;
    Enemy(unsigned _x, unsigned _y, unsigned _type) { x = _x; y = _y; type = _type; }
};

class Entry
{
public:
    unsigned x, y, n;
    inline Entry(unsigned _x = 0, unsigned _y = 0, unsigned _n = 0) : x(_x), y(_y), n(_n) {}
};

class Level
{
public:
    unsigned mapWidth = 0;
    unsigned mapHeight = 0;
    std::vector<unsigned> map;
    std::map<Tail, TailId> tails;
    unsigned tailId = 0;
    std::vector<TailById> tailsById;
    std::vector<Enemy> enemies;
    std::vector<Entry> entries;
    std::vector<Tail> enemyTails;

    unsigned bindTail(const Tail& t, unsigned x, unsigned y, unsigned incConter = 1);
    unsigned addTail(const Tail& t, unsigned x, unsigned y, unsigned incConter = 1, bool dontAddToHash = false);
};

unsigned Level::bindTail(const Tail& t, unsigned x, unsigned y, unsigned incConter)
{
    auto f = tails.find(t);
    unsigned cur;
    if (f != tails.end())
    {
        cur = f->second.id;
        TailById& t = tailsById[cur];
        if (t.cnt == 0)
        {
            t.firstX = x;
            t.firstY = y;
        }
        t.cnt += incConter;
        return cur;
    }    
    return addTail(t, x, y, incConter);
}

unsigned Level::addTail(const Tail& t, unsigned x, unsigned y, unsigned incConter, bool dontAddToHash)
{
    if (tailId >= 256) printf("Too many tails %u\n", (unsigned)tailId);
    unsigned cur = tailId++;
    TailId id;
    id.id = cur;
    if (!dontAddToHash) tails[t] = id;
    TailById b;
    b.tail = t;
    b.cnt = incConter;
    b.firstX = x;
    b.firstY = y;
    tailsById.push_back(b);
    return cur;
}

void clearTail(Png& png, int gx, int gy)
{
    for(unsigned iy = 0; iy < 8; iy++)
        for(unsigned ix = 0; ix < 8; ix++)
            png.setPixel(gx + ix, gy + iy, 0);
}

bool invent2zx(const char* outputFileName, const char* inputFileName, bool levelMode, unsigned cityRoadY)
{
    std::string name = truncFileExt(basename(inputFileName));

    Level l;

    Tail zt;
    zt.clear();
    l.bindTail(zt, 0, 0);

    Png png;
    if (!png.load(inputFileName)) return false;

    unsigned w = png.getWidth() / 8, h = png.getHeight() / 8;

    l.mapWidth = w;
    l.mapHeight = h;
    l.map.resize(l.mapWidth * l.mapHeight);

    for (unsigned y = 0; y < l.mapHeight; y++)
    {
        for (unsigned x = 0; x < l.mapWidth; x++)
        {
            Tail t;
            unsigned gx = x * 8, gy = y * 8;
            readTail(t, png, x * 8, y * 8);
            unsigned cur = l.bindTail(t, x * 8 , y * 8);
            l.map[x + y * l.mapWidth] = cur;
        }
    }

    FILE* fo = fopen(outputFileName, "w");
    if(!fo) return false;

    fprintf(fo, "   ds (10000h - $) & 7\n\n");
    fprintf(fo, "%sTails: ; count %u\n", name.c_str(), (unsigned)l.tailsById.size());
    unsigned n = 0;
    for (unsigned i = 0; i < l.tailsById.size(); i++)
    {
        for (unsigned j = 0; j < 8; j++)
        {
            unsigned t = i < l.tailsById.size() ? l.tailsById[i].tail.data[j % 9] : 0;
            fprintf(fo, "%s0%02Xh", j==0 ? "    db " : ", ", t);
        }
        fprintf(fo, "\n");
    }
    if (n != 0) fprintf(fo, "\n");
    fprintf(fo, "\n");

    fprintf(fo, "%sWidth=%u\n", name.c_str(), l.mapWidth);
    fprintf(fo, "%sHeight=%u\n", name.c_str(), l.mapHeight);

    fprintf(fo, "   ds (10000h - $) & 3\n\n");
    fprintf(fo, "%sMap: ; size %u x %u", name.c_str(), l.mapWidth, l.mapHeight);
    unsigned m = 0;
    for (unsigned i = 0; i < l.map.size(); i++)
    {
        unsigned c = l.map[i];
        if (c == 0)
        {
            c = 129;
            while (c < 255 & i + 1 < l.map.size() && l.map[i + 1] == 0)
            {
                i++;
                c++;
            }
        }
        fprintf(fo, "%s%u", m % 16 ? ", " : "\n    db ", c);
        m++;
    }
    fprintf(fo, "\n    db 128\n");
    fprintf(fo, "\n");

    fprintf(fo, "; maps tails\n");
    for (unsigned i = 0; i < l.map.size(); i++)
    {
        if ((i % l.mapWidth) == 0) fprintf(fo, "; ");
        fprintf(fo, "%3u,", l.map[i]);
        if (((i + 1) % l.mapWidth) == 0) fprintf(fo, "\n");
    }
    fprintf(fo, "\n");

    fprintf(fo, "; tail using\n");
    for (unsigned i = 0; i < l.map.size(); i++)
    {
        if ((i % l.mapWidth) == 0) fprintf(fo, "; ");
        fprintf(fo, "%4u,", l.tailsById[l.map[i]].cnt);
        if (((i + 1) % l.mapWidth) == 0) fprintf(fo, "\n");
    }

    fclose(fo);
    return true;
}

int main(int argc, char **argv)
{
    if (argc != 3)
    {
        std::cerr << "invent2zx (c) 13-12-2019 Alemorf" << std::endl
                  << "Syntax: " << argv[0] << " output_file.inc input_file.png" << std::endl;;
        return 2;
    }
    return invent2zx(argv[1], argv[2], false, 13) ? 0 : 1;
}
