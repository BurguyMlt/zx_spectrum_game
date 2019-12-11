    ; 3 const int KEY_UP = 1;
    ; 4 const int KEY_DOWN = 2;
    ; 5 const int KEY_LEFT = 4;
    ; 6 const int KEY_RIGHT = 8;
    ; 7 const int KEY_FIRE = 16;
    ; 9 const int PORT_7FFD_SECOND_VIDEO_PAGE = 8;
    ; 11 const int screenAddr1 = 0x4000;
    ; 12 const int screenAddr2 = 0xC000;
    ; 13 const int screenWidth = 256;
    ; 14 const int screenHeight = 192;
    ; 15 const int screenBwSize = screenWidth / 8 * screenHeight;
    ; 16 const int screenAttrSize = screenWidth / 8 * screenHeight / 8;
    ; 17 const int screenAttrAddr1 = screenAddr1 + screenBwSize;
    ; 18 const int screenAttrAddr2 = screenAddr2 + screenBwSize;
    ; 19 const int screenEndAddr1 = screenAttrAddr1 + screenAttrSize;
    ; 20 const int screenEndAddr2 = screenAttrAddr2 + screenAttrSize;
    ; 21 const int cacheAddr1 = screenEndAddr1;
    ; 22 const int cacheAddr2 = screenEndAddr2;
    ; 23 const int unusedTailCode = 0xFE;
    ; 24 const int viewWidth = 32;
    ; 25 const int viewHeight = 20;
    ; 26 const int cityRoadY = 13;
    ; 27 const int mapWidth = 256;
    ; 29 const int npc_timer           = 0;
    ; 30 const int npc_flags           = 1;
    ; 31 const int npc_flags_direction = 0x01;
    ; 32 const int npc_flags_type      = 0x02;
    ; 33 const int npc_step            = 2;
    ; 34 const int npc_position        = 3;
    ; 35 const int npc_sizeof          = 4;
    ; 37 const int npc_maxCount = 16;
    ; 38 const int npc_defaultSpeed = 7;
    ; 40 uint8_t cityPlayerX = 0;
cityPlayerX db 0
    ; 41 uint8_t cityScrollX = 0;
cityScrollX db 0
    ; 42 uint8_t cityPlayerDirection = 0;
cityPlayerDirection db 0
    ; 43 uint16_t cityPlayerSprite = &city1s_0;
cityPlayerSprite dw city1s_0
    ; 44 uint8_t processedFrames = 0;
processedFrames db 0
    ; 45 //uint8_t startFrame;
    ; 46 uint8_t npcCount = npc_maxCount;
npcCount db 16
    ; 47 uint8_t npc[npc_sizeof * npc_maxCount];
npc ds 64
    ; 49 void swapMaps()
swapMaps:
    ; 50 {
    ; 51 // Загрузка города
    ; 52 hl = &city1Tails;
    ld   hl, city1Tails
    ; 53 de = &city1bTails;
    ld   de, city1bTails
    ; 54 bc = [9 * 256 + 256 * 20];
    ld   bc, 7424
    ; 55 do
l2000:
    ; 56 {
    ; 57 a = *de;
    ld   a, (de)
    ; 58 ex(a, a);
    ex   af, af
    ; 59 a = *hl;
    ld   a, (hl)
    ; 60 *de = a;
    ld   (de), a
    ; 61 ex(a, a);
    ex   af, af
    ; 62 *hl = a;
    ld   (hl), a
    ; 63 hl++;
    inc  hl
    ; 64 de++;
    inc  de
    ; 65 bc--;
    dec  bc
    ; 66 } while(flag_nz (a = b) |= c);
    ld   a, b
    or   c
    jp   nz, l2000
    ; 67 }
    ret
    ; 69 void cityFullRedraw()
cityFullRedraw:
    ; 70 {
    ; 71 cityInvalidate(hl = cacheAddr1);
    ld   hl, 23296
    call cityInvalidate
    ; 72 *[cacheAddr1 + screenAttrSize] = a = 0;
    ld   a, 0
    ld   (24064), a
    ; 73 cityInvalidate(hl = cacheAddr2);
    ld   hl, 56064
    call cityInvalidate
    ; 74 *[cacheAddr2 + screenAttrSize] = a = 0;
    ld   a, 0
    ld   (56832), a
    ; 75 }
    ret
    ; 77 void main()
