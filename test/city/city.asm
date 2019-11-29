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
    ; 23 const int unusedTailCode = 0xFF;
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
    ; 45 uint8_t startFrame;
startFrame db 0
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
    ; 69 void main()
main:
    ; 70 {
    ; 71 cityPlayerX = a = [mapWidth / 2];
    ld   a, 128
    ld   (cityPlayerX), a
    ; 72 cityScrollX = (a -= [viewWidth / 2]);
    sub  16
    ld   (cityScrollX), a
    ; 74 // Инициализация NPC
    ; 75 initNpc();
    call initNpc
    ; 77 //swapMaps();
    ; 79 // Инициализация кеша
    ; 80 cityInvalidate(hl = cacheAddr1);
    ld   hl, 23296
    call cityInvalidate
    ; 81 cityInvalidate(hl = cacheAddr2);
    ld   hl, 56064
    call cityInvalidate
    ; 83 // Перерисовать
    ; 84 cityRedraw();
    call cityRedraw
    ; 86 while()
l2001:
    ; 87 {
    ; 88 while ((a = frame) != *(hl = &processedFrames))
l2003:
    ld   a, (frame)
    ld   hl, processedFrames
    cp   (hl)
    jp   z, l2004
    ; 89 {
    ; 90 *hl = a;
    ld   (hl), a
    ; 91 a &= 3;
    and  3
    ; 92 if (flag_z) processPlayer();
    call z, processPlayer
    ; 93 processNpc();
    call processNpc
    ; 94 }
    jp   l2003
l2004:
    ; 96 cityRedraw();
    call cityRedraw
    ; 97 }
    jp   l2001
    ; 98 }
    ret
    ; 100 void cityInvalidate(hl)
cityInvalidate:
    ; 101 {
    ; 102 d = h; e = l; de++;
    ld   d, h
    ld   e, l
    inc  de
    ; 103 *hl = unusedTailCode;
    ld   (hl), 255
    ; 104 bc = [viewWidth * viewHeight - 1];
    ld   bc, 639
    ; 105 ldir();
    ldir
    ; 106 }
    ret
    ; 108 //----------------------------------------------------------------------------------------------------------------------
    ; 109 // Инициализация жителей
    ; 111 void initNpc()
initNpc:
    ; 112 {
    ; 113 ix = &npc;
    ld   ix, npc
    ; 114 de = npc_sizeof;
    ld   de, 4
    ; 115 b = a = npcCount; // Счетчик цикла
    ld   a, (npcCount)
    ld   b, a
    ; 116 do
l2006:
    ; 117 {
    ; 118 a = b;
    ld   a, b
    ; 119 while (a >= npc_defaultSpeed) a -= npc_defaultSpeed;
l2007:
    cp   7
    jp   c, l2008
    sub  7
    jp   l2007
l2008:
    ; 120 a += 1;
    add  1
    ; 121 ix[npc_timer] = a; // Фаза таймера
    ld   (ix + 0), a
    ; 123 ix[npc_step] = 0;
    ld   (ix + 2), 0
    ; 124 rand();
    call rand
    ; 125 ix[npc_position] = a;
    ld   (ix + 3), a
    ; 126 ix[npc_flags] = (a &= [npc_flags_direction | npc_flags_type]);
    and  3
    ld   (ix + 1), a
    ; 127 ix += de;
    add  ix, de
    ; 128 } while(--b);
    djnz l2006
    ; 129 }
    ret
    ; 131 //----------------------------------------------------------------------------------------------------------------------
    ; 132 // Перемещение и анимация жителей.
    ; 134 void processNpc()
