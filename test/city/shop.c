#counter 4000

const int numberToString16max = 5;
const int playerItemsMax = 5;

//+ Добавить магазин амулетов

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
// Временный буфер для формирвоания строки с вопросом

const int tmpStringSize = 32;
uint8_t tmpString[tmpStringSize];

//----------------------------------------------------------------------------------------------------------------------
// Сформировать строку во временном буфере с наименованием и ценой.
// de - имя
// hl - цена
// bc - разделитель

void shopMakeNamePrice(bc, de, hl)
{
    push(hl);
        push(bc);
            hl = &tmpString;
            strcpyn(hl, b = [tmpStringSize - 7 - numberToString16max - 1], de); // Запас для " за  ?\r" или "\t"
        pop(de);
        strcpyn(hl, b = 4, de);
    pop(de);
    numberToString16(hl, de);
    hl = &tmpString;
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
        "Я хочу продать",
        ix = 0
    );
    if (flag_z a |= a) return; // Выход из магазина
    if (flag_z a--) return shopBuy();
    return shopTrade();
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
    subHlDe(hl = gPlayerMoney); //! Доработать компилятор
    if (flag_c) return shopBuyNoMoney();

    // Добавляем в карман
    playerAddItem(a = shopSel);
    if (flag_nz) return shopBuyNoSpace();

    // Уменьшаем деньги
    shopBuyGetNamePrice(a = shopSel);
    // hl - цена
    ex(hl, de);
    subHlDe(hl = gPlayerMoney);
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

uint8_t shopSel = 0;

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
    getItemOfArray8(hl = &playerItems, a);
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
    hl = 0;
    if (a >= playerItemsMax) return; // return hl = 0
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
    if (flag_c) return shopTradeOverflow(); // Денег больше, чем 65536 быть не может
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

void shopTradeOverflow()
{
    shopStart(de =
        "Вам не унести\n"
        "столько денег!"
        "\r"
        "Ок",
        ix = 0
    );
    return shopTrade();
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
