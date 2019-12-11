const int KEY_UP = 1;
const int KEY_DOWN = 2;
const int KEY_LEFT = 4;
const int KEY_RIGHT = 8;
const int KEY_FIRE = 16;

// 3 - фиолетовый

const int colorCursor = 0x43;
const int colorText   = 0x47;
const int colorItem   = 0x45;
const int colorPrice  = 0x44;

uint16_t shopText;
uint16_t shopGetLine;
uint8_t shopX;
uint8_t shopY;
uint8_t shopW;
uint8_t shopH;
const int shopLineHeight = 10;
uint16_t dialogCursor;
uint8_t dialogX;
uint8_t dialogX1;

//---------------------------------------------------------------------------------------------------------------------
// Вход: ix - функция динамического текста, iyh - режим, de - указатель на текст
// Вход: de - указатель на следующий текст, iyh - новый режим
// Сохраняет: hl, ix, iyl

void shopNextLine()
{
    // Вывод статического текста
    if (flag_z (a = iyh) & 0x80)
    {
        do { a = *de; de++; } while(a >= 32);
        if (flag_nz a |= a) return; // nz
        // Переход к динамическому тексту
        iyh = 0x80;
    }
    // Вывод динамического текста
    if (flag_z a |= ixl) return; // z
    (a = iyh) &= 0x7F; iyh++;
    push(hl)
    {
        callIx(); // Вход: a - номер. Выход: hl - текст. Портит: a, bc, de
        ex(hl, de);
    }
    (a = d) |= e; // return z/nz
}

//---------------------------------------------------------------------------------------------------------------------
// Алгоритм диалога

const int tailSize = 8;
const int shopTopPadding = 4;
const int shopAnswerSeparatorHeight = 4;

