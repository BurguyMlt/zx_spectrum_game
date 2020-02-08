    ; city/city2.c:2 
    ; city/city2.c:3 #include "common.h"
    ; city/city2.c:4 
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
    ; city/city2.c:5 const int PORT_7FFD_SECOND_VIDEO_PAGE = 8;
    ; city/city2.c:6 
    ; city/city2.c:7 const int screenAddr1 = 0x4000;
    ; city/city2.c:8 const int screenAddr2 = 0xC000;
    ; city/city2.c:9 const int screenWidth = 256;
    ; city/city2.c:10 const int screenHeight = 192;
    ; city/city2.c:11 const int screenBwSize = screenWidth / 8 * screenHeight;
    ; city/city2.c:12 const int screenAttrSize = screenWidth / 8 * screenHeight / 8;
    ; city/city2.c:13 const int screenAttrAddr1 = screenAddr1 + screenBwSize;
    ; city/city2.c:14 const int screenAttrAddr2 = screenAddr2 + screenBwSize;
    ; city/city2.c:15 const int screenEndAddr1 = screenAttrAddr1 + screenAttrSize;
    ; city/city2.c:16 const int screenEndAddr2 = screenAttrAddr2 + screenAttrSize;
    ; city/city2.c:17 const int cacheAddr1 = screenEndAddr1;
    ; city/city2.c:18 const int cacheAddr2 = screenEndAddr2;
    ; city/city2.c:19 const int unusedTailCode = 0xFE;
    ; city/city2.c:20 const int viewWidth = 32;
    ; city/city2.c:21 const int viewHeight = 20;
    ; city/city2.c:22 const int cityRoadY = 13;
    ; city/city2.c:23 const int mapWidth = 256;
    ; city/city2.c:24 
    ; city/city2.c:25 const int npc_timer           = 0;
    ; city/city2.c:26 const int npc_flags           = 1;
    ; city/city2.c:27 const int npc_flags_direction = 0x01;
    ; city/city2.c:28 const int npc_flags_type      = 0x02;
    ; city/city2.c:29 const int npc_step            = 2;
    ; city/city2.c:30 const int npc_position        = 3;
    ; city/city2.c:31 const int npc_sizeof          = 4;
    ; city/city2.c:32 
    ; city/city2.c:33 const int npc_maxCount = 16;
    ; city/city2.c:34 const int npc_defaultSpeed = 7;
    ; city/city2.c:35 
    ; city/city2.c:36 uint8_t cityPlayerX = 0;
cityPlayerX db 0
    ; city/city2.c:37 uint8_t cityScrollX = 0;
cityScrollX db 0
    ; city/city2.c:38 uint8_t cityPlayerDirection = 0;
cityPlayerDirection db 0
    ; city/city2.c:39 uint16_t cityPlayerSprite = &city1s_0;
cityPlayerSprite dw city1s_0
    ; city/city2.c:40 uint8_t processedFrames = 0;
processedFrames db 0
    ; city/city2.c:41 //uint8_t startFrame;
    ; city/city2.c:42 uint8_t npcCount = npc_maxCount;
npcCount db 16
    ; city/city2.c:43 uint8_t npc[npc_sizeof * npc_maxCount];
npc ds 64
    ; city/city2.c:44 
    ; city/city2.c:45 void swapMaps()
swapMaps:
    ; city/city2.c:46 {
    ; city/city2.c:47 // Загрузка города
    ; city/city2.c:48 hl = &city1Tails;
    ld   hl, city1Tails
    ; city/city2.c:49 de = &city1bTails;
    ld   de, city1bTails
    ; city/city2.c:50 bc = [9 * 256 + 256 * 20];
    ld   bc, 7424
    ; city/city2.c:51 do
l2000:
    ; city/city2.c:52 {
    ; city/city2.c:53 a = *de;
    ld   a, (de)
    ; city/city2.c:54 ex(a, a);
    ex   af, af
    ; city/city2.c:55 a = *hl;
    ld   a, (hl)
    ; city/city2.c:56 *de = a;
    ld   (de), a
    ; city/city2.c:57 ex(a, a);
    ex   af, af
    ; city/city2.c:58 *hl = a;
    ld   (hl), a
    ; city/city2.c:59 hl++;
    inc  hl
    ; city/city2.c:60 de++;
    inc  de
    ; city/city2.c:61 bc--;
    dec  bc
    ; city/city2.c:62 } while(flag_nz (a = b) |= c);
    ld   a, b
    or   c
    jp   nz, l2000
l2001:
    ; city/city2.c:63 }
    ret
    ; city/city2.c:64 
    ; city/city2.c:65 void cityFullRedraw()
cityFullRedraw:
    ; city/city2.c:66 {
    ; city/city2.c:67 cityInvalidate(hl = cacheAddr1);
    ld   hl, 23296
    call cityInvalidate
    ; city/city2.c:68 //*[cacheAddr1 + screenAttrSize] = a = 0;
    ; city/city2.c:69 cityInvalidate(hl = cacheAddr2);
    ld   hl, 56064
    call cityInvalidate
    ; city/city2.c:70 //*[cacheAddr2 + screenAttrSize] = a = 0;
    ; city/city2.c:71 gPanelChangedA = a = 0xFF;
    ld   a, 255
    ld   (gPanelChangedA), a
    ; city/city2.c:72 gPanelChangedB = a;
    ld   (gPanelChangedB), a
    ; city/city2.c:73 }
    ret
    ; city/city2.c:74 
    ; city/city2.c:75 void newGame()
