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
        if (flag_z a |= a) goto strncpyBreak;
        *hl = a; hl++;
    } while(--b);
strncpyBreak:
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
}

