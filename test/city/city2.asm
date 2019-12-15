    ; 3 const int playerLutMax = 12;
    ; 5 const int KEY_UP = 1;
    ; 6 const int KEY_DOWN = 2;
    ; 7 const int KEY_LEFT = 4;
    ; 8 const int KEY_RIGHT = 8;
    ; 9 const int KEY_FIRE = 16;
    ; 11 const int PORT_7FFD_SECOND_VIDEO_PAGE = 8;
    ; 13 const int screenAddr1 = 0x4000;
    ; 14 const int screenAddr2 = 0xC000;
    ; 15 const int screenWidth = 256;
    ; 16 const int screenHeight = 192;
    ; 17 const int screenBwSize = screenWidth / 8 * screenHeight;
    ; 18 const int screenAttrSize = screenWidth / 8 * screenHeight / 8;
    ; 19 const int screenAttrAddr1 = screenAddr1 + screenBwSize;
    ; 20 const int screenAttrAddr2 = screenAddr2 + screenBwSize;
    ; 21 const int screenEndAddr1 = screenAttrAddr1 + screenAttrSize;
    ; 22 const int screenEndAddr2 = screenAttrAddr2 + screenAttrSize;
    ; 23 const int cacheAddr1 = screenEndAddr1;
    ; 24 const int cacheAddr2 = screenEndAddr2;
    ; 25 const int unusedTailCode = 0xFE;
    ; 26 const int viewWidth = 32;
    ; 27 const int viewHeight = 20;
    ; 28 const int cityRoadY = 13;
    ; 29 const int mapWidth = 256;
    ; 31 const int npc_timer           = 0;
    ; 32 const int npc_flags           = 1;
    ; 33 const int npc_flags_direction = 0x01;
    ; 34 const int npc_flags_type      = 0x02;
    ; 35 const int npc_step            = 2;
    ; 36 const int npc_position        = 3;
    ; 37 const int npc_sizeof          = 4;
    ; 39 const int npc_maxCount = 16;
    ; 40 const int npc_defaultSpeed = 7;
    ; 42 uint8_t cityPlayerX = 0;
cityPlayerX db 0
    ; 43 uint8_t cityScrollX = 0;
cityScrollX db 0
    ; 44 uint8_t cityPlayerDirection = 0;
cityPlayerDirection db 0
    ; 45 uint16_t cityPlayerSprite = &city1s_0;
cityPlayerSprite dw city1s_0
    ; 46 uint8_t processedFrames = 0;
processedFrames db 0
    ; 47 //uint8_t startFrame;
    ; 48 uint8_t npcCount = npc_maxCount;
npcCount db 16
    ; 49 uint8_t npc[npc_sizeof * npc_maxCount];
npc ds 64
    ; 51 void swapMaps()
swapMaps:
    ; 52 {
    ; 53 // Загрузка города
    ; 54 hl = &city1Tails;
    ld   hl, city1Tails
    ; 55 de = &city1bTails;
    ld   de, city1bTails
    ; 56 bc = [9 * 256 + 256 * 20];
    ld   bc, 7424
    ; 57 do
l2000:
    ; 58 {
    ; 59 a = *de;
    ld   a, (de)
    ; 60 ex(a, a);
    ex   af, af
    ; 61 a = *hl;
    ld   a, (hl)
    ; 62 *de = a;
    ld   (de), a
    ; 63 ex(a, a);
    ex   af, af
    ; 64 *hl = a;
    ld   (hl), a
    ; 65 hl++;
    inc  hl
    ; 66 de++;
    inc  de
    ; 67 bc--;
    dec  bc
    ; 68 } while(flag_nz (a = b) |= c);
    ld   a, b
    or   c
    jp   nz, l2000
l2001:
    ; 69 }
    ret
    ; 71 void cityFullRedraw()
cityFullRedraw:
    ; 72 {
    ; 73 cityInvalidate(hl = cacheAddr1);
    ld   hl, 23296
    call cityInvalidate
    ; 74 //*[cacheAddr1 + screenAttrSize] = a = 0;
    ; 75 cityInvalidate(hl = cacheAddr2);
    ld   hl, 56064
    call cityInvalidate
    ; 76 //*[cacheAddr2 + screenAttrSize] = a = 0;
    ; 77 gPanelChangedA = a = 0xFF;
    ld   a, 255
    ld   (gPanelChangedA), a
    ; 78 gPanelChangedB = a;
    ld   (gPanelChangedB), a
    ; 79 }
    ret
    ; 81 void newGame()