main:
    ; 78 {
    ; 79 gPanelChanged1 = a = 0xFF;
    ld   a, 255
    ld   (gPanelChanged1), a
    ; 80 gPanelChanged2 = a = 0xFF;
    ld   a, 255
    ld   (gPanelChanged2), a
    ; 81 gPlayerMoney = hl = 10;
    ld   hl, 10
    ld   (gPlayerMoney), hl
    ; 83 cityPlayerX = a = [mapWidth / 2];
    ld   a, 128
    ld   (cityPlayerX), a
    ; 84 cityScrollX = (a -= [viewWidth / 2]);
    sub  16
    ld   (cityScrollX), a
    ; 86 // Перерисовать панель
    ; 87 gDrawPanel();
    call gDrawPanel
    ; 89 // Инициализация NPC
    ; 90 initNpc();
    call initNpc
    ; 92 //swapMaps();
    ; 94 // Инициализация кеша
    ; 95 cityFullRedraw();
    call cityFullRedraw
    ; 97 // Перерисовать
    ; 98 while()
l2001:
    ; 99 {
    ; 100 beginDraw();
    call beginDraw
    ; 101 cityDraw();
    call cityDraw
    ; 102 endDraw();
    call endDraw
    ; 104 while ((a = gFrame) != *(hl = &processedFrames))
l2003:
    ld   a, (gFrame)
    ld   hl, processedFrames
    cp   (hl)
    jp   z, l2004
    ; 105 {
    ; 106 *hl = a;
    ld   (hl), a
    ; 107 a &= 3;
    and  3
    ; 108 if (flag_z) processPlayer();
    call z, processPlayer
    ; 109 processNpc();
    call processNpc
    ; 110 }
    jp   l2003
l2004:
    ; 111 }
    jp   l2001
    ; 112 }
    ret
    ; 114 void cityInvalidate(hl)
cityInvalidate:
    ; 115 {
    ; 116 d = h; e = l; de++;
    ld   d, h
    ld   e, l
    inc  de
    ; 117 *hl = unusedTailCode;
    ld   (hl), 254
    ; 118 bc = [viewWidth * viewHeight - 1];
    ld   bc, 639
    ; 119 ldir();
    ldir
    ; 120 }
    ret
    ; 122 //----------------------------------------------------------------------------------------------------------------------
    ; 123 // Инициализация жителей
    ; 125 void initNpc()
initNpc:
    ; 126 {
    ; 127 ix = &npc;
    ld   ix, npc
    ; 128 de = npc_sizeof;
    ld   de, 4
    ; 129 b = a = npcCount; // Счетчик цикла
    ld   a, (npcCount)
    ld   b, a
    ; 130 do
l2006:
    ; 131 {
    ; 132 a = b;
    ld   a, b
    ; 133 while (a >= npc_defaultSpeed) a -= npc_defaultSpeed;
l2007:
    cp   7
    jp   c, l2008
    sub  7
    jp   l2007
l2008:
    ; 134 a += 1;
    add  1
    ; 135 ix[npc_timer] = a; // Фаза таймера
    ld   (ix + 0), a
    ; 137 ix[npc_step] = 0;
    ld   (ix + 2), 0
    ; 138 rand();
    call rand
    ; 139 ix[npc_position] = a;
    ld   (ix + 3), a
    ; 140 ix[npc_flags] = (a &= [npc_flags_direction | npc_flags_type]);
    and  3
    ld   (ix + 1), a
    ; 141 ix += de;
    add  ix, de
    ; 142 } while(--b);
    djnz l2006
    ; 143 }
    ret
    ; 145 //----------------------------------------------------------------------------------------------------------------------
    ; 146 // Перемещение и анимация жителей.
    ; 148 void processNpc()
