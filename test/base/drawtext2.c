// Вычисление ширины текста в пикселях
// Вход: DE - текст
// Выход: С - результат, A - последний символ, DE - адрес символа за последним символом
// Портит: HL

void measureText()
{
    c = 0;
    while()
    {
        a = *de; de++;
        if (a < ' ') return;

        // Вычисление адреса символа (de = image_font + a * 9)
        push(de)
        {
            calcCharAddr(); //  HL - адрес символа в знакогенераторе, DE - мусор
            hl += (de = 8);
            a = *hl;
            c = (a += c);
        }
    }
}

// Вычисление адреса символа
// Вход: A - символ
// Выход: HL - адрес символа в знакогенераторе
// Портит: DE

void calcCharAddr()
{
    a -= ' ';
    if (a >= 96) a -= 64;
    h = 0; l = a;
    d = h; e = l;
    (((hl += hl) += hl) += hl) += de;
    hl += (de = &image_font);
}

// Вывод текста по центру экрана
// Вход: DE - текст, H - строка

void drawTextCenter()
{
    ex(a, a);
    push(hl, de)
    {
        measureText();
        a = (((a = 256) -= c) >>= 1);
    }
    l = a;
    ex(a, a);
    drawTextEx();
}

// Вычисление адреса в видеопамяти и смещения в битах.
// Вход: H - коодината y, L - коодината x
// Выход: HL - адрес, C - смещение в битах
// Портит: A, B

void calcCoords()
{
    // Необходимо разместить Y в регистре HL следующим образом
    // ...76210 543.....

    c = ((a = l) &= 7); // Из координаты X получаем смещение в битах
    l >>= 3; //  Из координаты X смещение в байтах
    l = ((((a = h) <<= 2) &= 0xE0) |= l);
    b = (((a = h) >>= 3) &= 0x18);
    h = ((((a = h) &= 7) |= 0x40) |= b);
    h = (((a = gVideoPage) &= 0x80) |= h);
}

void drawTextEx()
{
    ex(a, a);
    calcCoords();
    ex(a, a);
    return drawTextSub();
}

void drawText()
{
    c = 0;
drawTextSub:
    ex(a, a);
    *[&drawTextS + 1] = hl;
    while ()
    {
        a = *de; de++;
        if (a < ' ') goto drawTextN;
        drawCharSub();
    }
drawTextN:
    push(a, bc, de, hl)
    {
        ex(hl, de);
drawTextS:
        hl = 0;

        // Две строки?
        if (flag_nz (a = h) &= 7) a = 1;
        b = a;

        // Преобразование адреса из чб в цвет
        d = (((a = h) >>= 3) &= 3);
        h = ((((a = h) &= 0xC0) |= 0x18) |= d);

        // Ширина
        (((a = e) -= l) &= 31);
        c++; if (flag_nz c--) a++;
        if (flag_nz a |= a)
        {
            c = a;

            // Цвет
            ex(a, a);

            // Первая строка
            push (bc, hl)
            {
                do
                {
                    *hl = a;
                    hl++;
                } while(flag_nz --c);
            }

            // Вторая строка
            if (flag_nz b & 1)
            {
                hl += (de = 32);
                do
                {
                    *hl = a;
                    hl++;
                } while(flag_nz --c);
            }
        }
    }
}

uint16_t drawTextTbl[] =
{
    0x0000, 0x0000, 0xE64F, 0x00FF,
    0x0F00, 0x0000, 0xE64F, 0x807F,
    0x0F0F, 0x0000, 0xE64F, 0xC03F,
    0x0F0F, 0x000F, 0xE64F, 0xE01F,
    0x0F0F, 0x0F0F, 0xE64F, 0xF00F,
    0x0707, 0x0700, 0xE64F, 0xF807,
    0x0707, 0x0000, 0xE64F, 0xFC03,
    0x0700, 0x0000, 0xE64F, 0xFE07
};

void drawCharSub()
{
    // Функция сохраняет DE
    push(de);

    // Вычисление адреса символа
    push(hl)
    {
        calcCharAddr(); // Вход A, выход HL, портит DE
        ex(hl, de);
    }

    push(hl, bc)
    {
        // Выбор одной из 8 подпрограмм рисования символа
        a = c;
        ex(bc, de, hl);
        l = ((((a += a) += a) += a) += &drawTextTbl);
        h = ((a +@= [&drawTextTbl >> 8]) -= l);
        de = &C1;
        bc = 7;
        ldir();
        de++; de++; de++;
        ldi();
        ex(bc, de, hl);

        b = 8;
        do
        {
            a = *de; // Половинка
C1:         nop(); nop(); nop(); nop();
            c = a;
            a &= 0;
            *hl = (a ^= *hl);
            a = 0; // Половинка
            a &= c;
            l++; // влево
            *hl = (a ^= *hl);
            l--; // вправо
            h++; // Цикл
            (a = h) &= 7;
            if (flag_z) drawCharNextLine();
            de++;
        } while(--b);
    }

    // Адрес вывода следующего символа на экране
    a = *de; // Ширина символа
    a += c; // Смещение в пикселях
    if (a >= 8) { a &= 7; l++; }
    c = a;

    // Функция сохраняет DE
    pop(de);
}

void drawCharNextLine()
{
    push(de)
    {
        hl += (de = [0x20 - 0x800]);
    }
    (a = h) &= 7;
    if (flag_z) return;
    push(de)
    {
        hl += (de = [0x800 - 0x100]);
    }
}
