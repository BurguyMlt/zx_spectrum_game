    ; 3 const int numberToString16max = 5;
    ; 4 const int playerItemsMax = 5;
    ; 6 //+ Добавить магазин амулетов
    ; 8 //----------------------------------------------------------------------------------------------------------------------
    ; 9 // Названия всех заклинаний
    ; 11 const int itemsCount = 8;
    ; 13 uint16_t itemNames[itemsCount] = {
    ; 14 "Отвар листьев",
    ; 15 "Полное исцеление",
    ; 16 "Заклинание 1",
    ; 17 "Магические силы",
    ; 18 "Каменная кожа",
    ; 19 "Огонь бездны",
    ; 20 "Порча",
    ; 21 "Телепортация"
    ; 22 };
itemNames:
    dw s4000
    dw s4001
    dw s4002
    dw s4003
    dw s4004
    dw s4005
    dw s4006
    dw s4007
    ; 24 uint16_t itemInfo[itemsCount] = {    
    ; 25 "*", //"Восстанавливает 10 единиц здоровья\r",
    ; 27 "*", //"Полностью восстанавливает здоровье\r",
    ; 29 "*", //"Полностью восстанавливает\n"
    ; 30 //"заклинание 1\r",
    ; 32 "*", //"Полностью восстанавливает\n"
    ; 33 //"все заклинания\r",
    ; 35 "Это заклинание делает вашу\n"
    ; 36 "плоть твердой как камень.\n"
    ; 37 "Пока заклинание активно,\n"
    ; 38 "урон уменьшается вдвое.",
    ; 40 "*", //"Полностью восстанавливает амулет\r",
    ; 42 "*", //"Пока заклинание активно,\n"
    ; 43 //"каждая ваша атака наноит в\n"
    ; 44 //"два раза больше урона врагу.\r",
    ; 46 "*" //"Это заклинание возращает\n"
    ; 47 //"Вас в последний посещенный\n"
    ; 48 //"вами город.\r"
    ; 49 };
itemInfo:
    dw s4008
    dw s4008
    dw s4008
    dw s4008
    dw s4009
    dw s4008
    dw s4008
    dw s4008
    ; 51 uint16_t itemPrices[itemsCount] = {
    ; 52 10,
    ; 53 20,
    ; 54 30,
    ; 55 40,
    ; 56 50,
    ; 57 60,
    ; 58 70,
    ; 59 80
    ; 60 };
itemPrices:
    dw 10
    dw 20
    dw 30
    dw 40
    dw 50
    dw 60
    dw 70
    dw 80
    ; 62 //----------------------------------------------------------------------------------------------------------------------
    ; 63 // Временный буфер для формирвоания строки с вопросом
    ; 65 const int tmpStringSize = 32;
    ; 66 uint8_t tmpString[tmpStringSize];
tmpString ds 32
    ; 68 //----------------------------------------------------------------------------------------------------------------------
    ; 69 // Сформировать строку во временном буфере с наименованием и ценой.
    ; 70 // de - имя
    ; 71 // hl - цена
    ; 72 // bc - разделитель
    ; 74 void shopMakeNamePrice(bc, de, hl)
shopMakeNamePrice:
    ; 75 {
    ; 76 push(hl);
    push hl
    ; 77 push(bc);
    push bc
    ; 78 hl = &tmpString;
    ld   hl, tmpString
    ; 79 strcpyn(hl, b = [tmpStringSize - 7 - numberToString16max - 1], de); // Запас для " за  ?\r" или "\t"
    ld   b, 19
    call strcpyn
    ; 80 pop(de);
    pop  de
    ; 81 strcpyn(hl, b = 4, de);
    ld   b, 4
    call strcpyn
    ; 82 pop(de);
    pop  de
    ; 83 numberToString16(hl, de);
    call numberToString16
    ; 84 hl = &tmpString;
    ld   hl, tmpString
    ; 85 }
    ret
    ; 87 //----------------------------------------------------------------------------------------------------------------------
    ; 88 // Сформировать строку во временном буфере с наименованием и ценой.
    ; 89 // de - имя
    ; 90 // hl - цена
    ; 92 void shopMakeNamePrice2()
