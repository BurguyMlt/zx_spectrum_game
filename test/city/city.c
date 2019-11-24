#counter 2000

const KEY_UP = 1;
const KEY_DOWN = 2;
const KEY_LEFT = 4;
const KEY_RIGHT = 8;
const KEY_FIRE = 16;

const PORT_7FFD_SECOND_VIDEO_PAGE = 8;

const screenAddr1 = 0x4000;
const screenAddr2 = 0xC000;
const screenWidth = 256;
const screenHeight = 192;
const screenBwSize = screenWidth / 8 * screenHeight;
const screenAttrSize = screenWidth / 8 * screenHeight / 8;
const screenAttrAddr1 = screenAddr1 + screenBwSize;
const screenAttrAddr2 = screenAddr2 + screenBwSize;
const screenEndAddr1 = screenAttrAddr1 + screenAttrSize;
const screenEndAddr2 = screenAttrAddr2 + screenAttrSize;
const cacheAddr1 = screenEndAddr1;
const cacheAddr2 = screenEndAddr2;
const unusedTailCode = 0xFF;
const viewWidth = 32;
const viewHeight = 20;
const cityRoadY = 13;
const mapWidth = 256;

const npc_timer      = 0;
const npc_direction  = 1;
const npc_step       = 2;
const npc_position   = 3;
const npc_sprite     = 4;
const npc_spriteType = 5;
const npc_sizeof     = 6;

const npc_maxCount = 16;
const npc_defaultSpeed = 7;

uint8_t cityPlayerX = 0;
uint8_t cityScrollX = 0;
uint8_t cityPlayerD = 0;
uint16_t cityPlayerSprite = [&city1Enemy + 0x100];
uint8_t processedFrames = 0;
uint8_t startFrame;
uint8_t npcCount = npc_maxCount;
uint8_t npc[npc_sizeof * npc_maxCount];

void swapMaps()
{
    // Загрузка города
    hl = &city1Tails;
    de = &city1bTails;
    bc = [9 * 256 + 256 * 20];
    do
    {
        a = *de;
        ex(a, a);
        a = *hl;
        *de = a;
        ex(a, a);
        *hl = a;
        hl++;
        de++;
        bc--;
    } while(flag_nz (a = b) |= c);
}

void main()
{
    cityPlayerX = a = [mapWidth / 2];
    cityScrollX = (a -= [viewWidth / 2]);

    // Инициализация NPC
    initNpc();

    //swapMaps();

    // Инициализация кеша
    cityInvalidate(hl = cacheAddr1);
    cityInvalidate(hl = cacheAddr2);

    // Перерисовать
    cityRedraw();

    while()
    {
        while ((a = frame) != *(hl = &processedFrames))
        {
            *hl = a;
            a &= 3;
            if (flag_z) processPlayer();
            processNpc();
        }

        cityRedraw();
    }
}

void cityInvalidate(hl)
{
    d = h; e = l; de++;
    *hl = unusedTailCode;
    bc = [viewWidth * viewHeight - 1];
    ldir();
}

void initNpc()
{
    ix = &npc;
    de = npc_sizeof;
    b = a = npcCount; // Счетчик цикла
    do
    {
        a = b;
        while (a >= npc_defaultSpeed) a -= npc_defaultSpeed;
        a += 1;
        ix[npc_timer] = a; // Фаза таймера

        ix[npc_step] = 0;
        ix[npc_sprite] = [&city1Enemy + 14 * 4];
        rand();
        ix[npc_position] = a;
        ix[npc_direction] = (a &= 1);
        ix += de;
    } while(--b);
}