processNpc:
    ; 149 {
    ; 150 de = npc_sizeof;
    ld   de, 4
    ; 151 hl = &npc;
    ld   hl, npc
    ; 152 b = a = npcCount;
    ld   a, (npcCount)
    ld   b, a
    ; 153 do
l2010:
    ; 154 {
    ; 155 if (flag_z --*hl) // Скорость
    dec  (hl)
    ; 156 {
    jp   nz, l2011
    ; 157 rand();
    call rand
    ; 158 if (flag_z a--) // Внезапная остановка
    dec  a
    ; 159 {
    jp   nz, l2012
    ; 160 //! Не полушаге не останавливать
    ; 161 push(hl);
    push hl
    ; 162 pop(ix);
    pop  ix
    ; 163 //a = ix[npc_spriteType];
    ; 164 //if (a == 1)
    ; 165 //{
    ; 166 *hl = 255;
    ld   (hl), 255
    ; 167 goto continue1;
    jp   continue1
    ; 168 //}
    ; 169 }
    ; 171 // У всех разная скорость
    ; 172 *hl = (((a = b) &= 7) += npc_defaultSpeed);
l2012:
    ld   a, b
    and  7
    add  7
    ld   (hl), a
    ; 174 if (flag_z a--) // Внезапный поворот
    dec  a
    ; 175 {
    jp   nz, l2013
    ; 176 hl++;
    inc  hl
    ; 177 a = *hl;
    ld   a, (hl)
    ; 178 a ^= npc_flags_direction;
    xor  1
    ; 179 *hl = a;
    ld   (hl), a
    ; 180 hl--;
    dec  hl
    ; 181 }
    ; 183 hl++;
l2013:
    inc  hl
    ; 184 if (*hl & npc_flags_direction) // Направление
    bit  0, (hl)
    ; 185 {
    jp   z, l2014
    ; 186 hl++;
    inc  hl
    ; 187 a = *hl;
    ld   a, (hl)
    ; 188 a++;
    inc  a
    ; 189 if (a >= 4) { a = 0; hl++; ++*hl; hl--; }
    cp   4
    jp   c, l2015
    ld   a, 0
    inc  hl
    inc  (hl)
    dec  hl
    ; 190 *hl = a;
l2015:
    ld   (hl), a
    ; 191 }
    ; 192 else
    jp   l2016
l2014:
    ; 193 {
    ; 194 hl++;
    inc  hl
    ; 195 a = *hl;
    ld   a, (hl)
    ; 196 a++;
    inc  a
    ; 197 if (a >= 4) { a = 0; hl++; --*hl; hl--; }
    cp   4
    jp   c, l2017
    ld   a, 0
    inc  hl
    dec  (hl)
    dec  hl
    ; 198 *hl = a;
l2017:
    ld   (hl), a
    ; 199 }
l2016:
    ; 200 hl++; hl++;
    inc  hl
    inc  hl
    ; 201 }
    ; 202 else
    jp   l2018
l2011:
    ; 203 {
    ; 204 continue1:
continue1:
    ; 205 hl += de; // Следующий NPC
    add  hl, de
    ; 206 }
l2018:
    ; 207 } while(flag_nz --b);
    dec  b
    jp   nz, l2010
    ; 208 }
    ret
    ; 210 //----------------------------------------------------------------------------------------------------------------------
    ; 211 // Вход: hl - должно указывать на npc_position
    ; 212 // Выход: hl - адрес спрайта
    ; 213 // Портит: a
    ; 215 // const int npc_timer      = 0;
    ; 216 // const int npc_direction  = 1;
    ; 217 // const int npc_step       = 2;
    ; 218 // const int npc_position   = 3;
    ; 219 // const int npc_sprite_l   = 4;
    ; 220 // const int npc_sprite_h   = 5;
    ; 221 // const int npc_sizeof     = 6;
    ; 223 void getNpcSprite(hl)
