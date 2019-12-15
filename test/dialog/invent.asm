    ; 3 const int KEY_UP = 1;
    ; 4 const int KEY_DOWN = 2;
    ; 5 const int KEY_LEFT = 4;
    ; 6 const int KEY_RIGHT = 8;
    ; 7 const int KEY_FIRE = 16;
    ; 9 const int secondWeaponBwAddrForPict = 0x4042;
    ; 10 const int secondWeaponClAddrForPict = 0x5842;
    ; 11 const int secondWeaponCount = 9;
    ; 12 const int secondWeaponTextPos = 35 * 256 + 19;
    ; 13 const int secondWeaponTextInactiveColor = 0x41;
    ; 14 const int secondWeaponTextActiveColor = 0x47;
    ; 15 const int itemsPos = 7 * 8 * 256 + 16;
    ; 16 const int itemsCursorPos = 7 * 8 * 256 + 9;
    ; 17 const int itemsCursorColor = 0x43;
    ; 18 const int lutPos = 7 * 8 * 256 + 144;
    ; 20 uint8_t secondWeapon = 4;
secondWeapon db 4
    ; 21 uint8_t selectedItem = 0;
selectedItem db 0
    ; 23 void invent()
invent:
    ; 24 {
    ; 25 gBeginDraw();
    call gBeginDraw
    ; 27 // Очистка экрана
    ; 28 hl = 0x4000;
    ld   hl, 16384
    ; 29 *hl = l;
    ld   (hl), l
    ; 30 ldir(hl, de = 0x4001, bc = [32 * 64 * 2 + 32 * 4 - 1]);
    ld   de, 16385
    ld   bc, 4223
    ldir
    ; 31 a = 7;
    ld   a, 7
    ; 32 do
l16000:
    ; 33 {
    ; 34 (hl = [32 * 4]) += de;
    ld   hl, 128
    add  hl, de
    ; 35 ex(hl, de);
    ex de, hl
    ; 36 ldir(hl = 0x4000, de, bc = [32 * 4]);
    ld   hl, 16384
    ld   bc, 128
    ldir
    ; 37 } while(flag_nz --a);
    dec  a
    jp   nz, l16000
l16001:
    ; 39 // Заливаем одним цветом
    ; 40 hl = 0x5800;
    ld   hl, 22528
    ; 41 *hl = 0x44;
    ld   (hl), 68
    ; 42 ldir(hl, de = 0x5801, bc = [32 * 20 - 1]);
    ld   de, 22529
    ld   bc, 639
    ldir
    ; 44 // Рисуем
    ; 45 bc = 0x4000;
    ld   bc, 16384
    ; 46 de = &inventgraphMap;
    ld   de, inventgraphMap
    ; 47 while()
l16002:
    ; 48 {
    ; 49 inventBlank2:
inventBlank2:
    ; 50 a = *de; de++;
    ld   a, (de)
    inc  de
    ; 51 if (a >= 128)
    cp   128
    ; 52 {
    jp   c, l16004
    ; 53 if (flag_z) break;
    jp   z, l16003
    ; 54 a -= 128;
    sub  128
    ; 55 c = (a += c);
    add  c
    ld   c, a
    ; 56 if (flag_c) b = ((a = b) += 8);
    jp   nc, l16005
    ld   a, b
    add  8
    ld   b, a
    ; 57 continue;
l16005:
    jp l16002
    ; 58 }
    ; 59 // Вычисление адреса
    ; 60 a += a += a;
l16004:
    add  a
    add  a
    ; 61 l = (a += [&inventgraphTails >> 1]);
    add  (inventgraphTails) >> (1)
    ld   l, a
    ; 62 h = ((a +@= [&inventgraphTails >> 9]) -= l);
    adc  (inventgraphTails) >> (9)
    sub  l
    ld   h, a
    ; 63 hl += hl;
    add  hl, hl
    ; 64 // Запись
    ; 65 *bc = a = *hl; l++; b++; // Тайлы не пересекают 256-байтную страницу
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; 66 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; 67 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; 68 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; 69 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; 70 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; 71 *bc = a = *hl; l++; b++;
    ld   a, (hl)
    ld   (bc), a
    inc  l
    inc  b
    ; 72 *bc = a = *hl;
    ld   a, (hl)
    ld   (bc), a
    ; 73 // Следующий адрес
    ; 74 b = ((a = b) -= 7);
    ld   a, b
    sub  7
    ld   b, a
    ; 75 c++;
    inc  c
    ; 76 if (flag_z) b = ((a = b) += 8);
    jp   nz, l16006
    ld   a, b
    add  8
    ld   b, a
    ; 77 }
l16006:
    jp   l16002
l16003:
    ; 79 // Пиктограммы второго оружия
    ; 80 bc = secondWeaponBwAddrForPict; //0x4042;
    ld   bc, 16450
    ; 81 hl = secondWeaponClAddrForPict; //0x5842;
    ld   hl, 22594
    ; 82 d = 0;
    ld   d, 0
    ; 83 do
l16007:
    ; 84 {
    ; 85 push(bc, de)
    ; 86 {
    push bc
    push de
    ; 87 push(hl)
    ; 88 {
    push hl
    ; 89 h = 0; l = d;
    ld   h, 0
    ld   l, d
    ; 90 hl += hl += hl; de = hl; (hl += hl += hl += hl) += de; hl += (de = &magic_0); ex(hl, de); // *36
    add  hl, hl
    add  hl, hl
    ld   d, h
    ld   e, l
    add  hl, hl
    add  hl, hl
    add  hl, hl
    add  hl, de
    ld   de, magic_0
    add  hl, de
    ex de, hl
    ; 91 }
    pop  hl
    ; 92 push(hl)
    ; 93 {
    push hl
    ; 94 drawSprite4(bc, hl, de);
    call drawSprite4
    ; 95 }
    pop  hl
    ; 96 }
    pop  de
    pop  bc
    ; 97 l = ((a = l) += 3); c = l;
    ld   a, l
    add  3
    ld   l, a
    ld   c, l
    ; 98 d++;
    inc  d
    ; 99 } while((a = d) < secondWeaponCount);
    ld   a, d
    cp   9
    jp   c, l16007
l16008:
    ; 101 // Кол-во второго оружия
    ; 102 b = secondWeaponCount;
    ld   b, 9
    ; 103 hl = secondWeaponTextPos;
    ld   hl, 8979
    ; 104 do
l16009:
    ; 105 {
    ; 106 push(bc, hl)
    ; 107 {
    push bc
    push hl
    ; 108 gDrawTextEx(hl, de = "\x1F\x1F\x02", a = secondWeaponTextInactiveColor);
    ld   de, s16000
    ld   a, 65
    call gDrawTextEx
    ; 109 }
    pop  hl
    pop  bc
    ; 110 l = ((a = l) += 24);
    ld   a, l
    add  24
    ld   l, a
    ; 111 } while(--b);
    djnz l16009
l16010:
    ; 113 // Предметы
    ; 114 b = 5;
    ld   b, 5
    ; 115 hl = itemsPos;
    ld   hl, 14352
    ; 116 do
l16011:
    ; 117 {
    ; 118 ex(hl, de);
    ex de, hl
    ; 119 getItemOfArray16(hl = &itemNames, --(a = b));
    ld   hl, itemNames
    ld   a, b
    dec  a
    call getItemOfArray16
    ; 120 ex(hl, de);
    ex de, hl
    ; 121 push(bc, hl)
    ; 122 {
    push bc
    push hl
    ; 123 gDrawTextEx(hl, de, a = secondWeaponTextActiveColor);
    ld   a, 71
    call gDrawTextEx
    ; 124 }
    pop  hl
    pop  bc
    ; 125 h = ((a = h) += 10);
    ld   a, h
    add  10
    ld   h, a
    ; 126 } while(--b);
    djnz l16011
l16012:
    ; 128 // ЛУТ
    ; 129 b = 9;
    ld   b, 9
    ; 130 hl = lutPos;
    ld   hl, 14480
    ; 131 do
l16013:
    ; 132 {
    ; 133 ex(hl, de);
    ex de, hl
    ; 134 getItemOfArray16(hl = &lutNames, --(a = b));
    ld   hl, lutNames
    ld   a, b
    dec  a
    call getItemOfArray16
    ; 135 ex(hl, de);
    ex de, hl
    ; 136 push(bc, hl)
    ; 137 {
    push bc
    push hl
    ; 138 gDrawTextEx(hl, de, a = 0x47);
    ld   a, 71
    call gDrawTextEx
    ; 139 }
    pop  hl
    pop  bc
    ; 140 push(bc, hl)
    ; 141 {
    push bc
    push hl
    ; 142 push(hl)
    ; 143 {
    push hl
    ; 144 gMeasureText(de = "99"); // Вход: de - текст. Выход: de - текст, a - терминатор, c - ширина в пикселях. Портит: b, hl.
    ld   de, s16001
    call gMeasureText
    ; 145 }
    pop  hl
    ; 146 l = ((a = 248) -= c);
    ld   a, 248
    sub  c
    ld   l, a
    ; 147 gDrawTextEx(hl, de = "99", a = 0x47);
    ld   de, s16001
    ld   a, 71
    call gDrawTextEx
    ; 148 }
    pop  hl
    pop  bc
    ; 149 h = ((a = h) += 10);
    ld   a, h
    add  10
    ld   h, a
    ; 150 } while(--b);
    djnz l16013
l16014:
    ; 152 // Основное оружие
    ; 153 drawSprite4(hl = 0x59E1, bc = 0x48E1, de = [&magic_0 + 36]);
    ld   hl, 23009
    ld   bc, 18657
    ld   de, (magic_0) + (36)
    call drawSprite4
    ; 154 gDrawTextEx(hl = [15 * 8 * 256 + 28], de = "Обычное оружие", a = 0x47);
    ld   hl, 30748
    ld   de, s16002
    ld   a, 71
    call gDrawTextEx
    ; 155 gDrawTextEx(hl = [(15 * 8 + 9) * 256 + 28], de = "\x16\x17\x18\x15\x19\x1A\x1B\x02", a = 0x46);
    ld   hl, 33052
    ld   de, s16003
    ld   a, 70
    call gDrawTextEx
    ; 157 // Защита
    ; 158 drawSprite4(hl = 0x5A21, bc = 0x5021, de = [&magic_0 + 36 * 3]);
    ld   hl, 23073
    ld   bc, 20513
    ld   de, (magic_0) + (108)
    call drawSprite4
    ; 159 gDrawTextEx(hl = [17 * 8 * 256 + 28], de = "Обычная защита", a = 0x47);
    ld   hl, 34844
    ld   de, s16004
    ld   a, 71
    call gDrawTextEx
    ; 160 gDrawTextEx(hl = [(17 * 8 + 9) * 256 + 28], de = "\x1A\x1B\x1C\x15\x1D\x1E\x1F\x02", a = 0x46);
    ld   hl, 37148
    ld   de, s16005
    ld   a, 70
    call gDrawTextEx
    ; 162 // Ключ
    ; 163 drawSprite4(hl = 0x5A2E, bc = 0x502E, de = [&magic_0 + 36 * 9]);
    ld   hl, 23086
    ld   bc, 20526
    ld   de, (magic_0) + (324)
    call drawSprite4
    ; 165 drawSecondWeaponCursor(ixh = 0x47);
    ld   ixh, 71
    call drawSecondWeaponCursor
    ; 167 drawItemCursor();
    call drawItemCursor
    ; 169 gEndDraw();
    call gEndDraw
    ; 171 while()
l16015:
    ; 172 {
    ; 173 hl = &gKeyTrigger;
    ld   hl, gKeyTrigger
    ; 174 a = *hl;
    ld   a, (hl)
    ; 175 *hl = 0;
    ld   (hl), 0
    ; 176 if (a & KEY_LEFT)
    bit  2, a
    ; 177 {
    jp   z, l16017
    ; 178 a = secondWeapon;
    ld   a, (secondWeapon)
    ; 179 a-=1;
    sub  1
    ; 180 if (flag_c) continue;
    jp   c, l16015
    ; 181 setSecondWeapon(a);
    call setSecondWeapon
    ; 182 }
    ; 183 else if (a & KEY_RIGHT)
    jp   l16018
l16017:
    bit  3, a
    ; 184 {
    jp   z, l16019
    ; 185 a = secondWeapon;
    ld   a, (secondWeapon)
    ; 186 a++;
    inc  a
    ; 187 if (a >= secondWeaponCount) continue;
    cp   9
    jp   nc, l16015
    ; 188 setSecondWeapon(a);
    call setSecondWeapon
    ; 189 }
    ; 190 else if (a & KEY_UP)
    jp   l16020
l16019:
    bit  0, a
    ; 191 {
    jp   z, l16021
    ; 192 a = selectedItem;
    ld   a, (selectedItem)
    ; 193 a-=1;
    sub  1
    ; 194 if (flag_c) continue;
    jp   c, l16015
    ; 195 selectItem(a);
    call selectItem
    ; 196 }
    ; 197 else if (a & KEY_DOWN)
    jp   l16022
l16021:
    bit  1, a
    ; 198 {
    jp   z, l16023
    ; 199 a = selectedItem;
    ld   a, (selectedItem)
    ; 200 a++;
    inc  a
    ; 201 if (a >= 5) continue; //*(hl = &gPlayerItemsCount)) continue;
    cp   5
    jp   nc, l16015
    ; 202 selectItem(a);
    call selectItem
    ; 203 }
    ; 204 }
l16023:
l16022:
l16020:
l16018:
    jp   l16015
l16016:
    ; 205 }
    ret
    ; 207 void drawItemCursor(de)
