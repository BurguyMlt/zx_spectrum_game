// Convert some to ZX some (c) 30-10-2019 Alemorf aleksey.f.morozov@gmail.com

#include <stdint.h>
#include <string.h>

enum TailType { ttDefault = 0, ttEnemy };

class Tail
{
public:
    TailType type;
    uint8_t data[9];

    inline Tail() { clear(); }
    inline void clear() { type == ttDefault; memset(data, 0, sizeof(data)); }
    inline Tail(const Tail& b) { *this = b; }
    inline Tail& operator = (const Tail& b) { type = b.type; memcpy(data, b.data, sizeof(data)); return *this; }

    bool operator < (const Tail& b) const
    {
        if (type < b.type)
            return true;
        if (type > b.type)
            return false;
        for (unsigned i = 0; i < 9; i++)
        {
            if (data[i] < b.data[i])
                return true;
            if (data[i] > b.data[i])
                return false;
        }
        return false;
    }

};

class Png;

void readTail(Tail& tail, Png& png, unsigned dx, unsigned dy);