processNpc:
    ; 135 {
    ; 136 de = npc_sizeof;
    ld   de, 4
    ; 137 hl = &npc;
    ld   hl, npc
    ; 138 b = a = npcCount;
    ld   a, (npcCount)
    ld   b, a
    ; 139 do
l2010:
    ; 140 {
    ; 141 if (flag_z --*hl) // Скорость
    dec  (hl)
    ; 142 {
    jp   nz, l2011
    ; 143 rand();
    call rand
    ; 144 if (flag_z a--) // Внезапная остановка
    dec  a
    ; 145 {
    jp   nz, l2012
    ; 146 //! Не полушаге не останавливать
    ; 147 push(hl);
    push hl
    ; 148 pop(ix);
    pop  ix
    ; 149 //a = ix[npc_spriteType];
    ; 150 //if (a == 1)
    ; 151 //{
    ; 152 *hl = 255;
    ld   (hl), 255
    ; 153 goto continue1;
    jp   continue1
    ; 154 //}
    ; 155 }
    ; 157 // У всех разная скорость
    ; 158 *hl = (((a = b) &= 7) += npc_defaultSpeed);
l2012:
    ld   a, b
    and  7
    add  7
    ld   (hl), a
    ; 160 if (flag_z a--) // Внезапный поворот
    dec  a
    ; 161 {
    jp   nz, l2013
    ; 162 hl++;
    inc  hl
    ; 163 a = *hl;
    ld   a, (hl)
    ; 164 a ^= npc_flags_direction;
    xor  1
    ; 165 *hl = a;
    ld   (hl), a
    ; 166 hl--;
    dec  hl
    ; 167 }
    ; 169 hl++;
l2013:
    inc  hl
    ; 170 if (*hl & npc_flags_direction) // Направление
    bit  0, (hl)
    ; 171 {
    jp   z, l2014
    ; 172 hl++;
    inc  hl
    ; 173 a = *hl;
    ld   a, (hl)
    ; 174 a++;
    inc  a
    ; 175 if (a >= 4) { a = 0; hl++; ++*hl; hl--; }
    cp   4
    jp   c, l2015
    ld   a, 0
    inc  hl
    inc  (hl)
    dec  hl
    ; 176 *hl = a;
l2015:
    ld   (hl), a
    ; 177 }
    ; 178 else
    jp   l2016
l2014:
    ; 179 {
    ; 180 hl++;
    inc  hl
    ; 181 a = *hl;
    ld   a, (hl)
    ; 182 a++;
    inc  a
    ; 183 if (a >= 4) { a = 0; hl++; --*hl; hl--; }
    cp   4
    jp   c, l2017
    ld   a, 0
    inc  hl
    dec  (hl)
    dec  hl
    ; 184 *hl = a;
l2017:
    ld   (hl), a
    ; 185 }
l2016:
    ; 186 hl++; hl++;
    inc  hl
    inc  hl
    ; 187 }
    ; 188 else
    jp   l2018
l2011:
    ; 189 {
    ; 190 continue1:
continue1:
    ; 191 hl += de; // Следующий NPC
    add  hl, de
    ; 192 }
l2018:
    ; 193 } while(flag_nz --b);
    dec  b
    jp   nz, l2010
    ; 194 }
    ret
    ; 196 //----------------------------------------------------------------------------------------------------------------------
    ; 197 // Вход: hl - должно указывать на npc_position
    ; 198 // Выход: hl - адрес спрайта
    ; 199 // Портит: a
    ; 201 // const int npc_timer      = 0;
    ; 202 // const int npc_direction  = 1;
    ; 203 // const int npc_step       = 2;
    ; 204 // const int npc_position   = 3;
    ; 205 // const int npc_sprite_l   = 4;
    ; 206 // const int npc_sprite_h   = 5;
    ; 207 // const int npc_sizeof     = 6;
    ; 209 void getNpcSprite(hl)
