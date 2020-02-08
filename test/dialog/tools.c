#counter 7000

void getItemOfArray8()
{
    l = (a += l);
    h = ((a +@= h) -= l);
    a = *hl;
}

void getItemOfArray16()
{
    push(a)
    {
        l = ((a += a) += l);
        h = ((a +@= h) -= l);
        a = *hl; hl++; h = *hl; l = a;
    }
}

// b - указывает на максимальное кол-во копируемых символов, размер буфера должен быть на 1 байт больше.

void strcpyn(hl, de, b)
{
    do
    {
        a = *de; de++;
        if (a == 0) break;
        *hl = a; hl++;
    } while(--b);
    *hl = 0;
}

void numberToString16(hl, de)
{
    *[&uint16_to_str_addr + 1] = hl;

    // Терминатор
    a ^= a;
    push(a);

    // Разделение числа на цифры
    ex(hl, de);
    do
    {
        div16(hl, de = 10);
        (a = e) += '0';
        push(a);
    } while (flag_nz (a = h) |= l);

    // Вывод в строку
uint16_to_str_addr:
    de = 0;
    do
    {
        pop(a);
        *de = a; de++;
    } while(flag_nz a |= a);
    de--;
    hl = de;
}

// Умножение HL на DE, результат в HL. BC портить нельзя

void mul16()
{
    bc = hl;
    hl = 0;
    a = 17;
    while()
    {
        a--;
        if (flag_z) return;
        hl += hl;
        ex(hl, de);
        if (flag_c)
        {
            hl += hl;
            hl++;
        }
        else
        {
            hl += hl;
        }
        ex(hl, de);
        if (flag_nc) continue;
        hl += bc;
        if (flag_nc) continue;
        de++;
    }
}

// Добавить элемент в конец массива uint8_t[]
//
// Вход:
//   de - адрес начала массива
//   hl - адрес, где хранится длинна массива
//   c  - максимальное кол-во элементов в массиве
// Выход:
//   z  - В массиве нет места

void addElement(de, hl, c, a)
{
    b = a;
    a = *hl;
    if (a == c) return; // z
    (*hl)++;
    l = (a += e); h = ((a +@= d) -= l);
    *hl = b;
    ++(a ^= a); // return nz
}

// Удалить элемент из массива
//
// Вход:
//   de - адрес начала массива
//   hl - адрес, где хранится длинна массива
//   c  - максимальное кол-во элементов в массиве
// Выход:
//   z  - В массиве нет места

void removeElement(de, hl, a)
{
    (*hl)--;
removeElement2:
    b = a;
    e = (a += e); d = ((a +@= d) -= e); // de += a
    (a = *hl) -= b;
    if (flag_z) return;
    b = 0; c = a;
    hl = de;
    hl++;
    ldir();
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
    l++;
    c++;
}

void drawSprite4(bc, hl, de)
{
    drawSprite2(bc, hl, de);
    drawSprite2(bc, hl, de);
    l = ((a = l) += [0x20 - 2]); c = l;
    if (flag_c) { b = ((a = b) += 8); h++; }
    drawSprite2(bc, hl, de);
    drawSprite2(bc, hl, de);
}

void drawSpriteXor(de, bc, hl, ixh)
{
    a = *de; de++; *hl = (a ^= *hl); h++;
    a = *de; de++; *hl = (a ^= *hl); h++;
    a = *de; de++; *hl = (a ^= *hl); h++;
    a = *de; de++; *hl = (a ^= *hl); h++;
    a = *de; de++; *hl = (a ^= *hl); h++;
    a = *de; de++; *hl = (a ^= *hl); h++;
    a = *de; de++; *hl = (a ^= *hl); h++;
    a = *de; de++; *hl = (a ^= *hl);
    h = ((a = h) -= 7);
    l++;
    *bc = a = ixh; de++;
    bc++;
}

void drawTextRight(hl, de, a)
{
    push(a)
    {
        push(hl, de)
        {
            gMeasureText(de); // Вход: de - текст. Выход: de - текст, a - терминатор, c - ширина в пикселях. Портит: b, hl.
        }
        l = ((a = l) -= c);
    }
    gDrawTextEx(hl, de, a);
}
