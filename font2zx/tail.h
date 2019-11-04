#include <stdint.h>
#include <string.h>

class Tail
{
public:
    uint8_t data[9];

    inline Tail() { clear(); }
    inline void clear() { memset(data, 0, sizeof(data)); }
};

class Png;

void readTail(Tail& tail, Png& png, unsigned dx, unsigned dy);
