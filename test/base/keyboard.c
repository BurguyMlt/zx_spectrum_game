#counter 1000

#include "common.h"

// Использует A, BC, HL
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
    c = in(bc = 0xBFFE);
    if (c & 0x01) a |= KEY_MENU;
    a ^= 0xFF;

    // Чтение прошлого значения и сохранение нового
    b = a;
    hl = &gKeyPressed;
    a = *hl;
    *hl = b;

    // Выделение события нажатия
    a ^= 0xFF;
    a &= b;
    hl = &gKeyTrigger;
    a |= *hl;
    *hl = a;

    return;
}
