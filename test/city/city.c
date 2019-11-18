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

uint8_t cityPlayerX = 0;

void cityInvalidate(hl)
{
    d = h; e = l; de++;
    *hl = unusedTailCode;
    bc = [viewWidth * viewHeight - 1];
    ldir();
}

void city()
{
    cityPlayerX = a = 0;

    // Очистка экрана
    out(bc = 0x7FFD, a = 7);
    clearScreenEx(hl = screenEndAddr2, d = 0x47);
    clearScreen(d = 0x47);

    // Инициализация кеша
    cityInvalidate(hl = cacheAddr1);
    cityInvalidate(hl = cacheAddr2);

    // Перерисовать
    cityRedraw();

    while()
    {
        readKey();

        // Чтение клавиши
        //hl = &keyTrigger;
        hl = &keyPressed;
        b = *hl;
        //*hl = 0;

        //
        a = cityPlayerX;
        if (b & KEY_LEFT)
        {
            cityPlayerX = --a;
            cityRedraw();
        }
        else if (b & KEY_RIGHT)
        {
            cityPlayerX = ++a;
            cityRedraw();
        }
    }
}

uint8_t startFrame;
uint8_t visibleVideoPageX;

void cityRedraw()
{
    // Адрес карты / источник
    de` = &levelMap; // Можно оптимизировать d` = [&levelMap >> 8], но не поддержвиает компилятор пока
    e` = a = cityPlayerX;
    b` = e`;

    // Ждем, если активная страница еще не стала видимой
    while ((a = visibleVideoPage) & 1);

    // Адрес видеостраницы / назначение
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

    // Оценка времени
    startFrame = a = frame;

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
            a = *de`;
            e`++;
            if (a == *hl`) goto optimize1;
            *hl` = a;
            ex(bc, de, hl);

            // Вычисление адреса тейла
            h = &levelTailsHigh;
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
    visibleVideoPage = ((a = visibleVideoPage) ^= 8 |= 1);

    // Оценка времени
    printDelay((a = frame) -= *(hl = &startFrame));

    return;
optimize1:
    ex(bc, de, hl);
    bc++;
    e++;
    ixl--;
    if(flag_nz) goto optimize0;
    goto optimize2;
}

uint8_t visibleVideoPage = 0;

void printDelay(a)
{
    push(a)
    {
        // Активная видеостраница
        a = visibleVideoPage;
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
