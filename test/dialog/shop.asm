    ; dialog/shop.c:2 
    ; common.h:2 const int itemsCount = 8;
    ; common.h:3 
    ; common.h:4 // Размер глобального строкового буфера
    ; common.h:5 const int gStringBufferSize = 32;
    ; common.h:6 
    ; common.h:7 // Флаги для переменных gPanelChangedA, gPanelChangedB
    ; common.h:8 const int gPanelChangedMoney = 0x01;
    ; common.h:9 const int gPanelChangedPlace = 0x02;
    ; common.h:10 //const int gPanelChangedImages = 0x04;
    ; common.h:11 const int gPanelChanedSecondWeaponCount = 0x08;
    ; common.h:12 const int gPanelChanedArmorCount = 0x10;
    ; common.h:13 
    ; common.h:14 // Максимальное кол-во символов (не учитывая терминатор строки), которое возращает функция numberToString16
    ; common.h:15 const int numberToString16max = 5;
    ; common.h:16 
    ; common.h:17 // Максимальное кол-во предметов у игрока
    ; common.h:18 const int playerItemsMax = 5;
    ; common.h:19 
    ; common.h:20 // Максимальное кол-во типов лута у игрока (кол-во отображаемых строк в инвентаре)
    ; common.h:21 const int playerLutMax = 12;
    ; common.h:22 
    ; common.h:23 // Максимальное кол-во лута у игрока (сумма)
    ; common.h:24 const int playerLutMaxCountInLine = 99;
    ; common.h:25 
    ; common.h:26 const int secondWeaponMax = 9;
    ; common.h:27 
    ; common.h:28 // Флаги клавиш для переменные gKeyPressed, gKeyTrigger
    ; common.h:29 const int KEY_UP = 1;
    ; common.h:30 const int KEY_DOWN = 2;
    ; common.h:31 const int KEY_LEFT = 4;
    ; common.h:32 const int KEY_RIGHT = 8;
    ; common.h:33 const int KEY_FIRE = 16;
    ; common.h:34 const int KEY_MENU = 32;
    ; common.h:35 
    ; common.h:36 // Стандартные адреса ZX Spectrum
    ; common.h:37 const int screenBw0 = 0x4000;
    ; common.h:38 const int screenAttr0 = 0x5800;
    ; common.h:39 
    ; common.h:40 // Размеры экрана
    ; common.h:41 const int screenWidthTails = 32;
    ; common.h:42 const int panelHeightTails = 4;
    ; common.h:43 const int tailHeight = 8;
    ; common.h:44 const int tailWidth = 8;
    ; common.h:45 const int playfieldHeightTails = 20;
    ; common.h:46 
    ; common.h:47 // Используется при упаковке координат X, Y в регистровую пару
    ; common.h:48 const int bpl = 256;
    ; common.h:49 
    ; common.h:50 // Точки входа
    ; common.h:51 const int gPanelRedrawImagesPage = 6;
    ; common.h:52 const int gPanelRedrawImages = 0xC006;
    ; common.h:53 const int gInventPage = 6;
    ; common.h:54 const int gInvent = 0xC000;
    ; common.h:55 
    ; common.h:56 // Параметр для drawText
    ; common.h:57 const int smallFontFlag = 0x80;
    ; common.h:58 
    ; dialog/shop.c:3 #counter 4000
    ; dialog/shop.c:4 
    ; dialog/shop.c:5 uint8_t shopSel = 0;
shopSel db 0
    ; dialog/shop.c:6 
    ; dialog/shop.c:7 //+ Добавить магазин амулетов
    ; dialog/shop.c:8 
    ; dialog/shop.c:9 void playerAddItem(a)
playerAddItem:
    ; dialog/shop.c:10 {
    ; dialog/shop.c:11 return addElement(de = &gPlayerItems, hl = &gPlayerItemsCount, c = playerItemsMax);
    ld   de, gPlayerItems
    ld   hl, gPlayerItemsCount
    ld   c, 5
    jp   addElement
    ; dialog/shop.c:12 }
    ret
    ; dialog/shop.c:13 
    ; dialog/shop.c:14 void playerRemoveItem(a)
playerRemoveItem:
    ; dialog/shop.c:15 {
    ; dialog/shop.c:16 return removeElement(de = &gPlayerItems, hl = &gPlayerItemsCount, a);
    ld   de, gPlayerItems
    ld   hl, gPlayerItemsCount
    jp   removeElement
    ; dialog/shop.c:17 }
    ret
    ; dialog/shop.c:18 
    ; dialog/shop.c:19 // Вход: d - тип предмета
    ; dialog/shop.c:20 
    ; dialog/shop.c:21 void playerAddLut(d)