drawItemCursor:
    ; 208 {
    ; 209 a = selectedItem;
    ld   a, (selectedItem)
    ; 210 a += a; b = a; (a += a += a) += b; // *10
    add  a
    ld   b, a
    add  a
    add  a
    add  b
    ; 211 hl = itemsCursorPos; h = (a += h);
    ld   hl, 14345
    add  h
    ld   h, a
    ; 212 gDrawTextEx(hl, de = "@", a = itemsCursorColor);
    ld   de, s16006
    ld   a, 67
    call gDrawTextEx
    ; 213 }
    ret
    ; 215 void selectItem()
selectItem:
    ; 216 {
    ; 217 push(a)
    ; 218 {
    push af
    ; 219 drawItemCursor();
    call drawItemCursor
    ; 220 }
    pop  af
    ; 221 selectedItem = a;
    ld   (selectedItem), a
    ; 222 drawItemCursor();
    call drawItemCursor
    ; 223 }
    ret
    ; 225 void setSecondWeapon(a)
setSecondWeapon:
    ; 226 {
    ; 227 push(a)
    ; 228 {
    push af
    ; 229 drawSecondWeaponCursor(ixh = secondWeaponTextInactiveColor);
    ld   ixh, 65
    call drawSecondWeaponCursor
    ; 230 }
    pop  af
    ; 231 secondWeapon = a;
    ld   (secondWeapon), a
    ; 232 drawSecondWeaponCursor(ixh = secondWeaponTextActiveColor);
    ld   ixh, 71
    call drawSecondWeaponCursor
    ; 234 return panelDrawSecondWeapon();
    jp   panelDrawSecondWeapon
    ; 235 }
    ret
    ; 237 void drawSecondWeaponCursor(ixh)