newGame:
    ; city/city2.c:76 {
    ; city/city2.c:77 gPlayerMoney = hl = 10;
    ld   hl, 10
    ld   (gPlayerMoney), hl
    ; city/city2.c:78 gPlayerItemsCount = a = 2;
    ld   a, 2
    ld   (gPlayerItemsCount), a
    ; city/city2.c:79 *[&gPlayerItems] = a = 0;
    ld   a, 0
    ld   (gPlayerItems), a
    ; city/city2.c:80 *[&gPlayerItems + 1] = a = 1;
    ld   a, 1
    ld   ((gPlayerItems) + (1)), a
    ; city/city2.c:81 
    ; city/city2.c:82 gPlayerLutCount = a = 3;
    ld   a, 3
    ld   (gPlayerLutCount), a
    ; city/city2.c:83 *[&gPlayerLut + 0] = a = 3;
    ld   a, 3
    ld   ((gPlayerLut) + (0)), a
    ; city/city2.c:84 *[&gPlayerLut + playerLutMax + 0] = a = 5;
    ld   a, 5
    ld   ((gPlayerLut) + (12)), a
    ; city/city2.c:85 *[&gPlayerLut + 1] = a = 4;
    ld   a, 4
    ld   ((gPlayerLut) + (1)), a
    ; city/city2.c:86 *[&gPlayerLut + playerLutMax + 1] = a = 10;
    ld   a, 10
    ld   ((gPlayerLut) + (13)), a
    ; city/city2.c:87 *[&gPlayerLut + 2] = a = 5;
    ld   a, 5
    ld   ((gPlayerLut) + (2)), a
    ; city/city2.c:88 *[&gPlayerLut + playerLutMax + 2] = a = 15;
    ld   a, 15
    ld   ((gPlayerLut) + (14)), a
    ; city/city2.c:89 
    ; city/city2.c:90 gPlayerSecondWeaponCount = a = 7;
    ld   a, 7
    ld   (gPlayerSecondWeaponCount), a
    ; city/city2.c:91 *[&gPlayerSecondWeaponCounters + 0] = a = 10;
    ld   a, 10
    ld   ((gPlayerSecondWeaponCounters) + (0)), a
    ; city/city2.c:92 *[&gPlayerSecondWeaponCounters + 1] = a = 12;
    ld   a, 12
    ld   ((gPlayerSecondWeaponCounters) + (1)), a
    ; city/city2.c:93 *[&gPlayerSecondWeaponCounters + 2] = a = 14;
    ld   a, 14
    ld   ((gPlayerSecondWeaponCounters) + (2)), a
    ; city/city2.c:94 *[&gPlayerSecondWeaponCounters + 3] = a = 16;
    ld   a, 16
    ld   ((gPlayerSecondWeaponCounters) + (3)), a
    ; city/city2.c:95 *[&gPlayerSecondWeaponCounters + 4] = a = 18;
    ld   a, 18
    ld   ((gPlayerSecondWeaponCounters) + (4)), a
    ; city/city2.c:96 *[&gPlayerSecondWeaponCounters + 5] = a = 20;
    ld   a, 20
    ld   ((gPlayerSecondWeaponCounters) + (5)), a
    ; city/city2.c:97 *[&gPlayerSecondWeaponCounters + 6] = a = 22;
    ld   a, 22
    ld   ((gPlayerSecondWeaponCounters) + (6)), a
    ; city/city2.c:98 *[&gPlayerSecondWeaponCounters + 7] = a = 24;
    ld   a, 24
    ld   ((gPlayerSecondWeaponCounters) + (7)), a
    ; city/city2.c:99 *[&gPlayerSecondWeaponCounters + 8] = a = 26;
    ld   a, 26
    ld   ((gPlayerSecondWeaponCounters) + (8)), a
    ; city/city2.c:100 }
    ret
    ; city/city2.c:101 
    ; city/city2.c:102 void main()
main:
    ; city/city2.c:103 {
    ; city/city2.c:104 newGame();
    call newGame
    ; city/city2.c:105 
    ; city/city2.c:106 gPanelChangedA = a = 0xFF;
    ld   a, 255
    ld   (gPanelChangedA), a
    ; city/city2.c:107 gPanelChangedB = a;
    ld   (gPanelChangedB), a
    ; city/city2.c:108 
    ; city/city2.c:109 cityPlayerX = a = [mapWidth / 2];
    ld   a, 128
    ld   (cityPlayerX), a
    ; city/city2.c:110 cityScrollX = (a -= [viewWidth / 2]);
    sub  16
    ld   (cityScrollX), a
    ; city/city2.c:111 
    ; city/city2.c:112 // Перерисовать панель    
    ; city/city2.c:113 gDrawPanel();
    call gDrawPanel
    ; city/city2.c:114 
    ; city/city2.c:115 // Инициализация NPC
    ; city/city2.c:116 initNpc();
    call initNpc
    ; city/city2.c:117 
    ; city/city2.c:118 //swapMaps();
    ; city/city2.c:119 
    ; city/city2.c:120 // Инициализация кеша
    ; city/city2.c:121 cityFullRedraw();
    call cityFullRedraw
    ; city/city2.c:122 
    ; city/city2.c:123 // Перерисовать
    ; city/city2.c:124 while()
l2002:
    ; city/city2.c:125 {
    ; city/city2.c:126 gBeginDraw();
    call gBeginDraw
    ; city/city2.c:127 cityDraw();
    call cityDraw
    ; city/city2.c:128 gEndDraw();
    call gEndDraw
    ; city/city2.c:129 
    ; city/city2.c:130 while ((a = gFrame) != *(hl = &processedFrames))
l2004:
    ld   a, (gFrame)
    ld   hl, processedFrames
    cp   (hl)
    jp   z, l2005
    ; city/city2.c:131 {
    ; city/city2.c:132 *hl = a;
    ld   (hl), a
    ; city/city2.c:133 a &= 3;
    and  3
    ; city/city2.c:134 if (flag_z) processPlayer();
    call z, processPlayer
    ; city/city2.c:135 processNpc();
    call processNpc
    ; city/city2.c:136 }
    jp   l2004
l2005:
    ; city/city2.c:137 }
    jp   l2002
l2003:
    ; city/city2.c:138 }
    ret
    ; city/city2.c:139 
    ; city/city2.c:140 void cityInvalidate(hl)
