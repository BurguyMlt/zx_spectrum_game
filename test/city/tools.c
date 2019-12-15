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
        if (flag_z a |= a) break;
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

// HL делится на DE, результат в HL, остаток в DE

void div16()
{
    ex(hl, de);
    if (flag_z (a = h) |= l) return; // Деление на ноль
    bc = 0;
    push(bc);
    do
    {
        (a = e) -= l;
        (a = d) -@= h;
        if (flag_c) break;
        push(hl);
        hl += hl;
    } while(flag_nc);
    hl = 0;
    while()
    {
        pop(bc);
        (a = b) |= c;
        if (flag_z) return;
        hl += hl;
        push(de);
        e = ((a = e) -= c);
        d = ((a = d) -@= b);
        if (flag_c)
        {
            pop(de);
            continue;
        }
        hl++;
        pop(bc);
    }
}
