#counter 5000

const int playerItemsMax = 5;
uint8_t playerItems[playerItemsMax] = { 0, 1, 2, -1, -1 };

void playerAddItem(a)
{
    c = a;
    hl = &playerItems;
    a = 0xFF;
    b = playerItemsMax;
    do {
        if (a == *hl)
        {
            *hl = c;
            return; // z
        }
        hl++;
    } while(--b);
    b--; // return nz
}

void playerRemoveItem(a)
{
    c = a;
    // Адрес удаляемого элемента de = &playerItems + a
    e = (a += &playerItems); d = ((a +@= [&playerItems >> 8]) -= e);
    // Адрес следующего за удаляемым элемента
    l = e; h = d; hl++;
    // Сдвигаем элементы, если есть что сдвигать
    (a = [playerItemsMax - 1]) -= c;
    if (flag_nz)
    {
        b = 0; c = a;
        ldir();
    }
    // Очищаем крайний элемент
    *de = a = 0xFF;
}
