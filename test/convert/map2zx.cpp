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
    l.addTail(zt, 0, 0, 0);

    Png png;
    if (!png.load(inputFileName)) return false;

    unsigned w = png.getWidth() / 8, h = png.getHeight() / 8;

    const unsigned topBorder = levelMode ? 1 : 4;
    const unsigned leftBorder = levelMode ? 8 : 0;

    l.mapWidth = w - leftBorder;
    l.mapHeight = h - topBorder;
//    if (l.mapHeight > 20) l.mapHeight = 20;

    if (levelMode)
    {
        for (unsigned x = 0; x < l.mapWidth; x++)
        {
            Tail t;
            readTail(t, png, x * 8, 0);
            unsigned cur = l.bindTail(t, x * 8, 0, 1);
        }
        l.mapHeight--;
    }
    else
    {
        unsigned c = 256 / topBorder;
        if (c > l.mapWidth) c = l.mapWidth;
        for (unsigned x = 0; x < c; x++)
        {
            for (unsigned y = 0; y < topBorder; y++)
            {
                Tail t;
                readTail(t, png, x * 8, y * 8);
                l.enemyTails.push_back(t);
            }
        }
    }

    l.map.resize(l.mapWidth * l.mapHeight);

    for (unsigned y = 0; y < l.mapHeight; y++)
    {
        for (unsigned x = 0; x < l.mapWidth; x++)
        {
            Tail t;
            unsigned gx = (x + leftBorder) * 8, gy = (y + topBorder) * 8;
            readTail(t, png, gx, gy);
            if (cityRoadY > 0 && cityRoadY == y)
            {
                if (t.data[0] == 0 && t.data[1] == 0 && t.data[2] == 0 && t.data[3] == 0
                    && t.data[4] == 0 && t.data[5] == 0 && t.data[6] == 0 && t.data[7] == 0
                    && t.data[8] != 0)
                {
                    l.entries.push_back(Entry(x, y, t.data[8] & 7));
                    t.data[8] = 0;
                }
            }
            else if (levelMode && t.type == ttEnemy)
            {
                l.enemies.push_back(Enemy(x, y, 1));
                t.clear();
            }            
            unsigned cur = l.bindTail(t, (x + leftBorder) * 8 , (y + topBorder) * 8, 1);
            if (cur == 1 && levelMode)
            {
                Tail t1, t2;
                readTail(t1, png, gx + 8, gy + 8);
                clearTail(png, gx + 8, gy + 8);
                readTail(t2, png, gx + 16, gy + 8);
                clearTail(png, gx + 16, gy + 8);
                l.entries.push_back(Entry(x, y, (t1.data[8] & 7)
                           | ((t2.data[8] & 7) << 3) ));
            }
            l.map[x + y * l.mapWidth] = cur;
        }
    }

    const unsigned dungeonEnemy = l.tailId;
    if (levelMode)
    {
        l.addTail(zt, 0, 0, 0, true);
        for (unsigned y = 0; y < l.mapHeight; y++)
        {
            for (unsigned x = 0; x < leftBorder; x++)
            {
                Tail t;
                readTail(t, png, x * 8, (y + topBorder) * 8);
                l.bindTail(t, x * 8, (y + topBorder) * 8, 1);
            }
        }
    }
    else
    {
        for (unsigned x = 0; x < l.mapWidth; x++)
        {
            for (unsigned y = 0; y < topBorder; y++)
            {
                if (l.tailId == 255) break;
                Tail t;
                readTail(t, png, x * 8, y * 8);
                l.addTail(t, x * 8, (y + topBorder) * 8, 1);
            }
        }
    }

//    for (unsigned y = 0; y < l.mapHeight; y++)
//    {
//        for (unsigned x = 0; x < l.mapWidth; x++)
//            printf("%c", 33 + l.map[x + y * l.mapWidth]);
//        printf("\n");
//    }

    // Сохранение

    FILE* fo = fopen(outputFileName, "w");
    if(!fo) return false;

    fprintf(fo, "   ds (10000h - $) & 0FFh\n\n");
    fprintf(fo, "%sTails: ; count %u\n", name.c_str(), (unsigned)l.tailsById.size());
    unsigned n = 0;
    for (unsigned j = 0; j < 9; j++)
    {
        for (unsigned i = 0; i < 256; i++)
        {
            unsigned t = i < l.tailsById.size() ? l.tailsById[i].tail.data[j % 9] : 0;
            fprintf(fo, "%s0%02Xh", n==0 ? "    db " : ", ", t);
            n = (n + 1) % 16;
            if (n == 0) fprintf(fo, "\n");
        }
    }
    if (n != 0) fprintf(fo, "\n");
    fprintf(fo, "\n");

    /*
    fprintf(fo, "%sEnemyTails: // count %u\n", name.c_str(), (unsigned)l.enemyTails.size());
    n = 0;
    for (unsigned j = 0; j < 9; j++)
    {
        for (unsigned i = 0; i < 256; i++)
        {
            unsigned t = i < l.enemyTails.size() ? l.enemyTails[i].data[j % 9] : 0;
            fprintf(fo, "%s0%02Xh", n==0 ? "    db " : ", ", t);
            n = (n + 1) % 16;
            if (n == 0) fprintf(fo, "\n");
        }
    }
    if (n != 0) fprintf(fo, "\n");
    fprintf(fo, "\n");
    */

    fprintf(fo, "%sEnemy=%u\n", name.c_str(), dungeonEnemy);
    fprintf(fo, "%sWidth=%u\n", name.c_str(), l.mapWidth);
    fprintf(fo, "%sHeight=%u\n", name.c_str(), l.mapHeight);
    fprintf(fo, "\n");

    fprintf(fo, "%sMap: ; size %u x %u", name.c_str(), l.mapWidth, l.mapHeight);
    for (unsigned i = 0; i < l.map.size(); i++)
    {
        fprintf(fo, "%s%u", i % 64 ? ", " : "\n    db ", l.map[i]);
    }
    fprintf(fo, "\n");
    fprintf(fo, "\n");

    fprintf(fo, "; maps tails\n");
    for (unsigned i = 0; i < l.map.size(); i++)
    {
        if ((i % l.mapWidth) == 0) fprintf(fo, "; ");
        fprintf(fo, "%3u,", l.map[i]);
        if (((i + 1) % l.mapWidth) == 0) fprintf(fo, "\n");
    }
    fprintf(fo, "\n");

//    fprintf(fo, "levelEnemies:\n");
//    for (unsigned i = 0; i < l.enemies.size(); i++)
//    {
//        fprintf(fo, " { ix: %3u, iy: %3u, type: %3u },\n", l.enemies[i].x, l.enemies[i].y, l.enemies[i].type);
//    }

//    fprintf(fo, "levelEntries:\n");
//    for (unsigned i = 0; i < l.entries.size(); i++)
//    {
//        fprintf(fo, "    { x: %3u, y: %3u, n: %3u },\n", l.entries[i].x, l.entries[i].y, l.entries[i].n);
//    }


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
        std::cerr << "png2zx (c) 3-10-2019 Alemorf" << std::endl
                  << "Syntax: " << argv[0] << " output_file.inc input_file.png" << std::endl;;
        return 2;
    }
    return invent2zx(argv[1], argv[2], false, 13) ? 0 : 1;
}
