#counter 2000

const int KEY_UP = 1;
const int KEY_DOWN = 2;
const int KEY_LEFT = 4;
const int KEY_RIGHT = 8;
const int KEY_FIRE = 16;

const int PORT_7FFD_SECOND_VIDEO_PAGE = 8;

const int screenAddr1 = 0x4000;
const int screenAddr2 = 0xC000;
const int screenWidth = 256;
const int screenHeight = 192;
const int screenBwSize = screenWidth / 8 * screenHeight;
const int screenAttrSize = screenWidth / 8 * screenHeight / 8;
const int screenAttrAddr1 = screenAddr1 + screenBwSize;
const int screenAttrAddr2 = screenAddr2 + screenBwSize;
const int screenEndAddr1 = screenAttrAddr1 + screenAttrSize;
const int screenEndAddr2 = screenAttrAddr2 + screenAttrSize;
const int cacheAddr1 = screenEndAddr1;
const int cacheAddr2 = screenEndAddr2;
const int unusedTailCode = 0xFF;
const int viewWidth = 32;
const int viewHeight = 20;
const int cityRoadY = 13;
const int mapWidth = 256;

const int npc_timer           = 0;
const int npc_flags           = 1;
const int npc_flags_direction = 0x01;
const int npc_flags_type      = 0x02;
const int npc_step            = 2;
const int npc_position        = 3;
const int npc_sizeof          = 4;

const int npc_maxCount = 16;
const int npc_defaultSpeed = 7;

uint8_t cityPlayerX = 0;
uint8_t cityScrollX = 0;
uint8_t cityPlayerDirection = 0;
uint16_t cityPlayerSprite = &city1s_0;
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

//----------------------------------------------------------------------------------------------------------------------
// Инициализация жителей

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
        rand();
        ix[npc_position] = a;
        ix[npc_flags] = (a &= [npc_flags_direction | npc_flags_type]);
        ix += de;
    } while(--b);
}

//----------------------------------------------------------------------------------------------------------------------
// Перемещение и анимация жителей.

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
                //a = ix[npc_spriteType];
                //if (a == 1)
                //{
                    *hl = 255;
                    goto continue1;
                //}
            }

            // У всех разная скорость
            *hl = (((a = b) &= 7) += npc_defaultSpeed);

            if (flag_z a--) // Внезапный поворот
            {
                hl++;
                a = *hl;
                a ^= npc_flags_direction;
                *hl = a;
                hl--;
            }

            hl++;
            if (*hl & npc_flags_direction) // Направление
            {
                hl++;
                a = *hl;
                a++;
                if (a >= 4) { a = 0; hl++; ++*hl; hl--; }
                *hl = a;
            }
            else
            {
                hl++;
                a = *hl;
                a++;
                if (a >= 4) { a = 0; hl++; --*hl; hl--; }
                *hl = a;
            }
            hl++; hl++;
        }
        else
        {
continue1:
            hl += de; // Следующий NPC
        }
    } while(flag_nz --b);
}

//----------------------------------------------------------------------------------------------------------------------
// Вход: hl - должно указывать на npc_position
// Выход: hl - адрес спрайта
// Портит: a

// const int npc_timer      = 0;
// const int npc_direction  = 1;
// const int npc_step       = 2;
// const int npc_position   = 3;
// const int npc_sprite_l   = 4;
// const int npc_sprite_h   = 5;
// const int npc_sizeof     = 6;

void getNpcSprite(hl)
{
    // Вычисление номера спрайта
    hl--;
    hl--;
    a = *hl; // npc_direction + npc_type
    a += a;
    a += a;
    hl++;
    a += *hl; // npc_step

    // Получение элемента массива
    l = ((a += a) += &sprite_citizen);
    h = ((a +@= [&sprite_citizen >> 8]) -= l);
    a = *hl; hl++; h = *hl; l = a;
}

uint16_t sprite_citizen[16] =
{
    &city1s_15, &city1s_16, &city1s_17, &city1s_14,
    &city1s_21, &city1s_20, &city1s_19, &city1s_18,

    &city1s_9,  &city1s_8,  &city1s_7,  &city1s_6,
    &city1s_10, &city1s_11, &city1s_12, &city1s_13
};

//----------------------------------------------------------------------------------------------------------------------
// Управление игроком и анимация игрока.

const int sprite_raistlin_left       = &city1s_0;
const int sprite_raistlin_left_step  = &city1s_1;
const int sprite_raistlin_right      = &city1s_3;
const int sprite_raistlin_right_step = &city1s_4;