cityInvalidate:
    ; city/city2.c:141 {
    ; city/city2.c:142 de = hl; e++;
    ld   d, h
    ld   e, l
    inc  e
    ; city/city2.c:143 *hl = unusedTailCode;
    ld   (hl), 254
    ; city/city2.c:144 bc = [viewWidth * viewHeight - 1];
    ld   bc, 639
    ; city/city2.c:145 ldir();
    ldir
    ; city/city2.c:146 }
    ret
    ; city/city2.c:147 
    ; city/city2.c:148 //----------------------------------------------------------------------------------------------------------------------
    ; city/city2.c:149 // Инициализация жителей
    ; city/city2.c:150 
    ; city/city2.c:151 void initNpc()
initNpc:
    ; city/city2.c:152 {
    ; city/city2.c:153 ix = &npc;
    ld   ix, npc
    ; city/city2.c:154 de = npc_sizeof;
    ld   de, 4
    ; city/city2.c:155 b = a = npcCount; // Счетчик цикла
    ld   a, (npcCount)
    ld   b, a
    ; city/city2.c:156 do
l2006:
    ; city/city2.c:157 {
    ; city/city2.c:158 a = b;
    ld   a, b
    ; city/city2.c:159 while (a >= npc_defaultSpeed) a -= npc_defaultSpeed;
l2008:
    cp   7
    jp   c, l2009
    sub  7
    jp   l2008
l2009:
    ; city/city2.c:160 a += 1;
    add  1
    ; city/city2.c:161 ix[npc_timer] = a; // Фаза таймера
    ld   (ix + 0), a
    ; city/city2.c:162 
    ; city/city2.c:163 ix[npc_step] = 0;
    ld   (ix + 2), 0
    ; city/city2.c:164 rand();
    call rand
    ; city/city2.c:165 ix[npc_position] = a;
    ld   (ix + 3), a
    ; city/city2.c:166 ix[npc_flags] = (a &= [npc_flags_direction | npc_flags_type]);
    and  3
    ld   (ix + 1), a
    ; city/city2.c:167 ix += de;
    add  ix, de
    ; city/city2.c:168 } while(--b);
    djnz l2006
l2007:
    ; city/city2.c:169 }
    ret
    ; city/city2.c:170 
    ; city/city2.c:171 //----------------------------------------------------------------------------------------------------------------------
    ; city/city2.c:172 // Перемещение и анимация жителей.
    ; city/city2.c:173 
    ; city/city2.c:174 void processNpc()
processNpc:
    ; city/city2.c:175 {
    ; city/city2.c:176 de = npc_sizeof;
    ld   de, 4
    ; city/city2.c:177 hl = &npc;
    ld   hl, npc
    ; city/city2.c:178 b = a = npcCount;
    ld   a, (npcCount)
    ld   b, a
    ; city/city2.c:179 do
l2010:
    ; city/city2.c:180 {
    ; city/city2.c:181 if (flag_z --*hl) // Скорость
    dec  (hl)
    ; city/city2.c:182 {
    jp   nz, l2012
    ; city/city2.c:183 rand();
    call rand
    ; city/city2.c:184 if (flag_z a--) // Внезапная остановка
    dec  a
    ; city/city2.c:185 {
    jp   nz, l2013
    ; city/city2.c:186 //! Не полушаге не останавливать
    ; city/city2.c:187 push(hl);
    push hl
    ; city/city2.c:188 pop(ix);
    pop  ix
    ; city/city2.c:189 //a = ix[npc_spriteType];
    ; city/city2.c:190 //if (a == 1)
    ; city/city2.c:191 //{
    ; city/city2.c:192 *hl = 255;
    ld   (hl), 255
    ; city/city2.c:193 goto continue1;
    jp   continue1
    ; city/city2.c:194 //}
    ; city/city2.c:195 }
    ; city/city2.c:196 
    ; city/city2.c:197 // У всех разная скорость
    ; city/city2.c:198 *hl = (((a = b) &= 7) += npc_defaultSpeed);
l2013:
    ld   a, b
    and  7
    add  7
    ld   (hl), a
    ; city/city2.c:199 
    ; city/city2.c:200 if (flag_z a--) // Внезапный поворот
    dec  a
    ; city/city2.c:201 {
    jp   nz, l2014
    ; city/city2.c:202 hl++;
    inc  hl
    ; city/city2.c:203 a = *hl;
    ld   a, (hl)
    ; city/city2.c:204 a ^= npc_flags_direction;
    xor  1
    ; city/city2.c:205 *hl = a;
    ld   (hl), a
    ; city/city2.c:206 hl--;
    dec  hl
    ; city/city2.c:207 }
    ; city/city2.c:208 
    ; city/city2.c:209 hl++;
l2014:
    inc  hl
    ; city/city2.c:210 if (*hl & npc_flags_direction) // Направление
    bit  0, (hl)
    ; city/city2.c:211 {
    jp   z, l2015
    ; city/city2.c:212 hl++;
    inc  hl
    ; city/city2.c:213 a = *hl;
    ld   a, (hl)
    ; city/city2.c:214 a++;
    inc  a
    ; city/city2.c:215 if (a >= 4) { a = 0; hl++; ++*hl; hl--; }
    cp   4
    jp   c, l2016
    ld   a, 0
    inc  hl
    inc  (hl)
    dec  hl
    ; city/city2.c:216 *hl = a;
l2016:
    ld   (hl), a
    ; city/city2.c:217 }
    ; city/city2.c:218 else
    jp   l2017
l2015:
    ; city/city2.c:219 {
    ; city/city2.c:220 hl++;
    inc  hl
    ; city/city2.c:221 a = *hl;
    ld   a, (hl)
    ; city/city2.c:222 a++;
    inc  a
    ; city/city2.c:223 if (a >= 4) { a = 0; hl++; --*hl; hl--; }
    cp   4
    jp   c, l2018
    ld   a, 0
    inc  hl
    dec  (hl)
    dec  hl
    ; city/city2.c:224 *hl = a;
l2018:
    ld   (hl), a
    ; city/city2.c:225 }
l2017:
    ; city/city2.c:226 hl++; hl++;
    inc  hl
    inc  hl
    ; city/city2.c:227 }
    ; city/city2.c:228 else
    jp   l2019
l2012:
    ; city/city2.c:229 {
    ; city/city2.c:230 continue1:
continue1:
    ; city/city2.c:231 hl += de; // Следующий NPC
    add  hl, de
    ; city/city2.c:232 }
l2019:
    ; city/city2.c:233 } while(flag_nz --b);
    dec  b
    jp   nz, l2010
l2011:
    ; city/city2.c:234 }
    ret
    ; city/city2.c:235 
    ; city/city2.c:236 //----------------------------------------------------------------------------------------------------------------------
    ; city/city2.c:237 // Вход: hl - должно указывать на npc_position
    ; city/city2.c:238 // Выход: hl - адрес спрайта
    ; city/city2.c:239 // Портит: a
    ; city/city2.c:240 
    ; city/city2.c:241 // const int npc_timer      = 0;
    ; city/city2.c:242 // const int npc_direction  = 1;
    ; city/city2.c:243 // const int npc_step       = 2;
    ; city/city2.c:244 // const int npc_position   = 3;
    ; city/city2.c:245 // const int npc_sprite_l   = 4;
    ; city/city2.c:246 // const int npc_sprite_h   = 5;
    ; city/city2.c:247 // const int npc_sizeof     = 6;
    ; city/city2.c:248 
    ; city/city2.c:249 void getNpcSprite(hl)
