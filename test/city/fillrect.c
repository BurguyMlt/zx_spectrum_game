#counter 3000

void fillRect(hl, bc)
{
    do
    {
        push(bc)
        {
            a ^= a;
            d = 8;
            e = l;
            do
            {
                b = c;
                do
                {
                    *hl = a; l++;
                } while(--b);
                l = e;
                h++;
                d--;
            } while(flag_nz);

            // Адрес следующей строки
            hl += (de = [0x20 - 0x800]);
            a = h;
            a &= 7;
            if (flag_nz) fillRectAddLine();
        }
    } while(--b);
}