void processPlayer()
{
    b = a = keyPressed;
    c = a = cityPlayerDirection;
    a = cityPlayerX;
    if (b & KEY_LEFT)
    {
        if (c & 1)
        {            
            cityPlayerDirection = (a ^= a);
            c = a;
        }
        else
        {
            a -= 1;
            if (flag_nc)
            {
                cityPlayerX = a;

                // Прокрутка экрана
                a -= [viewWidth / 2]; if (flag_nc) if (a < [mapWidth - viewWidth / 2 * 2 + 1]) { cityScrollX = a; } //! Почему нельзя без {} ?

                hl = sprite_raistlin_left;
                if ((a = cityPlayerSprite) == l) hl = sprite_raistlin_left_step;
                cityPlayerSprite = hl;
                return;
            }
        }
    }
    else if (b & KEY_RIGHT)
    {
        if (flag_z c & 1)
        {
            cityPlayerDirection = (a = 1);
            c = a;
        }
        else
        {
            a += 1;
            if (flag_nc)
            {
                cityPlayerX = a;

                // Прокрутка экрана
                a -= [viewWidth / 2]; if (flag_nc) if (a < [mapWidth - viewWidth / 2 * 2 + 1]) { cityScrollX = a; }  //! Почему нельзя без {} ?

                hl = sprite_raistlin_right;
                if ((a = cityPlayerSprite) == l) hl = sprite_raistlin_right_step;
                cityPlayerSprite = hl;
                return;
            }
        }
    }

    // Убираем анимацию шага, если ни одна клавиша не нажата
    hl = sprite_raistlin_left;
    if (c & 1) hl = sprite_raistlin_right;
    cityPlayerSprite = hl;
}

//----------------------------------------------------------------------------------------------------------------------

void cityRedraw()
{
    // Оценка времени
    startFrame = a = frame;

    // Ждем, если активная страница еще не стала видимой
    while ((a = videoPage) & 1);

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

    drawSprites();

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

void drawSprites()
{
    a = videoPage;
    if (a & 8) ixh = [screenAddr1 >> 8];
          else ixh = [screenAddr2 >> 8];

    // const int npc_timer      = 0;
    // const int npc_direction  = 1;
    // const int npc_step       = 2;
    // const int npc_position   = 3;
    // const int npc_sprite_l   = 4;
    // const int npc_sprite_h   = 5;
    // const int npc_sizeof     = 6;

    // Спрайты
    hl = [&npc + npc_position];
    b = a = npcCount;
    c = (a = cityScrollX); c--;
    de = npc_sizeof;
    do
    {
        // Если спрайт за экраном, то не рисуем его
        if (((a = *hl) -= c) < [viewWidth + 1]) //! для const int можно <=
        {
            push(bc, de, hl)
            {
                c = --a; // Для drawSprite

                // Цвет {
                a = b;
                while(a >= 14) a -= 14;
                if (a >= 7) a += [0x40 - 7]; a++;
                iyh = a;
                // }

                getNpcSprite(hl);
                b = cityRoadY;
                drawSprite();
            }
        }
        hl += de;
    } while(--b);

    // Рисование игрока
    b = cityRoadY;
    c++;
    c = ((a = cityPlayerX) -= c);
    hl = cityPlayerSprite;
    if ((a = l) == &city1s_1) c--;
    iyh = 0;
    drawSprite(bc, de, hl);
}

// Вывод спрайта
// c - координата X (от -1 до 31)
// b - координата Y (от 0 до 23)
// hl - спрайт

void drawSprite(bc, hl, ixh, iyh)
{
    // Читаем ширину спрайта
    d = *hl; l++;

    // Если спрайт за левым краем экрана
    if (c & 0x80) //! Можно оптимизировать
    do
    {
        l = ((a = l) += [4 * 9]);
        c++;
        d--;
        if (flag_z) return;
    } while (c & 0x80);

    // Если спрайт за правым краем экрана
    (a = viewWidth) -= c;
    if (flag_c) return;
    if (flag_z) return;
    if (a < d) d = a;
    iyl = d;

    // Вычисление координаты
    //       43210    43210
    // de .1.43... 210.....
    // bc .1.11.43 210.....
    d = (((a = b) &= 0x18) |= ixh);
    a = b;
    a >>r= 3;
    b = a;
    c = e = ((a &= 0xE0) |= c);
    b = ((((a = b) &= 0x03) |= 0x18) |= ixh);

    while()
    {
        push(bc, de)
        {
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
        iyl--;
        if (flag_z) return;
        c++;
        e++;
    };
}

void drawSprite1(de, bc, hl)
{
    ixl = d;
    *de = ((a = *de) |= *hl); l++; d++;
    *de = ((a = *de) |= *hl); l++; d++;
    *de = ((a = *de) |= *hl); l++; d++;
    *de = ((a = *de) |= *hl); l++; d++;
    *de = ((a = *de) |= *hl); l++; d++;
    *de = ((a = *de) |= *hl); l++; d++;
    *de = ((a = *de) |= *hl); l++; d++;
    *de = ((a = *de) |= *hl); l++;
    a = *hl; if (a == 0x45) a = iyh; *bc = a; l++;
    d = b; b++; b++; b++; *bc = a = 0xFE; b = d;

    // *de = a = *hl; l++; d++;
    // *de = a = *hl; l++; d++;
    // *de = a = *hl; l++; d++;
    // *de = a = *hl; l++; d++;
    // *de = a = *hl; l++; d++;
    // *de = a = *hl; l++; d++;
    // *de = a = *hl; l++; d++;
    // *de = a = *hl; l++;
    // *bc = a = *hl; l++;
    // d = b; b++; b++; b++; *bc = a = 0xFF; b = d;

    d = ixl;
}

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

void fillRectAddLine()
{
    hl += (de = [0x800 - 0x100]);
    return;
}