getNpcSprite:
    ; city/city2.c:250 {
    ; city/city2.c:251 // Вычисление номера спрайта
    ; city/city2.c:252 hl--;
    dec  hl
    ; city/city2.c:253 hl--;
    dec  hl
    ; city/city2.c:254 a = *hl; // npc_direction + npc_type
    ld   a, (hl)
    ; city/city2.c:255 a += a;
    add  a
    ; city/city2.c:256 a += a;
    add  a
    ; city/city2.c:257 hl++;
    inc  hl
    ; city/city2.c:258 a += *hl; // npc_step
    add  (hl)
    ; city/city2.c:259 
    ; city/city2.c:260 // Получение элемента массива
    ; city/city2.c:261 l = ((a += a) += &sprite_citizen);
    add  a
    add  sprite_citizen
    ld   l, a
    ; city/city2.c:262 h = ((a +@= [&sprite_citizen >> 8]) -= l);
    adc  (sprite_citizen) >> (8)
    sub  l
    ld   h, a
    ; city/city2.c:263 a = *hl; hl++; h = *hl; l = a;
    ld   a, (hl)
    inc  hl
    ld   h, (hl)
    ld   l, a
    ; city/city2.c:264 }
    ret
    ; city/city2.c:265 
    ; city/city2.c:266 uint16_t sprite_citizen[16] =
    ; city/city2.c:267 {
    ; city/city2.c:268 &city1s_15, &city1s_16, &city1s_17, &city1s_14,
    ; city/city2.c:269 &city1s_21, &city1s_20, &city1s_19, &city1s_18,
    ; city/city2.c:270 
    ; city/city2.c:271 &city1s_9,  &city1s_8,  &city1s_7,  &city1s_6,
    ; city/city2.c:272 &city1s_10, &city1s_11, &city1s_12, &city1s_13
    ; city/city2.c:273 };
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
    ; city/city2.c:274 
    ; city/city2.c:275 //----------------------------------------------------------------------------------------------------------------------
    ; city/city2.c:276 // Управление игроком и анимация игрока.
    ; city/city2.c:277 
    ; city/city2.c:278 const int sprite_raistlin_left       = &city1s_0;
    ; city/city2.c:279 const int sprite_raistlin_left_step  = &city1s_1;
    ; city/city2.c:280 const int sprite_raistlin_right      = &city1s_3;
    ; city/city2.c:281 const int sprite_raistlin_right_step = &city1s_4;
    ; city/city2.c:282 
    ; city/city2.c:283 void processPlayer()