void processNpc()
{
    de = npc_sizeof;
    hl = &npc;
    b = a = npcCount;
    do
    {
        if (flag_z --*hl) // Скорость
        {
            rand();
            if (flag_z a--) // Внезапная остановка
            {
                //! Не полушаге не останавливать
                push(hl);
                pop(ix);
                a = ix[npc_spriteType];
                if (a == 1)
                {
                    *hl = 255;
                    goto continue1;
                }
            }

            // У всех разная скорость
            *hl = (((a = b) &= 7) += npc_defaultSpeed);

            if (flag_z a--) // Внезапный поворот
            {
                hl++;
                a = *hl;
                a ^= 1;
                *hl = a;
                hl--;
            }

            hl++;
            if (*hl & 1) // Направление
            {
                hl++;
                c = *hl;
                if (c & 4) // Шаг
                {
                    *hl = 0; // Шаг
                    hl++; a = *hl; // Позиция
                   /* if (a == 254)
                    {
                        hl--; hl--; *hl = 0; // Направление
                        hl++;
                        goto turnLeft;
                    }*/
                    *hl = (++a); // Позиция
                    hl++; *hl = [&city1Enemy + 17 * 4]; // Спрайт
                    hl++; *hl = 1; // Тип спрайта
                }
                else if (c & 2) // Шаг
                {
                    *hl = 4; // Шаг
                    hl++; hl++; *hl = [&city1Enemy + 22 * 4]; // Спрайт
                    hl++; *hl = 0; // Тип спрайта
                }
                else if (c & 1) // Шаг
                {
                    *hl = 2; // Шаг
                    hl++; hl++; *hl = [&city1Enemy + 20 * 4]; // Спрайт
                    hl++; *hl = 0; // Тип спрайта
                }
                else
                {
                    *hl = 1; // Шаг
                    hl++; hl++; *hl = [&city1Enemy + 18 * 4]; // Спрайт
                    hl++; *hl = 0; // Тип спрайта
                }
            }
            else
            {
                hl++;
                c = *hl;
                if (c & 4) // Шаг
                {
                    *hl = 0; // Шаг
                    hl++; hl++; *hl = [&city1Enemy + 11 * 4]; // Спрайт
                    hl++; *hl = 0; // Тип спрайта
                }
                else
                if (c & 2)
                {
                    *hl = 4; // Шаг
                    hl++; hl++; *hl = [&city1Enemy + 13 * 4]; // Спрайт
                    hl++; *hl = 0; // Тип спрайта
                }
                else if(c & 1)
                {
                    *hl = 2; // Шаг
                    hl++; a = *hl; // Позиция
                    a--;
                    *hl = a; // Позиция
                    hl++; *hl = [&city1Enemy + 15 * 4]; // Спрайт
                    hl++; *hl = 0; // Тип спрайта
                }
                else
                {
                    *hl = 1; // Шаг
                    hl++; hl++; *hl = [&city1Enemy + 10 * 4]; // Спрайт
                    hl++; *hl = 1; // Тип спрайта
                }
            }
            hl++;
        }
        else
        {
continue1:
            hl += de; // Следующий NPC
        }
    } while(flag_nz --b);
}

void clearRoad()
{
    hl = &city1Map;
    l = a = cityScrollX;
    h = ((a = h) += cityRoadY);
    a = 0;
    c = 4;
    do
    {
        d = l;
        b = viewWidth;
        do
        {
            if (a != *hl)
                 *hl = a;
            l++;
        } while(--b);
        l = d;
        h++;
        --c;
    } while(flag_nz);
}

void processPlayer()
{
    // Чтение клавиши
    b = a = keyPressed;
    a = cityPlayerX;
    if (b & KEY_LEFT)
    {
        a -= 1;
        if (flag_c) goto playerStop;

        cityPlayerX = a;
        if (a >= [viewWidth / 2]) if (a < [mapWidth - viewWidth / 2 + 1]) { cityScrollX = (a -= [viewWidth / 2]); }
        cityPlayerD = a = 0;

        a = cityPlayerSprite;
        hl = [&city1Enemy + 0x100];
        if (a == l) hl = [&city1Enemy + 4 + 0x200];
        cityPlayerSprite = hl;
        return;
    }

    if (b & KEY_RIGHT)
    {
        a += 1;
        if (flag_c) goto playerStop;

        cityPlayerX = a;
        if (a >= [viewWidth / 2]) if (a < [mapWidth - viewWidth / 2 + 1]) { cityScrollX = (a -= [viewWidth / 2]); }
        cityPlayerD = a = 1;

        a = cityPlayerSprite;
        hl = [&city1Enemy + 20 + 0x100];
        if (a == l) hl = [&city1Enemy + 24];
        cityPlayerSprite = hl;
        return;
    }

playerStop:
    a = cityPlayerD;
    hl = [&city1Enemy + 0x100];
    if (a & 1) hl = [&city1Enemy + 20 + 0x100];
    cityPlayerSprite = hl;
}

