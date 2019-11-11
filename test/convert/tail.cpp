// Convert some to ZX some (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#include "tail.h"
#include "png.h"
#include <algorithm>

static unsigned color2zx(const uint32_t rgb)
{
    const unsigned r = (rgb >> 16) & 0xFF;
    const unsigned g = (rgb >> 8) & 0xFF;
    const unsigned b = rgb & 0xFF;
    const unsigned hf = (r >= 171 || g >= 171 || b >= 171) ? 8 : 0;
    const unsigned rf = r >= 81 ? 1 : 0;
    const unsigned gf = g >= 81 ? 4 : 0;
    const unsigned bf = b >= 81 ? 2 : 0;
    return bf | rf  | gf | hf;
}

void readTail(Tail& tail, Png& png, unsigned dx, unsigned dy)
{
    unsigned x, y;
    unsigned c1 = 0xFF, c2 = 0xFF;
    uint32_t tail_rgb[8 * 8];

    bool is_enemy_mark = true;
    for (y = 0; y < 8; y++)
    {
        for (x = 0; x < 8; x++)
        {
            uint32_t c = png.getPixel(x + dx, y + dy);
            if (c != 0x0080FF) is_enemy_mark = false;
            tail_rgb[x + y * 8] = c;
        }
    }

    if (is_enemy_mark)
    {
        memset(tail.data, 0, sizeof(tail.data));
        tail.type = ttEnemy;
        return;
    }


    for (y = 0; y < 8; y++)
    {
        uint8_t line = 0;
        for (x = 0; x < 8; x++)
        {
            uint32_t rgb = tail_rgb[x + y * 8];
            int c = color2zx(rgb);
            if (c != 0xFF && (c1 == 0xFF || c == c1)) { c1 = c; }
            else if (c != 0xFF && ((c1 & 8) == (c & 8) || c == 0 || c1 == 0) && (c2 == 0xFF || c == c2)) { c2 = c; line |= (0x80 >> x); }
            else printf("color error rgb=%06X x=%u y=%u c=%u c1=%u c2=%u\n", rgb, x + dx, y + dy, c, c1, c2);
        }
        tail.data[y] = line;
    }
    if (c2 == 0xFF) c2 = c1;
    if (c1 > c2)
    {
        std::swap(c1, c2);
        for (y = 0; y < 8; y++)
            tail.data[y] ^= 0xFF;
    }
    tail.data[8] = ((c1 & 0x07) << 3)
                 | (c2 & 0x07)
                 | ((c1 >= 8 || c2 >= 8) ? 0x40 : 0);
}