processPlayer:
    ; city/city2.c:284 {
    ; city/city2.c:285 if (*(hl = &gKeyTrigger) & KEY_MENU)
    ld   hl, gKeyTrigger
    bit  5, (hl)
    ; city/city2.c:286 {
    jp   z, l2020
    ; city/city2.c:287 *hl = 0;
    ld   (hl), 0
    ; city/city2.c:288 // На двух видеостраницах должно быть идентичное изображение, причем активной должна быть вторая видеостраница
    ; city/city2.c:289 hl = &gVideoPage;
    ld   hl, gVideoPage
    ; city/city2.c:290 while ((a = *hl) & 1);
l2021:
    ld   a, (hl)
    bit  0, a
    jp   z, l2022
    jp   l2021
l2022:
    ; city/city2.c:291 if (flag_z a & 8)
    bit  3, a
    ; city/city2.c:292 {
    jp   nz, l2023
    ; city/city2.c:293 gBeginDraw();
    call gBeginDraw
    ; city/city2.c:294 cityDraw();
    call cityDraw
    ; city/city2.c:295 gEndDraw();
    call gEndDraw
    ; city/city2.c:296 hl = &gVideoPage;
    ld   hl, gVideoPage
    ; city/city2.c:297 while ((a = *hl) & 1);
l2024:
    ld   a, (hl)
    bit  0, a
    jp   z, l2025
    jp   l2024
l2025:
    ; city/city2.c:298 }
    ; city/city2.c:299 
    ; city/city2.c:300 // Переход к магазину
    ; city/city2.c:301 gFarCall(iyl = gInventPage, ix = gInvent);
l2023:
    ld   iyl, 6
    ld   ix, 49152
    call gFarCall
    ; city/city2.c:302 
    ; city/city2.c:303 // Копируем панель на вторую страницу
    ; city/city2.c:304 gCopyPanel();
    call gCopyPanel
    ; city/city2.c:305 
    ; city/city2.c:306 // Перерисовать всё
    ; city/city2.c:307 cityInvalidate(hl = cacheAddr1);
    ld   hl, 23296
    call cityInvalidate
    ; city/city2.c:308 cityInvalidate(hl = cacheAddr2);
    ld   hl, 56064
    call cityInvalidate
    ; city/city2.c:309 return;
    ret
    ; city/city2.c:310 }
    ; city/city2.c:311 
    ; city/city2.c:312 b = a = gKeyPressed;
l2020:
    ld   a, (gKeyPressed)
    ld   b, a
    ; city/city2.c:313 c = a = cityPlayerDirection;
    ld   a, (cityPlayerDirection)
    ld   c, a
    ; city/city2.c:314 a = cityPlayerX;
    ld   a, (cityPlayerX)
    ; city/city2.c:315 if (b & KEY_LEFT)
    bit  2, b
    ; city/city2.c:316 {
    jp   z, l2026
    ; city/city2.c:317 if (c & 1)
    bit  0, c
    ; city/city2.c:318 {            
    jp   z, l2027
    ; city/city2.c:319 cityPlayerDirection = (a ^= a);
    xor  a
    ld   (cityPlayerDirection), a
    ; city/city2.c:320 c = a;
    ld   c, a
    ; city/city2.c:321 }
    ; city/city2.c:322 else
    jp   l2028
l2027:
    ; city/city2.c:323 {
    ; city/city2.c:324 a -= 1;
    sub  1
    ; city/city2.c:325 if (flag_nc)
    ; city/city2.c:326 {
    jp   c, l2029
    ; city/city2.c:327 cityPlayerX = a;
    ld   (cityPlayerX), a
    ; city/city2.c:328 
    ; city/city2.c:329 // Прокрутка экрана
    ; city/city2.c:330 a -= [viewWidth / 2]; if (flag_nc) if (a < [mapWidth - viewWidth / 2 * 2 + 1]) { cityScrollX = a; } //! Почему нельзя без {} ?
    sub  16
    jp   c, l2030
    cp   225
    jp   nc, l2031
    ld   (cityScrollX), a
    ; city/city2.c:331 
    ; city/city2.c:332 hl = sprite_raistlin_left;
l2031:
l2030:
    ld   hl, city1s_0
    ; city/city2.c:333 if ((a = cityPlayerSprite) == l) hl = sprite_raistlin_left_step;
    ld   a, (cityPlayerSprite)
    cp   l
    jp   nz, l2032
    ld   hl, city1s_1
    ; city/city2.c:334 cityPlayerSprite = hl;
l2032:
    ld   (cityPlayerSprite), hl
    ; city/city2.c:335 return;
    ret
    ; city/city2.c:336 }
    ; city/city2.c:337 }
l2029:
l2028:
    ; city/city2.c:338 }
    ; city/city2.c:339 else if (b & KEY_RIGHT)
    jp   l2033
l2026:
    bit  3, b
    ; city/city2.c:340 {
    jp   z, l2034
    ; city/city2.c:341 if (flag_z c & 1)
    bit  0, c
    ; city/city2.c:342 {
    jp   nz, l2035
    ; city/city2.c:343 cityPlayerDirection = (a = 1);
    ld   a, 1
    ld   (cityPlayerDirection), a
    ; city/city2.c:344 c = a;
    ld   c, a
    ; city/city2.c:345 }
    ; city/city2.c:346 else
    jp   l2036
l2035:
    ; city/city2.c:347 {
    ; city/city2.c:348 a += 1;
    add  1
    ; city/city2.c:349 if (flag_nc)
    ; city/city2.c:350 {
    jp   c, l2037
    ; city/city2.c:351 cityPlayerX = a;
    ld   (cityPlayerX), a
    ; city/city2.c:352 
    ; city/city2.c:353 // Прокрутка экрана
    ; city/city2.c:354 a -= [viewWidth / 2]; if (flag_nc) if (a < [mapWidth - viewWidth / 2 * 2 + 1]) { cityScrollX = a; }  //! Почему нельзя без {} ?
    sub  16
    jp   c, l2038
    cp   225
    jp   nc, l2039
    ld   (cityScrollX), a
    ; city/city2.c:355 
    ; city/city2.c:356 hl = sprite_raistlin_right;
l2039:
l2038:
    ld   hl, city1s_3
    ; city/city2.c:357 if ((a = cityPlayerSprite) == l) hl = sprite_raistlin_right_step;
    ld   a, (cityPlayerSprite)
    cp   l
    jp   nz, l2040
    ld   hl, city1s_4
    ; city/city2.c:358 cityPlayerSprite = hl;
l2040:
    ld   (cityPlayerSprite), hl
    ; city/city2.c:359 return;
    ret
    ; city/city2.c:360 }
    ; city/city2.c:361 }
l2037:
l2036:
    ; city/city2.c:362 }
    ; city/city2.c:363 
    ; city/city2.c:364 // Убираем анимацию шага, если ни одна клавиша не нажата
    ; city/city2.c:365 hl = sprite_raistlin_left;
l2034:
l2033:
    ld   hl, city1s_0
    ; city/city2.c:366 if (c & 1) hl = sprite_raistlin_right;
    bit  0, c
    jp   z, l2041
    ld   hl, city1s_3
    ; city/city2.c:367 cityPlayerSprite = hl;
l2041:
    ld   (cityPlayerSprite), hl
    ; city/city2.c:368 }
    ret
    ; city/city2.c:369 
    ; city/city2.c:370 //----------------------------------------------------------------------------------------------------------------------
    ; city/city2.c:371 
    ; city/city2.c:372 void cityDraw()