drawSecondWeaponCursor:
    ; 238 {
    ; 239 // Курсор
    ; 240 a = secondWeapon;
    ld   a, (secondWeapon)
    ; 241 b = a; (a += a) += b;
    ld   b, a
    add  a
    add  b
    ; 242 hl = [secondWeaponBwAddrForPict - 0x21]; l = (a += l);
    ld   hl, 16417
    add  l
    ld   l, a
    ; 243 b = [(secondWeaponClAddrForPict - 0x21) >> 8]; c = l;
    ld   b, 88
    ld   c, l
    ; 244 de = &magic_10;
    ld   de, magic_10
    ; 245 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; 246 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; 247 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; 248 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; 249 ixl = 2;
    ld   ixl, 2
    ; 250 do
l16024:
    ; 251 {
    ; 252 l = ((a = l) += [0x20 - 4]); c = l;
    ld   a, l
    add  28
    ld   l, a
    ld   c, l
    ; 253 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; 254 l++; l++; c = l;
    inc  l
    inc  l
    ld   c, l
    ; 255 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; 256 } while (flag_nz --ixl);
    dec  ixl
    jp   nz, l16024
l16025:
    ; 257 l = ((a = l) += [0x20 - 4]); c = l;
    ld   a, l
    add  28
    ld   l, a
    ld   c, l
    ; 258 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; 259 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; 260 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; 261 drawSpriteXor(bc, hl, de);
    call drawSpriteXor
    ; 262 }
    ret
    ; strings
s16003 db 22,23,24,21,25,26,27,2,0
s16005 db 26,27,28,21,29,30,31,2,0
s16000 db 31,31,2,0
s16001 db "99",0
s16006 db "@",0
s16004 db "Обычная защита",0
s16002 db "Обычное оружие",0
