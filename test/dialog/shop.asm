    ; 3 const int gStringBufferSize = 32;
    ; 5 const int gPanelChangedMoney = 0x01;
    ; 6 const int gPanelChangedPlace = 0x02;
    ; 8 const int numberToString16max = 5;
    ; 9 const int playerItemsMax = 5;
    ; 10 const int playerLutMaxCountInLine = 99;
    ; 11 const int playerLutMax = 12;
    ; 13 uint8_t shopSel = 0;
shopSel db 0
    ; 15 //+ Добавить магазин амулетов
    ; 17 void playerAddItem(a)
playerAddItem:
    ; 18 {
    ; 19 return addElement(de = &gPlayerItems, hl = &gPlayerItemsCount, c = playerItemsMax);
    ld   de, gPlayerItems
    ld   hl, gPlayerItemsCount
    ld   c, 5
    jp   addElement
    ; 20 }
    ret
    ; 23 void playerRemoveItem(a)
playerRemoveItem:
    ; 24 {
    ; 25 return removeElement(de = &gPlayerItems, hl = &gPlayerItemsCount, a);
    ld   de, gPlayerItems
    ld   hl, gPlayerItemsCount
    jp   removeElement
    ; 26 }
    ret
    ; 28 // Вход: d - тип предмета
    ; 30 void playerAddLut(d)
playerAddLut:
    ; 31 {
    ; 32 // Поиск этого предмета в кармане
    ; 34 hl = &gPlayerLut;
    ld   hl, gPlayerLut
    ; 35 a = gPlayerLutCount;
    ld   a, (gPlayerLutCount)
    ; 36 if (a != 0) // Если карман пуст, то не ищем
    or   a
    ; 37 {
    jp   z, l4000
    ; 38 b = a; // Для while который замеится на djnz
    ld   b, a
    ; 39 a = d; // Для ускорения поиска помещаем тип предмета в A
    ld   a, d
    ; 40 do {
l4001:
    ; 41 if (a == *hl) // Найден предмет этого типа
    cp   (hl)
    ; 42 {
    jp   nz, l4003
    ; 43 hl += (de = playerLutMax);
    ld   de, 12
    add  hl, de
    ; 44 a = *hl; // Учеличиваем кол-во
    ld   a, (hl)
    ; 45 a++;
    inc  a
    ; 46 if (a >= playerLutMaxCountInLine) a |= 0x80; // Исключаем из поиска
    cp   99
    jp   c, l4004
    or   128
    ; 47 return; // nz
l4004:
    ret
    ; 48 }
    ; 49 hl++;
l4003:
    inc  hl
    ; 50 } while(--b);
    djnz l4001
l4002:
    ; 52 // Если максимум ЛУТ-а, то выходим
    ; 53 a = gPlayerLutCount;
    ld   a, (gPlayerLutCount)
    ; 54 if (a == playerLutMax) return ; // Z - Нет места в кармане
    cp   12
    ret  z
    ; 55 }
    ; 57 gPlayerLutCount = ++a; // Тут получится флаг NZ
l4000:
    inc  a
    ld   (gPlayerLutCount), a
    ; 59 // Создаем новую запись
    ; 60 *hl = d;
    ld   (hl), d
    ; 61 hl += (de = playerLutMax);
    ld   de, 12
    add  hl, de
    ; 62 *hl = 1;
    ld   (hl), 1
    ; 64 // return nz
    ; 65 }
    ret
    ; 67 // Вход: a - порядковый номер ЛУТ-а
    ; 69 void playerRemoveLut(a)
playerRemoveLut:
    ; 70 {
    ; 71 push(a)
    ; 72 {
    push af
    ; 73 removeElement(de = &gPlayerLut, hl = &gPlayerLutCount, a);
    ld   de, gPlayerLut
    ld   hl, gPlayerLutCount
    call removeElement
    ; 74 }
    pop  af
    ; 75 return removeElement2(de = [&gPlayerLut + playerLutMax], hl = &gPlayerLutCount, a);
    ld   de, (gPlayerLut) + (12)
    ld   hl, gPlayerLutCount
    jp   removeElement2
    ; 76 }
    ret
    ; 78 void setPlayerMoney(hl)
