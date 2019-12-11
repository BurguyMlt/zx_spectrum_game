// Последнее Испытание 8 бит наброски на JavaScript
// (c) Морозов Алексей
// Главное меню.

const int KEY_UP = 1;
const int KEY_DOWN = 2;
const int KEY_LEFT = 4;
const int KEY_RIGHT = 8;
const int KEY_FIRE = 16;

const int menuLogoX      = 1;
const int menuLogoY      = 1;
const int menuItemH      = 10;
const int menuItemsY     = 100;
const int menuItemsX     = 80;
const int menuItemsSX    = 72;
const int menuItemsCount = 3;
const int menuItemsM     = menuItemsCount * menuItemH;

uint8_t menuX = 0;
uint8_t menuX1 = 0;

uint16_t test;

void menuDrawCursor()
{
    gDrawTextEx(h = ((a = menuX1) += menuItemsY), l = menuItemsSX, de = "@", a = 0x44);
}

void wait()
{
    hl = &gFrame;
    a ^= a;
    do { a |= *hl; } while(flag_z);
    *hl = 0;
}

void main()
{
    gClearScreen(a = 0x45);
    gDrawImage(de = [0x5800 + menuLogoX + (menuLogoY << 5)], hl = &image_logo);
    gDrawTextEx(a = 0x45, hl = [(menuItemsY + menuItemH * 0) * 256 + menuItemsX], de = "Начать новую игру");
    gDrawTextEx(a = 0x45, hl = [(menuItemsY + menuItemH * 1) * 256 + menuItemsX], de = "Настроить управление");
    gDrawTextEx(a = 0x45, hl = [(menuItemsY + menuItemH * 2) * 256 + menuItemsX], de = "Ввести пароль");

    gDrawTextCenter(a = 0x43, h = [192 - 8 - menuItemH * 2], de = "Игра | 2019 Алексей {Alemorf} Морозов");
    gDrawTextCenter(a = 0x43, h = [192 - 8 - menuItemH * 1], de = "Мюзикл | 1998 Антон {Саруман} Круглов,");
    gDrawTextCenter(a = 0x43, h = [192 - 8 - menuItemH * 0], de = "Елена {Мириам} Ханпира");

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
    hl = &gKeyTrigger;
    b = *hl;
    *hl = 0;

    // Нажат выстрел
    a = menuX;
    if (b & KEY_FIRE)
    {
        if (a == [0 * menuItemH]) return gExec(hl = "city");
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
