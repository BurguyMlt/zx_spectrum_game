#counter 7000

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

void getItemOfArray8()
{
    l = (a += l);
    h = ((a +@= h) -= l);
    a = *hl;
}