setPlayerMoney:
    ; 79 {
    ; 80 gPlayerMoney = hl;
    ld   (gPlayerMoney), hl
    ; 81 hl = &gPanelChangedA;
    ld   hl, gPanelChangedA
    ; 82 *hl |= gPanelChangedMoney;
    set  0, (hl)
    ; 83 hl++;
    inc  hl
    ; 84 *hl |= gPanelChangedMoney;    
    set  0, (hl)
    ; 85 //panelRedraw:
    ; 86 //    return gFarCall(iyl = 7, ix = &gPanelRedraw);
    ; 87 }
    ret
    ; 89 //----------------------------------------------------------------------------------------------------------------------
    ; 90 // Названия всех заклинаний
    ; 92 const int itemsCount = 8;
    ; 94 uint16_t itemNames[itemsCount] = {
    ; 95 "Отвар листьев",
    ; 96 "Полное исцеление",
    ; 97 "Заклинание 1",
    ; 98 "Магические силы",
    ; 99 "Каменная кожа",
    ; 100 "Огонь бездны",
    ; 101 "Порча",
    ; 102 "Телепортация"
    ; 103 };
itemNames:
    dw s4000
    dw s4001
    dw s4002
    dw s4003
    dw s4004
    dw s4005
    dw s4006
    dw s4007
    ; 105 uint16_t lutNames[] = {
    ; 106 "Кожа змеи",
    ; 107 "Нож хобгоблина",
    ; 108 "Ядовитый клык",
    ; 109 "Кровь дракона",
    ; 110 "Кислота",
    ; 111 "Перья",
    ; 112 "Слизь",
    ; 113 "Копыта",
    ; 114 "Кольчуга",
    ; 115 "Изумруд",
    ; 116 "Золотое руно",
    ; 117 "Майоран"
    ; 118 };
lutNames:
    dw s4008
    dw s4009
    dw s4010
    dw s4011
    dw s4012
    dw s4013
    dw s4014
    dw s4015
    dw s4016
    dw s4017
    dw s4018
    dw s4019
    ; 120 uint16_t lutPrices[] = {
    ; 121 1,
    ; 122 2,
    ; 123 3
    ; 124 };
lutPrices:
    dw 1
    dw 2
    dw 3
    ; 126 uint16_t itemInfo[itemsCount] = {    
    ; 127 "*", //"Восстанавливает 10 единиц здоровья\r",
    ; 129 "*", //"Полностью восстанавливает здоровье\r",
    ; 131 "*", //"Полностью восстанавливает\n"
    ; 132 //"заклинание 1\r",
    ; 134 "*", //"Полностью восстанавливает\n"
    ; 135 //"все заклинания\r",
    ; 137 "Это заклинание делает вашу\n"
    ; 138 "плоть твердой как камень.\n"
    ; 139 "Пока заклинание активно,\n"
    ; 140 "урон уменьшается вдвое.",
    ; 142 "*", //"Полностью восстанавливает амулет\r",
    ; 144 "*", //"Пока заклинание активно,\n"
    ; 145 //"каждая ваша атака наноит в\n"
    ; 146 //"два раза больше урона врагу.\r",
    ; 148 "*" //"Это заклинание возращает\n"
    ; 149 //"Вас в последний посещенный\n"
    ; 150 //"вами город.\r"
    ; 151 };
itemInfo:
    dw s4020
    dw s4020
    dw s4020
    dw s4020
    dw s4021
    dw s4020
    dw s4020
    dw s4020
    ; 153 uint16_t itemPrices[itemsCount] = {
    ; 154 10,
    ; 155 20,
    ; 156 30,
    ; 157 40,
    ; 158 50,
    ; 159 60,
    ; 160 70,
    ; 161 80
    ; 162 };
itemPrices:
    dw 10
    dw 20
    dw 30
    dw 40
    dw 50
    dw 60
    dw 70
    dw 80
    ; 164 //----------------------------------------------------------------------------------------------------------------------
    ; 165 // Сформировать строку во временном буфере с наименованием и ценой.
    ; 166 // de - имя
    ; 167 // hl - цена
    ; 168 // bc - разделитель
    ; 170 void shopMakeNamePrice(bc, de, hl)
shopMakeNamePrice:
    ; 171 {
    ; 172 push(hl);
    push hl
    ; 173 push(bc);
    push bc
    ; 174 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; 175 strcpyn(hl, b = [gStringBufferSize - 7 - numberToString16max - 1], de); // Запас для " за  ?\r" или "\t"
    ld   b, 19
    call strcpyn
    ; 176 pop(de);
    pop  de
    ; 177 strcpyn(hl, b = 4, de);
    ld   b, 4
    call strcpyn
    ; 178 pop(de);
    pop  de
    ; 179 numberToString16(hl, de);
    call numberToString16
    ; 180 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; 181 }
    ret
    ; 183 //----------------------------------------------------------------------------------------------------------------------
    ; 184 // Сформировать строку во временном буфере с наименованием и ценой.
    ; 185 // de - имя
    ; 186 // hl - цена
    ; 188 void shopMakeNamePrice2()