playerAddLut:
    ; dialog/shop.c:22 {
    ; dialog/shop.c:23 // Поиск этого предмета в кармане
    ; dialog/shop.c:24 
    ; dialog/shop.c:25 hl = &gPlayerLut;
    ld   hl, gPlayerLut
    ; dialog/shop.c:26 a = gPlayerLutCount;
    ld   a, (gPlayerLutCount)
    ; dialog/shop.c:27 if (a != 0) // Если карман пуст, то не ищем
    or   a
    ; dialog/shop.c:28 {
    jp   z, l4000
    ; dialog/shop.c:29 b = a; // Для while который замеится на djnz
    ld   b, a
    ; dialog/shop.c:30 a = d; // Для ускорения поиска помещаем тип предмета в A
    ld   a, d
    ; dialog/shop.c:31 do {
l4001:
    ; dialog/shop.c:32 if (a == *hl) // Найден предмет этого типа
    cp   (hl)
    ; dialog/shop.c:33 {
    jp   nz, l4003
    ; dialog/shop.c:34 hl += (de = playerLutMax);
    ld   de, 12
    add  hl, de
    ; dialog/shop.c:35 a = *hl; // Учеличиваем кол-во
    ld   a, (hl)
    ; dialog/shop.c:36 a++;
    inc  a
    ; dialog/shop.c:37 if (a >= playerLutMaxCountInLine) a |= 0x80; // Исключаем из поиска
    cp   99
    jp   c, l4004
    or   128
    ; dialog/shop.c:38 return; // nz
l4004:
    ret
    ; dialog/shop.c:39 }
    ; dialog/shop.c:40 hl++;
l4003:
    inc  hl
    ; dialog/shop.c:41 } while(--b);
    djnz l4001
l4002:
    ; dialog/shop.c:42 
    ; dialog/shop.c:43 // Если максимум ЛУТ-а, то выходим
    ; dialog/shop.c:44 a = gPlayerLutCount;
    ld   a, (gPlayerLutCount)
    ; dialog/shop.c:45 if (a == playerLutMax) return ; // Z - Нет места в кармане
    cp   12
    ret  z
    ; dialog/shop.c:46 }
    ; dialog/shop.c:47 
    ; dialog/shop.c:48 gPlayerLutCount = ++a; // Тут получится флаг NZ
l4000:
    inc  a
    ld   (gPlayerLutCount), a
    ; dialog/shop.c:49 
    ; dialog/shop.c:50 // Создаем новую запись
    ; dialog/shop.c:51 *hl = d;
    ld   (hl), d
    ; dialog/shop.c:52 hl += (de = playerLutMax);
    ld   de, 12
    add  hl, de
    ; dialog/shop.c:53 *hl = 1;
    ld   (hl), 1
    ; dialog/shop.c:54 
    ; dialog/shop.c:55 // return nz
    ; dialog/shop.c:56 }
    ret
    ; dialog/shop.c:57 
    ; dialog/shop.c:58 // Вход: a - порядковый номер ЛУТ-а
    ; dialog/shop.c:59 
    ; dialog/shop.c:60 void playerRemoveLut(a)
playerRemoveLut:
    ; dialog/shop.c:61 {
    ; dialog/shop.c:62 push(a)
    ; dialog/shop.c:63 {
    push af
    ; dialog/shop.c:64 removeElement(de = &gPlayerLut, hl = &gPlayerLutCount, a);
    ld   de, gPlayerLut
    ld   hl, gPlayerLutCount
    call removeElement
    ; dialog/shop.c:65 }
    pop  af
    ; dialog/shop.c:66 return removeElement2(de = [&gPlayerLut + playerLutMax], hl = &gPlayerLutCount, a);
    ld   de, (gPlayerLut) + (12)
    ld   hl, gPlayerLutCount
    jp   removeElement2
    ; dialog/shop.c:67 }
    ret
    ; dialog/shop.c:68 
    ; dialog/shop.c:69 void setPlayerMoney(hl)
setPlayerMoney:
    ; dialog/shop.c:70 {
    ; dialog/shop.c:71 gPlayerMoney = hl;
    ld   (gPlayerMoney), hl
    ; dialog/shop.c:72 hl = &gPanelChangedA;
    ld   hl, gPanelChangedA
    ; dialog/shop.c:73 *hl |= gPanelChangedMoney;
    set  0, (hl)
    ; dialog/shop.c:74 hl++;
    inc  hl
    ; dialog/shop.c:75 *hl |= gPanelChangedMoney;    
    set  0, (hl)
    ; dialog/shop.c:76 //panelRedraw:
    ; dialog/shop.c:77 //    return gFarCall(iyl = 7, ix = &gPanelRedraw);
    ; dialog/shop.c:78 }
    ret
    ; dialog/shop.c:79 
    ; dialog/shop.c:80 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:81 // Сформировать строку во временном буфере с наименованием и ценой.
    ; dialog/shop.c:82 // de - имя
    ; dialog/shop.c:83 // hl - цена
    ; dialog/shop.c:84 // bc - разделитель
    ; dialog/shop.c:85 
    ; dialog/shop.c:86 void shopMakeNamePrice(bc, de, hl)
shopMakeNamePrice:
    ; dialog/shop.c:87 {
    ; dialog/shop.c:88 push(hl);
    push hl
    ; dialog/shop.c:89 push(bc);
    push bc
    ; dialog/shop.c:90 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; dialog/shop.c:91 strcpyn(hl, b = [gStringBufferSize - 7 - numberToString16max - 1], de); // Запас для " за  ?\r" или "\t"
    ld   b, 19
    call strcpyn
    ; dialog/shop.c:92 pop(de);
    pop  de
    ; dialog/shop.c:93 strcpyn(hl, b = 4, de);
    ld   b, 4
    call strcpyn
    ; dialog/shop.c:94 pop(de);
    pop  de
    ; dialog/shop.c:95 numberToString16(hl, de);
    call numberToString16
    ; dialog/shop.c:96 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; dialog/shop.c:97 }
    ret
    ; dialog/shop.c:98 
    ; dialog/shop.c:99 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:100 // Сформировать строку во временном буфере с наименованием и ценой.
    ; dialog/shop.c:101 // de - имя
    ; dialog/shop.c:102 // hl - цена
    ; dialog/shop.c:103 
    ; dialog/shop.c:104 void shopMakeNamePrice2()