shopMakeNamePrice2:
    ; 93 {
    ; 94 shopMakeNamePrice(bc = " за ");
    ld   bc, s4010
    call shopMakeNamePrice
    ; 95 // hl - указатель на начало строки, de - указатель на терминатор строки
    ; 96 // Добавляем строку
    ; 97 push (hl)
    ; 98 {
    push hl
    ; 99 ex(hl, de);
    ex de, hl
    ; 100 strcpyn(hl, b = 3, de = " ?\r");
    ld   b, 3
    ld   de, s4011
    call strcpyn
    ; 101 }
    pop  hl
    ; 102 }
    ret
    ; 104 //----------------------------------------------------------------------------------------------------------------------
    ; 105 // Главная страница магазина
    ; 107 void shopMain()
shopMain:
    ; 108 {
    ; 109 shopStart(de =
    ; 110 "Добрый день, чем я\n"
    ; 111 "могу вам помочь?"
    ; 112 "\r"
    ; 113 "Мне пора идти\n"
    ; 114 "Я хочу купить\n"
    ; 115 "Я хочу продать",
    ld   de, s4012
    ; 116 ix = 0
    ld   ix, 0
    ; 117 );
    call shopStart
    ; 118 if (flag_z a |= a) return; // Выход из магазина
    or   a
    ret  z
    ; 119 if (flag_z a--) return shopBuy();
    dec  a
    jp   z, shopBuy
    ; 120 return shopTrade();
    jp   shopTrade
    ; 121 }
    ret
    ; 123 //----------------------------------------------------------------------------------------------------------------------
    ; 124 // Страница с товарами для покупки
    ; 126 void shopBuy()