newGame:
    ; 82 {
    ; 83 gPlayerMoney = hl = 10;
    ld   hl, 10
    ld   (gPlayerMoney), hl
    ; 84 gPlayerItemsCount = a = 2;
    ld   a, 2
    ld   (gPlayerItemsCount), a
    ; 85 *[&gPlayerItems] = a = 0;
    ld   a, 0
    ld   (gPlayerItems), a
    ; 86 *[&gPlayerItems + 1] = a = 1;
    ld   a, 1
    ld   ((gPlayerItems) + (1)), a
    ; 88 gPlayerLutCount = a = 3;
    ld   a, 3
    ld   (gPlayerLutCount), a
    ; 89 *[&gPlayerLut + 0] = a = 0;
    ld   a, 0
    ld   ((gPlayerLut) + (0)), a
    ; 90 *[&gPlayerLut + playerLutMax + 0] = a = 5;
    ld   a, 5
    ld   ((gPlayerLut) + (12)), a
    ; 91 *[&gPlayerLut + 1] = a = 1;
    ld   a, 1
    ld   ((gPlayerLut) + (1)), a
    ; 92 *[&gPlayerLut + playerLutMax + 1] = a = 10;
    ld   a, 10
    ld   ((gPlayerLut) + (13)), a
    ; 93 *[&gPlayerLut + 2] = a = 2;
    ld   a, 2
    ld   ((gPlayerLut) + (2)), a
    ; 94 *[&gPlayerLut + playerLutMax + 2] = a = 15;
    ld   a, 15
    ld   ((gPlayerLut) + (14)), a
    ; 95 }
    ret
    ; 97 void main()
main:
    ; 98 {
    ; 99 newGame();
    call newGame
    ; 101 gPanelChangedA = a = 0xFF;
    ld   a, 255
    ld   (gPanelChangedA), a
    ; 102 gPanelChangedB = a;
    ld   (gPanelChangedB), a
    ; 104 cityPlayerX = a = [mapWidth / 2];
    ld   a, 128
    ld   (cityPlayerX), a
    ; 105 cityScrollX = (a -= [viewWidth / 2]);
    sub  16
    ld   (cityScrollX), a
    ; 107 // Перерисовать панель    
    ; 108 gDrawPanel();
    call gDrawPanel
    ; 110 // Инициализация NPC
    ; 111 initNpc();
    call initNpc
    ; 113 //swapMaps();
    ; 115 // Инициализация кеша
    ; 116 cityFullRedraw();
    call cityFullRedraw
    ; 118 // Перерисовать
    ; 119 while()
l2002:
    ; 120 {
    ; 121 gBeginDraw();
    call gBeginDraw
    ; 122 cityDraw();
    call cityDraw
    ; 123 gEndDraw();
    call gEndDraw
    ; 125 while ((a = gFrame) != *(hl = &processedFrames))
l2004:
    ld   a, (gFrame)
    ld   hl, processedFrames
    cp   (hl)
    jp   z, l2005
    ; 126 {
    ; 127 *hl = a;
    ld   (hl), a
    ; 128 a &= 3;
    and  3
    ; 129 if (flag_z) processPlayer();
    call z, processPlayer
    ; 130 processNpc();
    call processNpc
    ; 131 }
    jp   l2004
l2005:
    ; 132 }
    jp   l2002
l2003:
    ; 133 }
    ret
    ; 135 void cityInvalidate(hl)
cityInvalidate:
    ; 136 {
    ; 137 d = h; e = l; de++;
    ld   d, h
    ld   e, l
    inc  de
    ; 138 *hl = unusedTailCode;
    ld   (hl), 254
    ; 139 bc = [viewWidth * viewHeight - 1];
    ld   bc, 639
    ; 140 ldir();
    ldir
    ; 141 }
    ret
    ; 143 //----------------------------------------------------------------------------------------------------------------------
    ; 144 // Инициализация жителей
    ; 146 void initNpc()