shopMakeNamePrice2:
    ; dialog/shop.c:105 {
    ; dialog/shop.c:106 shopMakeNamePrice(bc = " за ");
    ld   bc, s4000
    call shopMakeNamePrice
    ; dialog/shop.c:107 // hl - указатель на начало строки, de - указатель на терминатор строки
    ; dialog/shop.c:108 // Добавляем строку
    ; dialog/shop.c:109 push (hl)
    ; dialog/shop.c:110 {
    push hl
    ; dialog/shop.c:111 ex(hl, de);
    ex de, hl
    ; dialog/shop.c:112 strcpyn(hl, b = 3, de = " ?\r");
    ld   b, 3
    ld   de, s4001
    call strcpyn
    ; dialog/shop.c:113 }
    pop  hl
    ; dialog/shop.c:114 }
    ret
    ; dialog/shop.c:115 
    ; dialog/shop.c:116 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:117 // Главная страница магазина
    ; dialog/shop.c:118 
    ; dialog/shop.c:119 void shopMain()
shopMain:
    ; dialog/shop.c:120 {
    ; dialog/shop.c:121 shopStart(de =
    ; dialog/shop.c:122 "Добрый день, чем я\n"
    ; dialog/shop.c:123 "могу вам помочь?"
    ; dialog/shop.c:124 "\r"
    ; dialog/shop.c:125 "Мне пора идти\n"
    ; dialog/shop.c:126 "Я хочу купить\n"
    ; dialog/shop.c:127 "Я хочу продать\n"
    ; dialog/shop.c:128 "Я хочу продать ЛУТ",
    ld   de, s4002
    ; dialog/shop.c:129 ix = 0
    ld   ix, 0
    ; dialog/shop.c:130 );
    call shopStart
    ; dialog/shop.c:131 if (flag_z a |= a) return; // Выход из магазина
    or   a
    ret  z
    ; dialog/shop.c:132 if (flag_z a--) return shopBuy();
    dec  a
    jp   z, shopBuy
    ; dialog/shop.c:133 if (flag_z a--) return shopTrade();
    dec  a
    jp   z, shopTrade
    ; dialog/shop.c:134 return shopTradeLut();
    jp   shopTradeLut
    ; dialog/shop.c:135 }
    ret
    ; dialog/shop.c:136 
    ; dialog/shop.c:137 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:138 // Страница с товарами для покупки
    ; dialog/shop.c:139 
    ; dialog/shop.c:140 void shopBuy()
