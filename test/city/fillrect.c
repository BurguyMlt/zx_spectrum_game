#counter 3000

void fillRect(hl, bc)
{
    ixl = b;
    do
    {
        a ^= a;
        d = h; e = l;
        b = c;
        do
        {
            *hl = a; h++;
            *hl = a; h++;
            *hl = a; h++;
            *hl = a; h++;
            *hl = a; h++;
            *hl = a; h++;
            *hl = a; h++;
            *hl = a; h = d;
            l++;
        } while(--b);

        // Адрес следующей строки
        l = ((a = e) += 32);
        if (flag_c) h = ((a = h) += 8);
    } while(flag_nz --ixl);
}