initNpc:
    ; 147 {
    ; 148 ix = &npc;
    ld   ix, npc
    ; 149 de = npc_sizeof;
    ld   de, 4
    ; 150 b = a = npcCount; // Счетчик цикла
    ld   a, (npcCount)
    ld   b, a
    ; 151 do
l2006:
    ; 152 {
    ; 153 a = b;
    ld   a, b
    ; 154 while (a >= npc_defaultSpeed) a -= npc_defaultSpeed;
l2008:
    cp   7
    jp   c, l2009
    sub  7
    jp   l2008
l2009:
    ; 155 a += 1;
    add  1
    ; 156 ix[npc_timer] = a; // Фаза таймера
    ld   (ix + 0), a
    ; 158 ix[npc_step] = 0;
    ld   (ix + 2), 0
    ; 159 rand();
    call rand
    ; 160 ix[npc_position] = a;
    ld   (ix + 3), a
    ; 161 ix[npc_flags] = (a &= [npc_flags_direction | npc_flags_type]);
    and  3
    ld   (ix + 1), a
    ; 162 ix += de;
    add  ix, de
    ; 163 } while(--b);
    djnz l2006
l2007:
    ; 164 }
    ret
    ; 166 //----------------------------------------------------------------------------------------------------------------------
    ; 167 // Перемещение и анимация жителей.
    ; 169 void processNpc()
processNpc:
    ; 170 {
    ; 171 de = npc_sizeof;
    ld   de, 4
    ; 172 hl = &npc;
    ld   hl, npc
    ; 173 b = a = npcCount;
    ld   a, (npcCount)
    ld   b, a
    ; 174 do
l2010:
    ; 175 {
    ; 176 if (flag_z --*hl) // Скорость
    dec  (hl)
    ; 177 {
    jp   nz, l2012
    ; 178 rand();
    call rand
    ; 179 if (flag_z a--) // Внезапная остановка
    dec  a
    ; 180 {
    jp   nz, l2013
    ; 181 //! Не полушаге не останавливать
    ; 182 push(hl);
    push hl
    ; 183 pop(ix);
    pop  ix
    ; 184 //a = ix[npc_spriteType];
    ; 185 //if (a == 1)
    ; 186 //{
    ; 187 *hl = 255;
    ld   (hl), 255
    ; 188 goto continue1;
    jp   continue1
    ; 189 //}
    ; 190 }
    ; 192 // У всех разная скорость
    ; 193 *hl = (((a = b) &= 7) += npc_defaultSpeed);
l2013:
    ld   a, b
    and  7
    add  7
    ld   (hl), a
    ; 195 if (flag_z a--) // Внезапный поворот
    dec  a
    ; 196 {
    jp   nz, l2014
    ; 197 hl++;
    inc  hl
    ; 198 a = *hl;
    ld   a, (hl)
    ; 199 a ^= npc_flags_direction;
    xor  1
    ; 200 *hl = a;
    ld   (hl), a
    ; 201 hl--;
    dec  hl
    ; 202 }
    ; 204 hl++;
l2014:
    inc  hl
    ; 205 if (*hl & npc_flags_direction) // Направление
    bit  0, (hl)
    ; 206 {
    jp   z, l2015
    ; 207 hl++;
    inc  hl
    ; 208 a = *hl;
    ld   a, (hl)
    ; 209 a++;
    inc  a
    ; 210 if (a >= 4) { a = 0; hl++; ++*hl; hl--; }
    cp   4
    jp   c, l2016
    ld   a, 0
    inc  hl
    inc  (hl)
    dec  hl
    ; 211 *hl = a;
l2016:
    ld   (hl), a
    ; 212 }
    ; 213 else
    jp   l2017
l2015:
    ; 214 {
    ; 215 hl++;
    inc  hl
    ; 216 a = *hl;
    ld   a, (hl)
    ; 217 a++;
    inc  a
    ; 218 if (a >= 4) { a = 0; hl++; --*hl; hl--; }
    cp   4
    jp   c, l2018
    ld   a, 0
    inc  hl
    dec  (hl)
    dec  hl
    ; 219 *hl = a;
l2018:
    ld   (hl), a
    ; 220 }
l2017:
    ; 221 hl++; hl++;
    inc  hl
    inc  hl
    ; 222 }
    ; 223 else
    jp   l2019
l2012:
    ; 224 {
    ; 225 continue1:
continue1:
    ; 226 hl += de; // Следующий NPC
    add  hl, de
    ; 227 }
l2019:
    ; 228 } while(flag_nz --b);
    dec  b
    jp   nz, l2010
l2011:
    ; 229 }
    ret
    ; 231 //----------------------------------------------------------------------------------------------------------------------
    ; 232 // Вход: hl - должно указывать на npc_position
    ; 233 // Выход: hl - адрес спрайта
    ; 234 // Портит: a
    ; 236 // const int npc_timer      = 0;
    ; 237 // const int npc_direction  = 1;
    ; 238 // const int npc_step       = 2;
    ; 239 // const int npc_position   = 3;
    ; 240 // const int npc_sprite_l   = 4;
    ; 241 // const int npc_sprite_h   = 5;
    ; 242 // const int npc_sizeof     = 6;
    ; 244 void getNpcSprite(hl)
