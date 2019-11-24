    ; 3 const KEY_UP = 1;
    ; 4 const KEY_DOWN = 2;
    ; 5 const KEY_LEFT = 4;
    ; 6 const KEY_RIGHT = 8;
    ; 7 const KEY_FIRE = 16;
    ; 9 const PORT_7FFD_SECOND_VIDEO_PAGE = 8;
    ; 11 const screenAddr1 = 0x4000;
    ; 12 const screenAddr2 = 0xC000;
    ; 13 const screenWidth = 256;
    ; 14 const screenHeight = 192;
    ; 15 const screenBwSize = screenWidth / 8 * screenHeight;
    ; 16 const screenAttrSize = screenWidth / 8 * screenHeight / 8;
    ; 17 const screenAttrAddr1 = screenAddr1 + screenBwSize;
    ; 18 const screenAttrAddr2 = screenAddr2 + screenBwSize;
    ; 19 const screenEndAddr1 = screenAttrAddr1 + screenAttrSize;
    ; 20 const screenEndAddr2 = screenAttrAddr2 + screenAttrSize;
    ; 21 const cacheAddr1 = screenEndAddr1;
    ; 22 const cacheAddr2 = screenEndAddr2;
    ; 23 const unusedTailCode = 0xFF;
    ; 24 const viewWidth = 32;
    ; 25 const viewHeight = 20;
    ; 26 const cityRoadY = 13;
    ; 27 const mapWidth = 256;
    ; 29 const npc_timer      = 0;
    ; 30 const npc_direction  = 1;
    ; 31 const npc_step       = 2;
    ; 32 const npc_position   = 3;
    ; 33 const npc_sprite     = 4;
    ; 34 const npc_spriteType = 5;
    ; 35 const npc_sizeof     = 6;
    ; 37 const npc_maxCount = 16;
    ; 38 const npc_defaultSpeed = 7;
    ; 40 uint8_t cityPlayerX = 0;
cityPlayerX db 0
    ; 41 uint8_t cityScrollX = 0;
cityScrollX db 0
    ; 42 uint8_t cityPlayerD = 0;
cityPlayerD db 0
    ; 43 uint16_t cityPlayerSprite = [&city1Enemy + 0x100];
cityPlayerSprite dw (city1Enemy) + (256)
    ; 44 uint8_t processedFrames = 0;
processedFrames db 0
    ; 45 uint8_t startFrame;
startFrame db 0
    ; 46 uint8_t npcCount = npc_maxCount;
npcCount db 16
    ; 47 uint8_t npc[npc_sizeof * npc_maxCount];
npc ds 96
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
    ; 108 void initNpc()
initNpc:
    ; 109 {
    ; 110 ix = &npc;
    ld   ix, npc
    ; 111 de = npc_sizeof;
    ld   de, 6
    ; 112 b = a = npcCount; // Счетчик цикла
    ld   a, (npcCount)
    ld   b, a
    ; 113 do
l2006:
    ; 114 {
    ; 115 a = b;
    ld   a, b
    ; 116 while (a >= npc_defaultSpeed) a -= npc_defaultSpeed;
l2007:
    cp   7
    jp   c, l2008
    sub  7
    jp   l2007
l2008:
    ; 117 a += 1;
    add  1
    ; 118 ix[npc_timer] = a; // Фаза таймера
    ld   (ix + 0), a
    ; 120 ix[npc_step] = 0;
    ld   (ix + 2), 0
    ; 121 ix[npc_sprite] = [&city1Enemy + 14 * 4];
    ld   (ix + 4), (city1Enemy) + (56)
    ; 122 rand();
    call rand
    ; 123 ix[npc_position] = a;
    ld   (ix + 3), a
    ; 124 ix[npc_direction] = (a &= 1);
    and  1
    ld   (ix + 1), a
    ; 125 ix += de;
    add  ix, de
    ; 126 } while(--b);
    djnz l2006
    ; 127 }
    ret
    ; 129 void processNpc()