void shopStart(de, ix)
{
    shopText = de;
    shopGetLine = ix;

    // ВЫЧИСЛЕНИЕ РАЗМЕРА

    ex(bc, de, hl);
    hl` = 0; // h` - ширина цен, l` - ширина товаров
    ex(bc, de, hl);
    hl = shopTopPadding; // h - ширина назчаний, l - высота всех элементов
    iy = 0; // iyl - режим ответов, iyh - режим динамического текста
    // de - указатель на текст
    do
    {
        push(de)
        {
            push(hl)
            {
                gMeasureText(); // Вход: de - текст. Выход: de - текст, a - терминатор, c - ширина в пикселях. Портит: b, hl.
            }

            ex(a); // Сохраняем термиатор
            a = c;
            if (flag_nz (a |= a))
            {
                a += iyl; // Добавляем отступ ответов
                ex(a);
                if (a == 9) // Если есть цена
                {
                    ex(bc, de, hl);
                    ex(a);
                    if (a >= l`) l` = a;  // Вычисляем максимальную ширину
                    ex(bc, de, hl);

                    push(hl)
                    {
                        gMeasureText();
                    }
                    // Учет ширины и высоты

                    ex(a); // Сохраняем термиатор
                    a = c;
                    ex(bc, de, hl);
                    if (a >= h`) h` = a;  // Вычисляем максимальную ширину
                    ex(bc, de, hl);
                }
                else
                {
                    ex(a);
                    if (a >= h) h = a; // Вычисляем максимальную ширину
                }
                l = ((a = l) += shopLineHeight); // Вычисляем высоту
            }
            ex(a);

            // Если строка оканчивается кодом 13, то далее идут ответы
            if (a == 13)
            {
                iyl = tailSize; // Отступ для ответов
                l = ((a = l) += [shopAnswerSeparatorHeight]); // Отступ ответов. Это примерно половина высота строки. Это гарантирует отсутсвтие клешинга.
            }
        }

        // Следующая строка
        shopNextLine();
    } while(flag_nz);

    // Преобразование пикселей в знакоместа
    ex(bc, de, hl);
    a = h`;
    if (flag_nz a |= a) a += tailSize; // Если есть цена, то добавляем разделитель в одно знакоместо между наименованием и ценой.
    a += l`; // Суммируем ширину наименований и цен
    ex(bc, de, hl);
    if (a < h) a = h;

    h = ((a += 7) >>= 3); shopW = a; // Преобразуем в знакоместа
    l = (((a = l) += 7) >>= 3); shopH = a; // Преобразуем в знакоместа
    shopX = (((a = [32 - 2]) -= h) >>= 1); // Вычисляем положение диалога
    shopY = (((a = [20 - 3]) -= l) >>= 1);

    // РИСОВАНИЕ

    // Выбираем активной видеостраницей невидимую и очищаем экран.
    beginDraw();
    cityDraw();

    // Рисуем рамку
    hl = shopX; // И за одно shopY
    calcAddr(); // bc - чб, hl = цвет
    iy = shopW; // И за одно shopH
    drawDialog2(de = &dialog_0, bc, hl, iyl);
    do
    {
        drawDialog2(de = &dialog_3, bc, hl, iyl);
    } while(flag_nz --iyh);
    drawDialog2(de = &dialog_6, bc, hl, iyl);
    drawSprite2(bc, de, hl);

    *[&shopStartColor + 1] = a = colorText;
    // Рисуем текст
    ix = shopGetLine;  // ix - функция динамического текста
    de = shopText;     // de - статический текст
    hl = shopX;        // hl - Координаты для вывода текста в знакоместах
    (((hl += hl) += hl) += hl) += (bc = [(tailSize + shopTopPadding) * 256 + tailSize]); // Вычисляем координаты в внутри рамки в пикселях
    dialogCursor = hl; // hl - координаты первого ответа (что бы не было глюка, если программист забудет в диалоге описать варианты ответов)
    iy = 0;            // iyl - кол-во ответов, iyh - режим динамического текста
    do
    {
        a = *de;
        if (a >= ' ')
        {
            push(de)
            {
                push(hl)
                {
    shopStartColor: a = colorText;
                    gDrawTextEx(hl, de, a); // Выводим наименование
                }
                if (a == 9)
                {
                    push(hl)
                    {
                        push(de, hl)
                        {
                            gMeasureText(); // Вычисляем ширину цены, что бы прижать её к правому краю
                        }
                        l = a = shopW;
                        (a = shopX) += l;
                        a++;
                        a <<= 3;
                        l = (a -= c);
                        gDrawTextEx(hl, de, a = colorPrice); // Выводим цену
                    }
                }
            }
            hl += (bc = [shopLineHeight * 256]);
        }
        if (a == 13)
        {
            h = ((a = h) += shopAnswerSeparatorHeight); // Если есть цена, то добавляем разделитель в одно знакоместо между наименованием и ценой.
            dialogCursor = hl; // Координаты первого ответа
            l = ((a = l) += tailSize); // Отступ для ответов
            iyl = -1; // Сброс счетчика кол-ва ответов
            *[&shopStartColor + 1] = a = colorItem;
        }
        iyl++; // Счетчик кол-ва ответов
        shopNextLine();
    } while(flag_nz);

    // Начальное положение курсора
    dialogX = (a ^= a);
    dialogX1 = a;

    // Рисуем курсор
    dialogDrawCursor();

    // Выводим на экран
    endDraw();

    // Клавиатура
    while()
    {
continue:
        // Ждем, если прошло меньше 1/50 сек с прошлого цикла.
        while ((a = gVideoPage) & 1);
        gVideoPage = (a |= 1);

        // Получить нажатую клавишу
        hl = &gKeyTrigger;
        b = *hl;
        *hl = 0;

        // Нажат выстрел
        if (b & KEY_FIRE)
        {
            // Отмечаем, что весь экран нужно перерисовать и выходим
            cityFullRedraw();
            a = dialogX;
            return;
        }

        // Перемещение курсора
        a = dialogX;
        if (b & KEY_UP)
        {
            a -= 1;
            if (flag_c) goto continue;
        }
        else if (b & KEY_DOWN)
        {
            a++;
            if (a >= iyl) goto continue;
        }
        dialogX = a;

        // Умножение на 10
        c = (a += a);
        ((a += a) += a) += c;

        // Плавное перемещение курсора
        hl = &dialogX1;
        b = *hl;
        if (a == b) goto continue; // Оставит флаг CF при выполнении dialogX1 - menuX
        b++; // Не изменяет CF
        if (flag_c) ----b;

        // Стираем прошлый курсор
        push(bc);
        dialogDrawCursor();
        pop(bc);

        // Сохраняем новые координаты курсора
        *(hl = &dialogX1) = b;

        // Рисуем курсор
        dialogDrawCursor();
    }
}

void dialogDrawCursor()
{
    hl = dialogCursor;
    h = ((a = dialogX1) += h);
    gDrawTextEx(hl, de = "@", a = colorCursor);
}

void drawDialog2()
{
    push(bc, hl)
    {
        drawSprite2();
        a = iyl;
        ixh = d; ixl = e;
        do
        {
            ex(a);
            d = ixh; e = ixl;
            drawSprite2();
            ex(a);
        } while(flag_nz --a);
        drawSprite2();
    }
    // Следующая строка
    l = ((a = l) += 32); h = ((a +@= h) -= l);
    c = ((a = c) += 32); if (flag_c) b = ((a = b) += 8);
}

void drawSprite2(de, bc, hl)
{
    *bc = a = *de; de++; b++;
    *bc = a = *de; de++; b++;
    *bc = a = *de; de++; b++;
    *bc = a = *de; de++; b++;
    *bc = a = *de; de++; b++;
    *bc = a = *de; de++; b++;
    *bc = a = *de; de++; b++;
    *bc = a = *de; de++;
    *hl = a = *de; de++;
    b = ((a = b) -= 7);
    hl++;
    c++;
}

// Вход:
//   l - x
//   h - y
//   hl - цветной адрес
//   bc - чб адрес

void calcAddr()
{
    //        43210     43210
    // bc  .1.43...  210.....
    // hl  .1.11.43  210.....
    b = (((a = h) &= 0x18) |= 0x40);
    h = ((a = h) >>r= 3);
    c = l = ((a &= 0xE0) |= l);
    h = (((a = h) &= 0x03) |= 0x58);

    if (flag_z (a = gVideoPage) & 0x80) return;
    h |= 0x80;
    b |= 0x80;
}