getNpcSprite:
    ; 224 {
    ; 225 // Вычисление номера спрайта
    ; 226 hl--;
    dec  hl
    ; 227 hl--;
    dec  hl
    ; 228 a = *hl; // npc_direction + npc_type
    ld   a, (hl)
    ; 229 a += a;
    add  a
    ; 230 a += a;
    add  a
    ; 231 hl++;
    inc  hl
    ; 232 a += *hl; // npc_step
    add  (hl)
    ; 234 // Получение элемента массива
    ; 235 l = ((a += a) += &sprite_citizen);
    add  a
    add  sprite_citizen
    ld   l, a
    ; 236 h = ((a +@= [&sprite_citizen >> 8]) -= l);
    adc  (sprite_citizen) >> (8)
    sub  l
    ld   h, a
    ; 237 a = *hl; hl++; h = *hl; l = a;
    ld   a, (hl)
    inc  hl
    ld   h, (hl)
    ld   l, a
    ; 238 }
    ret
    ; 240 uint16_t sprite_citizen[16] =
    ; 241 {
    ; 242 &city1s_15, &city1s_16, &city1s_17, &city1s_14,
    ; 243 &city1s_21, &city1s_20, &city1s_19, &city1s_18,
    ; 245 &city1s_9,  &city1s_8,  &city1s_7,  &city1s_6,
    ; 246 &city1s_10, &city1s_11, &city1s_12, &city1s_13
    ; 247 };
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
    ; 249 //----------------------------------------------------------------------------------------------------------------------
    ; 250 // Управление игроком и анимация игрока.
    ; 252 const int sprite_raistlin_left       = &city1s_0;
    ; 253 const int sprite_raistlin_left_step  = &city1s_1;
    ; 254 const int sprite_raistlin_right      = &city1s_3;
    ; 255 const int sprite_raistlin_right_step = &city1s_4;
    ; 257 void processPlayer()
processPlayer:
    ; 258 {
    ; 259 if (*(hl = &gKeyTrigger) & KEY_FIRE)
    ld   hl, gKeyTrigger
    bit  4, (hl)
    ; 260 {
    jp   z, l2019
    ; 261 *hl = 0;
    ld   (hl), 0
    ; 262 shopMain();
    call shopMain
    ; 263 // Перерисовать всё
    ; 264 cityInvalidate(hl = cacheAddr1);
    ld   hl, 23296
    call cityInvalidate
    ; 265 cityInvalidate(hl = cacheAddr2);
    ld   hl, 56064
    call cityInvalidate
    ; 266 return;
    ret
    ; 267 }
    ; 269 b = a = gKeyPressed;
l2019:
    ld   a, (gKeyPressed)
    ld   b, a
    ; 270 c = a = cityPlayerDirection;
    ld   a, (cityPlayerDirection)
    ld   c, a
    ; 271 a = cityPlayerX;
    ld   a, (cityPlayerX)
    ; 272 if (b & KEY_LEFT)
    bit  2, b
    ; 273 {
    jp   z, l2020
    ; 274 if (c & 1)
    bit  0, c
    ; 275 {            
    jp   z, l2021
    ; 276 cityPlayerDirection = (a ^= a);
    xor  a
    ld   (cityPlayerDirection), a
    ; 277 c = a;
    ld   c, a
    ; 278 }
    ; 279 else
    jp   l2022
l2021:
    ; 280 {
    ; 281 a -= 1;
    sub  1
    ; 282 if (flag_nc)
    ; 283 {
    jp   c, l2023
    ; 284 cityPlayerX = a;
    ld   (cityPlayerX), a
    ; 286 // Прокрутка экрана
    ; 287 a -= [viewWidth / 2]; if (flag_nc) if (a < [mapWidth - viewWidth / 2 * 2 + 1]) { cityScrollX = a; } //! Почему нельзя без {} ?
    sub  16
    jp   c, l2024
    cp   225
    jp   nc, l2025
    ld   (cityScrollX), a
    ; 289 hl = sprite_raistlin_left;
l2025:
l2024:
    ld   hl, city1s_0
    ; 290 if ((a = cityPlayerSprite) == l) hl = sprite_raistlin_left_step;
    ld   a, (cityPlayerSprite)
    cp   l
    jp   nz, l2026
    ld   hl, city1s_1
    ; 291 cityPlayerSprite = hl;
l2026:
    ld   (cityPlayerSprite), hl
    ; 292 return;
    ret
    ; 293 }
    ; 294 }
l2023:
l2022:
    ; 295 }
    ; 296 else if (b & KEY_RIGHT)
    jp   l2027
l2020:
    bit  3, b
    ; 297 {
    jp   z, l2028
    ; 298 if (flag_z c & 1)
    bit  0, c
    ; 299 {
    jp   nz, l2029
    ; 300 cityPlayerDirection = (a = 1);
    ld   a, 1
    ld   (cityPlayerDirection), a
    ; 301 c = a;
    ld   c, a
    ; 302 }
    ; 303 else
    jp   l2030
l2029:
    ; 304 {
    ; 305 a += 1;
    add  1
    ; 306 if (flag_nc)
    ; 307 {
    jp   c, l2031
    ; 308 cityPlayerX = a;
    ld   (cityPlayerX), a
    ; 310 // Прокрутка экрана
    ; 311 a -= [viewWidth / 2]; if (flag_nc) if (a < [mapWidth - viewWidth / 2 * 2 + 1]) { cityScrollX = a; }  //! Почему нельзя без {} ?
    sub  16
    jp   c, l2032
    cp   225
    jp   nc, l2033
    ld   (cityScrollX), a
    ; 313 hl = sprite_raistlin_right;
l2033:
l2032:
    ld   hl, city1s_3
    ; 314 if ((a = cityPlayerSprite) == l) hl = sprite_raistlin_right_step;
    ld   a, (cityPlayerSprite)
    cp   l
    jp   nz, l2034
    ld   hl, city1s_4
    ; 315 cityPlayerSprite = hl;
l2034:
    ld   (cityPlayerSprite), hl
    ; 316 return;
    ret
    ; 317 }
    ; 318 }
l2031:
l2030:
    ; 319 }
    ; 321 // Убираем анимацию шага, если ни одна клавиша не нажата
    ; 322 hl = sprite_raistlin_left;
l2028:
l2027:
    ld   hl, city1s_0
    ; 323 if (c & 1) hl = sprite_raistlin_right;
    bit  0, c
    jp   z, l2035
    ld   hl, city1s_3
    ; 324 cityPlayerSprite = hl;
l2035:
    ld   (cityPlayerSprite), hl
    ; 325 }
    ret
    ; 327 //----------------------------------------------------------------------------------------------------------------------
    ; 329 void beginDraw()