processNpc:
    ; 130 {
    ; 131 de = npc_sizeof;
    ld   de, 6
    ; 132 hl = &npc;
    ld   hl, npc
    ; 133 b = a = npcCount;
    ld   a, (npcCount)
    ld   b, a
    ; 134 do
l2010:
    ; 135 {
    ; 136 if (flag_z --*hl) // Скорость
    dec  (hl)
    ; 137 {
    jp   nz, l2011
    ; 138 rand();
    call rand
    ; 139 if (flag_z a--) // Внезапная остановка
    dec  a
    ; 140 {
    jp   nz, l2012
    ; 141 //! Не полушаге не останавливать
    ; 142 push(hl);
    push hl
    ; 143 pop(ix);
    pop  ix
    ; 144 a = ix[npc_spriteType];
    ld   a, (ix + 5)
    ; 145 if (a == 1)
    cp   1
    ; 146 {
    jp   nz, l2013
    ; 147 *hl = 255;
    ld   (hl), 255
    ; 148 goto continue1;
    jp   continue1
    ; 149 }
    ; 150 }
l2013:
    ; 152 // У всех разная скорость
    ; 153 *hl = (((a = b) &= 7) += npc_defaultSpeed);
l2012:
    ld   a, b
    and  7
    add  7
    ld   (hl), a
    ; 155 if (flag_z a--) // Внезапный поворот
    dec  a
    ; 156 {
    jp   nz, l2014
    ; 157 hl++;
    inc  hl
    ; 158 a = *hl;
    ld   a, (hl)
    ; 159 a ^= 1;
    xor  1
    ; 160 *hl = a;
    ld   (hl), a
    ; 161 hl--;
    dec  hl
    ; 162 }
    ; 164 hl++;
l2014:
    inc  hl
    ; 165 if (*hl & 1) // Направление
    bit  0, (hl)
    ; 166 {
    jp   z, l2015
    ; 167 hl++;
    inc  hl
    ; 168 c = *hl;
    ld   c, (hl)
    ; 169 if (c & 4) // Шаг
    bit  2, c
    ; 170 {
    jp   z, l2016
    ; 171 *hl = 0; // Шаг
    ld   (hl), 0
    ; 172 hl++; a = *hl; // Позиция
    inc  hl
    ld   a, (hl)
    ; 173 /* if (a == 254)
    ; 179 *hl = (++a); // Позиция
    inc  a
    ld   (hl), a
    ; 180 hl++; *hl = [&city1Enemy + 17 * 4]; // Спрайт
    inc  hl
    ld   (hl), (city1Enemy) + (68)
    ; 181 hl++; *hl = 1; // Тип спрайта
    inc  hl
    ld   (hl), 1
    ; 182 }
    ; 183 else if (c & 2) // Шаг
    jp   l2017
l2016:
    bit  1, c
    ; 184 {
    jp   z, l2018
    ; 185 *hl = 4; // Шаг
    ld   (hl), 4
    ; 186 hl++; hl++; *hl = [&city1Enemy + 22 * 4]; // Спрайт
    inc  hl
    inc  hl
    ld   (hl), (city1Enemy) + (88)
    ; 187 hl++; *hl = 0; // Тип спрайта
    inc  hl
    ld   (hl), 0
    ; 188 }
    ; 189 else if (c & 1) // Шаг
    jp   l2019
l2018:
    bit  0, c
    ; 190 {
    jp   z, l2020
    ; 191 *hl = 2; // Шаг
    ld   (hl), 2
    ; 192 hl++; hl++; *hl = [&city1Enemy + 20 * 4]; // Спрайт
    inc  hl
    inc  hl
    ld   (hl), (city1Enemy) + (80)
    ; 193 hl++; *hl = 0; // Тип спрайта
    inc  hl
    ld   (hl), 0
    ; 194 }
    ; 195 else
    jp   l2021
l2020:
    ; 196 {
    ; 197 *hl = 1; // Шаг
    ld   (hl), 1
    ; 198 hl++; hl++; *hl = [&city1Enemy + 18 * 4]; // Спрайт
    inc  hl
    inc  hl
    ld   (hl), (city1Enemy) + (72)
    ; 199 hl++; *hl = 0; // Тип спрайта
    inc  hl
    ld   (hl), 0
    ; 200 }
l2021:
l2019:
l2017:
    ; 201 }
    ; 202 else
    jp   l2022
l2015:
    ; 203 {
    ; 204 hl++;
    inc  hl
    ; 205 c = *hl;
    ld   c, (hl)
    ; 206 if (c & 4) // Шаг
    bit  2, c
    ; 207 {
    jp   z, l2023
    ; 208 *hl = 0; // Шаг
    ld   (hl), 0
    ; 209 hl++; hl++; *hl = [&city1Enemy + 11 * 4]; // Спрайт
    inc  hl
    inc  hl
    ld   (hl), (city1Enemy) + (44)
    ; 210 hl++; *hl = 0; // Тип спрайта
    inc  hl
    ld   (hl), 0
    ; 211 }
    ; 212 else
    jp   l2024
l2023:
    ; 213 if (c & 2)
    bit  1, c
    ; 214 {
    jp   z, l2025
    ; 215 *hl = 4; // Шаг
    ld   (hl), 4
    ; 216 hl++; hl++; *hl = [&city1Enemy + 13 * 4]; // Спрайт
    inc  hl
    inc  hl
    ld   (hl), (city1Enemy) + (52)
    ; 217 hl++; *hl = 0; // Тип спрайта
    inc  hl
    ld   (hl), 0
    ; 218 }
    ; 219 else if(c & 1)
    jp   l2026
l2025:
    bit  0, c
    ; 220 {
    jp   z, l2027
    ; 221 *hl = 2; // Шаг
    ld   (hl), 2
    ; 222 hl++; a = *hl; // Позиция
    inc  hl
    ld   a, (hl)
    ; 223 a--;
    dec  a
    ; 224 *hl = a; // Позиция
    ld   (hl), a
    ; 225 hl++; *hl = [&city1Enemy + 15 * 4]; // Спрайт
    inc  hl
    ld   (hl), (city1Enemy) + (60)
    ; 226 hl++; *hl = 0; // Тип спрайта
    inc  hl
    ld   (hl), 0
    ; 227 }
    ; 228 else
    jp   l2028
l2027:
    ; 229 {
    ; 230 *hl = 1; // Шаг
    ld   (hl), 1
    ; 231 hl++; hl++; *hl = [&city1Enemy + 10 * 4]; // Спрайт
    inc  hl
    inc  hl
    ld   (hl), (city1Enemy) + (40)
    ; 232 hl++; *hl = 1; // Тип спрайта
    inc  hl
    ld   (hl), 1
    ; 233 }
l2028:
l2026:
l2024:
    ; 234 }
l2022:
    ; 235 hl++;
    inc  hl
    ; 236 }
    ; 237 else
    jp   l2029
l2011:
    ; 238 {
    ; 239 continue1:
continue1:
    ; 240 hl += de; // Следующий NPC
    add  hl, de
    ; 241 }
l2029:
    ; 242 } while(flag_nz --b);
    dec  b
    jp   nz, l2010
    ; 243 }
    ret
    ; 245 void clearRoad()
clearRoad:
    ; 246 {
    ; 247 hl = &city1Map;
    ld   hl, city1Map
    ; 248 l = a = cityScrollX;
    ld   a, (cityScrollX)
    ld   l, a
    ; 249 h = ((a = h) += cityRoadY);
    ld   a, h
    add  13
    ld   h, a
    ; 250 a = 0;
    ld   a, 0
    ; 251 c = 4;
    ld   c, 4
    ; 252 do
l2030:
    ; 253 {
    ; 254 d = l;
    ld   d, l
    ; 255 b = viewWidth;
    ld   b, 32
    ; 256 do
l2031:
    ; 257 {
    ; 258 if (a != *hl)
    cp   (hl)
    ; 259 *hl = a;
    jp   z, l2032
    ld   (hl), a
    ; 260 l++;
l2032:
    inc  l
    ; 261 } while(--b);
    djnz l2031
    ; 262 l = d;
    ld   l, d
    ; 263 h++;
    inc  h
    ; 264 --c;
    dec  c
    ; 265 } while(flag_nz);
    jp   nz, l2030
    ; 266 }
    ret
    ; 268 void processPlayer()
processPlayer:
    ; 269 {
    ; 270 // Чтение клавиши
    ; 271 b = a = keyPressed;
    ld   a, (keyPressed)
    ld   b, a
    ; 272 a = cityPlayerX;
    ld   a, (cityPlayerX)
    ; 273 if (b & KEY_LEFT)
    bit  2, b
    ; 274 {
    jp   z, l2033
    ; 275 a -= 1;
    sub  1
    ; 276 if (flag_c) goto playerStop;
    jp   c, playerStop
    ; 278 cityPlayerX = a;
    ld   (cityPlayerX), a
    ; 279 if (a >= [viewWidth / 2]) if (a < [mapWidth - viewWidth / 2 + 1]) { cityScrollX = (a -= [viewWidth / 2]); }
    cp   16
    jp   c, l2034
    cp   241
    jp   nc, l2035
    sub  16
    ld   (cityScrollX), a
    ; 280 cityPlayerD = a = 0;
l2035:
l2034:
    ld   a, 0
    ld   (cityPlayerD), a
    ; 282 a = cityPlayerSprite;
    ld   a, (cityPlayerSprite)
    ; 283 hl = [&city1Enemy + 0x100];
    ld   hl, (city1Enemy) + (256)
    ; 284 if (a == l) hl = [&city1Enemy + 4 + 0x200];
    cp   l
    jp   nz, l2036
    ld   hl, (city1Enemy) + (516)
    ; 285 cityPlayerSprite = hl;
l2036:
    ld   (cityPlayerSprite), hl
    ; 286 return;
    ret
    ; 287 }
    ; 289 if (b & KEY_RIGHT)
l2033:
    bit  3, b
    ; 290 {
    jp   z, l2037
    ; 291 a += 1;
    add  1
    ; 292 if (flag_c) goto playerStop;
    jp   c, playerStop
    ; 294 cityPlayerX = a;
    ld   (cityPlayerX), a
    ; 295 if (a >= [viewWidth / 2]) if (a < [mapWidth - viewWidth / 2 + 1]) { cityScrollX = (a -= [viewWidth / 2]); }
    cp   16
    jp   c, l2038
    cp   241
    jp   nc, l2039
    sub  16
    ld   (cityScrollX), a
    ; 296 cityPlayerD = a = 1;
l2039:
l2038:
    ld   a, 1
    ld   (cityPlayerD), a
    ; 298 a = cityPlayerSprite;
    ld   a, (cityPlayerSprite)
    ; 299 hl = [&city1Enemy + 20 + 0x100];
    ld   hl, (city1Enemy) + (276)
    ; 300 if (a == l) hl = [&city1Enemy + 24];
    cp   l
    jp   nz, l2040
    ld   hl, (city1Enemy) + (24)
    ; 301 cityPlayerSprite = hl;
l2040:
    ld   (cityPlayerSprite), hl
    ; 302 return;
    ret
    ; 303 }
    ; 305 playerStop:
l2037:
playerStop:
    ; 306 a = cityPlayerD;
    ld   a, (cityPlayerD)
    ; 307 hl = [&city1Enemy + 0x100];
    ld   hl, (city1Enemy) + (256)
    ; 308 if (a & 1) hl = [&city1Enemy + 20 + 0x100];
    bit  0, a
    jp   z, l2041
    ld   hl, (city1Enemy) + (276)
    ; 309 cityPlayerSprite = hl;
l2041:
    ld   (cityPlayerSprite), hl
    ; 310 }
    ret
    ; 312 void drawCharacter(e, ix)
drawCharacter:
    ; 313 {
    ; 314 // Рисуем
    ; 315 d = [(&city1Map >> 8) + cityRoadY];
    ld   d, (+((city1Map) >> (8))) + (13)
    ; 316 e = a;
    ld   e, a
    ; 317 a = ixl;
    ld   a, ixl
    ; 318 *de = a; a++; d++;
    ld   (de), a
    inc  a
    inc  d
    ; 319 *de = a; a++; d++;
    ld   (de), a
    inc  a
    inc  d
    ; 320 *de = a; a++; d++;
    ld   (de), a
    inc  a
    inc  d
    ; 321 *de = a;
    ld   (de), a
    ; 322 if (b & 1) return;
    bit  0, b
    ret  nz
    ; 323 a += 4; e++;
    add  4
    inc  e
    ; 324 *de = a; a--; d--;
    ld   (de), a
    dec  a
    dec  d
    ; 325 *de = a; a--; d--;
    ld   (de), a
    dec  a
    dec  d
    ; 326 *de = a; a--; d--;
    ld   (de), a
    dec  a
    dec  d
    ; 327 *de = a;
    ld   (de), a
    ; 328 }
    ret
    ; 330 void cityRedraw()
cityRedraw:
    ; 331 {
    ; 332 // Оценка времени
    ; 333 startFrame = a = frame;
    ld   a, (frame)
    ld   (startFrame), a
    ; 335 // Очистка дороги от нарисованных жителей и игрока
    ; 336 clearRoad();
    call clearRoad
    ; 338 // Рисование жителей
    ; 339 /*
    ; 368 // Ждем, если активная страница еще не стала видимой
    ; 369 while ((a = videoPage) & 1);
l2042:
    ld   a, (videoPage)
    bit  0, a
    jp   z, l2043
    jp   l2042
l2043:
    ; 371 // const npc_timer      = 0;
    ; 372 // const npc_direction  = 1;
    ; 373 // const npc_step       = 2;
    ; 374 // const npc_position   = 3;
    ; 375 // const npc_sprite     = 4;
    ; 376 // const npc_spriteType = 5;
    ; 377 // const npc_sizeof     = 6;
    ; 379 a = videoPage;
    ld   a, (videoPage)
    ; 380 if (a & 8) ixh = [screenAddr1 >> 8];
    bit  3, a
    jp   z, l2045
    ld   ixh, 64
    ; 381 else ixh = [screenAddr2 >> 8];
    jp   l2046
l2045:
    ld   ixh, 192
l2046:
    ; 383 // Спрайты
    ; 384 hl = [&npc + npc_position];
    ld   hl, (npc) + (3)
    ; 385 b = a = npcCount;
    ld   a, (npcCount)
    ld   b, a
    ; 386 c = a = cityScrollX;
    ld   a, (cityScrollX)
    ld   c, a
    ; 387 de = npc_sizeof;
    ld   de, 6
    ; 388 do
l2047:
    ; 389 {
    ; 390 // Если спрайт за экраном, то не рисуем его
    ; 391 if (((a = *hl) -= c) < viewWidth)
    ld   a, (hl)
    sub  c
    cp   32
    ; 392 {
    jp   nc, l2048
    ; 393 ixl = a; // position
    ld   ixl, a
    ; 394 hl++; a = *hl; // npc_sprite
    inc  hl
    ld   a, (hl)
    ; 395 ex(a, a);
    ex   af, af
    ; 396 hl++; a = *hl; hl--; hl--; // npc_spriteType
    inc  hl
    ld   a, (hl)
    dec  hl
    dec  hl
    ; 397 ex(a, a);
    ex   af, af
    ; 398 ex(bc, de, hl);
    exx
    ; 399 h = [&city1Tails >> 8];
    ld   h, (city1Tails) >> (8)
    ; 400 l = a;
    ld   l, a
    ; 401 b = cityRoadY;
    ld   b, 13
    ; 402 c = ixl;
    ld   c, ixl
    ; 403 drawSprite();
    call drawSprite
    ; 404 ex(a, a);
    ex   af, af
    ; 405 if(flag_nc a >>= 1) drawSpriteRight();
    srl  a
    call nc, drawSpriteRight
    ; 406 ex(bc, de, hl);
    exx
    ; 407 }
    ; 408 hl += de;
l2048:
    add  hl, de
    ; 409 } while(--b);
    djnz l2047
    ; 411 // Рисование игрока
    ; 412 b = cityRoadY;
    ld   b, 13
    ; 413 c = ((a = cityPlayerX) -= c);
    ld   a, (cityPlayerX)
    sub  c
    ld   c, a
    ; 414 hl = cityPlayerSprite;
    ld   hl, (cityPlayerSprite)
    ; 415 a = h;
    ld   a, h
    ; 416 if (a & 2) c--;
    bit  1, a
    jp   z, l2049
    dec  c
    ; 417 h = [&city1Tails >> 8];
l2049:
    ld   h, (city1Tails) >> (8)
    ; 418 ex(a, a);
    ex   af, af
    ; 419 drawSprite(bc, de, hl);
    call drawSprite
    ; 420 ex(a, a);
    ex   af, af
    ; 421 if (flag_nc a >>= 1) drawSpriteRight(bc, de, hl);
    srl  a
    call nc, drawSpriteRight
    ; 423 // Адрес карты / источник
    ; 424 d` = [&city1Map >> 8];
    ld   d, (city1Map) >> (8)
    ; 425 e` = a = cityScrollX;
    ld   a, (cityScrollX)
    ld   e, a
    ; 426 b` = e`;
    ld   b, e
    ; 428 // Адрес видеостраницы / назначение
    ; 429 a = videoPage;
    ld   a, (videoPage)
    ; 430 if (a & 8)
    bit  3, a
    ; 431 {
    jp   z, l2050
    ; 432 hl` = [cacheAddr1 - 1];
    ld   hl, 23295
    ; 433 ex(bc, de, hl);
    exx
    ; 434 de = screenAddr1;
    ld   de, 16384
    ; 435 bc = screenAttrAddr1;
    ld   bc, 22528
    ; 436 }
    ; 437 else
    jp   l2051
l2050:
    ; 438 {
    ; 439 hl` = [cacheAddr2 - 1];
    ld   hl, 56063
    ; 440 ex(bc, de, hl);
    exx
    ; 441 de = screenAddr2;
    ld   de, 49152
    ; 442 bc = screenAttrAddr2;
    ld   bc, 55296
    ; 443 }
l2051:
    ; 445 // Цикл строк
    ; 446 ixh = viewHeight;
    ld   ixh, 20
    ; 447 do
l2052:
    ; 448 {
    ; 449 // Сохранение адреса вывода
    ; 450 iyl = e;
    ld   iyl, e
    ; 451 iyh = d;
    ld   iyh, d
    ; 453 // Цикл стобцов
    ; 454 ixl = viewWidth;
    ld   ixl, 32
    ; 455 do
l2053:
    ; 456 {
    ; 457 optimize0:  // Чтение номера тейла из карты уровня
optimize0:
    ; 458 ex(bc, de, hl);
    exx
    ; 459 hl`++;
    inc  hl
    ; 460 c` = *hl;
    ld   c, (hl)
    ; 461 a = *de`;
    ld   a, (de)
    ; 462 if (a == c`) goto optimize1;
    cp   c
    jp   z, optimize1
    ; 463 if (flag_z c`++) goto optimize3;
    inc  c
    jp   z, optimize3
    ; 464 e`++;
    inc  e
    ; 465 *hl` = a;
    ld   (hl), a
    ; 466 ex(bc, de, hl);
    exx
    ; 468 // Вычисление адреса тейла
    ; 469 h = [&city1Tails >> 8];
    ld   h, (city1Tails) >> (8)
    ; 470 l = a;
    ld   l, a
    ; 472 // Вывод на экран
    ; 473 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 474 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 475 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 476 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 477 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 478 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 479 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 480 a = *hl; h++; *de = a;
    ld   a, (hl)
    inc  h
    ld   (de), a
    ; 481 a = *hl;      *bc = a; bc++;
    ld   a, (hl)
    ld   (bc), a
    inc  bc
    ; 483 d = iyh;
    ld   d, iyh
    ; 484 e++;
    inc  e
    ; 485 ixl--;
    dec  ixl
    ; 486 } while(flag_nz);
    jp   nz, l2053
    ; 487 optimize2:
optimize2:
    ; 489 // Следующая строка карты
    ; 490 ex(bc, de, hl);
    exx
    ; 491 e` = b`;
    ld   e, b
    ; 492 d`++;
    inc  d
    ; 493 ex(bc, de, hl);
    exx
    ; 495 // Адрес следующей чб строки на экране
    ; 496 e = ((a = iyl) += 0x20);
    ld   a, iyl
    add  32
    ld   e, a
    ; 497 if (flag_c) d = ((a = d) += 0x08);
    jp   nc, l2054
    ld   a, d
    add  8
    ld   d, a
    ; 499 ixh--;
l2054:
    dec  ixh
    ; 500 } while(flag_nz);
    jp   nz, l2052
    ; 502 // Переключить видеостраницы во время следующего прерывания
    ; 503 videoPage = ((a = videoPage) ^= 8 |= 1);
    ld   a, (videoPage)
    xor  8
    or   1
    ld   (videoPage), a
    ; 505 // Оценка времени
    ; 506 printDelay((a = frame) -= *(hl = &startFrame));
    ld   a, (frame)
    ld   hl, startFrame
    sub  (hl)
    call printDelay
    ; 508 return;
    ret
    ; 509 optimize3:
optimize3:
    ; 510 *hl` = a = 254;
    ld   a, 254
    ld   (hl), a
    ; 511 optimize1:
optimize1:
    ; 512 e`++;
    inc  e
    ; 513 ex(bc, de, hl);
    exx
    ; 514 bc++;
    inc  bc
    ; 515 e++;
    inc  e
    ; 516 ixl--;
    dec  ixl
    ; 517 if(flag_nz) goto optimize0;
    jp   nz, optimize0
    ; 518 goto optimize2;
    jp   optimize2
    ; 519 }
    ret
    ; 521 // Вывод спрайта
    ; 522 // c - координата X
    ; 523 // b - координата Y
    ; 524 // hl - спрайт
    ; 525 // d - тип
    ; 527 uint16_t drawSprite_a;
drawSprite_a dw 0
    ; 528 uint16_t drawSprite_b;
drawSprite_b dw 0
    ; 530 void drawSprite(bc, de, hl)
drawSprite:
    ; 531 {
    ; 532 // Вычисление координаты
    ; 533 //       43210    43210
    ; 534 // de .1.43... 210.....
    ; 535 // bc .1.11.43 210.....
    ; 536 d = (((a = b) &= 0x18) |= ixh);
    ld   a, b
    and  24
    or   ixh
    ld   d, a
    ; 537 a = b;
    ld   a, b
    ; 538 a >>r= 1 >>r= 1 >>r= 1;
    rrca
    rrca
    rrca
    ; 539 b = a;
    ld   b, a
    ; 540 c = e = ((a &= 0xE0) |= c);
    and  224
    or   c
    ld   e, a
    ld   c, e
    ; 541 b = ((((a = b) &= 0x03) |= 0x18) |= ixh);
    ld   a, b
    and  3
    or   24
    or   ixh
    ld   b, a
    ; 543 drawSprite_a = bc;
    ld   (drawSprite_a), bc
    ; 544 drawSprite_b = de;
    ld   (drawSprite_b), de
    ; 546 drawSprite_1:
drawSprite_1:
    ; 547 drawSprite1(bc, de, hl);
    call drawSprite1
    ; 548 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 549 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2055
    ld   a, d
    add  8
    ld   d, a
    ; 550 drawSprite1(bc, de, hl);
l2055:
    call drawSprite1
    ; 551 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 552 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2056
    ld   a, d
    add  8
    ld   d, a
    ; 553 drawSprite1(bc, de, hl);
l2056:
    call drawSprite1
    ; 554 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; 555 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2057
    ld   a, d
    add  8
    ld   d, a
    ; 556 drawSprite1(bc, de, hl);
l2057:
    call drawSprite1
    ; 557 }
    ret
    ; 559 void drawSpriteRight(bc, de, hl)
drawSpriteRight:
    ; 560 {
    ; 561 bc = drawSprite_a;
    ld   bc, (drawSprite_a)
    ; 562 de = drawSprite_b;
    ld   de, (drawSprite_b)
    ; 563 c++; e++;
    inc  c
    inc  e
    ; 564 if (flag_nz (a = e) &= 0x1F) goto drawSprite_1;
    ld   a, e
    and  31
    jp   nz, drawSprite_1
    ; 565 }
    ret
    ; 567 void drawSprite1(de, bc, hl)
drawSprite1:
    ; 568 {
    ; 569 // Вывод на экран
    ; 570 ixl = d; // 8
    ld   ixl, d
    ; 571 push(hl);
    push hl
    ; 572 a = *hl; h++; *de = a; d++; // 22*7
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 573 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 574 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 575 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 576 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 577 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 578 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; 579 a = *hl; h++; *de = a; // 18
    ld   a, (hl)
    inc  h
    ld   (de), a
    ; 580 a = *hl; h++; *bc = a; // 14
    ld   a, (hl)
    inc  h
    ld   (bc), a
    ; 581 b++; b++; b++; *bc = a = 0xFF; b--; b--; b--; // Перерисовать
    inc  b
    inc  b
    inc  b
    ld   a, 255
    ld   (bc), a
    dec  b
    dec  b
    dec  b
    ; 582 pop(hl);
    pop  hl
    ; 583 l++;
    inc  l
    ; 584 d = ixl; // 8
    ld   d, ixl
    ; 585 } // total 202
    ret
    ; 587 void printDelay(a)
printDelay:
    ; 588 {
    ; 589 push(a)
    ; 590 {
    push af
    ; 591 // Активная видеостраница
    ; 592 a = videoPage;
    ld   a, (videoPage)
    ; 593 hl = [screenAddr1 + 0x10E0];
    ld   hl, 20704
    ; 594 if (a & PORT_7FFD_SECOND_VIDEO_PAGE)
    bit  3, a
    ; 595 hl = [screenAddr2 + 0x10E0];
    jp   z, l2058
    ld   hl, 53472
    ; 597 // Очиска
    ; 598 push (hl)
l2058:
    ; 599 {
    push hl
    ; 600 fillRect(hl, bc = 0x0101);
    ld   bc, 257
    call fillRect
    ; 601 }
    pop  hl
    ; 602 }
    pop  af
    ; 603 a += '0';
    add  48
    ; 604 drawCharSub(hl, a);
    call drawCharSub
    ; 605 }
    ret
    ; 607 // b - высота, c - ширина,
    ; 609 void fillRect(hl, bc)
fillRect:
    ; 610 {
    ; 611 do
l2059:
    ; 612 {
    ; 613 push(bc)
    ; 614 {
    push bc
    ; 615 a ^= a;
    xor  a
    ; 616 d = 8;
    ld   d, 8
    ; 617 e = l;
    ld   e, l
    ; 618 do
l2060:
    ; 619 {
    ; 620 b = c;
    ld   b, c
    ; 621 do
l2061:
    ; 622 {
    ; 623 *hl = a;
    ld   (hl), a
    ; 624 l++;
    inc  l
    ; 625 } while(--b);
    djnz l2061
    ; 626 l = e;
    ld   l, e
    ; 627 h++;
    inc  h
    ; 628 d--;
    dec  d
    ; 629 } while(flag_nz);
    jp   nz, l2060
    ; 631 // Адрес следующей строки
    ; 632 hl += (de = [0x20 - 0x800]);
    ld   de, -2016
    add  hl, de
    ; 633 a = h;
    ld   a, h
    ; 634 a &= 7;
    and  7
    ; 635 if (flag_nz) fillRectAddLine();
    call nz, fillRectAddLine
    ; 636 }
    pop  bc
    ; 637 } while(--b);
    djnz l2059
    ; 638 return;
    ret
    ; 639 }
    ret
    ; 641 void fillRectAddLine()
fillRectAddLine:
    ; 642 {
    ; 643 hl += (de = [0x800 - 0x100]);
    ld   de, 1792
    add  hl, de
    ; 644 return;
    ret
    ; 645 }
    ret