getNpcSprite:
    ; 210 {
    ; 211 // Вычисление номера спрайта
    ; 212 hl--;
    dec  hl
    ; 213 hl--;
    dec  hl
    ; 214 a = *hl; // npc_direction + npc_type
    ld   a, (hl)
    ; 215 a += a;
    add  a
    ; 216 a += a;
    add  a
    ; 217 hl++;
    inc  hl
    ; 218 a += *hl; // npc_step
    add  (hl)
    ; 220 // Получение элемента массива
    ; 221 l = ((a += a) += &sprite_citizen);
    add  a
    add  sprite_citizen
    ld   l, a
    ; 222 h = ((a +@= [&sprite_citizen >> 8]) -= l);
    adc  (sprite_citizen) >> (8)
    sub  l
    ld   h, a
    ; 223 a = *hl; hl++; h = *hl; l = a;
    ld   a, (hl)
    inc  hl
    ld   h, (hl)
    ld   l, a
    ; 224 }
    ret
    ; 226 uint16_t sprite_citizen[16] =
    ; 227 {
    ; 228 &city1s_15, &city1s_16, &city1s_17, &city1s_14,
    ; 229 &city1s_21, &city1s_20, &city1s_19, &city1s_18,
    ; 231 &city1s_9,  &city1s_8,  &city1s_7,  &city1s_6,
    ; 232 &city1s_10, &city1s_11, &city1s_12, &city1s_13
    ; 233 };
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
    ; 235 //----------------------------------------------------------------------------------------------------------------------
    ; 236 // Управление игроком и анимация игрока.
    ; 238 const int sprite_raistlin_left       = &city1s_0;
    ; 239 const int sprite_raistlin_left_step  = &city1s_1;
    ; 240 const int sprite_raistlin_right      = &city1s_3;
    ; 241 const int sprite_raistlin_right_step = &city1s_4;
    ; 243 void processPlayer()
processPlayer:
    ; 244 {
    ; 245 b = a = keyPressed;
    ld   a, (keyPressed)
    ld   b, a
    ; 246 c = a = cityPlayerDirection;
    ld   a, (cityPlayerDirection)
    ld   c, a
    ; 247 a = cityPlayerX;
    ld   a, (cityPlayerX)
    ; 248 if (b & KEY_LEFT)
    bit  2, b
    ; 249 {
    jp   z, l2019
    ; 250 if (c & 1)
    bit  0, c
    ; 251 {            
    jp   z, l2020
    ; 252 cityPlayerDirection = (a ^= a);
    xor  a
    ld   (cityPlayerDirection), a
    ; 253 c = a;
    ld   c, a
    ; 254 }
    ; 255 else
    jp   l2021
l2020:
    ; 256 {
    ; 257 a -= 1;
    sub  1
    ; 258 if (flag_nc)
    ; 259 {
    jp   c, l2022
    ; 260 cityPlayerX = a;
    ld   (cityPlayerX), a
    ; 262 // Прокрутка экрана
    ; 263 a -= [viewWidth / 2]; if (flag_nc) if (a < [mapWidth - viewWidth / 2 * 2 + 1]) { cityScrollX = a; } //! Почему нельзя без {} ?
    sub  16
    jp   c, l2023
    cp   225
    jp   nc, l2024
    ld   (cityScrollX), a
    ; 265 hl = sprite_raistlin_left;
l2024:
l2023:
    ld   hl, city1s_0
    ; 266 if ((a = cityPlayerSprite) == l) hl = sprite_raistlin_left_step;
    ld   a, (cityPlayerSprite)
    cp   l
    jp   nz, l2025
    ld   hl, city1s_1
    ; 267 cityPlayerSprite = hl;
l2025:
    ld   (cityPlayerSprite), hl
    ; 268 return;
    ret
    ; 269 }
    ; 270 }
l2022:
l2021:
    ; 271 }
    ; 272 else if (b & KEY_RIGHT)
    jp   l2026
l2019:
    bit  3, b
    ; 273 {
    jp   z, l2027
    ; 274 if (flag_z c & 1)
    bit  0, c
    ; 275 {
    jp   nz, l2028
    ; 276 cityPlayerDirection = (a = 1);
    ld   a, 1
    ld   (cityPlayerDirection), a
    ; 277 c = a;
    ld   c, a
    ; 278 }
    ; 279 else
    jp   l2029
l2028:
    ; 280 {
    ; 281 a += 1;
    add  1
    ; 282 if (flag_nc)
    ; 283 {
    jp   c, l2030
    ; 284 cityPlayerX = a;
    ld   (cityPlayerX), a
    ; 286 // Прокрутка экрана
    ; 287 a -= [viewWidth / 2]; if (flag_nc) if (a < [mapWidth - viewWidth / 2 * 2 + 1]) { cityScrollX = a; }  //! Почему нельзя без {} ?
    sub  16
    jp   c, l2031
    cp   225
    jp   nc, l2032
    ld   (cityScrollX), a
    ; 289 hl = sprite_raistlin_right;
l2032:
l2031:
    ld   hl, city1s_3
    ; 290 if ((a = cityPlayerSprite) == l) hl = sprite_raistlin_right_step;
    ld   a, (cityPlayerSprite)
    cp   l
    jp   nz, l2033
    ld   hl, city1s_4
    ; 291 cityPlayerSprite = hl;
l2033:
    ld   (cityPlayerSprite), hl
    ; 292 return;
    ret
    ; 293 }
    ; 294 }
l2030:
l2029:
    ; 295 }
    ; 297 // Убираем анимацию шага, если ни одна клавиша не нажата
    ; 298 hl = sprite_raistlin_left;
l2027:
l2026:
    ld   hl, city1s_0
    ; 299 if (c & 1) hl = sprite_raistlin_right;
    bit  0, c
    jp   z, l2034
    ld   hl, city1s_3
    ; 300 cityPlayerSprite = hl;
l2034:
    ld   (cityPlayerSprite), hl
    ; 301 }
    ret
    ; 303 //----------------------------------------------------------------------------------------------------------------------
    ; 305 void cityRedraw()