cityDraw:
    ; city/city2.c:373 {
    ; city/city2.c:374 // Оценка времени
    ; city/city2.c:375 //startFrame = a = gFrame;
    ; city/city2.c:376 
    ; city/city2.c:377 // Обновить панель
    ; city/city2.c:378 gPanelRedraw();
    call gPanelRedraw
    ; city/city2.c:379 
    ; city/city2.c:380 // Адрес карты / и сточник
    ; city/city2.c:381 d` = [&city1Map >> 8];
    ld   d, (city1Map) >> (8)
    ; city/city2.c:382 e` = a = cityScrollX;
    ld   a, (cityScrollX)
    ld   e, a
    ; city/city2.c:383 b` = e`;
    ld   b, e
    ; city/city2.c:384 
    ; city/city2.c:385 // Адрес видеостраницы / назначение
    ; city/city2.c:386 if (flag_z (a = gVideoPage) &= 0x80)
    ld   a, (gVideoPage)
    and  128
    ; city/city2.c:387 {
    jp   nz, l2042
    ; city/city2.c:388 hl` = [cacheAddr1 - 1];
    ld   hl, 23295
    ; city/city2.c:389 ex(bc, de, hl);
    exx
    ; city/city2.c:390 de = screenAddr1;
    ld   de, 16384
    ; city/city2.c:391 bc = screenAttrAddr1;
    ld   bc, 22528
    ; city/city2.c:392 }
    ; city/city2.c:393 else
    jp   l2043
l2042:
    ; city/city2.c:394 {
    ; city/city2.c:395 hl` = [cacheAddr2 - 1];
    ld   hl, 56063
    ; city/city2.c:396 ex(bc, de, hl);
    exx
    ; city/city2.c:397 de = screenAddr2;
    ld   de, 49152
    ; city/city2.c:398 bc = screenAttrAddr2;
    ld   bc, 55296
    ; city/city2.c:399 }
l2043:
    ; city/city2.c:400 
    ; city/city2.c:401 // Цикл строк
    ; city/city2.c:402 ixh = viewHeight;
    ld   ixh, 20
    ; city/city2.c:403 do
l2044:
    ; city/city2.c:404 {
    ; city/city2.c:405 // Сохранение адреса вывода
    ; city/city2.c:406 iy = de;
    ld   iyh, d
    ld   iyl, e
    ; city/city2.c:407 
    ; city/city2.c:408 // Цикл стобцов
    ; city/city2.c:409 ixl = viewWidth;
    ld   ixl, 32
    ; city/city2.c:410 do
l2046:
    ; city/city2.c:411 {
    ; city/city2.c:412 optimize0:  // Чтение номера тейла из карты уровня
optimize0:
    ; city/city2.c:413 ex(bc, de, hl);
    exx
    ; city/city2.c:414 hl`++;
    inc  hl
    ; city/city2.c:415 c` = *hl;
    ld   c, (hl)
    ; city/city2.c:416 a = *de`;
    ld   a, (de)
    ; city/city2.c:417 if (a == c`) goto optimize1;
    cp   c
    jp   z, optimize1
    ; city/city2.c:418 if (flag_z c`++) goto optimize3;
    inc  c
    jp   z, optimize3
    ; city/city2.c:419 e`++;
    inc  e
    ; city/city2.c:420 *hl` = a;
    ld   (hl), a
    ; city/city2.c:421 ex(bc, de, hl);
    exx
    ; city/city2.c:422 
    ; city/city2.c:423 // Вычисление адреса тейла
    ; city/city2.c:424 h = [&city1Tails >> 8];
    ld   h, (city1Tails) >> (8)
    ; city/city2.c:425 l = a;
    ld   l, a
    ; city/city2.c:426 
    ; city/city2.c:427 // Вывод на экран
    ; city/city2.c:428 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; city/city2.c:429 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; city/city2.c:430 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; city/city2.c:431 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; city/city2.c:432 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; city/city2.c:433 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; city/city2.c:434 a = *hl; h++; *de = a; d++;
    ld   a, (hl)
    inc  h
    ld   (de), a
    inc  d
    ; city/city2.c:435 a = *hl; h++; *de = a;
    ld   a, (hl)
    inc  h
    ld   (de), a
    ; city/city2.c:436 a = *hl;      *bc = a; bc++;
    ld   a, (hl)
    ld   (bc), a
    inc  bc
    ; city/city2.c:437 
    ; city/city2.c:438 d = iyh;
    ld   d, iyh
    ; city/city2.c:439 e++;
    inc  e
    ; city/city2.c:440 ixl--;
    dec  ixl
    ; city/city2.c:441 } while(flag_nz);
    jp   nz, l2046
l2047:
    ; city/city2.c:442 optimize2:
optimize2:
    ; city/city2.c:443 
    ; city/city2.c:444 // Следующая строка карты
    ; city/city2.c:445 ex(bc, de, hl);
    exx
    ; city/city2.c:446 e` = b`;
    ld   e, b
    ; city/city2.c:447 d`++;
    inc  d
    ; city/city2.c:448 ex(bc, de, hl);
    exx
    ; city/city2.c:449 
    ; city/city2.c:450 // Адрес следующей чб строки на экране
    ; city/city2.c:451 e = ((a = iyl) += 0x20);
    ld   a, iyl
    add  32
    ld   e, a
    ; city/city2.c:452 if (flag_c) d = ((a = d) += 0x08);
    jp   nc, l2048
    ld   a, d
    add  8
    ld   d, a
    ; city/city2.c:453 
    ; city/city2.c:454 ixh--;
l2048:
    dec  ixh
    ; city/city2.c:455 } while(flag_nz);
    jp   nz, l2044
l2045:
    ; city/city2.c:456 
    ; city/city2.c:457 drawSprites();
    call drawSprites
    ; city/city2.c:458 
    ; city/city2.c:459 // Оценка времени
    ; city/city2.c:460 //printDelay((a = gFrame) -= *(hl = &startFrame));
    ; city/city2.c:461 
    ; city/city2.c:462 return;
    ret
    ; city/city2.c:463 optimize3:
optimize3:
    ; city/city2.c:464 *hl` = a = 254;
    ld   a, 254
    ld   (hl), a
    ; city/city2.c:465 optimize1:
optimize1:
    ; city/city2.c:466 e`++;
    inc  e
    ; city/city2.c:467 ex(bc, de, hl);
    exx
    ; city/city2.c:468 bc++;
    inc  bc
    ; city/city2.c:469 e++;
    inc  e
    ; city/city2.c:470 ixl--;
    dec  ixl
    ; city/city2.c:471 if(flag_nz) goto optimize0;
    jp   nz, optimize0
    ; city/city2.c:472 goto optimize2;
    jp   optimize2
    ; city/city2.c:473 }
    ret
    ; city/city2.c:474 
    ; city/city2.c:475 void drawSprites()
drawSprites:
    ; city/city2.c:476 {
    ; city/city2.c:477 a = gVideoPage;
    ld   a, (gVideoPage)
    ; city/city2.c:478 if (a & 8) ixh = [screenAddr1 >> 8];
    bit  3, a
    jp   z, l2049
    ld   ixh, 64
    ; city/city2.c:479 else ixh = [screenAddr2 >> 8];
    jp   l2050
l2049:
    ld   ixh, 192
l2050:
    ; city/city2.c:480 
    ; city/city2.c:481 // const int npc_timer      = 0;
    ; city/city2.c:482 // const int npc_direction  = 1;
    ; city/city2.c:483 // const int npc_step       = 2;
    ; city/city2.c:484 // const int npc_position   = 3;
    ; city/city2.c:485 // const int npc_sprite_l   = 4;
    ; city/city2.c:486 // const int npc_sprite_h   = 5;
    ; city/city2.c:487 // const int npc_sizeof     = 6;
    ; city/city2.c:488 
    ; city/city2.c:489 // Спрайты
    ; city/city2.c:490 hl = [&npc + npc_position];
    ld   hl, (npc) + (3)
    ; city/city2.c:491 b = a = npcCount;
    ld   a, (npcCount)
    ld   b, a
    ; city/city2.c:492 c = (a = cityScrollX); c--;
    ld   a, (cityScrollX)
    ld   c, a
    dec  c
    ; city/city2.c:493 de = npc_sizeof;
    ld   de, 4
    ; city/city2.c:494 do
l2051:
    ; city/city2.c:495 {
    ; city/city2.c:496 // Если спрайт за экраном, то не рисуем его
    ; city/city2.c:497 if (((a = *hl) -= c) < [viewWidth + 1]) //! для const int можно <=
    ld   a, (hl)
    sub  c
    cp   33
    ; city/city2.c:498 {
    jp   nc, l2053
    ; city/city2.c:499 push(bc, de, hl)
    ; city/city2.c:500 {
    push bc
    push de
    push hl
    ; city/city2.c:501 c = --a; // Для drawSprite
    dec  a
    ld   c, a
    ; city/city2.c:502 
    ; city/city2.c:503 // Цвет {
    ; city/city2.c:504 a = b;
    ld   a, b
    ; city/city2.c:505 while(a >= 14) a -= 14;
l2054:
    cp   14
    jp   c, l2055
    sub  14
    jp   l2054
l2055:
    ; city/city2.c:506 if (a >= 7) a += [0x40 - 7]; a++;
    cp   7
    jp   c, l2056
    add  57
l2056:
    inc  a
    ; city/city2.c:507 iyh = a;
    ld   iyh, a
    ; city/city2.c:508 // }
    ; city/city2.c:509 
    ; city/city2.c:510 getNpcSprite(hl);
    call getNpcSprite
    ; city/city2.c:511 b = cityRoadY;
    ld   b, 13
    ; city/city2.c:512 drawSprite();
    call drawSprite
    ; city/city2.c:513 }
    pop  hl
    pop  de
    pop  bc
    ; city/city2.c:514 }
    ; city/city2.c:515 hl += de;
l2053:
    add  hl, de
    ; city/city2.c:516 } while(--b);
    djnz l2051
l2052:
    ; city/city2.c:517 
    ; city/city2.c:518 // Рисование игрока
    ; city/city2.c:519 b = cityRoadY;
    ld   b, 13
    ; city/city2.c:520 c++;
    inc  c
    ; city/city2.c:521 c = ((a = cityPlayerX) -= c);
    ld   a, (cityPlayerX)
    sub  c
    ld   c, a
    ; city/city2.c:522 hl = cityPlayerSprite;
    ld   hl, (cityPlayerSprite)
    ; city/city2.c:523 if ((a = l) == &city1s_1) c--;
    ld   a, l
    cp   city1s_1
    jp   nz, l2057
    dec  c
    ; city/city2.c:524 iyh = 0;
l2057:
    ld   iyh, 0
    ; city/city2.c:525 drawSprite(bc, de, hl);
    call drawSprite
    ; city/city2.c:526 }
    ret
    ; city/city2.c:527 
    ; city/city2.c:528 // Вывод спрайта
    ; city/city2.c:529 // c - координата X (от -1 до 31)
    ; city/city2.c:530 // b - координата Y (от 0 до 23)
    ; city/city2.c:531 // hl - спрайт
    ; city/city2.c:532 
    ; city/city2.c:533 void drawSprite(bc, hl, ixh, iyh)
drawSprite:
    ; city/city2.c:534 {
    ; city/city2.c:535 // Читаем ширину спрайта
    ; city/city2.c:536 d = *hl; l++;
    ld   d, (hl)
    inc  l
    ; city/city2.c:537 
    ; city/city2.c:538 // Если спрайт за левым краем экрана
    ; city/city2.c:539 if (c & 0x80) //! Можно оптимизировать
    bit  7, c
    ; city/city2.c:540 do
    jp   z, l2058
l2059:
    ; city/city2.c:541 {
    ; city/city2.c:542 l = ((a = l) += [4 * 9]);
    ld   a, l
    add  36
    ld   l, a
    ; city/city2.c:543 c++;
    inc  c
    ; city/city2.c:544 d--;
    dec  d
    ; city/city2.c:545 if (flag_z) return;
    ret  z
    ; city/city2.c:546 } while (c & 0x80);
    bit  7, c
    jp   nz, l2059
l2060:
    ; city/city2.c:547 
    ; city/city2.c:548 // Если спрайт за правым краем экрана
    ; city/city2.c:549 (a = viewWidth) -= c;
l2058:
    ld   a, 32
    sub  c
    ; city/city2.c:550 if (flag_c) return;
    ret  c
    ; city/city2.c:551 if (flag_z) return;
    ret  z
    ; city/city2.c:552 if (a < d) d = a;
    cp   d
    jp   nc, l2061
    ld   d, a
    ; city/city2.c:553 iyl = d;
l2061:
    ld   iyl, d
    ; city/city2.c:554 
    ; city/city2.c:555 // Вычисление координаты
    ; city/city2.c:556 //       43210    43210
    ; city/city2.c:557 // de .1.43... 210.....
    ; city/city2.c:558 // bc .1.11.43 210.....
    ; city/city2.c:559 d = (((a = b) &= 0x18) |= ixh);
    ld   a, b
    and  24
    or   ixh
    ld   d, a
    ; city/city2.c:560 a = b;
    ld   a, b
    ; city/city2.c:561 a >>r= 3;
    rrca
    rrca
    rrca
    ; city/city2.c:562 b = a;
    ld   b, a
    ; city/city2.c:563 c = e = ((a &= 0xE0) |= c);
    and  224
    or   c
    ld   e, a
    ld   c, e
    ; city/city2.c:564 b = ((((a = b) &= 0x03) |= 0x18) |= ixh);
    ld   a, b
    and  3
    or   24
    or   ixh
    ld   b, a
    ; city/city2.c:565 
    ; city/city2.c:566 while()
l2062:
    ; city/city2.c:567 {
    ; city/city2.c:568 push(bc, de)
    ; city/city2.c:569 {
    push bc
    push de
    ; city/city2.c:570 drawSprite1(bc, de, hl);
    call drawSprite1
    ; city/city2.c:571 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; city/city2.c:572 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2064
    ld   a, d
    add  8
    ld   d, a
    ; city/city2.c:573 drawSprite1(bc, de, hl);
l2064:
    call drawSprite1
    ; city/city2.c:574 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; city/city2.c:575 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2065
    ld   a, d
    add  8
    ld   d, a
    ; city/city2.c:576 drawSprite1(bc, de, hl);
l2065:
    call drawSprite1
    ; city/city2.c:577 c = ((a = c) += 32); b = ((a +@= b) -= c); // 27
    ld   a, c
    add  32
    ld   c, a
    adc  b
    sub  c
    ld   b, a
    ; city/city2.c:578 e = ((a = e) += 32); if (flag_c) d = ((a = d) += 0x08); // 25
    ld   a, e
    add  32
    ld   e, a
    jp   nc, l2066
    ld   a, d
    add  8
    ld   d, a
    ; city/city2.c:579 drawSprite1(bc, de, hl);
l2066:
    call drawSprite1
    ; city/city2.c:580 }
    pop  de
    pop  bc
    ; city/city2.c:581 iyl--;
    dec  iyl
    ; city/city2.c:582 if (flag_z) return;
    ret  z
    ; city/city2.c:583 c++;
    inc  c
    ; city/city2.c:584 e++;
    inc  e
    ; city/city2.c:585 };
    jp   l2062
l2063:
    ; city/city2.c:586 }
    ret
    ; city/city2.c:587 
    ; city/city2.c:588 void drawSprite1(de, bc, hl)
drawSprite1:
    ; city/city2.c:589 {
    ; city/city2.c:590 ixl = d;
    ld   ixl, d
    ; city/city2.c:591 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; city/city2.c:592 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; city/city2.c:593 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; city/city2.c:594 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; city/city2.c:595 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; city/city2.c:596 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; city/city2.c:597 *de = ((a = *de) |= *hl); l++; d++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    inc  d
    ; city/city2.c:598 *de = ((a = *de) |= *hl); l++;
    ld   a, (de)
    or   (hl)
    ld   (de), a
    inc  l
    ; city/city2.c:599 a = *hl; if (a == 0x45) a = iyh; *bc = a; l++;
    ld   a, (hl)
    cp   69
    jp   nz, l2067
    ld   a, iyh
l2067:
    ld   (bc), a
    inc  l
    ; city/city2.c:600 d = b; b++; b++; b++; *bc = a = 0xFE; b = d;
    ld   d, b
    inc  b
    inc  b
    inc  b
    ld   a, 254
    ld   (bc), a
    ld   b, d
    ; city/city2.c:601 
    ; city/city2.c:602 // *de = a = *hl; l++; d++;
    ; city/city2.c:603 // *de = a = *hl; l++; d++;
    ; city/city2.c:604 // *de = a = *hl; l++; d++;
    ; city/city2.c:605 // *de = a = *hl; l++; d++;
    ; city/city2.c:606 // *de = a = *hl; l++; d++;
    ; city/city2.c:607 // *de = a = *hl; l++; d++;
    ; city/city2.c:608 // *de = a = *hl; l++; d++;
    ; city/city2.c:609 // *de = a = *hl; l++;
    ; city/city2.c:610 // *bc = a = *hl; l++;
    ; city/city2.c:611 // d = b; b++; b++; b++; *bc = a = 0xFF; b = d;
    ; city/city2.c:612 
    ; city/city2.c:613 d = ixl;
    ld   d, ixl
    ; city/city2.c:614 }
    ret
    ; city/city2.c:615 
    ; city/city2.c:616 /*
    ; city/city2.c:637 