shopMakeNamePrice2:
    ; 189 {
    ; 190 shopMakeNamePrice(bc = " за ");
    ld   bc, s4022
    call shopMakeNamePrice
    ; 191 // hl - указатель на начало строки, de - указатель на терминатор строки
    ; 192 // Добавляем строку
    ; 193 push (hl)
    ; 194 {
    push hl
    ; 195 ex(hl, de);
    ex de, hl
    ; 196 strcpyn(hl, b = 3, de = " ?\r");
    ld   b, 3
    ld   de, s4023
    call strcpyn
    ; 197 }
    pop  hl
    ; 198 }
    ret
    ; 200 //----------------------------------------------------------------------------------------------------------------------
    ; 201 // Главная страница магазина
    ; 203 void shopMain()
shopMain:
    ; 204 {
    ; 205 shopStart(de =
    ; 206 "Добрый день, чем я\n"
    ; 207 "могу вам помочь?"
    ; 208 "\r"
    ; 209 "Мне пора идти\n"
    ; 210 "Я хочу купить\n"
    ; 211 "Я хочу продать\n"
    ; 212 "Я хочу продать ЛУТ",
    ld   de, s4024
    ; 213 ix = 0
    ld   ix, 0
    ; 214 );
    call shopStart
    ; 215 if (flag_z a |= a) return; // Выход из магазина
    or   a
    ret  z
    ; 216 if (flag_z a--) return shopBuy();
    dec  a
    jp   z, shopBuy
    ; 217 if (flag_z a--) return shopTrade();
    dec  a
    jp   z, shopTrade
    ; 218 return shopTradeLut();
    jp   shopTradeLut
    ; 219 }
    ret
    ; 221 //----------------------------------------------------------------------------------------------------------------------
    ; 222 // Страница с товарами для покупки
    ; 224 void shopBuy()