getNpcSprite:
    ; 245 {
    ; 246 // Вычисление номера спрайта
    ; 247 hl--;
    dec  hl
    ; 248 hl--;
    dec  hl
    ; 249 a = *hl; // npc_direction + npc_type
    ld   a, (hl)
    ; 250 a += a;
    add  a
    ; 251 a += a;
    add  a
    ; 252 hl++;
    inc  hl
    ; 253 a += *hl; // npc_step
    add  (hl)
    ; 255 // Получение элемента массива
    ; 256 l = ((a += a) += &sprite_citizen);
    add  a
    add  sprite_citizen
    ld   l, a
    ; 257 h = ((a +@= [&sprite_citizen >> 8]) -= l);
    adc  (sprite_citizen) >> (8)
    sub  l
    ld   h, a
    ; 258 a = *hl; hl++; h = *hl; l = a;
    ld   a, (hl)
    inc  hl
    ld   h, (hl)
    ld   l, a
    ; 259 }
    ret
    ; 261 uint16_t sprite_citizen[16] =
    ; 262 {
    ; 263 &city1s_15, &city1s_16, &city1s_17, &city1s_14,
    ; 264 &city1s_21, &city1s_20, &city1s_19, &city1s_18,
    ; 266 &city1s_9,  &city1s_8,  &city1s_7,  &city1s_6,
    ; 267 &city1s_10, &city1s_11, &city1s_12, &city1s_13
    ; 268 };
sprite_citizen:
    dw city1s_15
    dw city1s_16
    dw city1s_17
    dw city1s_14
    dw city1s_21
    dw city1s_20
    dw city1s_19
    dw city1s_18
    dw city1s_9
    dw city1s_8
    dw city1s_7
    dw city1s_6
    dw city1s_10
    dw city1s_11
    dw city1s_12
    dw city1s_13
    ; 270 //----------------------------------------------------------------------------------------------------------------------
    ; 271 // Управление игроком и анимация игрока.
    ; 273 const int sprite_raistlin_left       = &city1s_0;
    ; 274 const int sprite_raistlin_left_step  = &city1s_1;
    ; 275 const int sprite_raistlin_right      = &city1s_3;
    ; 276 const int sprite_raistlin_right_step = &city1s_4;
    ; 278 void processPlayer()