shopBuy:
    ; dialog/shop.c:141 {
    ; dialog/shop.c:142 shopStart(de =
    ; dialog/shop.c:143 "Что вы хотите купить?"
    ; dialog/shop.c:144 "\r"
    ; dialog/shop.c:145 "Ничего",
    ld   de, s4003
    ; dialog/shop.c:146 ix = &shopBuyGetText
    ld   ix, shopBuyGetText
    ; dialog/shop.c:147 );
    call shopStart
    ; dialog/shop.c:148 if (flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; dialog/shop.c:149 shopSel = (--a);
    dec  a
    ld   (shopSel), a
    ; dialog/shop.c:150 return shopBuyItem();
    jp   shopBuyItem
    ; dialog/shop.c:151 }
    ret
    ; dialog/shop.c:152 
    ; dialog/shop.c:153 // Вход: a - порядковый номер
    ; dialog/shop.c:154 // Выход: de - наименование, hl - цена продажи. Если нет предмета, то de = 0
    ; dialog/shop.c:155 
    ; dialog/shop.c:156 void shopBuyGetNamePrice(a)
shopBuyGetNamePrice:
    ; dialog/shop.c:157 {
    ; dialog/shop.c:158 hl = 0;
    ld   hl, 0
    ; dialog/shop.c:159 de = 0;
    ld   de, 0
    ; dialog/shop.c:160 if (a >= itemsCount) return;
    cp   8
    ret  nc
    ; dialog/shop.c:161 getItemOfArray16(hl = &itemNames, a);
    ld   hl, itemNames
    call getItemOfArray16
    ; dialog/shop.c:162 ex(hl, de);
    ex de, hl
    ; dialog/shop.c:163 getItemOfArray16(hl = &itemPrices, a);
    ld   hl, itemPrices
    call getItemOfArray16
    ; dialog/shop.c:164 }
    ret
    ; dialog/shop.c:165 
    ; dialog/shop.c:166 void shopBuyGetText(a)
shopBuyGetText:
    ; dialog/shop.c:167 {
    ; dialog/shop.c:168 shopBuyGetNamePrice(a);    
    call shopBuyGetNamePrice
    ; dialog/shop.c:169 if (flag_z (a ^= a) |= d) return;
    xor  a
    or   d
    ret  z
    ; dialog/shop.c:170 shopMakeNamePrice(bc = "\x09", hl, de);
    ld   bc, s4004
    call shopMakeNamePrice
    ; dialog/shop.c:171 }
    ret
    ; dialog/shop.c:172 
    ; dialog/shop.c:173 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:174 // Страница с подтверждением покупки
    ; dialog/shop.c:175 
    ; dialog/shop.c:176 void shopBuyItem()
shopBuyItem:
    ; dialog/shop.c:177 {
    ; dialog/shop.c:178 shopStart(de =
    ; dialog/shop.c:179 "Вы уверены, что хотите\n"
    ; dialog/shop.c:180 "купить заклинание",
    ld   de, s4005
    ; dialog/shop.c:181 ix = &shopBuyItemGetText
    ld   ix, shopBuyItemGetText
    ; dialog/shop.c:182 );
    call shopStart
    ; dialog/shop.c:183 
    ; dialog/shop.c:184 if (flag_z a |= a) return shopBuy();
    or   a
    jp   z, shopBuy
    ; dialog/shop.c:185 if (flag_nz a--) return shopBuyInfo();
    dec  a
    jp   nz, shopBuyInfo
    ; dialog/shop.c:186 
    ; dialog/shop.c:187 // Вычисление цены
    ; dialog/shop.c:188 shopBuyGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call shopBuyGetNamePrice
    ; dialog/shop.c:189 // hl - цена
    ; dialog/shop.c:190 
    ; dialog/shop.c:191 // Хватит ли денег?
    ; dialog/shop.c:192 ex(hl, de);
    ex de, hl
    ; dialog/shop.c:193 (hl = gPlayerMoney) -= de;
    ld   hl, (gPlayerMoney)
    or   a
    sub  hl, de
    ; dialog/shop.c:194 if (flag_c) return shopBuyNoMoney();
    jp   c, shopBuyNoMoney
    ; dialog/shop.c:195 
    ; dialog/shop.c:196 // Добавляем в карман
    ; dialog/shop.c:197 playerAddItem(a = shopSel);
    ld   a, (shopSel)
    call playerAddItem
    ; dialog/shop.c:198 if (flag_z) return shopBuyNoSpace();
    jp   z, shopBuyNoSpace
    ; dialog/shop.c:199 
    ; dialog/shop.c:200 // Уменьшаем деньги
    ; dialog/shop.c:201 shopBuyGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call shopBuyGetNamePrice
    ; dialog/shop.c:202 // hl - цена
    ; dialog/shop.c:203 ex(hl, de);
    ex de, hl
    ; dialog/shop.c:204 (hl = gPlayerMoney) -= de;
    ld   hl, (gPlayerMoney)
    or   a
    sub  hl, de
    ; dialog/shop.c:205 setPlayerMoney(hl);
    call setPlayerMoney
    ; dialog/shop.c:206 
    ; dialog/shop.c:207 // Переход на главную страницу
    ; dialog/shop.c:208 return shopAnyElseBuy();
    jp   shopAnyElseBuy
    ; dialog/shop.c:209 }
    ret
    ; dialog/shop.c:210 
    ; dialog/shop.c:211 void shopBuyItemGetText()
shopBuyItemGetText:
    ; dialog/shop.c:212 {
    ; dialog/shop.c:213 if (flag_z a |= a)
    or   a
    ; dialog/shop.c:214 {
    jp   nz, l4005
    ; dialog/shop.c:215 shopBuyGetNamePrice(a = shopSel, de, hl);
    ld   a, (shopSel)
    call shopBuyGetNamePrice
    ; dialog/shop.c:216 // de - наимерование, hl - цена
    ; dialog/shop.c:217 shopMakeNamePrice2(hl, de); // Сформировать строку de + " за " + numberToString(hl) + " ?"
    call shopMakeNamePrice2
    ; dialog/shop.c:218 return;
    ret
    ; dialog/shop.c:219 }
    ; dialog/shop.c:220 hl = "Нет";            if (flag_z a--) return;
l4005:
    ld   hl, s4006
    dec  a
    ret  z
    ; dialog/shop.c:221 hl = "Да";             if (flag_z a--) return;
    ld   hl, s4007
    dec  a
    ret  z
    ; dialog/shop.c:222 hl = "Что это такое?"; if (flag_z a--) return;
    ld   hl, s4008
    dec  a
    ret  z
    ; dialog/shop.c:223 hl = 0;
    ld   hl, 0
    ; dialog/shop.c:224 }
    ret
    ; dialog/shop.c:225 
    ; dialog/shop.c:226 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:227 // Страница с информацией о товаре
    ; dialog/shop.c:228 
    ; dialog/shop.c:229 void shopBuyInfo()
shopBuyInfo:
    ; dialog/shop.c:230 {
    ; dialog/shop.c:231 getItemOfArray16(hl = &itemInfo, a = shopSel);
    ld   hl, itemInfo
    ld   a, (shopSel)
    call getItemOfArray16
    ; dialog/shop.c:232 ex(hl, de);
    ex de, hl
    ; dialog/shop.c:233 shopStart(de, ix = &shopBuyInfoGetText);
    ld   ix, shopBuyInfoGetText
    call shopStart
    ; dialog/shop.c:234 return shopBuyItem();
    jp   shopBuyItem
    ; dialog/shop.c:235 }
    ret
    ; dialog/shop.c:236 
    ; dialog/shop.c:237 void shopBuyInfoGetText(a)
shopBuyInfoGetText:
    ; dialog/shop.c:238 {
    ; dialog/shop.c:239 hl = "\r"; if (flag_z a |= a) return;
    ld   hl, s4009
    or   a
    ret  z
    ; dialog/shop.c:240 hl = "Ок"; if (flag_z a--) return;
    ld   hl, s4010
    dec  a
    ret  z
    ; dialog/shop.c:241 hl = 0;
    ld   hl, 0
    ; dialog/shop.c:242 }
    ret
    ; dialog/shop.c:243 
    ; dialog/shop.c:244 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:245 // Страница с товарами для продажи
    ; dialog/shop.c:246 
    ; dialog/shop.c:247 void shopTrade()
shopTrade:
    ; dialog/shop.c:248 {
    ; dialog/shop.c:249 shopStart(de =
    ; dialog/shop.c:250 "Что вы хотите продать?"
    ; dialog/shop.c:251 "\r"
    ; dialog/shop.c:252 "Ничего",
    ld   de, s4011
    ; dialog/shop.c:253 ix = &stopTradeGetText
    ld   ix, stopTradeGetText
    ; dialog/shop.c:254 );
    call shopStart
    ; dialog/shop.c:255 if (flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; dialog/shop.c:256 shopSel = --a;
    dec  a
    ld   (shopSel), a
    ; dialog/shop.c:257 return shopTradeItem();
    jp   shopTradeItem
    ; dialog/shop.c:258 }
    ret
    ; dialog/shop.c:259 
    ; dialog/shop.c:260 // Вход: a - порядковый номер
    ; dialog/shop.c:261 // Выход: z - нет предмена, de - наименование, hl - цена продажи
    ; dialog/shop.c:262 
    ; dialog/shop.c:263 void stopTradeGetNamePrice(a)
stopTradeGetNamePrice:
    ; dialog/shop.c:264 {
    ; dialog/shop.c:265 getItemOfArray8(hl = &gPlayerItems, a);
    ld   hl, gPlayerItems
    call getItemOfArray8
    ; dialog/shop.c:266 hl = 0;
    ld   hl, 0
    ; dialog/shop.c:267 if (a == 0xFF) return; // return z
    cp   255
    ret  z
    ; dialog/shop.c:268 getItemOfArray16(hl = &itemNames, a);
    ld   hl, itemNames
    call getItemOfArray16
    ; dialog/shop.c:269 ex(hl, de);
    ex de, hl
    ; dialog/shop.c:270 // de - наименование
    ; dialog/shop.c:271 getItemOfArray16(hl = &itemPrices, a);
    ld   hl, itemPrices
    call getItemOfArray16
    ; dialog/shop.c:272 // hl - цена
    ; dialog/shop.c:273 h >>= 1; l >>c= 1; // Делим цену на 2
    srl  h
    rr   l
    ; dialog/shop.c:274 a |= d; // return nz
    or   d
    ; dialog/shop.c:275 }
    ret
    ; dialog/shop.c:276 
    ; dialog/shop.c:277 void stopTradeGetText(a)
stopTradeGetText:
    ; dialog/shop.c:278 {
    ; dialog/shop.c:279 if (a >= *(hl = &gPlayerItemsCount))
    ld   hl, gPlayerItemsCount
    cp   (hl)
    ; dialog/shop.c:280 {
    jp   c, l4006
    ; dialog/shop.c:281 hl = 0;
    ld   hl, 0
    ; dialog/shop.c:282 return; // return hl = 0
    ret
    ; dialog/shop.c:283 }
    ; dialog/shop.c:284 stopTradeGetNamePrice(a);
l4006:
    call stopTradeGetNamePrice
    ; dialog/shop.c:285 if (flag_z) return; // В этой функции hl = 0, поэтому return hl = 0
    ret  z
    ; dialog/shop.c:286 // de - наимерование, hl - цена
    ; dialog/shop.c:287 shopMakeNamePrice(bc = "\x09", hl, de); // Сформировать строку de + "\x09" + numberToString(hl)
    ld   bc, s4004
    call shopMakeNamePrice
    ; dialog/shop.c:288 // hl - указатель на временную строку
    ; dialog/shop.c:289 }
    ret
    ; dialog/shop.c:290 
    ; dialog/shop.c:291 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:292 // Страница с подтверждением продажи
    ; dialog/shop.c:293 
    ; dialog/shop.c:294 void shopTradeItem()
shopTradeItem:
    ; dialog/shop.c:295 {
    ; dialog/shop.c:296 shopStart(de =
    ; dialog/shop.c:297 "Вы уверены, что хотите\n"
    ; dialog/shop.c:298 "продать заклинание",
    ld   de, s4012
    ; dialog/shop.c:299 ix = &shopTradeItemGetText
    ld   ix, shopTradeItemGetText
    ; dialog/shop.c:300 );
    call shopStart
    ; dialog/shop.c:301 if (flag_z a |= a) return shopTrade();
    or   a
    jp   z, shopTrade
    ; dialog/shop.c:302 
    ; dialog/shop.c:303 // Узнаем цену
    ; dialog/shop.c:304 stopTradeGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call stopTradeGetNamePrice
    ; dialog/shop.c:305 // hl - цена
    ; dialog/shop.c:306 // Увеличиваем деньги игрока
    ; dialog/shop.c:307 hl += (de = gPlayerMoney);
    ld   de, (gPlayerMoney)
    add  hl, de
    ; dialog/shop.c:308 if (flag_c) { return shopOverflow(hl = &shopTrade); } // Денег больше, чем 65536 быть не может
    jp   nc, l4007
    ld   hl, shopTrade
    jp   shopOverflow
    ; dialog/shop.c:309 setPlayerMoney(hl);
l4007:
    call setPlayerMoney
    ; dialog/shop.c:310 // Удаляем предмет из кармана
    ; dialog/shop.c:311 playerRemoveItem(a = shopSel);  
    ld   a, (shopSel)
    call playerRemoveItem
    ; dialog/shop.c:312 // Возвращаемся в меню
    ; dialog/shop.c:313 return shopAnyElseTrade();
    jp   shopAnyElseTrade
    ; dialog/shop.c:314 }
    ret
    ; dialog/shop.c:315 
    ; dialog/shop.c:316 void shopTradeItemGetText(a)
shopTradeItemGetText:
    ; dialog/shop.c:317 {
    ; dialog/shop.c:318 if (flag_z a |= a)
    or   a
    ; dialog/shop.c:319 {
    jp   nz, l4008
    ; dialog/shop.c:320 stopTradeGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call stopTradeGetNamePrice
    ; dialog/shop.c:321 // de - наименование, hl - цена
    ; dialog/shop.c:322 shopMakeNamePrice2(hl, de); // Сформировать строку: de + " за " + numberToString(hl) + " ?"
    call shopMakeNamePrice2
    ; dialog/shop.c:323 // hl - указатель на временную строку
    ; dialog/shop.c:324 return;
    ret
    ; dialog/shop.c:325 }
    ; dialog/shop.c:326 hl = "Нет"; if (flag_z a--) return;
l4008:
    ld   hl, s4006
    dec  a
    ret  z
    ; dialog/shop.c:327 hl = "Да";  if (flag_z a--) return;
    ld   hl, s4007
    dec  a
    ret  z
    ; dialog/shop.c:328 hl = 0;
    ld   hl, 0
    ; dialog/shop.c:329 }
    ret
    ; dialog/shop.c:330 
    ; dialog/shop.c:331 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:332 // Страница с ошибкой
    ; dialog/shop.c:333 
    ; dialog/shop.c:334 void shopOverflow(hl)
shopOverflow:
    ; dialog/shop.c:335 {
    ; dialog/shop.c:336 push(hl);
    push hl
    ; dialog/shop.c:337 shopStart(de =
    ; dialog/shop.c:338 "Вам не унести\n"
    ; dialog/shop.c:339 "столько денег!"
    ; dialog/shop.c:340 "\r"
    ; dialog/shop.c:341 "Ок",
    ld   de, s4013
    ; dialog/shop.c:342 ix = 0
    ld   ix, 0
    ; dialog/shop.c:343 );
    call shopStart
    ; dialog/shop.c:344 }
    ret
    ; dialog/shop.c:345 
    ; dialog/shop.c:346 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:347 // Страница с ошибкой
    ; dialog/shop.c:348 
    ; dialog/shop.c:349 void shopBuyNoMoney()
shopBuyNoMoney:
    ; dialog/shop.c:350 {
    ; dialog/shop.c:351 shopStart(de =
    ; dialog/shop.c:352 "У вас не хватает денег.\n"
    ; dialog/shop.c:353 "Я не могу продать вам это\n"
    ; dialog/shop.c:354 "в кредит. Может быть у вас\n"
    ; dialog/shop.c:355 "есть что-нибудь на продажу?"
    ; dialog/shop.c:356 "\r"
    ; dialog/shop.c:357 "Ок",
    ld   de, s4014
    ; dialog/shop.c:358 ix = 0
    ld   ix, 0
    ; dialog/shop.c:359 );
    call shopStart
    ; dialog/shop.c:360 return shopBuy();
    jp   shopBuy
    ; dialog/shop.c:361 }
    ret
    ; dialog/shop.c:362 
    ; dialog/shop.c:363 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:364 // Страница с ошибкой
    ; dialog/shop.c:365 
    ; dialog/shop.c:366 void shopBuyNoSpace()
shopBuyNoSpace:
    ; dialog/shop.c:367 {
    ; dialog/shop.c:368 shopStart(de =
    ; dialog/shop.c:369 "Вам не унести сколько\n"
    ; dialog/shop.c:370 "предметов с собой.\n"
    ; dialog/shop.c:371 "Я могу у вас купить\n"
    ; dialog/shop.c:372 "что-нибудь лишнее."
    ; dialog/shop.c:373 "\r"
    ; dialog/shop.c:374 "Ок",
    ld   de, s4015
    ; dialog/shop.c:375 ix = 0
    ld   ix, 0
    ; dialog/shop.c:376 );
    call shopStart
    ; dialog/shop.c:377 return shopBuy();
    jp   shopBuy
    ; dialog/shop.c:378 }
    ret
    ; dialog/shop.c:379 
    ; dialog/shop.c:380 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:381 // Страница с продолжением покупки
    ; dialog/shop.c:382 
    ; dialog/shop.c:383 void shopAnyElseBuy()
shopAnyElseBuy:
    ; dialog/shop.c:384 {
    ; dialog/shop.c:385 shopStart(de =
    ; dialog/shop.c:386 "Хотите купить\n"
    ; dialog/shop.c:387 "что-нибудь еще?"
    ; dialog/shop.c:388 "\r"
    ; dialog/shop.c:389 "Нет\n"
    ; dialog/shop.c:390 "Да",
    ld   de, s4016
    ; dialog/shop.c:391 ix = 0
    ld   ix, 0
    ; dialog/shop.c:392 );
    call shopStart
    ; dialog/shop.c:393 if(flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; dialog/shop.c:394 return shopBuy();
    jp   shopBuy
    ; dialog/shop.c:395 }
    ret
    ; dialog/shop.c:396 
    ; dialog/shop.c:397 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:398 // Страница с продолжением покупки
    ; dialog/shop.c:399 
    ; dialog/shop.c:400 void shopAnyElseTrade()
shopAnyElseTrade:
    ; dialog/shop.c:401 {
    ; dialog/shop.c:402 shopStart(de =
    ; dialog/shop.c:403 "Хотите продать\n"
    ; dialog/shop.c:404 "что-нибудь еще?"
    ; dialog/shop.c:405 "\r"
    ; dialog/shop.c:406 "Нет\n"
    ; dialog/shop.c:407 "Да",
    ld   de, s4017
    ; dialog/shop.c:408 ix = 0
    ld   ix, 0
    ; dialog/shop.c:409 );
    call shopStart
    ; dialog/shop.c:410 if(flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; dialog/shop.c:411 return shopTrade();
    jp   shopTrade
    ; dialog/shop.c:412 }
    ret
    ; dialog/shop.c:413 
    ; dialog/shop.c:414 //----------------------------------------------------------------------------------------------------------------------
    ; dialog/shop.c:415 // Страница с ЛУТ-ом для продажи
    ; dialog/shop.c:416 
    ; dialog/shop.c:417 uint16_t shopSum;
shopSum dw 0
    ; dialog/shop.c:418 
    ; dialog/shop.c:419 void shopTradeLut()
shopTradeLut:
    ; dialog/shop.c:420 {
    ; dialog/shop.c:421 while()
l4009:
    ; dialog/shop.c:422 {
    ; dialog/shop.c:423 // Расчет общей суммы
    ; dialog/shop.c:424 hl = 0;
    ld   hl, 0
    ; dialog/shop.c:425 a = gPlayerLutCount;
    ld   a, (gPlayerLutCount)
    ; dialog/shop.c:426 while(a != 0)
l4011:
    or   a
    jp   z, l4012
    ; dialog/shop.c:427 {
    ; dialog/shop.c:428 a--;
    dec  a
    ; dialog/shop.c:429 push(hl);
    push hl
    ; dialog/shop.c:430 push(a)
    ; dialog/shop.c:431 {
    push af
    ; dialog/shop.c:432 stopTradeLutGetNameCntPrice(a);
    call stopTradeLutGetNameCntPrice
    ; dialog/shop.c:433 }
    pop  af
    ; dialog/shop.c:434 pop(de);
    pop  de
    ; dialog/shop.c:435 hl += de;
    add  hl, de
    ; dialog/shop.c:436 }
    jp   l4011
l4012:
    ; dialog/shop.c:437 shopSum = hl;
    ld   (shopSum), hl
    ; dialog/shop.c:438 
    ; dialog/shop.c:439 // Диалог
    ; dialog/shop.c:440 shopStart(de =
    ; dialog/shop.c:441 "Что вы хотите продать?"
    ; dialog/shop.c:442 "\r"
    ; dialog/shop.c:443 "Ничего",
    ld   de, s4011
    ; dialog/shop.c:444 ix = &stopTradeLutGetText
    ld   ix, stopTradeLutGetText
    ; dialog/shop.c:445 );
    call shopStart
    ; dialog/shop.c:446 
    ; dialog/shop.c:447 // Выход
    ; dialog/shop.c:448 a -= 1;
    sub  1
    ; dialog/shop.c:449 if (flag_c) return shopMain();
    jp   c, shopMain
    ; dialog/shop.c:450 
    ; dialog/shop.c:451 // Продать всё
    ; dialog/shop.c:452 if (flag_z)
    ; dialog/shop.c:453 {
    jp   nz, l4013
    ; dialog/shop.c:454 hl = gPlayerMoney;
    ld   hl, (gPlayerMoney)
    ; dialog/shop.c:455 hl += (de = shopSum);
    ld   de, (shopSum)
    add  hl, de
    ; dialog/shop.c:456 if (flag_c) { return shopOverflow(hl = &shopTradeLut); } // Денег больше, чем 65536 быть не может
    jp   nc, l4014
    ld   hl, shopTradeLut
    jp   shopOverflow
    ; dialog/shop.c:457 setPlayerMoney(hl);
l4014:
    call setPlayerMoney
    ; dialog/shop.c:458 gPlayerLutCount = a = 0; // Удаляем все предметы
    ld   a, 0
    ld   (gPlayerLutCount), a
    ; dialog/shop.c:459 return shopMain();
    jp   shopMain
    ; dialog/shop.c:460 }
    ; dialog/shop.c:461 
    ; dialog/shop.c:462 // Продать один
    ; dialog/shop.c:463 a--;
l4013:
    dec  a
    ; dialog/shop.c:464 shopSel = a;
    ld   (shopSel), a
    ; dialog/shop.c:465 // Узнаем цену
    ; dialog/shop.c:466 stopTradeLutGetNameCntPrice(a);
    call stopTradeLutGetNameCntPrice
    ; dialog/shop.c:467 // hl - цена
    ; dialog/shop.c:468 // Увеличиваем деньги игрока
    ; dialog/shop.c:469 hl += (de = gPlayerMoney);
    ld   de, (gPlayerMoney)
    add  hl, de
    ; dialog/shop.c:470 if (flag_c) { return shopOverflow(hl = &shopTradeLut); } // Денег больше, чем 65536 быть не может
    jp   nc, l4015
    ld   hl, shopTradeLut
    jp   shopOverflow
    ; dialog/shop.c:471 setPlayerMoney(hl);
l4015:
    call setPlayerMoney
    ; dialog/shop.c:472 // Удаляем предмет из кармана
    ; dialog/shop.c:473 playerRemoveLut(a = shopSel);
    ld   a, (shopSel)
    call playerRemoveLut
    ; dialog/shop.c:474 }
    jp   l4009
l4010:
    ; dialog/shop.c:475 }
    ret
    ; dialog/shop.c:476 
    ; dialog/shop.c:477 // Получить информацию о ЛУТ-е
    ; dialog/shop.c:478 // Вход: a - порядковый номер
    ; dialog/shop.c:479 // Выход: de - наименование, hl - цена, c - кол-во
    ; dialog/shop.c:480 
    ; dialog/shop.c:481 void stopTradeLutGetNameCntPrice(a)
stopTradeLutGetNameCntPrice:
    ; dialog/shop.c:482 {
    ; dialog/shop.c:483 getItemOfArray8(hl = &gPlayerLut, a);
    ld   hl, gPlayerLut
    call getItemOfArray8
    ; dialog/shop.c:484 hl += (de = playerLutMax);
    ld   de, 12
    add  hl, de
    ; dialog/shop.c:485 c = *hl;
    ld   c, (hl)
    ; dialog/shop.c:486 // с - кол-во
    ; dialog/shop.c:487 getItemOfArray16(hl = &lutNames, a);
    ld   hl, lutNames
    call getItemOfArray16
    ; dialog/shop.c:488 ex(hl, de);
    ex de, hl
    ; dialog/shop.c:489 // de - наименование
    ; dialog/shop.c:490 getItemOfArray16(hl = &lutPrices, a);
    ld   hl, lutPrices
    call getItemOfArray16
    ; dialog/shop.c:491 // hl - цена (hl *= c)
    ; dialog/shop.c:492 push(bc, de)
    ; dialog/shop.c:493 {
    push bc
    push de
    ; dialog/shop.c:494 d = 0; e = c;
    ld   d, 0
    ld   e, c
    ; dialog/shop.c:495 mul16();
    call mul16
    ; dialog/shop.c:496 }
    pop  de
    pop  bc
    ; dialog/shop.c:497 }
    ret
    ; dialog/shop.c:498 
    ; dialog/shop.c:499 // Сформировать текст для вывода на экран
    ; dialog/shop.c:500 // Вход: a - порядковый номер
    ; dialog/shop.c:501 // Выход: hl - строка (если hl = 0, то конец)
    ; dialog/shop.c:502 
    ; dialog/shop.c:503 void stopTradeLutGetText(a)
stopTradeLutGetText:
    ; dialog/shop.c:504 {
    ; dialog/shop.c:505 // Продать все
    ; dialog/shop.c:506 a -= 1;
    sub  1
    ; dialog/shop.c:507 if (flag_c)
    ; dialog/shop.c:508 {
    jp   nc, l4016
    ; dialog/shop.c:509 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; dialog/shop.c:510 strcpyn(hl, b = [gStringBufferSize - numberToString16max - 1], de = "Продать все\x09");
    ld   b, 26
    ld   de, s4018
    call strcpyn
    ; dialog/shop.c:511 de = shopSum;
    ld   de, (shopSum)
    ; dialog/shop.c:512 if (flag_z (a = d) |= e)
    ld   a, d
    or   e
    ; dialog/shop.c:513 {
    jp   nz, l4017
    ; dialog/shop.c:514 hl = 0;
    ld   hl, 0
    ; dialog/shop.c:515 return;
    ret
    ; dialog/shop.c:516 }
    ; dialog/shop.c:517 numberToString16(hl, de);
l4017:
    call numberToString16
    ; dialog/shop.c:518 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; dialog/shop.c:519 return;
    ret
    ; dialog/shop.c:520 }
    ; dialog/shop.c:521 
    ; dialog/shop.c:522 // По отдельности
    ; dialog/shop.c:523 if (a < *(hl = &gPlayerLutCount))
l4016:
    ld   hl, gPlayerLutCount
    cp   (hl)
    ; dialog/shop.c:524 {
    jp   nc, l4018
    ; dialog/shop.c:525 // Получить информацию
    ; dialog/shop.c:526 stopTradeLutGetNameCntPrice(a);
    call stopTradeLutGetNameCntPrice
    ; dialog/shop.c:527 // de - наимерование, hl - цена, c - кол-во
    ; dialog/shop.c:528 push(hl);
    push hl
    ; dialog/shop.c:529 push(bc);
    push bc
    ; dialog/shop.c:530 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; dialog/shop.c:531 strcpyn(hl, b = [gStringBufferSize - 3 - 2 - 1 - numberToString16max - 1], de);
    ld   b, 20
    call strcpyn
    ; dialog/shop.c:532 strcpyn(hl, b = 3, de = " * ");
    ld   b, 3
    ld   de, s4019
    call strcpyn
    ; dialog/shop.c:533 pop(de);
    pop  de
    ; dialog/shop.c:534 d = 0;
    ld   d, 0
    ; dialog/shop.c:535 if ((a = e) < 100) numberToString16(hl, de);
    ld   a, e
    cp   100
    call c, numberToString16
    ; dialog/shop.c:536 strcpyn(hl, b = 1, de = "\x09");
    ld   b, 1
    ld   de, s4004
    call strcpyn
    ; dialog/shop.c:537 pop(de);
    pop  de
    ; dialog/shop.c:538 numberToString16(hl, de);
    call numberToString16
    ; dialog/shop.c:539 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; dialog/shop.c:540 return;
    ret
    ; dialog/shop.c:541 }
    ; dialog/shop.c:542 
    ; dialog/shop.c:543 // Конец
    ; dialog/shop.c:544 hl = 0;
l4018:
    ld   hl, 0
    ; dialog/shop.c:545 return;
    ret
    ; dialog/shop.c:546 }
    ret
    ; dialog/shop.c:547 
    ; strings
s4004 db 9,0
s4009 db 13,0
s4019 db " * ",0
s4001 db " ?",13,0
s4000 db " �� ",0
s4013 db "��� �� ������",10,"������� �����!",13,"��",0
s4015 db "��� �� ������ �������",10,"��������� � �����.",10,"� ���� � ��� ������",10,"���-������ ������.",13,"��",0
s4005 db "�� �������, ��� ������",10,"������ ����������",0
s4012 db "�� �������, ��� ������",10,"������� ����������",0
s4007 db "��",0
s4002 db "������ ����, ��� �",10,"���� ��� ������?",13,"��� ���� ����",10,"� ���� ������",10,"� ���� �������",10,"� ���� ������� ���",0
s4006 db "���",0
s4010 db "��",0
s4018 db "������� ���",9,0
s4014 db "� ��� �� ������� �����.",10,"� �� ���� ������� ��� ���",10,"� ������. ����� ���� � ���",10,"���� ���-������ �� �������?",13,"��",0
s4016 db "������ ������",10,"���-������ ���?",13,"���",10,"��",0
s4017 db "������ �������",10,"���-������ ���?",13,"���",10,"��",0
s4003 db "��� �� ������ ������?",13,"������",0
s4011 db "��� �� ������ �������?",13,"������",0
s4008 db "��� ��� �����?",0