shopBuy:
    ; 225 {
    ; 226 shopStart(de =
    ; 227 "Что вы хотите купить?"
    ; 228 "\r"
    ; 229 "Ничего",
    ld   de, s4025
    ; 230 ix = &shopBuyGetText
    ld   ix, shopBuyGetText
    ; 231 );
    call shopStart
    ; 232 if (flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; 233 shopSel = (--a);
    dec  a
    ld   (shopSel), a
    ; 234 return shopBuyItem();
    jp   shopBuyItem
    ; 235 }
    ret
    ; 237 // Вход: a - порядковый номер
    ; 238 // Выход: de - наименование, hl - цена продажи. Если нет предмета, то de = 0
    ; 240 void shopBuyGetNamePrice(a)
shopBuyGetNamePrice:
    ; 241 {
    ; 242 hl = 0;
    ld   hl, 0
    ; 243 de = 0;
    ld   de, 0
    ; 244 if (a >= itemsCount) return;
    cp   8
    ret  nc
    ; 245 getItemOfArray16(hl = &itemNames, a);
    ld   hl, itemNames
    call getItemOfArray16
    ; 246 ex(hl, de);
    ex de, hl
    ; 247 getItemOfArray16(hl = &itemPrices, a);
    ld   hl, itemPrices
    call getItemOfArray16
    ; 248 }
    ret
    ; 250 void shopBuyGetText(a)
shopBuyGetText:
    ; 251 {
    ; 252 shopBuyGetNamePrice(a);    
    call shopBuyGetNamePrice
    ; 253 if (flag_z (a ^= a) |= d) return;
    xor  a
    or   d
    ret  z
    ; 254 shopMakeNamePrice(bc = "\x09", hl, de);
    ld   bc, s4026
    call shopMakeNamePrice
    ; 255 }
    ret
    ; 257 //----------------------------------------------------------------------------------------------------------------------
    ; 258 // Страница с подтверждением покупки
    ; 260 void shopBuyItem()
shopBuyItem:
    ; 261 {
    ; 262 shopStart(de =
    ; 263 "Вы уверены, что хотите\n"
    ; 264 "купить заклинание",
    ld   de, s4027
    ; 265 ix = &shopBuyItemGetText
    ld   ix, shopBuyItemGetText
    ; 266 );
    call shopStart
    ; 268 if (flag_z a |= a) return shopBuy();
    or   a
    jp   z, shopBuy
    ; 269 if (flag_nz a--) return shopBuyInfo();
    dec  a
    jp   nz, shopBuyInfo
    ; 271 // Вычисление цены
    ; 272 shopBuyGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call shopBuyGetNamePrice
    ; 273 // hl - цена
    ; 275 // Хватит ли денег?
    ; 276 ex(hl, de);
    ex de, hl
    ; 277 (hl = gPlayerMoney) -= de;
    ld   hl, (gPlayerMoney)
    or   a
    sub  hl, de
    ; 278 if (flag_c) return shopBuyNoMoney();
    jp   c, shopBuyNoMoney
    ; 280 // Добавляем в карман
    ; 281 playerAddItem(a = shopSel);
    ld   a, (shopSel)
    call playerAddItem
    ; 282 if (flag_z) return shopBuyNoSpace();
    jp   z, shopBuyNoSpace
    ; 284 // Уменьшаем деньги
    ; 285 shopBuyGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call shopBuyGetNamePrice
    ; 286 // hl - цена
    ; 287 ex(hl, de);
    ex de, hl
    ; 288 (hl = gPlayerMoney) -= de;
    ld   hl, (gPlayerMoney)
    or   a
    sub  hl, de
    ; 289 setPlayerMoney(hl);
    call setPlayerMoney
    ; 291 // Переход на главную страницу
    ; 292 return shopAnyElseBuy();
    jp   shopAnyElseBuy
    ; 293 }
    ret
    ; 295 void shopBuyItemGetText()
shopBuyItemGetText:
    ; 296 {
    ; 297 if (flag_z a |= a)
    or   a
    ; 298 {
    jp   nz, l4005
    ; 299 shopBuyGetNamePrice(a = shopSel, de, hl);
    ld   a, (shopSel)
    call shopBuyGetNamePrice
    ; 300 // de - наимерование, hl - цена
    ; 301 shopMakeNamePrice2(hl, de); // Сформировать строку de + " за " + numberToString(hl) + " ?"
    call shopMakeNamePrice2
    ; 302 return;
    ret
    ; 303 }
    ; 304 hl = "Нет";            if (flag_z a--) return;
l4005:
    ld   hl, s4028
    dec  a
    ret  z
    ; 305 hl = "Да";             if (flag_z a--) return;
    ld   hl, s4029
    dec  a
    ret  z
    ; 306 hl = "Что это такое?"; if (flag_z a--) return;
    ld   hl, s4030
    dec  a
    ret  z
    ; 307 hl = 0;
    ld   hl, 0
    ; 308 }
    ret
    ; 310 //----------------------------------------------------------------------------------------------------------------------
    ; 311 // Страница с информацией о товаре
    ; 313 void shopBuyInfo()
shopBuyInfo:
    ; 314 {
    ; 315 getItemOfArray16(hl = &itemInfo, a = shopSel);
    ld   hl, itemInfo
    ld   a, (shopSel)
    call getItemOfArray16
    ; 316 ex(hl, de);
    ex de, hl
    ; 317 shopStart(de, ix = &shopBuyInfoGetText);
    ld   ix, shopBuyInfoGetText
    call shopStart
    ; 318 return shopBuyItem();
    jp   shopBuyItem
    ; 319 }
    ret
    ; 321 void shopBuyInfoGetText(a)
shopBuyInfoGetText:
    ; 322 {
    ; 323 hl = "\r"; if (flag_z a |= a) return;
    ld   hl, s4031
    or   a
    ret  z
    ; 324 hl = "Ок"; if (flag_z a--) return;
    ld   hl, s4032
    dec  a
    ret  z
    ; 325 hl = 0;
    ld   hl, 0
    ; 326 }
    ret
    ; 328 //----------------------------------------------------------------------------------------------------------------------
    ; 329 // Страница с товарами для продажи
    ; 331 void shopTrade()
shopTrade:
    ; 332 {
    ; 333 shopStart(de =
    ; 334 "Что вы хотите продать?"
    ; 335 "\r"
    ; 336 "Ничего",
    ld   de, s4033
    ; 337 ix = &stopTradeGetText
    ld   ix, stopTradeGetText
    ; 338 );
    call shopStart
    ; 339 if (flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; 340 shopSel = --a;
    dec  a
    ld   (shopSel), a
    ; 341 return shopTradeItem();
    jp   shopTradeItem
    ; 342 }
    ret
    ; 344 // Вход: a - порядковый номер
    ; 345 // Выход: z - нет предмена, de - наименование, hl - цена продажи
    ; 347 void stopTradeGetNamePrice(a)
stopTradeGetNamePrice:
    ; 348 {
    ; 349 getItemOfArray8(hl = &gPlayerItems, a);
    ld   hl, gPlayerItems
    call getItemOfArray8
    ; 350 hl = 0;
    ld   hl, 0
    ; 351 if (a == 0xFF) return; // return z
    cp   255
    ret  z
    ; 352 getItemOfArray16(hl = &itemNames, a);
    ld   hl, itemNames
    call getItemOfArray16
    ; 353 ex(hl, de);
    ex de, hl
    ; 354 // de - наименование
    ; 355 getItemOfArray16(hl = &itemPrices, a);
    ld   hl, itemPrices
    call getItemOfArray16
    ; 356 // hl - цена
    ; 357 h >>= 1; l >>c= 1; // Делим цену на 2
    srl  h
    rr   l
    ; 358 a |= d; // return nz
    or   d
    ; 359 }
    ret
    ; 361 void stopTradeGetText(a)
stopTradeGetText:
    ; 362 {
    ; 363 if (a >= *(hl = &gPlayerItemsCount))
    ld   hl, gPlayerItemsCount
    cp   (hl)
    ; 364 {
    jp   c, l4006
    ; 365 hl = 0;
    ld   hl, 0
    ; 366 return; // return hl = 0
    ret
    ; 367 }
    ; 368 stopTradeGetNamePrice(a);
l4006:
    call stopTradeGetNamePrice
    ; 369 if (flag_z) return; // В этой функции hl = 0, поэтому return hl = 0
    ret  z
    ; 370 // de - наимерование, hl - цена
    ; 371 shopMakeNamePrice(bc = "\x09", hl, de); // Сформировать строку de + "\x09" + numberToString(hl)
    ld   bc, s4026
    call shopMakeNamePrice
    ; 372 // hl - указатель на временную строку
    ; 373 }
    ret
    ; 375 //----------------------------------------------------------------------------------------------------------------------
    ; 376 // Страница с подтверждением продажи
    ; 378 void shopTradeItem()
shopTradeItem:
    ; 379 {
    ; 380 shopStart(de =
    ; 381 "Вы уверены, что хотите\n"
    ; 382 "продать заклинание",
    ld   de, s4034
    ; 383 ix = &shopTradeItemGetText
    ld   ix, shopTradeItemGetText
    ; 384 );
    call shopStart
    ; 385 if (flag_z a |= a) return shopTrade();
    or   a
    jp   z, shopTrade
    ; 387 // Узнаем цену
    ; 388 stopTradeGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call stopTradeGetNamePrice
    ; 389 // hl - цена
    ; 390 // Увеличиваем деньги игрока
    ; 391 hl += (de = gPlayerMoney);
    ld   de, (gPlayerMoney)
    add  hl, de
    ; 392 if (flag_c) { return shopOverflow(hl = &shopTrade); } // Денег больше, чем 65536 быть не может
    jp   nc, l4007
    ld   hl, shopTrade
    jp   shopOverflow
    ; 393 setPlayerMoney(hl);
l4007:
    call setPlayerMoney
    ; 394 // Удаляем предмет из кармана
    ; 395 playerRemoveItem(a = shopSel);  
    ld   a, (shopSel)
    call playerRemoveItem
    ; 396 // Возвращаемся в меню
    ; 397 return shopAnyElseTrade();
    jp   shopAnyElseTrade
    ; 398 }
    ret
    ; 400 void shopTradeItemGetText(a)
shopTradeItemGetText:
    ; 401 {
    ; 402 if (flag_z a |= a)
    or   a
    ; 403 {
    jp   nz, l4008
    ; 404 stopTradeGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call stopTradeGetNamePrice
    ; 405 // de - наименование, hl - цена
    ; 406 shopMakeNamePrice2(hl, de); // Сформировать строку: de + " за " + numberToString(hl) + " ?"
    call shopMakeNamePrice2
    ; 407 // hl - указатель на временную строку
    ; 408 return;
    ret
    ; 409 }
    ; 410 hl = "Нет"; if (flag_z a--) return;
l4008:
    ld   hl, s4028
    dec  a
    ret  z
    ; 411 hl = "Да";  if (flag_z a--) return;
    ld   hl, s4029
    dec  a
    ret  z
    ; 412 hl = 0;
    ld   hl, 0
    ; 413 }
    ret
    ; 415 //----------------------------------------------------------------------------------------------------------------------
    ; 416 // Страница с ошибкой
    ; 418 void shopOverflow(hl)
shopOverflow:
    ; 419 {
    ; 420 push(hl);
    push hl
    ; 421 shopStart(de =
    ; 422 "Вам не унести\n"
    ; 423 "столько денег!"
    ; 424 "\r"
    ; 425 "Ок",
    ld   de, s4035
    ; 426 ix = 0
    ld   ix, 0
    ; 427 );
    call shopStart
    ; 428 }
    ret
    ; 430 //----------------------------------------------------------------------------------------------------------------------
    ; 431 // Страница с ошибкой
    ; 433 void shopBuyNoMoney()
shopBuyNoMoney:
    ; 434 {
    ; 435 shopStart(de =
    ; 436 "У вас не хватает денег.\n"
    ; 437 "Я не могу продать вам это\n"
    ; 438 "в кредит. Может быть у вас\n"
    ; 439 "есть что-нибудь на продажу?"
    ; 440 "\r"
    ; 441 "Ок",
    ld   de, s4036
    ; 442 ix = 0
    ld   ix, 0
    ; 443 );
    call shopStart
    ; 444 return shopBuy();
    jp   shopBuy
    ; 445 }
    ret
    ; 447 //----------------------------------------------------------------------------------------------------------------------
    ; 448 // Страница с ошибкой
    ; 450 void shopBuyNoSpace()
shopBuyNoSpace:
    ; 451 {
    ; 452 shopStart(de =
    ; 453 "Вам не унести сколько\n"
    ; 454 "предметов с собой.\n"
    ; 455 "Я могу у вас купить\n"
    ; 456 "что-нибудь лишнее."
    ; 457 "\r"
    ; 458 "Ок",
    ld   de, s4037
    ; 459 ix = 0
    ld   ix, 0
    ; 460 );
    call shopStart
    ; 461 return shopBuy();
    jp   shopBuy
    ; 462 }
    ret
    ; 464 //----------------------------------------------------------------------------------------------------------------------
    ; 465 // Страница с продолжением покупки
    ; 467 void shopAnyElseBuy()
shopAnyElseBuy:
    ; 468 {
    ; 469 shopStart(de =
    ; 470 "Хотите купить\n"
    ; 471 "что-нибудь еще?"
    ; 472 "\r"
    ; 473 "Нет\n"
    ; 474 "Да",
    ld   de, s4038
    ; 475 ix = 0
    ld   ix, 0
    ; 476 );
    call shopStart
    ; 477 if(flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; 478 return shopBuy();
    jp   shopBuy
    ; 479 }
    ret
    ; 481 //----------------------------------------------------------------------------------------------------------------------
    ; 482 // Страница с продолжением покупки
    ; 484 void shopAnyElseTrade()
shopAnyElseTrade:
    ; 485 {
    ; 486 shopStart(de =
    ; 487 "Хотите продать\n"
    ; 488 "что-нибудь еще?"
    ; 489 "\r"
    ; 490 "Нет\n"
    ; 491 "Да",
    ld   de, s4039
    ; 492 ix = 0
    ld   ix, 0
    ; 493 );
    call shopStart
    ; 494 if(flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; 495 return shopTrade();
    jp   shopTrade
    ; 496 }
    ret
    ; 498 //----------------------------------------------------------------------------------------------------------------------
    ; 499 // Страница с ЛУТ-ом для продажи
    ; 501 uint16_t shopSum;
shopSum dw 0
    ; 503 void shopTradeLut()
shopTradeLut:
    ; 504 {
    ; 505 while()
l4009:
    ; 506 {
    ; 507 // Расчет общей суммы
    ; 508 hl = 0;
    ld   hl, 0
    ; 509 a = gPlayerLutCount;
    ld   a, (gPlayerLutCount)
    ; 510 while(a != 0)
l4011:
    or   a
    jp   z, l4012
    ; 511 {
    ; 512 a--;
    dec  a
    ; 513 push(hl);
    push hl
    ; 514 push(a)
    ; 515 {
    push af
    ; 516 stopTradeLutGetNameCntPrice(a);
    call stopTradeLutGetNameCntPrice
    ; 517 }
    pop  af
    ; 518 pop(de);
    pop  de
    ; 519 hl += de;
    add  hl, de
    ; 520 }
    jp   l4011
l4012:
    ; 521 shopSum = hl;
    ld   (shopSum), hl
    ; 523 // Диалог
    ; 524 shopStart(de =
    ; 525 "Что вы хотите продать?"
    ; 526 "\r"
    ; 527 "Ничего",
    ld   de, s4033
    ; 528 ix = &stopTradeLutGetText
    ld   ix, stopTradeLutGetText
    ; 529 );
    call shopStart
    ; 531 // Выход
    ; 532 a -= 1;
    sub  1
    ; 533 if (flag_c) return shopMain();
    jp   c, shopMain
    ; 535 // Продать всё
    ; 536 if (flag_z)
    ; 537 {
    jp   nz, l4013
    ; 538 hl = gPlayerMoney;
    ld   hl, (gPlayerMoney)
    ; 539 hl += (de = shopSum);
    ld   de, (shopSum)
    add  hl, de
    ; 540 if (flag_c) { return shopOverflow(hl = &shopTradeLut); } // Денег больше, чем 65536 быть не может
    jp   nc, l4014
    ld   hl, shopTradeLut
    jp   shopOverflow
    ; 541 setPlayerMoney(hl);
l4014:
    call setPlayerMoney
    ; 542 gPlayerLutCount = a = 0; // Удаляем все предметы
    ld   a, 0
    ld   (gPlayerLutCount), a
    ; 543 return shopMain();
    jp   shopMain
    ; 544 }
    ; 546 // Продать один
    ; 547 a--;
l4013:
    dec  a
    ; 548 shopSel = a;
    ld   (shopSel), a
    ; 549 // Узнаем цену
    ; 550 stopTradeLutGetNameCntPrice(a);
    call stopTradeLutGetNameCntPrice
    ; 551 // hl - цена
    ; 552 // Увеличиваем деньги игрока
    ; 553 hl += (de = gPlayerMoney);
    ld   de, (gPlayerMoney)
    add  hl, de
    ; 554 if (flag_c) { return shopOverflow(hl = &shopTradeLut); } // Денег больше, чем 65536 быть не может
    jp   nc, l4015
    ld   hl, shopTradeLut
    jp   shopOverflow
    ; 555 setPlayerMoney(hl);
l4015:
    call setPlayerMoney
    ; 556 // Удаляем предмет из кармана
    ; 557 playerRemoveLut(a = shopSel);
    ld   a, (shopSel)
    call playerRemoveLut
    ; 558 }
    jp   l4009
l4010:
    ; 559 }
    ret
    ; 561 // Получить информацию о ЛУТ-е
    ; 562 // Вход: a - порядковый номер
    ; 563 // Выход: de - наименование, hl - цена, c - кол-во
    ; 565 void stopTradeLutGetNameCntPrice(a)
stopTradeLutGetNameCntPrice:
    ; 566 {
    ; 567 getItemOfArray8(hl = &gPlayerLut, a);
    ld   hl, gPlayerLut
    call getItemOfArray8
    ; 568 hl += (de = playerLutMax);
    ld   de, 12
    add  hl, de
    ; 569 c = *hl;
    ld   c, (hl)
    ; 570 // с - кол-во
    ; 571 getItemOfArray16(hl = &lutNames, a);
    ld   hl, lutNames
    call getItemOfArray16
    ; 572 ex(hl, de);
    ex de, hl
    ; 573 // de - наименование
    ; 574 getItemOfArray16(hl = &lutPrices, a);
    ld   hl, lutPrices
    call getItemOfArray16
    ; 575 // hl - цена (hl *= c)
    ; 576 push(bc, de)
    ; 577 {
    push bc
    push de
    ; 578 d = 0; e = c;
    ld   d, 0
    ld   e, c
    ; 579 mul16();
    call mul16
    ; 580 }
    pop  de
    pop  bc
    ; 581 }
    ret
    ; 583 // Сформировать текст для вывода на экран
    ; 584 // Вход: a - порядковый номер
    ; 585 // Выход: hl - строка (если hl = 0, то конец)
    ; 587 void stopTradeLutGetText(a)
stopTradeLutGetText:
    ; 588 {
    ; 589 // Продать все
    ; 590 a -= 1;
    sub  1
    ; 591 if (flag_c)
    ; 592 {
    jp   nc, l4016
    ; 593 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; 594 strcpyn(hl, b = [gStringBufferSize - numberToString16max - 1], de = "Продать все\x09");
    ld   b, 26
    ld   de, s4040
    call strcpyn
    ; 595 de = shopSum;
    ld   de, (shopSum)
    ; 596 if (flag_z (a = d) |= e)
    ld   a, d
    or   e
    ; 597 {
    jp   nz, l4017
    ; 598 hl = 0;
    ld   hl, 0
    ; 599 return;
    ret
    ; 600 }
    ; 601 numberToString16(hl, de);
l4017:
    call numberToString16
    ; 602 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; 603 return;
    ret
    ; 604 }
    ; 606 // По отдельности
    ; 607 if (a < *(hl = &gPlayerLutCount))
l4016:
    ld   hl, gPlayerLutCount
    cp   (hl)
    ; 608 {
    jp   nc, l4018
    ; 609 // Получить информацию
    ; 610 stopTradeLutGetNameCntPrice(a);
    call stopTradeLutGetNameCntPrice
    ; 611 // de - наимерование, hl - цена, c - кол-во
    ; 612 push(hl);
    push hl
    ; 613 push(bc);
    push bc
    ; 614 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; 615 strcpyn(hl, b = [gStringBufferSize - 3 - 2 - 1 - numberToString16max - 1], de);
    ld   b, 20
    call strcpyn
    ; 616 strcpyn(hl, b = 3, de = " x ");
    ld   b, 3
    ld   de, s4041
    call strcpyn
    ; 617 pop(de);
    pop  de
    ; 618 d = 0;
    ld   d, 0
    ; 619 if ((a = e) < 100) numberToString16(hl, de);
    ld   a, e
    cp   100
    call c, numberToString16
    ; 620 strcpyn(hl, b = 1, de = "\x09");
    ld   b, 1
    ld   de, s4026
    call strcpyn
    ; 621 pop(de);
    pop  de
    ; 622 numberToString16(hl, de);
    call numberToString16
    ; 623 hl = &gStringBuffer;
    ld   hl, gStringBuffer
    ; 624 return;
    ret
    ; 625 }
    ; 627 // Конец
    ; 628 hl = 0;
l4018:
    ld   hl, 0
    ; 629 return;
    ret
    ; 630 }
    ret
    ; strings
s4026 db 9,0
s4031 db 13,0
s4023 db " ?",13,0
s4041 db " x ",0
s4022 db " за ",0
s4020 db "*",0
s4035 db "Вам не унести",10,"столько денег!",13,"Ок",0
s4037 db "Вам не унести сколько",10,"предметов с собой.",10,"Я могу у вас купить",10,"что-нибудь лишнее.",13,"Ок",0
s4027 db "Вы уверены, что хотите",10,"купить заклинание",0
s4034 db "Вы уверены, что хотите",10,"продать заклинание",0
s4029 db "Да",0
s4024 db "Добрый день, чем я",10,"могу вам помочь?",13,"Мне пора идти",10,"Я хочу купить",10,"Я хочу продать",10,"Я хочу продать ЛУТ",0
s4002 db "Заклинание 1",0
s4018 db "Золотое руно",0
s4017 db "Изумруд",0
s4004 db "Каменная кожа",0
s4012 db "Кислота",0
s4008 db "Кожа змеи",0
s4016 db "Кольчуга",0
s4015 db "Копыта",0
s4011 db "Кровь дракона",0
s4003 db "Магические силы",0
s4019 db "Майоран",0
s4028 db "Нет",0
s4009 db "Нож хобгоблина",0
s4005 db "Огонь бездны",0
s4032 db "Ок",0
s4000 db "Отвар листьев",0
s4013 db "Перья",0
s4001 db "Полное исцеление",0
s4006 db "Порча",0
s4040 db "Продать все",9,0
s4014 db "Слизь",0
s4007 db "Телепортация",0
s4036 db "У вас не хватает денег.",10,"Я не могу продать вам это",10,"в кредит. Может быть у вас",10,"есть что-нибудь на продажу?",13,"Ок",0
s4038 db "Хотите купить",10,"что-нибудь еще?",13,"Нет",10,"Да",0
s4039 db "Хотите продать",10,"что-нибудь еще?",13,"Нет",10,"Да",0
s4025 db "Что вы хотите купить?",13,"Ничего",0
s4033 db "Что вы хотите продать?",13,"Ничего",0
s4030 db "Что это такое?",0
s4021 db "Это заклинание делает вашу",10,"плоть твердой как камень.",10,"Пока заклинание активно,",10,"урон уменьшается вдвое.",0
s4010 db "Ядовитый клык",0