processPlayer:
    ; 279 {
    ; 280 if (*(hl = &gKeyTrigger) & KEY_FIRE)
    ld   hl, gKeyTrigger
    bit  4, (hl)
    ; 281 {
    jp   z, l2020
    ; 282 *hl = 0;
    ld   (hl), 0
    ; 283 // На двух видеостраницах должно быть идентичное изображение, причем активной должна быть вторая видеостраница
    ; 284 hl = &gVideoPage;
    ld   hl, gVideoPage
    ; 285 while ((a = *hl) & 1);
l2021:
    ld   a, (hl)
    bit  0, a
    jp   z, l2022
    jp   l2021
l2022:
    ; 286 if (flag_z a & 8)
    bit  3, a
    ; 287 {
    jp   nz, l2023
    ; 288 gBeginDraw();
    call gBeginDraw
    ; 289 cityDraw();
    call cityDraw
    ; 290 gEndDraw();
    call gEndDraw
    ; 291 hl = &gVideoPage;
    ld   hl, gVideoPage
    ; 292 while ((a = *hl) & 1);
l2024:
    ld   a, (hl)
    bit  0, a
    jp   z, l2025
    jp   l2024
l2025:
    ; 293 }
    ; 295 // Переход к магазину
    ; 296 gFarCall(iyl = 6, ix = 0xC000);
l2023:
    ld   iyl, 6
    ld   ix, 49152
    call gFarCall
    ; 298 // Перерисовать всё
    ; 299 cityInvalidate(hl = cacheAddr1);
    ld   hl, 23296
    call cityInvalidate
    ; 300 cityInvalidate(hl = cacheAddr2);
    ld   hl, 56064
    call cityInvalidate
    ; 301 return;
    ret
    ; 302 }
    ; 304 b = a = gKeyPressed;
l2020:
    ld   a, (gKeyPressed)
    ld   b, a
    ; 305 c = a = cityPlayerDirection;
    ld   a, (cityPlayerDirection)
    ld   c, a
    ; 306 a = cityPlayerX;
    ld   a, (cityPlayerX)
    ; 307 if (b & KEY_LEFT)
    bit  2, b
    ; 308 {
    jp   z, l2026
    ; 309 if (c & 1)
    bit  0, c
    ; 310 {            
    jp   z, l2027
    ; 311 cityPlayerDirection = (a ^= a);
    xor  a
    ld   (cityPlayerDirection), a
    ; 312 c = a;
    ld   c, a
    ; 313 }
    ; 314 else
    jp   l2028
l2027:
    ; 315 {
    ; 316 a -= 1;
    sub  1
    ; 317 if (flag_nc)
    ; 318 {
    jp   c, l2029
    ; 319 cityPlayerX = a;
    ld   (cityPlayerX), a
    ; 321 // Прокрутка экрана
    ; 322 a -= [viewWidth / 2]; if (flag_nc) if (a < [mapWidth - viewWidth / 2 * 2 + 1]) { cityScrollX = a; } //! Почему нельзя без {} ?
    sub  16
    jp   c, l2030
    cp   225
    jp   nc, l2031
    ld   (cityScrollX), a
    ; 324 hl = sprite_raistlin_left;
l2031:
l2030:
    ld   hl, city1s_0
    ; 325 if ((a = cityPlayerSprite) == l) hl = sprite_raistlin_left_step;
    ld   a, (cityPlayerSprite)
    cp   l
    jp   nz, l2032
    ld   hl, city1s_1
    ; 326 cityPlayerSprite = hl;
l2032:
    ld   (cityPlayerSprite), hl
    ; 327 return;
    ret
    ; 328 }
    ; 329 }
l2029:
l2028:
    ; 330 }
    ; 331 else if (b & KEY_RIGHT)
    jp   l2033
l2026:
    bit  3, b
    ; 332 {
    jp   z, l2034
    ; 333 if (flag_z c & 1)
    bit  0, c
    ; 334 {
    jp   nz, l2035
    ; 335 cityPlayerDirection = (a = 1);
    ld   a, 1
    ld   (cityPlayerDirection), a
    ; 336 c = a;
    ld   c, a
    ; 337 }
    ; 338 else
    jp   l2036
l2035:
    ; 339 {
    ; 340 a += 1;
    add  1
    ; 341 if (flag_nc)
    ; 342 {
    jp   c, l2037
    ; 343 cityPlayerX = a;
    ld   (cityPlayerX), a
    ; 345 // Прокрутка экрана
    ; 346 a -= [viewWidth / 2]; if (flag_nc) if (a < [mapWidth - viewWidth / 2 * 2 + 1]) { cityScrollX = a; }  //! Почему нельзя без {} ?
    sub  16
    jp   c, l2038
    cp   225
    jp   nc, l2039
    ld   (cityScrollX), a
    ; 348 hl = sprite_raistlin_right;
l2039:
l2038:
    ld   hl, city1s_3
    ; 349 if ((a = cityPlayerSprite) == l) hl = sprite_raistlin_right_step;
    ld   a, (cityPlayerSprite)
    cp   l
    jp   nz, l2040
    ld   hl, city1s_4
    ; 350 cityPlayerSprite = hl;
l2040:
    ld   (cityPlayerSprite), hl
    ; 351 return;
    ret
    ; 352 }
    ; 353 }
l2037:
l2036:
    ; 354 }
    ; 356 // Убираем анимацию шага, если ни одна клавиша не нажата
    ; 357 hl = sprite_raistlin_left;
l2034:
l2033:
    ld   hl, city1s_0
    ; 358 if (c & 1) hl = sprite_raistlin_right;
    bit  0, c
    jp   z, l2041
    ld   hl, city1s_3
    ; 359 cityPlayerSprite = hl;
l2041:
    ld   (cityPlayerSprite), hl
    ; 360 }
    ret
    ; 362 //----------------------------------------------------------------------------------------------------------------------
    ; 364 void cityDraw()
