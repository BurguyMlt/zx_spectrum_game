#counter 4000

const int gStringBufferSize = 32;

const int gPanelChangedMoney = 0x01;
const int gPanelChangedPlace = 0x02;

const int numberToString16max = 5;
const int playerItemsMax = 5;
const int playerLutMaxCountInLine = 99;
const int playerLutMax = 12;

uint8_t shopSel = 0;

//+ Добавить магазин амулетов

void playerAddItem(a)
{
    return addElement(de = &gPlayerItems, hl = &gPlayerItemsCount, c = playerItemsMax);
}


void playerRemoveItem(a)
{
    return removeElement(de = &gPlayerItems, hl = &gPlayerItemsCount, a);
}

// Вход: d - тип предмета

void playerAddLut(d)
{
    // Поиск этого предмета в кармане

    hl = &gPlayerLut;
    a = gPlayerLutCount;
    if (a != 0) // Если карман пуст, то не ищем
    {
        b = a; // Для while который замеится на djnz
        a = d; // Для ускорения поиска помещаем тип предмета в A
        do {
            if (a == *hl) // Найден предмет этого типа
            {
                hl += (de = playerLutMax);
                a = *hl; // Учеличиваем кол-во
                a++;
                if (a >= playerLutMaxCountInLine) a |= 0x80; // Исключаем из поиска
                return; // nz
            }
            hl++;
        } while(--b);

        // Если максимум ЛУТ-а, то выходим
        a = gPlayerLutCount;
        if (a == playerLutMax) return ; // Z - Нет места в кармане
    }

    gPlayerLutCount = ++a; // Тут получится флаг NZ

    // Создаем новую запись
    *hl = d;
    hl += (de = playerLutMax);
    *hl = 1;

    // return nz
}

// Вход: a - порядковый номер ЛУТ-а

void playerRemoveLut(a)
{
    push(a)
    {
        removeElement(de = &gPlayerLut, hl = &gPlayerLutCount, a);
    }
    return removeElement2(de = [&gPlayerLut + playerLutMax], hl = &gPlayerLutCount, a);
}

void setPlayerMoney(hl)
{
    gPlayerMoney = hl;
    hl = &gPanelChangedA;
    *hl |= gPanelChangedMoney;
    hl++;
    *hl |= gPanelChangedMoney;    
//panelRedraw:
//    return gFarCall(iyl = 7, ix = &gPanelRedraw);
}

//----------------------------------------------------------------------------------------------------------------------
// Названия всех заклинаний

const int itemsCount = 8;

uint16_t itemNames[itemsCount] = {
    "Отвар листьев",
    "Полное исцеление",
    "Заклинание 1",
    "Магические силы",
    "Каменная кожа",
    "Огонь бездны",
    "Порча",
    "Телепортация"
};

uint16_t lutNames[] = {
    "Кожа змеи",
    "Нож хобгоблина",
    "Ядовитый клык",
    "Кровь дракона",
    "Кислота",
    "Перья",
    "Слизь",
    "Копыта",
    "Кольчуга",
    "Изумруд",
    "Золотое руно",
    "Майоран"
};

uint16_t lutPrices[] = {
    1,
    2,
    3
};

uint16_t itemInfo[itemsCount] = {    
    "*", //"Восстанавливает 10 единиц здоровья\r",

    "*", //"Полностью восстанавливает здоровье\r",

    "*", //"Полностью восстанавливает\n"
    //"заклинание 1\r",

    "*", //"Полностью восстанавливает\n"
    //"все заклинания\r",

    "Это заклинание делает вашу\n"
    "плоть твердой как камень.\n"
    "Пока заклинание активно,\n"
    "урон уменьшается вдвое.",

    "*", //"Полностью восстанавливает амулет\r",

    "*", //"Пока заклинание активно,\n"
    //"каждая ваша атака наноит в\n"
    //"два раза больше урона врагу.\r",

    "*" //"Это заклинание возращает\n"
    //"Вас в последний посещенный\n"
    //"вами город.\r"
};