void drawCharacter(e, ix)
{
    // Рисуем
    d = [(&city1Map >> 8) + cityRoadY];
    e = a;
    a = ixl;
    *de = a; a++; d++;
    *de = a; a++; d++;
    *de = a; a++; d++;
    *de = a;
    if (b & 1) return;
    a += 4; e++;
    *de = a; a--; d--;
    *de = a; a--; d--;
    *de = a; a--; d--;
    *de = a;
}

void cityRedraw()
{
    // Оценка времени
    startFrame = a = frame;

    // Очистка дороги от нарисованных жителей и игрока
    clearRoad();

    // Рисование жителей
    /*
    hl = [&npc + npc_position];
    b = a = npcCount;
    c = a = cityScrollX;
    de = npc_sizeof;
    do
    {
        // Если спрайт за экраном, то не рисуем его
        if (((a = *hl) -= c) < viewWidth)
        {
            hl++; ixl = a = *hl; // Спрайт
            hl++; ixh = a = *hl; // Тип спрайта
            hl--; hl--; a = *hl; // Положение
            ex(bc, de, hl);
            b = ixh;
            drawCharacter(a, b, ixl);
            ex(bc, de, hl);
        }
        hl += de;
    } while(--b);

    // Рисование игрока
    a = cityPlayerX;
    bc = cityPlayerSprite;
    if (b & 2) a--;
    ixl = c;
    drawCharacter(a, b, ixl);
   */

    // Ждем, если активная страница еще не стала видимой
    while ((a = videoPage) & 1);

    // const npc_timer      = 0;
    // const npc_direction  = 1;
    // const npc_step       = 2;
    // const npc_position   = 3;
    // const npc_sprite     = 4;
    // const npc_spriteType = 5;
    // const npc_sizeof     = 6;

    a = videoPage;
    if (a & 8) ixh = [screenAddr1 >> 8];
          else ixh = [screenAddr2 >> 8];

    // Спрайты
    hl = [&npc + npc_position];
    b = a = npcCount;
    c = a = cityScrollX;
    de = npc_sizeof;
    do
    {
        // Если спрайт за экраном, то не рисуем его
        if (((a = *hl) -= c) < viewWidth)
        {
            ixl = a; // position
            hl++; a = *hl; // npc_sprite
            ex(a, a);
            hl++; a = *hl; hl--; hl--; // npc_spriteType
            ex(a, a);
            ex(bc, de, hl);
            h = [&city1Tails >> 8];
            l = a;
            b = cityRoadY;
            c = ixl;
            drawSprite();
            ex(a, a);
            if(flag_nc a >>= 1) drawSpriteRight();
            ex(bc, de, hl);
        }
        hl += de;
    } while(--b);

    // Рисование игрока
    b = cityRoadY;
    c = ((a = cityPlayerX) -= c);
    hl = cityPlayerSprite;
    a = h;
    if (a & 2) c--;
    h = [&city1Tails >> 8];
    ex(a, a);
    drawSprite(bc, de, hl);
    ex(a, a);
    if (flag_nc a >>= 1) drawSpriteRight(bc, de, hl);

    // Адрес карты / источник
    d` = [&city1Map >> 8];
    e` = a = cityScrollX;
    b` = e`;

    // Адрес видеостраницы / назначение
    a = videoPage;
    if (a & 8)
    {
        hl` = [cacheAddr1 - 1];
        ex(bc, de, hl);
        de = screenAddr1;
        bc = screenAttrAddr1;
    }
    else
    {
        hl` = [cacheAddr2 - 1];
        ex(bc, de, hl);
        de = screenAddr2;
        bc = screenAttrAddr2;
    }

    // Цикл строк
    ixh = viewHeight;
    do
    {
        // Сохранение адреса вывода
        iyl = e;
        iyh = d;

        // Цикл стобцов
        ixl = viewWidth;
        do
        {
optimize0:  // Чтение номера тейла из карты уровня
            ex(bc, de, hl);
            hl`++;
            c` = *hl;
            a = *de`;
            if (a == c`) goto optimize1;
            if (flag_z c`++) goto optimize3;
            e`++;
            *hl` = a;
            ex(bc, de, hl);

            // Вычисление адреса тейла
            h = [&city1Tails >> 8];
            l = a;

            // Вывод на экран
            a = *hl; h++; *de = a; d++;
            a = *hl; h++; *de = a; d++;
            a = *hl; h++; *de = a; d++;
            a = *hl; h++; *de = a; d++;
            a = *hl; h++; *de = a; d++;
            a = *hl; h++; *de = a; d++;
            a = *hl; h++; *de = a; d++;
            a = *hl; h++; *de = a;
            a = *hl;      *bc = a; bc++;

            d = iyh;
            e++;
            ixl--;
        } while(flag_nz);
optimize2:

        // Следующая строка карты
        ex(bc, de, hl);
        e` = b`;
        d`++;
        ex(bc, de, hl);

        // Адрес следующей чб строки на экране
        e = ((a = iyl) += 0x20);
        if (flag_c) d = ((a = d) += 0x08);

        ixh--;
    } while(flag_nz);

    // Переключить видеостраницы во время следующего прерывания
    videoPage = ((a = videoPage) ^= 8 |= 1);

    // Оценка времени
    printDelay((a = frame) -= *(hl = &startFrame));

    return;
optimize3:
    *hl` = a = 254;
optimize1:
    e`++;
    ex(bc, de, hl);
    bc++;
    e++;
    ixl--;
    if(flag_nz) goto optimize0;
    goto optimize2;
}

// Вывод спрайта
// c - координата X
// b - координата Y
// hl - спрайт
// d - тип

uint16_t drawSprite_a;
uint16_t drawSprite_b;

void drawSprite(bc, de, hl)
{
    // Вычисление координаты
    //       43210    43210
    // de .1.43... 210.....
    // bc .1.11.43 210.....
    d = (((a = b) &= 0x18) |= ixh);
    a = b;
    a >>r= 1 >>r= 1 >>r= 1;
    b = a;
    c = e = ((a &= 0xE0) |= c);
    b = ((((a = b) &= 0x03) |= 0x18) |= ixh);

    drawSprite_a = bc;
    drawSprite_b = de;

drawSprite_1:
    drawSprite1(bc, de, hl);
    c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    drawSprite1(bc, de, hl);
    c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    drawSprite1(bc, de, hl);
    c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    drawSprite1(bc, de, hl);
}

void drawSpriteRight(bc, de, hl)
{
    bc = drawSprite_a;
    de = drawSprite_b;
    c++; e++;
    if (flag_nz (a = e) &= 0x1F) goto drawSprite_1;
}

void drawSprite1(de, bc, hl)
{
    // Вывод на экран
    ixl = d; // 8
    push(hl);
    a = *hl; h++; *de = a; d++; // 22*7
    a = *hl; h++; *de = a; d++;
    a = *hl; h++; *de = a; d++;
    a = *hl; h++; *de = a; d++;
    a = *hl; h++; *de = a; d++;
    a = *hl; h++; *de = a; d++;
    a = *hl; h++; *de = a; d++;
    a = *hl; h++; *de = a; // 18
    a = *hl; h++; *bc = a; // 14
    b++; b++; b++; *bc = a = 0xFF; b--; b--; b--; // Перерисовать
    pop(hl);
    l++;
    d = ixl; // 8
} // total 202

void printDelay(a)
{
    push(a)
    {
        // Активная видеостраница
        a = videoPage;
        hl = [screenAddr1 + 0x10E0];
        if (a & PORT_7FFD_SECOND_VIDEO_PAGE)
            hl = [screenAddr2 + 0x10E0];

        // Очиска
        push (hl)
        {
            fillRect(hl, bc = 0x0101);
        }
    }
    a += '0';
    drawCharSub(hl, a);
}

// b - высота, c - ширина,

void fillRect(hl, bc)
{
    do
    {
        push(bc)
        {
            a ^= a;
            d = 8;
            e = l;
            do
            {
                b = c;
                do
                {
                    *hl = a;
                    l++;
                } while(--b);
                l = e;
                h++;
                d--;
            } while(flag_nz);

            // Адрес следующей строки
            hl += (de = [0x20 - 0x800]);
            a = h;
            a &= 7;
            if (flag_nz) fillRectAddLine();
        }
    } while(--b);
    return;
}

void fillRectAddLine()
{
    hl += (de = [0x800 - 0x100]);
    return;
}
