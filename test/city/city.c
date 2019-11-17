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
    showVisibleVideoPage();
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

void cityRedraw()
{
    // Оценка времени
    startFrame = a = frame;

    // Адрес карты / источник
    de` = &levelMap; // Можно оптимизировать d` = [&levelMap >> 8], но не поддержвиает компилятор пока
    e` = a = cityPlayerX;
    b` = e`;

    // Адрес видеостраницы / назначение
    hl` = &visibleVideoPage;
    if (*hl` & PORT_7FFD_SECOND_VIDEO_PAGE)
    {
        *hl = 0;
        hl` = [cacheAddr1 - 1];
        ex(bc, de, hl);
        hl = screenAddr1;
        bc = screenAttrAddr1;
    }
    else
    {
        *hl` = PORT_7FFD_SECOND_VIDEO_PAGE;
        hl` = [cacheAddr2 - 1];
        ex(bc, de, hl);
        hl = screenAddr2;
        bc = screenAttrAddr2;
    }

    // Цикл строк
    ixh = viewHeight;
    do
    {
        push(hl);

        // Цикл стобцов
        ixl = viewWidth;
        do
        {
            push(hl);

            // Чтение номера тейла из карты уровня
            ex(bc, de, hl);
            hl`++;
            a = *de`;
            e`++;
            if (a == *hl`) // Можно потом оптимизировать на один переход
            {
                ex(bc, de, hl);
                bc++;
            }
            else
            {
                *hl` = a;
                ex(bc, de, hl);

                // Вычисление адреса тейла
                de = &levelTails; // Можно оптимизировать d = [&levelTails >> 8], но не поддержвиает компилятор пока
                e = a;

                // Вывод на экран
                a = *de; d++; *hl = a; h++;
                a = *de; d++; *hl = a; h++;
                a = *de; d++; *hl = a; h++;
                a = *de; d++; *hl = a; h++;
                a = *de; d++; *hl = a; h++;
                a = *de; d++; *hl = a; h++;
                a = *de; d++; *hl = a; h++;
                a = *de; d++; *hl = a;
                a = *de;      *bc = a; bc++;
            }

            pop(hl); // h был увеличен на 8
            l++;
            ixl--;
        } while(flag_nz);

        pop(hl);

        // Следующая строка карты
        ex(bc, de, hl);
        e` = b`;
        d`++;
        ex(bc, de, hl);

        // Адрес следующей чб строки на экране
        hl += (de = 0x20);
        if (h & 1) hl += (de = [0x800 - 0x100]);

        ixh--;
    } while(flag_nz);

    halt();
    showVisibleVideoPage();

    (a = frame) -= *(hl = &startFrame);
    printDelay(a);
}

uint8_t visibleVideoPage = 0;

void showVisibleVideoPage()
{
    a = visibleVideoPage;
    a |= 0x7;
    p7FFD = a;
    out(bc = 0x7FFD, a);
}

void printDelay(a)
{
    push(a)
    {
        a = visibleVideoPage;
        hl = [screenAddr1 + 0x10E0];
        if (a & PORT_7FFD_SECOND_VIDEO_PAGE)
            hl = [screenAddr2 + 0x10E0];

        push (hl)
        {
            fillRect(hl, bc = 0x0101);
        }
    }
    a += 48;
    drawCharSub(hl, a);
}