uint16_t itemPrices[itemsCount] = {
    10,
    20,
    30,
    40,
    50,
    60,
    70,
    80
};

//----------------------------------------------------------------------------------------------------------------------
// Сформировать строку во временном буфере с наименованием и ценой.
// de - имя
// hl - цена
// bc - разделитель

void shopMakeNamePrice(bc, de, hl)
{
    push(hl);
        push(bc);
            hl = &gStringBuffer;
            strcpyn(hl, b = [gStringBufferSize - 7 - numberToString16max - 1], de); // Запас для " за  ?\r" или "\t"
        pop(de);
        strcpyn(hl, b = 4, de);
    pop(de);
    numberToString16(hl, de);
    hl = &gStringBuffer;
}

//----------------------------------------------------------------------------------------------------------------------
// Сформировать строку во временном буфере с наименованием и ценой.
// de - имя
// hl - цена

void shopMakeNamePrice2()
{
    shopMakeNamePrice(bc = " за ");
    // hl - указатель на начало строки, de - указатель на терминатор строки
    // Добавляем строку
    push (hl)
    {
        ex(hl, de);
        strcpyn(hl, b = 3, de = " ?\r");
    }
}

//----------------------------------------------------------------------------------------------------------------------
// Главная страница магазина

void shopMain()
{
    shopStart(de =
        "Добрый день, чем я\n"
        "могу вам помочь?"
        "\r"
        "Мне пора идти\n"
        "Я хочу купить\n"
        "Я хочу продать\n"
        "Я хочу продать ЛУТ",
        ix = 0
    );
    if (flag_z a |= a) return; // Выход из магазина
    if (flag_z a--) return shopBuy();
    if (flag_z a--) return shopTrade();
    return shopTradeLut();
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с товарами для покупки

void shopBuy()
{
    shopStart(de =
        "Что вы хотите купить?"
        "\r"
        "Ничего",
        ix = &shopBuyGetText
    );
    if (flag_z a |= a) return shopMain();
    shopSel = (--a);
    return shopBuyItem();
}

// Вход: a - порядковый номер
// Выход: de - наименование, hl - цена продажи. Если нет предмета, то de = 0

void shopBuyGetNamePrice(a)
{
    hl = 0;
    de = 0;
    if (a >= itemsCount) return;
    getItemOfArray16(hl = &itemNames, a);
    ex(hl, de);
    getItemOfArray16(hl = &itemPrices, a);
}

void shopBuyGetText(a)
{
    shopBuyGetNamePrice(a);    
    if (flag_z (a ^= a) |= d) return;
    shopMakeNamePrice(bc = "\x09", hl, de);
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с подтверждением покупки

void shopBuyItem()
{
    shopStart(de =
        "Вы уверены, что хотите\n"
        "купить заклинание",
        ix = &shopBuyItemGetText
    );

    if (flag_z a |= a) return shopBuy();
    if (flag_nz a--) return shopBuyInfo();

    // Вычисление цены
    shopBuyGetNamePrice(a = shopSel);
    // hl - цена

    // Хватит ли денег?
    ex(hl, de);
    (hl = gPlayerMoney) -= de;
    if (flag_c) return shopBuyNoMoney();

    // Добавляем в карман
    playerAddItem(a = shopSel);
    if (flag_z) return shopBuyNoSpace();

    // Уменьшаем деньги
    shopBuyGetNamePrice(a = shopSel);
    // hl - цена
    ex(hl, de);
    (hl = gPlayerMoney) -= de;
    setPlayerMoney(hl);

    // Переход на главную страницу
    return shopAnyElseBuy();
}

void shopBuyItemGetText()
{
    if (flag_z a |= a)
    {
        shopBuyGetNamePrice(a = shopSel, de, hl);
        // de - наимерование, hl - цена
        shopMakeNamePrice2(hl, de); // Сформировать строку de + " за " + numberToString(hl) + " ?"
        return;
    }
    hl = "Нет";            if (flag_z a--) return;
    hl = "Да";             if (flag_z a--) return;
    hl = "Что это такое?"; if (flag_z a--) return;
    hl = 0;
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с информацией о товаре

void shopBuyInfo()
{
    getItemOfArray16(hl = &itemInfo, a = shopSel);
    ex(hl, de);
    shopStart(de, ix = &shopBuyInfoGetText);
    return shopBuyItem();
}

void shopBuyInfoGetText(a)
{
    hl = "\r"; if (flag_z a |= a) return;
    hl = "Ок"; if (flag_z a--) return;
    hl = 0;
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с товарами для продажи

void shopTrade()
{
    shopStart(de =
        "Что вы хотите продать?"
        "\r"
        "Ничего",
        ix = &stopTradeGetText
    );
    if (flag_z a |= a) return shopMain();
    shopSel = --a;
    return shopTradeItem();
}

// Вход: a - порядковый номер
// Выход: z - нет предмена, de - наименование, hl - цена продажи

void stopTradeGetNamePrice(a)
{
    getItemOfArray8(hl = &gPlayerItems, a);
    hl = 0;
    if (a == 0xFF) return; // return z
    getItemOfArray16(hl = &itemNames, a);
    ex(hl, de);
    // de - наименование
    getItemOfArray16(hl = &itemPrices, a);
    // hl - цена
    h >>= 1; l >>c= 1; // Делим цену на 2
    a |= d; // return nz
}

void stopTradeGetText(a)
{
    if (a >= *(hl = &gPlayerItemsCount))
    {
        hl = 0;
        return; // return hl = 0
    }
    stopTradeGetNamePrice(a);
    if (flag_z) return; // В этой функции hl = 0, поэтому return hl = 0
    // de - наимерование, hl - цена
    shopMakeNamePrice(bc = "\x09", hl, de); // Сформировать строку de + "\x09" + numberToString(hl)
    // hl - указатель на временную строку
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с подтверждением продажи

void shopTradeItem()
{
    shopStart(de =
        "Вы уверены, что хотите\n"
        "продать заклинание",
        ix = &shopTradeItemGetText
    );
    if (flag_z a |= a) return shopTrade();

    // Узнаем цену
    stopTradeGetNamePrice(a = shopSel);
    // hl - цена
    // Увеличиваем деньги игрока
    hl += (de = gPlayerMoney);
    if (flag_c) { return shopOverflow(hl = &shopTrade); } // Денег больше, чем 65536 быть не может
    setPlayerMoney(hl);
    // Удаляем предмет из кармана
    playerRemoveItem(a = shopSel);  
    // Возвращаемся в меню
    return shopAnyElseTrade();
}

void shopTradeItemGetText(a)
{
    if (flag_z a |= a)
    {
        stopTradeGetNamePrice(a = shopSel);
        // de - наименование, hl - цена
        shopMakeNamePrice2(hl, de); // Сформировать строку: de + " за " + numberToString(hl) + " ?"
        // hl - указатель на временную строку
        return;
    }
    hl = "Нет"; if (flag_z a--) return;
    hl = "Да";  if (flag_z a--) return;
    hl = 0;
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с ошибкой

void shopOverflow(hl)
{
    push(hl);
    shopStart(de =
        "Вам не унести\n"
        "столько денег!"
        "\r"
        "Ок",
        ix = 0
    );
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с ошибкой

void shopBuyNoMoney()
{
    shopStart(de =
        "У вас не хватает денег.\n"
        "Я не могу продать вам это\n"
        "в кредит. Может быть у вас\n"
        "есть что-нибудь на продажу?"
        "\r"
        "Ок",
        ix = 0
    );
    return shopBuy();
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с ошибкой

void shopBuyNoSpace()
{
    shopStart(de =
        "Вам не унести сколько\n"
        "предметов с собой.\n"
        "Я могу у вас купить\n"
        "что-нибудь лишнее."
        "\r"
        "Ок",
        ix = 0
    );
    return shopBuy();
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с продолжением покупки

void shopAnyElseBuy()
{
    shopStart(de =
        "Хотите купить\n"
        "что-нибудь еще?"
        "\r"
        "Нет\n"
        "Да",
        ix = 0
    );
    if(flag_z a |= a) return shopMain();
    return shopBuy();
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с продолжением покупки

void shopAnyElseTrade()
{
    shopStart(de =
        "Хотите продать\n"
        "что-нибудь еще?"
        "\r"
        "Нет\n"
        "Да",
        ix = 0
    );
    if(flag_z a |= a) return shopMain();
    return shopTrade();
}

//----------------------------------------------------------------------------------------------------------------------
// Страница с ЛУТ-ом для продажи

uint16_t shopSum;

void shopTradeLut()
{
    while()
    {
        // Расчет общей суммы
        hl = 0;
        a = gPlayerLutCount;
        while(a != 0)
        {
            a--;
            push(hl);
            push(a)
            {
                stopTradeLutGetNameCntPrice(a);
            }
            pop(de);
            hl += de;
        }
        shopSum = hl;

        // Диалог
        shopStart(de =
            "Что вы хотите продать?"
            "\r"
            "Ничего",
            ix = &stopTradeLutGetText
        );

        // Выход
        a -= 1;
        if (flag_c) return shopMain();

        // Продать всё
        if (flag_z)
        {
            hl = gPlayerMoney;
            hl += (de = shopSum);
            if (flag_c) { return shopOverflow(hl = &shopTradeLut); } // Денег больше, чем 65536 быть не может
            setPlayerMoney(hl);
            gPlayerLutCount = a = 0; // Удаляем все предметы
            return shopMain();
        }

        // Продать один
        a--;
        shopSel = a;
        // Узнаем цену
        stopTradeLutGetNameCntPrice(a);
        // hl - цена
        // Увеличиваем деньги игрока
        hl += (de = gPlayerMoney);
        if (flag_c) { return shopOverflow(hl = &shopTradeLut); } // Денег больше, чем 65536 быть не может
        setPlayerMoney(hl);
        // Удаляем предмет из кармана
        playerRemoveLut(a = shopSel);
    }
}

// Получить информацию о ЛУТ-е
// Вход: a - порядковый номер
// Выход: de - наименование, hl - цена, c - кол-во

void stopTradeLutGetNameCntPrice(a)
{
    getItemOfArray8(hl = &gPlayerLut, a);
    hl += (de = playerLutMax);
    c = *hl;
    // с - кол-во
    getItemOfArray16(hl = &lutNames, a);
    ex(hl, de);
    // de - наименование
    getItemOfArray16(hl = &lutPrices, a);
    // hl - цена (hl *= c)
    push(bc, de)
    {
        d = 0; e = c;
        mul16();
    }
}

// Сформировать текст для вывода на экран
// Вход: a - порядковый номер
// Выход: hl - строка (если hl = 0, то конец)

void stopTradeLutGetText(a)
{
    // Продать все
    a -= 1;
    if (flag_c)
    {
        hl = &gStringBuffer;
        strcpyn(hl, b = [gStringBufferSize - numberToString16max - 1], de = "Продать все\x09");
        de = shopSum;
        if (flag_z (a = d) |= e)
        {
            hl = 0;
            return;
        }
        numberToString16(hl, de);
        hl = &gStringBuffer;
        return;
    }

    // По отдельности
    if (a < *(hl = &gPlayerLutCount))
    {
        // Получить информацию
        stopTradeLutGetNameCntPrice(a);
        // de - наимерование, hl - цена, c - кол-во
        push(hl);
            push(bc);
                hl = &gStringBuffer;
                strcpyn(hl, b = [gStringBufferSize - 3 - 2 - 1 - numberToString16max - 1], de);
                strcpyn(hl, b = 3, de = " x ");
            pop(de);
            d = 0;
            if ((a = e) < 100) numberToString16(hl, de);
            strcpyn(hl, b = 1, de = "\x09");
        pop(de);
        numberToString16(hl, de);
        hl = &gStringBuffer;
        return;
    }

    // Конец
    hl = 0;
    return;
}
