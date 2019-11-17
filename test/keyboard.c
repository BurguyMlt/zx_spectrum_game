#counter 1000

uint8_t keyTrigger;
uint8_t keyPressed;

const KEY_UP = 1;
const KEY_DOWN = 2;
const KEY_LEFT = 4;
const KEY_RIGHT = 8;
const KEY_FIRE = 16;

void readKey()
{
    c = in(bc = 0xEFFE);
    a ^= a;
    if (c & 0x04) a |= KEY_RIGHT;
    if (c & 0x08) a |= KEY_UP;
    if (c & 0x10) a |= KEY_DOWN;
    c = in(bc = 0xF7FE);
    if (c & 0x10) a |= KEY_LEFT;
    c = in(bc = 0x7FFE);
    if (c & 0x01) a |= KEY_FIRE;
    a ^= 0xFF;

    // Чтение прошлого значения и сохранение нового
    b = a;
    hl = &keyPressed;
    a = *hl;
    *hl = b;

    //*(hl = 0x4000) = a;

    // Выделение события нажатия
    a ^= 0xFF;
    a &= b;
    hl = &keyTrigger;
    a |= *hl;
    *hl = a;

    return;
}