beginDraw:
    ; 330 {
    ; 331 hl = &gVideoPage;
    ld   hl, gVideoPage
    ; 332 while ((a = *hl) & 1);
l2036:
    ld   a, (hl)
    bit  0, a
    jp   z, l2037
    jp   l2036
l2037:
    ; 333 a &= 0x7F;
    and  127
    ; 334 if (flag_z a & 8) a |= 0x80;
    bit  3, a
    jp   nz, l2039
    or   128
    ; 335 *hl = a;
l2039:
    ld   (hl), a
    ; 336 }
    ret
    ; 338 //----------------------------------------------------------------------------------------------------------------------
    ; 340 void endDraw()
endDraw:
    ; 341 {
    ; 342 gVideoPage = ((a = gVideoPage) ^= 8 |= 1);
    ld   a, (gVideoPage)
    xor  8
    or   1
    ld   (gVideoPage), a
    ; 343 }
    ret
    ; 345 //----------------------------------------------------------------------------------------------------------------------
    ; 347 void cityDraw()
cityDraw:
    ; 348 {
    ; 349 // Оценка времени
    ; 350 //startFrame = a = gFrame;
    ; 352 // Обновить панель
    ; 353 playerMoneyRedraw();
    call playerMoneyRedraw
    ; 355 // Адрес карты / и сточник
    ; 356 d` = [&city1Map >> 8];
    ld   d, (city1Map) >> (8)
    ; 357 e` = a = cityScrollX;
    ld   a, (cityScrollX)
    ld   e, a
    ; 358 b` = e`;
    ld   b, e
    ; 360 // Адрес видеостраницы / назначение
    ; 361 if (flag_z (a = gVideoPage) &= 0x80)
    ld   a, (gVideoPage)
    and  128
    ; 362 {
    jp   nz, l2040
    ; 363 hl` = [cacheAddr1 - 1];
    ld   hl, 23295
    ; 364 ex(bc, de, hl);
    exx
    ; 365 de = screenAddr1;
    ld   de, 16384
    ; 366 bc = screenAttrAddr1;
    ld   bc, 22528
    ; 367 }
    ; 368 else
    jp   l2041
l2040:
    ; 369 {
    ; 370 hl` = [cacheAddr2 - 1];
    ld   hl, 56063
    ; 371 ex(bc, de, hl);
    exx
    ; 372 de = screenAddr2;
    ld   de, 49152
    ; 373 bc = screenAttrAddr2;
    ld   bc, 55296
    ; 374 }
l2041:
    ; 376 // Цикл строк
    ; 377 ixh = viewHeight;
    ld   ixh, 20
    ; 378 do
l2042:
    ; 379 {
    ; 380 // Сохранение адреса вывода
    ; 381 iyl = e;
    ld   iyl, e
    ; 382 iyh = d;
    ld   iyh, d
    ; 384 // Цикл стобцов
    ; 385 ixl = viewWidth;
    ld   ixl, 32
    ; 386 do
l2043:
    ; 387 {
    ; 388 optimize0:  // Чтение номера тейла из карты уровня
optimize0:
    ; 389 ex(bc, de, hl);
    exx
    ; 390 hl`++;
    inc  hl
    ; 391 c` = *hl;
    ld   c, (hl)
    ; 392 a = *de`;
    ld   a, (de)
    ; 393 if (a == c`) goto optimize1;
    cp   c
    jp   z, optimize1
    ; 394 if (flag_z c`++) goto optimize3;
    inc  c
    jp   z, optimize3
    ; 395 e`++;
    inc  e
    ; 396 *hl` = a;
    ld   (hl), a
    ; 397 ex(bc, de, hl);
    exx
    ; 399 // Вычисление адреса тейла
    ; 400 h = [&city1Tails >> 8];
    ld   h, (city1Tails) >> (8)
    ; 401 l = a;
    ld   l, a
    ; 403 // Вывод на экран
    ; 404 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 405 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 406 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 407 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 408 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 409 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 410 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 411 a = *hl; h++; *de = a;
    ld   a, (hl)
    inc  h
    ld   (de), a
    ; 412 a = *hl;      *bc = a; bc++;
    ld   a, (hl)
    ld   (bc), a
    inc  bc
    ; 414 d = iyh;
    ld   d, iyh
    ; 415 e++;
    inc  e
    ; 416 ixl--;
    dec  ixl
    ; 417 } while(flag_nz);
    jp   nz, l2043
    ; 418 optimize2:
optimize2:
    ; 420 // Следующая строка карты
    ; 421 ex(bc, de, hl);
    exx
    ; 422 e` = b`;
    ld   e, b
    ; 423 d`++;
    inc  d
    ; 424 ex(bc, de, hl);
    exx
    ; 426 // Адрес следующей чб строки на экране
    ; 427 e = ((a = iyl) += 0x20);
    ld   a, iyl
    add  32
    ld   e, a
    ; 428 if (flag_c) d = ((a = d) += 0x08);
    jp   nc, l2044
    ld   a, d
    add  8
    ld   d, a
    ; 430 ixh--;
l2044:
    dec  ixh
    ; 431 } while(flag_nz);
    jp   nz, l2042
    ; 433 drawSprites();
    call drawSprites
    ; 435 // Оценка времени
    ; 436 //printDelay((a = gFrame) -= *(hl = &startFrame));
    ; 438 return;
    ret
    ; 439 optimize3:
optimize3:
    ; 440 *hl` = a = 254;
    ld   a, 254
    ld   (hl), a
    ; 441 optimize1:
optimize1:
    ; 442 e`++;
    inc  e
    ; 443 ex(bc, de, hl);
    exx
    ; 444 bc++;
    inc  bc
    ; 445 e++;
    inc  e
    ; 446 ixl--;
    dec  ixl
    ; 447 if(flag_nz) goto optimize0;
    jp   nz, optimize0
    ; 448 goto optimize2;
    jp   optimize2
    ; 449 }
    ret
    ; 451 void drawSprites()
drawSprites:
    ; 452 {
    ; 453 a = gVideoPage;
    ld   a, (gVideoPage)
    ; 454 if (a & 8) ixh = [screenAddr1 >> 8];
    bit  3, a
    jp   z, l2045
    ld   ixh, 64
    ; 455 else ixh = [screenAddr2 >> 8];
    jp   l2046
l2045:
    ld   ixh, 192
l2046:
    ; 457 // const int npc_timer      = 0;
    ; 458 // const int npc_direction  = 1;
    ; 459 // const int npc_step       = 2;
    ; 460 // const int npc_position   = 3;
    ; 461 // const int npc_sprite_l   = 4;
    ; 462 // const int npc_sprite_h   = 5;
    ; 463 // const int npc_sizeof     = 6;
    ; 465 // Спрайты
    ; 466 hl = [&npc + npc_position];
    ld   hl, (npc) + (3)
    ; 467 b = a = npcCount;
    ld   a, (npcCount)
    ld   b, a
    ; 468 c = (a = cityScrollX); c--;
    ld   a, (cityScrollX)
    ld   c, a
    dec  c
    ; 469 de = npc_sizeof;
    ld   de, 4
    ; 470 do
l2047:
    ; 471 {
    ; 472 // Если спрайт за экраном, то не рисуем его
    ; 473 if (((a = *hl) -= c) < [viewWidth + 1]) //! для const int можно <=
    ld   a, (hl)
    sub  c
    cp   33
    ; 474 {
    jp   nc, l2048
    ; 475 push(bc, de, hl)
    ; 476 {
    push bc
    push de
    push hl
    ; 477 c = --a; // Для drawSprite
    dec  a
    ld   c, a
    ; 479 // Цвет {
    ; 480 a = b;
    ld   a, b
    ; 481 while(a >= 14) a -= 14;
l2049:
    cp   14
    jp   c, l2050
    sub  14
    jp   l2049
l2050:
    ; 482 if (a >= 7) a += [0x40 - 7]; a++;
    cp   7
    jp   c, l2052
    add  57
l2052:
    inc  a
    ; 483 iyh = a;
    ld   iyh, a
    ; 484 // }
    ; 486 getNpcSprite(hl);
    call getNpcSprite
    ; 487 b = cityRoadY;
    ld   b, 13
    ; 488 drawSprite();
    call drawSprite
    ; 489 }
    pop  hl
    pop  de
    pop  bc
    ; 490 }
    ; 491 hl += de;
l2048:
    add  hl, de
    ; 492 } while(--b);
    djnz l2047
    ; 494 // Рисование игрока
    ; 495 b = cityRoadY;
    ld   b, 13
    ; 496 c++;
    inc  c
    ; 497 c = ((a = cityPlayerX) -= c);
    ld   a, (cityPlayerX)
    sub  c
    ld   c, a
    ; 498 hl = cityPlayerSprite;
    ld   hl, (cityPlayerSprite)
    ; 499 if ((a = l) == &city1s_1) c--;
    ld   a, l
    cp   city1s_1
    jp   nz, l2053
    dec  c
    ; 500 iyh = 0;
l2053:
    ld   iyh, 0
    ; 501 drawSprite(bc, de, hl);
    call drawSprite
    ; 502 }
    ret
    ; 504 // Вывод спрайта
    ; 505 // c - координата X (от -1 до 31)
    ; 506 // b - координата Y (от 0 до 23)
    ; 507 // hl - спрайт
    ; 509 void drawSprite(bc, hl, ixh, iyh)
drawSprite:
    ; 510 {
    ; 511 // Читаем ширину спрайта
    ; 512 d = *hl; l++;
    ld   d, (hl)
    inc  l
    ; 514 // Если спрайт за левым краем экрана
    ; 515 if (c & 0x80) //! Можно оптимизировать
    bit  7, c
    ; 516 do
    jp   z, l2054
l2055:
    ; 517 {
    ; 518 l = ((a = l) += [4 * 9]);
    ld   a, l
    add  36
    ld   l, a
    ; 519 c++;
    inc  c
    ; 520 d--;
    dec  d
    ; 521 if (flag_z) return;
    ret  z
    ; 522 } while (c & 0x80);
    bit  7, c
    jp   nz, l2055
    ; 524 // Если спрайт за правым краем экрана
    ; 525 (a = viewWidth) -= c;
l2054:
    ld   a, 32
    sub  c
    ; 526 if (flag_c) return;
    ret  c
    ; 527 if (flag_z) return;
    ret  z
    ; 528 if (a < d) d = a;
    cp   d
    jp   nc, l2056
    ld   d, a
    ; 529 iyl = d;
l2056:
    ld   iyl, d
    ; 531 // Вычисление координаты
    ; 532 //       43210    43210
    ; 533 // de .1.43... 210.....
    ; 534 // bc .1.11.43 210.....
    ; 535 d = (((a = b) &= 0x18) |= ixh);
    ld   a, b
    and  24
    or   ixh
    ld   d, a
    ; 536 a = b;
    ld   a, b
    ; 537 a >>r= 3;
    rrca
    rrca
    rrca
    ; 538 b = a;
    ld   b, a
    ; 539 c = e = ((a &= 0xE0) |= c);
    and  224
    or   c
    ld   e, a
    ld   c, e
    ; 540 b = ((((a = b) &= 0x03) |= 0x18) |= ixh);
    ld   a, b
    and  3
    or   24
    or   ixh
    ld   b, a
    ; 542 while()
l2057:
    ; 543 {
    ; 544 push(bc, de)
    ; 545 {
    push bc
    push de
    ; 546 drawSprite1(bc, de, hl);
    call drawSprite1
    ; 547 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 548 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2059
    ld   a, d
    add  8
    ld   d, a
    ; 549 drawSprite1(bc, de, hl);
l2059:
    call drawSprite1
    ; 550 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 551 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2060
    ld   a, d
    add  8
    ld   d, a
    ; 552 drawSprite1(bc, de, hl);
l2060:
    call drawSprite1
    ; 553 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 554 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2061
    ld   a, d
    add  8
    ld   d, a
    ; 555 drawSprite1(bc, de, hl);
l2061:
    call drawSprite1
    ; 556 }
    pop  de
    pop  bc
    ; 557 iyl--;
    dec  iyl
    ; 558 if (flag_z) return;
    ret  z
    ; 559 c++;
    inc  c
    ; 560 e++;
    inc  e
    ; 561 };
    jp   l2057
    ; 562 }
    ret
    ; 564 void drawSprite1(de, bc, hl)
drawSprite1:
    ; 565 {
    ; 566 ixl = d;
    ld   ixl, d
    ; 567 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 568 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 569 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 570 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 571 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 572 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 573 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 574 *de = ((a = *de) |= *hl); l++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    ; 575 a = *hl; if (a == 0x45) a = iyh; *bc = a; l++;
    ld   a, (hl)
    cp   69
    jp   nz, l2062
    ld   a, iyh
l2062:
    ld   (bc), a
    inc  l
    ; 576 d = b; b++; b++; b++; *bc = a = 0xFE; b = d;
    ld   d, b
    inc  b
    inc  b
    inc  b
    ld   a, 254
    ld   (bc), a
    ld   b, d
    ; 578 // *de = a = *hl; l++; d++;
    ; 579 // *de = a = *hl; l++; d++;
    ; 580 // *de = a = *hl; l++; d++;
    ; 581 // *de = a = *hl; l++; d++;
    ; 582 // *de = a = *hl; l++; d++;
    ; 583 // *de = a = *hl; l++; d++;
    ; 584 // *de = a = *hl; l++; d++;
    ; 585 // *de = a = *hl; l++;
    ; 586 // *bc = a = *hl; l++;
    ; 587 // d = b; b++; b++; b++; *bc = a = 0xFF; b = d;
    ; 589 d = ixl;
    ld   d, ixl
    ; 590 }
    ret
    ; 592 /*