cityDraw:
    ; 365 {
    ; 366 // Оценка времени
    ; 367 //startFrame = a = gFrame;
    ; 369 // Обновить панель
    ; 370 gPanelRedraw();
    call gPanelRedraw
    ; 372 // Адрес карты / и сточник
    ; 373 d` = [&city1Map >> 8];
    ld   d, (city1Map) >> (8)
    ; 374 e` = a = cityScrollX;
    ld   a, (cityScrollX)
    ld   e, a
    ; 375 b` = e`;
    ld   b, e
    ; 377 // Адрес видеостраницы / назначение
    ; 378 if (flag_z (a = gVideoPage) &= 0x80)
    ld   a, (gVideoPage)
    and  128
    ; 379 {
    jp   nz, l2042
    ; 380 hl` = [cacheAddr1 - 1];
    ld   hl, 23295
    ; 381 ex(bc, de, hl);
    exx
    ; 382 de = screenAddr1;
    ld   de, 16384
    ; 383 bc = screenAttrAddr1;
    ld   bc, 22528
    ; 384 }
    ; 385 else
    jp   l2043
l2042:
    ; 386 {
    ; 387 hl` = [cacheAddr2 - 1];
    ld   hl, 56063
    ; 388 ex(bc, de, hl);
    exx
    ; 389 de = screenAddr2;
    ld   de, 49152
    ; 390 bc = screenAttrAddr2;
    ld   bc, 55296
    ; 391 }
l2043:
    ; 393 // Цикл строк
    ; 394 ixh = viewHeight;
    ld   ixh, 20
    ; 395 do
l2044:
    ; 396 {
    ; 397 // Сохранение адреса вывода
    ; 398 iy = de;
    ld   iyh, d
    ld   iyl, e
    ; 400 // Цикл стобцов
    ; 401 ixl = viewWidth;
    ld   ixl, 32
    ; 402 do
l2046:
    ; 403 {
    ; 404 optimize0:  // Чтение номера тейла из карты уровня
optimize0:
    ; 405 ex(bc, de, hl);
    exx
    ; 406 hl`++;
    inc  hl
    ; 407 c` = *hl;
    ld   c, (hl)
    ; 408 a = *de`;
    ld   a, (de)
    ; 409 if (a == c`) goto optimize1;
    cp   c
    jp   z, optimize1
    ; 410 if (flag_z c`++) goto optimize3;
    inc  c
    jp   z, optimize3
    ; 411 e`++;
    inc  e
    ; 412 *hl` = a;
    ld   (hl), a
    ; 413 ex(bc, de, hl);
    exx
    ; 415 // Вычисление адреса тейла
    ; 416 h = [&city1Tails >> 8];
    ld   h, (city1Tails) >> (8)
    ; 417 l = a;
    ld   l, a
    ; 419 // Вывод на экран
    ; 420 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 421 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 422 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 423 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 424 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 425 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 426 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 427 a = *hl; h++; *de = a;
    ld   a, (hl)
    inc  h
    ld   (de), a
    ; 428 a = *hl;      *bc = a; bc++;
    ld   a, (hl)
    ld   (bc), a
    inc  bc
    ; 430 d = iyh;
    ld   d, iyh
    ; 431 e++;
    inc  e
    ; 432 ixl--;
    dec  ixl
    ; 433 } while(flag_nz);
    jp   nz, l2046
l2047:
    ; 434 optimize2:
optimize2:
    ; 436 // Следующая строка карты
    ; 437 ex(bc, de, hl);
    exx
    ; 438 e` = b`;
    ld   e, b
    ; 439 d`++;
    inc  d
    ; 440 ex(bc, de, hl);
    exx
    ; 442 // Адрес следующей чб строки на экране
    ; 443 e = ((a = iyl) += 0x20);
    ld   a, iyl
    add  32
    ld   e, a
    ; 444 if (flag_c) d = ((a = d) += 0x08);
    jp   nc, l2048
    ld   a, d
    add  8
    ld   d, a
    ; 446 ixh--;
l2048:
    dec  ixh
    ; 447 } while(flag_nz);
    jp   nz, l2044
l2045:
    ; 449 drawSprites();
    call drawSprites
    ; 451 // Оценка времени
    ; 452 //printDelay((a = gFrame) -= *(hl = &startFrame));
    ; 454 return;
    ret
    ; 455 optimize3:
optimize3:
    ; 456 *hl` = a = 254;
    ld   a, 254
    ld   (hl), a
    ; 457 optimize1:
optimize1:
    ; 458 e`++;
    inc  e
    ; 459 ex(bc, de, hl);
    exx
    ; 460 bc++;
    inc  bc
    ; 461 e++;
    inc  e
    ; 462 ixl--;
    dec  ixl
    ; 463 if(flag_nz) goto optimize0;
    jp   nz, optimize0
    ; 464 goto optimize2;
    jp   optimize2
    ; 465 }
    ret
    ; 467 void drawSprites()
drawSprites:
    ; 468 {
    ; 469 a = gVideoPage;
    ld   a, (gVideoPage)
    ; 470 if (a & 8) ixh = [screenAddr1 >> 8];
    bit  3, a
    jp   z, l2049
    ld   ixh, 64
    ; 471 else ixh = [screenAddr2 >> 8];
    jp   l2050
l2049:
    ld   ixh, 192
l2050:
    ; 473 // const int npc_timer      = 0;
    ; 474 // const int npc_direction  = 1;
    ; 475 // const int npc_step       = 2;
    ; 476 // const int npc_position   = 3;
    ; 477 // const int npc_sprite_l   = 4;
    ; 478 // const int npc_sprite_h   = 5;
    ; 479 // const int npc_sizeof     = 6;
    ; 481 // Спрайты
    ; 482 hl = [&npc + npc_position];
    ld   hl, (npc) + (3)
    ; 483 b = a = npcCount;
    ld   a, (npcCount)
    ld   b, a
    ; 484 c = (a = cityScrollX); c--;
    ld   a, (cityScrollX)
    ld   c, a
    dec  c
    ; 485 de = npc_sizeof;
    ld   de, 4
    ; 486 do
l2051:
    ; 487 {
    ; 488 // Если спрайт за экраном, то не рисуем его
    ; 489 if (((a = *hl) -= c) < [viewWidth + 1]) //! для const int можно <=
    ld   a, (hl)
    sub  c
    cp   33
    ; 490 {
    jp   nc, l2053
    ; 491 push(bc, de, hl)
    ; 492 {
    push bc
    push de
    push hl
    ; 493 c = --a; // Для drawSprite
    dec  a
    ld   c, a
    ; 495 // Цвет {
    ; 496 a = b;
    ld   a, b
    ; 497 while(a >= 14) a -= 14;
l2054:
    cp   14
    jp   c, l2055
    sub  14
    jp   l2054
l2055:
    ; 498 if (a >= 7) a += [0x40 - 7]; a++;
    cp   7
    jp   c, l2056
    add  57
l2056:
    inc  a
    ; 499 iyh = a;
    ld   iyh, a
    ; 500 // }
    ; 502 getNpcSprite(hl);
    call getNpcSprite
    ; 503 b = cityRoadY;
    ld   b, 13
    ; 504 drawSprite();
    call drawSprite
    ; 505 }
    pop  hl
    pop  de
    pop  bc
    ; 506 }
    ; 507 hl += de;
l2053:
    add  hl, de
    ; 508 } while(--b);
    djnz l2051
l2052:
    ; 510 // Рисование игрока
    ; 511 b = cityRoadY;
    ld   b, 13
    ; 512 c++;
    inc  c
    ; 513 c = ((a = cityPlayerX) -= c);
    ld   a, (cityPlayerX)
    sub  c
    ld   c, a
    ; 514 hl = cityPlayerSprite;
    ld   hl, (cityPlayerSprite)
    ; 515 if ((a = l) == &city1s_1) c--;
    ld   a, l
    cp   city1s_1
    jp   nz, l2057
    dec  c
    ; 516 iyh = 0;
l2057:
    ld   iyh, 0
    ; 517 drawSprite(bc, de, hl);
    call drawSprite
    ; 518 }
    ret
    ; 520 // Вывод спрайта
    ; 521 // c - координата X (от -1 до 31)
    ; 522 // b - координата Y (от 0 до 23)
    ; 523 // hl - спрайт
    ; 525 void drawSprite(bc, hl, ixh, iyh)
drawSprite:
    ; 526 {
    ; 527 // Читаем ширину спрайта
    ; 528 d = *hl; l++;
    ld   d, (hl)
    inc  l
    ; 530 // Если спрайт за левым краем экрана
    ; 531 if (c & 0x80) //! Можно оптимизировать
    bit  7, c
    ; 532 do
    jp   z, l2058
l2059:
    ; 533 {
    ; 534 l = ((a = l) += [4 * 9]);
    ld   a, l
    add  36
    ld   l, a
    ; 535 c++;
    inc  c
    ; 536 d--;
    dec  d
    ; 537 if (flag_z) return;
    ret  z
    ; 538 } while (c & 0x80);
    bit  7, c
    jp   nz, l2059
l2060:
    ; 540 // Если спрайт за правым краем экрана
    ; 541 (a = viewWidth) -= c;
l2058:
    ld   a, 32
    sub  c
    ; 542 if (flag_c) return;
    ret  c
    ; 543 if (flag_z) return;
    ret  z
    ; 544 if (a < d) d = a;
    cp   d
    jp   nc, l2061
    ld   d, a
    ; 545 iyl = d;
l2061:
    ld   iyl, d
    ; 547 // Вычисление координаты
    ; 548 //       43210    43210
    ; 549 // de .1.43... 210.....
    ; 550 // bc .1.11.43 210.....
    ; 551 d = (((a = b) &= 0x18) |= ixh);
    ld   a, b
    and  24
    or   ixh
    ld   d, a
    ; 552 a = b;
    ld   a, b
    ; 553 a >>r= 3;
    rrca
    rrca
    rrca
    ; 554 b = a;
    ld   b, a
    ; 555 c = e = ((a &= 0xE0) |= c);
    and  224
    or   c
    ld   e, a
    ld   c, e
    ; 556 b = ((((a = b) &= 0x03) |= 0x18) |= ixh);
    ld   a, b
    and  3
    or   24
    or   ixh
    ld   b, a
    ; 558 while()
l2062:
    ; 559 {
    ; 560 push(bc, de)
    ; 561 {
    push bc
    push de
    ; 562 drawSprite1(bc, de, hl);
    call drawSprite1
    ; 563 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 564 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2064
    ld   a, d
    add  8
    ld   d, a
    ; 565 drawSprite1(bc, de, hl);
l2064:
    call drawSprite1
    ; 566 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 567 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2065
    ld   a, d
    add  8
    ld   d, a
    ; 568 drawSprite1(bc, de, hl);
l2065:
    call drawSprite1
    ; 569 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 570 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2066
    ld   a, d
    add  8
    ld   d, a
    ; 571 drawSprite1(bc, de, hl);
l2066:
    call drawSprite1
    ; 572 }
    pop  de
    pop  bc
    ; 573 iyl--;
    dec  iyl
    ; 574 if (flag_z) return;
    ret  z
    ; 575 c++;
    inc  c
    ; 576 e++;
    inc  e
    ; 577 };
    jp   l2062
l2063:
    ; 578 }
    ret
    ; 580 void drawSprite1(de, bc, hl)
drawSprite1:
    ; 581 {
    ; 582 ixl = d;
    ld   ixl, d
    ; 583 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 584 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 585 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 586 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 587 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 588 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 589 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 590 *de = ((a = *de) |= *hl); l++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    ; 591 a = *hl; if (a == 0x45) a = iyh; *bc = a; l++;
    ld   a, (hl)
    cp   69
    jp   nz, l2067
    ld   a, iyh
l2067:
    ld   (bc), a
    inc  l
    ; 592 d = b; b++; b++; b++; *bc = a = 0xFE; b = d;
    ld   d, b
    inc  b
    inc  b
    inc  b
    ld   a, 254
    ld   (bc), a
    ld   b, d
    ; 594 // *de = a = *hl; l++; d++;
    ; 595 // *de = a = *hl; l++; d++;
    ; 596 // *de = a = *hl; l++; d++;
    ; 597 // *de = a = *hl; l++; d++;
    ; 598 // *de = a = *hl; l++; d++;
    ; 599 // *de = a = *hl; l++; d++;
    ; 600 // *de = a = *hl; l++; d++;
    ; 601 // *de = a = *hl; l++;
    ; 602 // *bc = a = *hl; l++;
    ; 603 // d = b; b++; b++; b++; *bc = a = 0xFF; b = d;
    ; 605 d = ixl;
    ld   d, ixl
    ; 606 }
    ret
    ; 608 /*