cityRedraw:
    ; 306 {
    ; 307 // Оценка времени
    ; 308 startFrame = a = frame;
    ld   a, (frame)
    ld   (startFrame), a
    ; 310 // Ждем, если активная страница еще не стала видимой
    ; 311 while ((a = videoPage) & 1);
l2035:
    ld   a, (videoPage)
    bit  0, a
    jp   z, l2036
    jp   l2035
l2036:
    ; 313 // Адрес карты / источник
    ; 314 d` = [&city1Map >> 8];
    ld   d, (city1Map) >> (8)
    ; 315 e` = a = cityScrollX;
    ld   a, (cityScrollX)
    ld   e, a
    ; 316 b` = e`;
    ld   b, e
    ; 318 // Адрес видеостраницы / назначение
    ; 319 a = videoPage;
    ld   a, (videoPage)
    ; 320 if (a & 8)
    bit  3, a
    ; 321 {
    jp   z, l2038
    ; 322 hl` = [cacheAddr1 - 1];
    ld   hl, 23295
    ; 323 ex(bc, de, hl);
    exx
    ; 324 de = screenAddr1;
    ld   de, 16384
    ; 325 bc = screenAttrAddr1;
    ld   bc, 22528
    ; 326 }
    ; 327 else
    jp   l2039
l2038:
    ; 328 {
    ; 329 hl` = [cacheAddr2 - 1];
    ld   hl, 56063
    ; 330 ex(bc, de, hl);
    exx
    ; 331 de = screenAddr2;
    ld   de, 49152
    ; 332 bc = screenAttrAddr2;
    ld   bc, 55296
    ; 333 }
l2039:
    ; 335 // Цикл строк
    ; 336 ixh = viewHeight;
    ld   ixh, 20
    ; 337 do
l2040:
    ; 338 {
    ; 339 // Сохранение адреса вывода
    ; 340 iyl = e;
    ld   iyl, e
    ; 341 iyh = d;
    ld   iyh, d
    ; 343 // Цикл стобцов
    ; 344 ixl = viewWidth;
    ld   ixl, 32
    ; 345 do
l2041:
    ; 346 {
    ; 347 optimize0:  // Чтение номера тейла из карты уровня
optimize0:
    ; 348 ex(bc, de, hl);
    exx
    ; 349 hl`++;
    inc  hl
    ; 350 c` = *hl;
    ld   c, (hl)
    ; 351 a = *de`;
    ld   a, (de)
    ; 352 if (a == c`) goto optimize1;
    cp   c
    jp   z, optimize1
    ; 353 if (flag_z c`++) goto optimize3;
    inc  c
    jp   z, optimize3
    ; 354 e`++;
    inc  e
    ; 355 *hl` = a;
    ld   (hl), a
    ; 356 ex(bc, de, hl);
    exx
    ; 358 // Вычисление адреса тейла
    ; 359 h = [&city1Tails >> 8];
    ld   h, (city1Tails) >> (8)
    ; 360 l = a;
    ld   l, a
    ; 362 // Вывод на экран
    ; 363 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 364 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 365 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 366 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 367 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 368 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 369 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 370 a = *hl; h++; *de = a;
    ld   a, (hl)
    inc  h
    ld   (de), a
    ; 371 a = *hl;      *bc = a; bc++;
    ld   a, (hl)
    ld   (bc), a
    inc  bc
    ; 373 d = iyh;
    ld   d, iyh
    ; 374 e++;
    inc  e
    ; 375 ixl--;
    dec  ixl
    ; 376 } while(flag_nz);
    jp   nz, l2041
    ; 377 optimize2:
optimize2:
    ; 379 // Следующая строка карты
    ; 380 ex(bc, de, hl);
    exx
    ; 381 e` = b`;
    ld   e, b
    ; 382 d`++;
    inc  d
    ; 383 ex(bc, de, hl);
    exx
    ; 385 // Адрес следующей чб строки на экране
    ; 386 e = ((a = iyl) += 0x20);
    ld   a, iyl
    add  32
    ld   e, a
    ; 387 if (flag_c) d = ((a = d) += 0x08);
    jp   nc, l2042
    ld   a, d
    add  8
    ld   d, a
    ; 389 ixh--;
l2042:
    dec  ixh
    ; 390 } while(flag_nz);
    jp   nz, l2040
    ; 392 drawSprites();
    call drawSprites
    ; 394 // Переключить видеостраницы во время следующего прерывания
    ; 395 videoPage = ((a = videoPage) ^= 8 |= 1);
    ld   a, (videoPage)
    xor  8
    or   1
    ld   (videoPage), a
    ; 397 // Оценка времени
    ; 398 printDelay((a = frame) -= *(hl = &startFrame));
    ld   a, (frame)
    ld   hl, startFrame
    sub  (hl)
    call printDelay
    ; 400 return;
    ret
    ; 401 optimize3:
optimize3:
    ; 402 *hl` = a = 254;
    ld   a, 254
    ld   (hl), a
    ; 403 optimize1:
optimize1:
    ; 404 e`++;
    inc  e
    ; 405 ex(bc, de, hl);
    exx
    ; 406 bc++;
    inc  bc
    ; 407 e++;
    inc  e
    ; 408 ixl--;
    dec  ixl
    ; 409 if(flag_nz) goto optimize0;
    jp   nz, optimize0
    ; 410 goto optimize2;
    jp   optimize2
    ; 411 }
    ret
    ; 413 void drawSprites()
drawSprites:
    ; 414 {
    ; 415 a = videoPage;
    ld   a, (videoPage)
    ; 416 if (a & 8) ixh = [screenAddr1 >> 8];
    bit  3, a
    jp   z, l2043
    ld   ixh, 64
    ; 417 else ixh = [screenAddr2 >> 8];
    jp   l2044
l2043:
    ld   ixh, 192
l2044:
    ; 419 // const int npc_timer      = 0;
    ; 420 // const int npc_direction  = 1;
    ; 421 // const int npc_step       = 2;
    ; 422 // const int npc_position   = 3;
    ; 423 // const int npc_sprite_l   = 4;
    ; 424 // const int npc_sprite_h   = 5;
    ; 425 // const int npc_sizeof     = 6;
    ; 427 // Спрайты
    ; 428 hl = [&npc + npc_position];
    ld   hl, (npc) + (3)
    ; 429 b = a = npcCount;
    ld   a, (npcCount)
    ld   b, a
    ; 430 c = (a = cityScrollX); c--;
    ld   a, (cityScrollX)
    ld   c, a
    dec  c
    ; 431 de = npc_sizeof;
    ld   de, 4
    ; 432 do
l2045:
    ; 433 {
    ; 434 // Если спрайт за экраном, то не рисуем его
    ; 435 if (((a = *hl) -= c) < [viewWidth + 1]) //! для const int можно <=
    ld   a, (hl)
    sub  c
    cp   33
    ; 436 {
    jp   nc, l2046
    ; 437 push(bc, de, hl)
    ; 438 {
    push bc
    push de
    push hl
    ; 439 c = --a; // Для drawSprite
    dec  a
    ld   c, a
    ; 441 // Цвет {
    ; 442 a = b;
    ld   a, b
    ; 443 while(a >= 14) a -= 14;
l2047:
    cp   14
    jp   c, l2048
    sub  14
    jp   l2047
l2048:
    ; 444 if (a >= 7) a += [0x40 - 7]; a++;
    cp   7
    jp   c, l2050
    add  57
l2050:
    inc  a
    ; 445 iyh = a;
    ld   iyh, a
    ; 446 // }
    ; 448 getNpcSprite(hl);
    call getNpcSprite
    ; 449 b = cityRoadY;
    ld   b, 13
    ; 450 drawSprite();
    call drawSprite
    ; 451 }
    pop  hl
    pop  de
    pop  bc
    ; 452 }
    ; 453 hl += de;
l2046:
    add  hl, de
    ; 454 } while(--b);
    djnz l2045
    ; 456 // Рисование игрока
    ; 457 b = cityRoadY;
    ld   b, 13
    ; 458 c++;
    inc  c
    ; 459 c = ((a = cityPlayerX) -= c);
    ld   a, (cityPlayerX)
    sub  c
    ld   c, a
    ; 460 hl = cityPlayerSprite;
    ld   hl, (cityPlayerSprite)
    ; 461 if ((a = l) == &city1s_1) c--;
    ld   a, l
    cp   city1s_1
    jp   nz, l2051
    dec  c
    ; 462 iyh = 0;
l2051:
    ld   iyh, 0
    ; 463 drawSprite(bc, de, hl);
    call drawSprite
    ; 464 }
    ret
    ; 466 // Вывод спрайта
    ; 467 // c - координата X (от -1 до 31)
    ; 468 // b - координата Y (от 0 до 23)
    ; 469 // hl - спрайт
    ; 471 void drawSprite(bc, hl, ixh, iyh)
drawSprite:
    ; 472 {
    ; 473 // Читаем ширину спрайта
    ; 474 d = *hl; l++;
    ld   d, (hl)
    inc  l
    ; 476 // Если спрайт за левым краем экрана
    ; 477 if (c & 0x80) //! Можно оптимизировать
    bit  7, c
    ; 478 do
    jp   z, l2052
l2053:
    ; 479 {
    ; 480 l = ((a = l) += [4 * 9]);
    ld   a, l
    add  36
    ld   l, a
    ; 481 c++;
    inc  c
    ; 482 d--;
    dec  d
    ; 483 if (flag_z) return;
    ret  z
    ; 484 } while (c & 0x80);
    bit  7, c
    jp   nz, l2053
    ; 486 // Если спрайт за правым краем экрана
    ; 487 (a = viewWidth) -= c;
l2052:
    ld   a, 32
    sub  c
    ; 488 if (flag_c) return;
    ret  c
    ; 489 if (flag_z) return;
    ret  z
    ; 490 if (a < d) d = a;
    cp   d
    jp   nc, l2054
    ld   d, a
    ; 491 iyl = d;
l2054:
    ld   iyl, d
    ; 493 // Вычисление координаты
    ; 494 //       43210    43210
    ; 495 // de .1.43... 210.....
    ; 496 // bc .1.11.43 210.....
    ; 497 d = (((a = b) &= 0x18) |= ixh);
    ld   a, b
    and  24
    or   ixh
    ld   d, a
    ; 498 a = b;
    ld   a, b
    ; 499 a >>r= 3;
    rrca
    rrca
    rrca
    ; 500 b = a;
    ld   b, a
    ; 501 c = e = ((a &= 0xE0) |= c);
    and  224
    or   c
    ld   e, a
    ld   c, e
    ; 502 b = ((((a = b) &= 0x03) |= 0x18) |= ixh);
    ld   a, b
    and  3
    or   24
    or   ixh
    ld   b, a
    ; 504 while()
l2055:
    ; 505 {
    ; 506 push(bc, de)
    ; 507 {
    push bc
    push de
    ; 508 drawSprite1(bc, de, hl);
    call drawSprite1
    ; 509 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 510 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2057
    ld   a, d
    add  8
    ld   d, a
    ; 511 drawSprite1(bc, de, hl);
l2057:
    call drawSprite1
    ; 512 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 513 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2058
    ld   a, d
    add  8
    ld   d, a
    ; 514 drawSprite1(bc, de, hl);
l2058:
    call drawSprite1
    ; 515 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 516 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2059
    ld   a, d
    add  8
    ld   d, a
    ; 517 drawSprite1(bc, de, hl);
l2059:
    call drawSprite1
    ; 518 }
    pop  de
    pop  bc
    ; 519 iyl--;
    dec  iyl
    ; 520 if (flag_z) return;
    ret  z
    ; 521 c++;
    inc  c
    ; 522 e++;
    inc  e
    ; 523 };
    jp   l2055
    ; 524 }
    ret
    ; 526 void drawSprite1(de, bc, hl)
drawSprite1:
    ; 527 {
    ; 528 ixl = d;
    ld   ixl, d
    ; 529 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 530 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 531 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 532 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 533 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 534 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 535 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; 536 *de = ((a = *de) |= *hl); l++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    ; 537 a = *hl; if (a == 0x45) a = iyh; *bc = a; l++;
    ld   a, (hl)
    cp   69
    jp   nz, l2060
    ld   a, iyh
l2060:
    ld   (bc), a
    inc  l
    ; 538 d = b; b++; b++; b++; *bc = a = 0xFE; b = d;
    ld   d, b
    inc  b
    inc  b
    inc  b
    ld   a, 254
    ld   (bc), a
    ld   b, d
    ; 540 // *de = a = *hl; l++; d++;
    ; 541 // *de = a = *hl; l++; d++;
    ; 542 // *de = a = *hl; l++; d++;
    ; 543 // *de = a = *hl; l++; d++;
    ; 544 // *de = a = *hl; l++; d++;
    ; 545 // *de = a = *hl; l++; d++;
    ; 546 // *de = a = *hl; l++; d++;
    ; 547 // *de = a = *hl; l++;
    ; 548 // *bc = a = *hl; l++;
    ; 549 // d = b; b++; b++; b++; *bc = a = 0xFF; b = d;
    ; 551 d = ixl;
    ld   d, ixl
    ; 552 }
    ret
    ; 554 void printDelay(a)
printDelay:
    ; 555 {
    ; 556 push(a)
    ; 557 {
    push af
    ; 558 // Активная видеостраница
    ; 559 a = videoPage;
    ld   a, (videoPage)
    ; 560 hl = [screenAddr1 + 0x10E0];
    ld   hl, 20704
    ; 561 if (a & PORT_7FFD_SECOND_VIDEO_PAGE)
    bit  3, a
    ; 562 hl = [screenAddr2 + 0x10E0];
    jp   z, l2061
    ld   hl, 53472
    ; 564 // Очиска
    ; 565 push (hl)
l2061:
    ; 566 {
    push hl
    ; 567 fillRect(hl, bc = 0x0101);
    ld   bc, 257
    call fillRect
    ; 568 }
    pop  hl
    ; 569 }
    pop  af
    ; 570 a += '0';
    add  48
    ; 571 drawCharSub(hl, a);
    call drawCharSub
    ; 572 }
    ret
    ; 574 void fillRectAddLine()
fillRectAddLine:
    ; 575 {
    ; 576 hl += (de = [0x800 - 0x100]);
    ld   de, 1792
    add  hl, de
    ; 577 return;
    ret
    ; 578 }
    ret