shopBuy:
    ; 127 {
    ; 128 shopStart(de =
    ; 129 "Что вы хотите купить?"
    ; 130 "\r"
    ; 131 "Ничего",
    ld   de, s4013
    ; 132 ix = &shopBuyGetText
    ld   ix, shopBuyGetText
    ; 133 );
    call shopStart
    ; 134 if (flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; 135 shopSel = (--a);
    dec  a
    ld   (shopSel), a
    ; 136 return shopBuyItem();
    jp   shopBuyItem
    ; 137 }
    ret
    ; 139 // Вход: a - порядковый номер
    ; 140 // Выход: de - наименование, hl - цена продажи. Если нет предмета, то de = 0
    ; 142 void shopBuyGetNamePrice(a)
shopBuyGetNamePrice:
    ; 143 {
    ; 144 hl = 0;
    ld   hl, 0
    ; 145 de = 0;
    ld   de, 0
    ; 146 if (a >= itemsCount) return;
    cp   8
    ret  nc
    ; 147 getItemOfArray16(hl = &itemNames, a);
    ld   hl, itemNames
    call getItemOfArray16
    ; 148 ex(hl, de);
    ex de, hl
    ; 149 getItemOfArray16(hl = &itemPrices, a);
    ld   hl, itemPrices
    call getItemOfArray16
    ; 150 }
    ret
    ; 152 void shopBuyGetText(a)
shopBuyGetText:
    ; 153 {
    ; 154 shopBuyGetNamePrice(a);    
    call shopBuyGetNamePrice
    ; 155 if (flag_z (a ^= a) |= d) return;
    xor  a
    or   d
    ret  z
    ; 156 shopMakeNamePrice(bc = "\x09", hl, de);
    ld   bc, s4014
    call shopMakeNamePrice
    ; 157 }
    ret
    ; 159 //----------------------------------------------------------------------------------------------------------------------
    ; 160 // Страница с подтверждением покупки
    ; 162 void shopBuyItem()
shopBuyItem:
    ; 163 {
    ; 164 shopStart(de =
    ; 165 "Вы уверены, что хотите\n"
    ; 166 "купить заклинание",
    ld   de, s4015
    ; 167 ix = &shopBuyItemGetText
    ld   ix, shopBuyItemGetText
    ; 168 );
    call shopStart
    ; 170 if (flag_z a |= a) return shopBuy();
    or   a
    jp   z, shopBuy
    ; 171 if (flag_nz a--) return shopBuyInfo();
    dec  a
    jp   nz, shopBuyInfo
    ; 173 // Вычисление цены
    ; 174 shopBuyGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call shopBuyGetNamePrice
    ; 175 // hl - цена
    ; 177 // Хватит ли денег?
    ; 178 ex(hl, de);
    ex de, hl
    ; 179 subHlDe(hl = gPlayerMoney); //! Доработать компилятор
    ld   hl, (gPlayerMoney)
    call subHlDe
    ; 180 if (flag_c) return shopBuyNoMoney();
    jp   c, shopBuyNoMoney
    ; 182 // Добавляем в карман
    ; 183 playerAddItem(a = shopSel);
    ld   a, (shopSel)
    call playerAddItem
    ; 184 if (flag_nz) return shopBuyNoSpace();
    jp   nz, shopBuyNoSpace
    ; 186 // Уменьшаем деньги
    ; 187 shopBuyGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call shopBuyGetNamePrice
    ; 188 // hl - цена
    ; 189 ex(hl, de);
    ex de, hl
    ; 190 subHlDe(hl = gPlayerMoney);
    ld   hl, (gPlayerMoney)
    call subHlDe
    ; 191 setPlayerMoney(hl);
    call setPlayerMoney
    ; 193 // Переход на главную страницу
    ; 194 return shopAnyElseBuy();
    jp   shopAnyElseBuy
    ; 195 }
    ret
    ; 197 void shopBuyItemGetText()
shopBuyItemGetText:
    ; 198 {
    ; 199 if (flag_z a |= a)
    or   a
    ; 200 {
    jp   nz, l4000
    ; 201 shopBuyGetNamePrice(a = shopSel, de, hl);
    ld   a, (shopSel)
    call shopBuyGetNamePrice
    ; 202 // de - наимерование, hl - цена
    ; 203 shopMakeNamePrice2(hl, de); // Сформировать строку de + " за " + numberToString(hl) + " ?"
    call shopMakeNamePrice2
    ; 204 return;
    ret
    ; 205 }
    ; 206 hl = "Нет";            if (flag_z a--) return;
l4000:
    ld   hl, s4016
    dec  a
    ret  z
    ; 207 hl = "Да";             if (flag_z a--) return;
    ld   hl, s4017
    dec  a
    ret  z
    ; 208 hl = "Что это такое?"; if (flag_z a--) return;
    ld   hl, s4018
    dec  a
    ret  z
    ; 209 hl = 0;
    ld   hl, 0
    ; 210 }
    ret
    ; 212 //----------------------------------------------------------------------------------------------------------------------
    ; 213 // Страница с информацией о товаре
    ; 215 void shopBuyInfo()
shopBuyInfo:
    ; 216 {
    ; 217 getItemOfArray16(hl = &itemInfo, a = shopSel);
    ld   hl, itemInfo
    ld   a, (shopSel)
    call getItemOfArray16
    ; 218 ex(hl, de);
    ex de, hl
    ; 219 shopStart(de, ix = &shopBuyInfoGetText);
    ld   ix, shopBuyInfoGetText
    call shopStart
    ; 220 return shopBuyItem();
    jp   shopBuyItem
    ; 221 }
    ret
    ; 223 void shopBuyInfoGetText(a)
shopBuyInfoGetText:
    ; 224 {
    ; 225 hl = "\r"; if (flag_z a |= a) return;
    ld   hl, s4019
    or   a
    ret  z
    ; 226 hl = "Ок"; if (flag_z a--) return;
    ld   hl, s4020
    dec  a
    ret  z
    ; 227 hl = 0;
    ld   hl, 0
    ; 228 }
    ret
    ; 230 //----------------------------------------------------------------------------------------------------------------------
    ; 231 // Страница с товарами для продажи
    ; 233 uint8_t shopSel = 0;
shopSel db 0
    ; 235 void shopTrade()
shopTrade:
    ; 236 {
    ; 237 shopStart(de =
    ; 238 "Что вы хотите продать?"
    ; 239 "\r"
    ; 240 "Ничего",
    ld   de, s4021
    ; 241 ix = &stopTradeGetText
    ld   ix, stopTradeGetText
    ; 242 );
    call shopStart
    ; 243 if (flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; 244 shopSel = --a;
    dec  a
    ld   (shopSel), a
    ; 245 return shopTradeItem();
    jp   shopTradeItem
    ; 246 }
    ret
    ; 248 // Вход: a - порядковый номер
    ; 249 // Выход: z - нет предмена, de - наименование, hl - цена продажи
    ; 251 void stopTradeGetNamePrice(a)
stopTradeGetNamePrice:
    ; 252 {
    ; 253 getItemOfArray8(hl = &playerItems, a);
    ld   hl, playerItems
    call getItemOfArray8
    ; 254 hl = 0;
    ld   hl, 0
    ; 255 if (a == 0xFF) return; // return z
    cp   255
    ret  z
    ; 256 getItemOfArray16(hl = &itemNames, a);
    ld   hl, itemNames
    call getItemOfArray16
    ; 257 ex(hl, de);
    ex de, hl
    ; 258 // de - наименование
    ; 259 getItemOfArray16(hl = &itemPrices, a);
    ld   hl, itemPrices
    call getItemOfArray16
    ; 260 // hl - цена
    ; 261 h >>= 1; l >>c= 1; // Делим цену на 2
    srl  h
    rr   l
    ; 262 a |= d; // return nz
    or   d
    ; 263 }
    ret
    ; 265 void stopTradeGetText(a)
stopTradeGetText:
    ; 266 {
    ; 267 hl = 0;
    ld   hl, 0
    ; 268 if (a >= playerItemsMax) return; // return hl = 0
    cp   5
    ret  nc
    ; 269 stopTradeGetNamePrice(a);
    call stopTradeGetNamePrice
    ; 270 if (flag_z) return; // В этой функции hl = 0, поэтому return hl = 0
    ret  z
    ; 271 // de - наимерование, hl - цена
    ; 272 shopMakeNamePrice(bc = "\x09", hl, de); // Сформировать строку de + "\x09" + numberToString(hl)
    ld   bc, s4014
    call shopMakeNamePrice
    ; 273 // hl - указатель на временную строку
    ; 274 }
    ret
    ; 276 //----------------------------------------------------------------------------------------------------------------------
    ; 277 // Страница с подтверждением продажи
    ; 279 void shopTradeItem()
shopTradeItem:
    ; 280 {
    ; 281 shopStart(de =
    ; 282 "Вы уверены, что хотите\n"
    ; 283 "продать заклинание",
    ld   de, s4022
    ; 284 ix = &shopTradeItemGetText
    ld   ix, shopTradeItemGetText
    ; 285 );
    call shopStart
    ; 286 if (flag_z a |= a) return shopTrade();
    or   a
    jp   z, shopTrade
    ; 288 // Узнаем цену
    ; 289 stopTradeGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call stopTradeGetNamePrice
    ; 290 // hl - цена
    ; 291 // Увеличиваем деньги игрока
    ; 292 hl += (de = gPlayerMoney);
    ld   de, (gPlayerMoney)
    add  hl, de
    ; 293 if (flag_c) return shopTradeOverflow(); // Денег больше, чем 65536 быть не может
    jp   c, shopTradeOverflow
    ; 294 setPlayerMoney(hl);
    call setPlayerMoney
    ; 295 // Удаляем предмет из кармана
    ; 296 playerRemoveItem(a = shopSel);  
    ld   a, (shopSel)
    call playerRemoveItem
    ; 297 // Возвращаемся в меню
    ; 298 return shopAnyElseTrade();
    jp   shopAnyElseTrade
    ; 299 }
    ret
    ; 301 void shopTradeItemGetText(a)
shopTradeItemGetText:
    ; 302 {
    ; 303 if (flag_z a |= a)
    or   a
    ; 304 {
    jp   nz, l4001
    ; 305 stopTradeGetNamePrice(a = shopSel);
    ld   a, (shopSel)
    call stopTradeGetNamePrice
    ; 306 // de - наименование, hl - цена
    ; 307 shopMakeNamePrice2(hl, de); // Сформировать строку: de + " за " + numberToString(hl) + " ?"
    call shopMakeNamePrice2
    ; 308 // hl - указатель на временную строку
    ; 309 return;
    ret
    ; 310 }
    ; 311 hl = "Нет"; if (flag_z a--) return;
l4001:
    ld   hl, s4016
    dec  a
    ret  z
    ; 312 hl = "Да";  if (flag_z a--) return;
    ld   hl, s4017
    dec  a
    ret  z
    ; 313 hl = 0;
    ld   hl, 0
    ; 314 }
    ret
    ; 316 //----------------------------------------------------------------------------------------------------------------------
    ; 317 // Страница с ошибкой
    ; 319 void shopTradeOverflow()
shopTradeOverflow:
    ; 320 {
    ; 321 shopStart(de =
    ; 322 "Вам не унести\n"
    ; 323 "столько денег!"
    ; 324 "\r"
    ; 325 "Ок",
    ld   de, s4023
    ; 326 ix = 0
    ld   ix, 0
    ; 327 );
    call shopStart
    ; 328 return shopTrade();
    jp   shopTrade
    ; 329 }
    ret
    ; 331 //----------------------------------------------------------------------------------------------------------------------
    ; 332 // Страница с ошибкой
    ; 334 void shopBuyNoMoney()
shopBuyNoMoney:
    ; 335 {
    ; 336 shopStart(de =
    ; 337 "У вас не хватает денег.\n"
    ; 338 "Я не могу продать вам это\n"
    ; 339 "в кредит. Может быть у вас\n"
    ; 340 "есть что-нибудь на продажу?"
    ; 341 "\r"
    ; 342 "Ок",
    ld   de, s4024
    ; 343 ix = 0
    ld   ix, 0
    ; 344 );
    call shopStart
    ; 345 return shopBuy();
    jp   shopBuy
    ; 346 }
    ret
    ; 348 //----------------------------------------------------------------------------------------------------------------------
    ; 349 // Страница с ошибкой
    ; 351 void shopBuyNoSpace()
shopBuyNoSpace:
    ; 352 {
    ; 353 shopStart(de =
    ; 354 "Вам не унести сколько\n"
    ; 355 "предметов с собой.\n"
    ; 356 "Я могу у вас купить\n"
    ; 357 "что-нибудь лишнее."
    ; 358 "\r"
    ; 359 "Ок",
    ld   de, s4025
    ; 360 ix = 0
    ld   ix, 0
    ; 361 );
    call shopStart
    ; 362 return shopBuy();
    jp   shopBuy
    ; 363 }
    ret
    ; 365 //----------------------------------------------------------------------------------------------------------------------
    ; 366 // Страница с продолжением покупки
    ; 368 void shopAnyElseBuy()
shopAnyElseBuy:
    ; 369 {
    ; 370 shopStart(de =
    ; 371 "Хотите купить\n"
    ; 372 "что-нибудь еще?"
    ; 373 "\r"
    ; 374 "Нет\n"
    ; 375 "Да",
    ld   de, s4026
    ; 376 ix = 0
    ld   ix, 0
    ; 377 );
    call shopStart
    ; 378 if(flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; 379 return shopBuy();
    jp   shopBuy
    ; 380 }
    ret
    ; 382 //----------------------------------------------------------------------------------------------------------------------
    ; 383 // Страница с продолжением покупки
    ; 385 void shopAnyElseTrade()
shopAnyElseTrade:
    ; 386 {
    ; 387 shopStart(de =
    ; 388 "Хотите продать\n"
    ; 389 "что-нибудь еще?"
    ; 390 "\r"
    ; 391 "Нет\n"
    ; 392 "Да",
    ld   de, s4027
    ; 393 ix = 0
    ld   ix, 0
    ; 394 );
    call shopStart
    ; 395 if(flag_z a |= a) return shopMain();
    or   a
    jp   z, shopMain
    ; 396 return shopTrade();
    jp   shopTrade
    ; 397 }
    ret
    ; strings
s4014 db 9,0
s4019 db 13,0
s4011 db " ?",13,0
s4010 db " за ",0
s4008 db "*",0
s4023 db "Вам не унести",10,"столько денег!",13,"Ок",0
s4025 db "Вам не унести сколько",10,"предметов с собой.",10,"Я могу у вас купить",10,"что-нибудь лишнее.",13,"Ок",0
s4015 db "Вы уверены, что хотите",10,"купить заклинание",0
s4022 db "Вы уверены, что хотите",10,"продать заклинание",0
s4017 db "Да",0
s4012 db "Добрый день, чем я",10,"могу вам помочь?",13,"Мне пора идти",10,"Я хочу купить",10,"Я хочу продать",0
s4002 db "Заклинание 1",0
s4004 db "Каменная кожа",0
s4003 db "Магические силы",0
s4016 db "Нет",0
s4005 db "Огонь бездны",0
s4020 db "Ок",0
s4000 db "Отвар листьев",0
s4001 db "Полное исцеление",0
s4006 db "Порча",0
s4007 db "Телепортация",0
s4024 db "У вас не хватает денег.",10,"Я не могу продать вам это",10,"в кредит. Может быть у вас",10,"есть что-нибудь на продажу?",13,"Ок",0
s4026 db "Хотите купить",10,"что-нибудь еще?",13,"Нет",10,"Да",0
s4027 db "Хотите продать",10,"что-нибудь еще?",13,"Нет",10,"Да",0
s4013 db "Что вы хотите купить?",13,"Ничего",0
s4021 db "Что вы хотите продать?",13,"Ничего",0
s4018 db "Что это такое?",0
s4009 db "Это заклинание делает вашу",10,"плоть твердой как камень.",10,"Пока заклинание активно,",10,"урон уменьшается вдвое.",0
