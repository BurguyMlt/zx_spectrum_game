// Последнее Испытание 8 бит наброски на JavaScript
// (c) Морозов Алексей
// Главное меню.

const KEY_UP = 1;
const KEY_DOWN = 2;
const KEY_LEFT = 4;
const KEY_RIGHT = 8;
const KEY_FIRE = 16;

const menuLogoX      = 1;
const menuLogoY      = 1;
const menuItemH      = 10;
const menuItemsY     = 100;
const menuItemsX     = 80;
const menuItemsSX    = 72;
const menuItemsCount = 3;
const menuItemsM     = menuItemsCount * menuItemH;

uint8_t menuX = 0;
uint8_t menuX1 = 0;

uint16_t test;

void menuDrawCursor()
{
    drawTextEx(h = ((a = menuX1) += menuItemsY), l = menuItemsSX, de = "@");
    return;
}

void wait()
{
    hl = &frame;
    a ^= a;
    do { a |= *hl; } while(flag_z);
    *hl = 0;
}

void main()
{
    clearScreen(a = 0x45);
    drawImage(de = [0x5800 + menuLogoX + (menuLogoY << 5)], hl = &image_logo);
    drawTextEx(hl = [(menuItemsY + menuItemH * 0) * 256 + menuItemsX], de = "Начать новую игру");
    drawTextEx(hl = [(menuItemsY + menuItemH * 1) * 256 + menuItemsX], de = "Настроить управление");
    drawTextEx(hl = [(menuItemsY + menuItemH * 2) * 256 + menuItemsX], de = "Ввести пароль");

    drawTextCenter(h = [192 - 8 - menuItemH * 2], de = "Игра | 2019 Алексей {Alemorf} Морозов");
    drawTextCenter(h = [192 - 8 - menuItemH * 1], de = "Мюзикл | 1998 Антон {Саруман} Круглов,");
    drawTextCenter(h = [192 - 8 - menuItemH * 0], de = "Елена {Мириам} Ханпира");

    menuX = a ^= a;
    menuX1 = (++a);

    menuDrawCursor();

    while()
    {
        wait();
        menuTick();
    }
    return;
}

void menuTick()
{
    // Получить нажатую клавишу
    hl = &keyTrigger;
    b = *hl;
    *hl = 0;

    // Нажат выстрел
    a = menuX;
    if (b & KEY_FIRE)
    {
        if (a == [0 * menuItemH]) return exec(hl = "city");
        if (a == [1 * menuItemH]) return intro();
        //if (a == [2 * menuItemH]) return loadGame();
        //return saveGame();
        return;
    }

    // Перемещение курсора
    if (b & KEY_UP)
    {
        a -= menuItemH;
        if (flag_c) return;
    }
    else if (b & KEY_DOWN)
    {
        a += menuItemH;
        if (a >= menuItemsM) return;
    }
    menuX = a;

    // Плавное перемещение курсора
    hl = &menuX1;
    b = *hl;
    if (a == b) return; // Оставит флаг CF при выполнении menuX1 - menuX
    b++; // Не изменяет CF
    if (flag_c) ----b;

    push(bc);
    menuDrawCursor();
    pop(bc);

    *(hl = &menuX1) = b;

    menuDrawCursor();

    return;
}
