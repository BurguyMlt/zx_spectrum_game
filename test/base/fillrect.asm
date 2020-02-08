    ; base/fillrect.c:2 
    ; base/fillrect.c:3 void fillRect(hl, bc)
fillRect:
    ; base/fillrect.c:4 {
    ; base/fillrect.c:5 ixl = b;
    ld   ixl, b
    ; base/fillrect.c:6 do
l3000:
    ; base/fillrect.c:7 {
    ; base/fillrect.c:8 a ^= a;
    xor  a
    ; base/fillrect.c:9 d = h; e = l;
    ld   d, h
    ld   e, l
    ; base/fillrect.c:10 b = c;
    ld   b, c
    ; base/fillrect.c:11 do
l3002:
    ; base/fillrect.c:12 {
    ; base/fillrect.c:13 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/fillrect.c:14 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/fillrect.c:15 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/fillrect.c:16 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/fillrect.c:17 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/fillrect.c:18 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/fillrect.c:19 *hl = a; h++;
    ld   (hl), a
    inc  h
    ; base/fillrect.c:20 *hl = a; h = d;
    ld   (hl), a
    ld   h, d
    ; base/fillrect.c:21 l++;
    inc  l
    ; base/fillrect.c:22 } while(--b);
    djnz l3002
l3003:
    ; base/fillrect.c:23 
    ; base/fillrect.c:24 // Адрес следующей строки
    ; base/fillrect.c:25 l = ((a = e) += 32);
    ld   a, e
    add  32
    ld   l, a
    ; base/fillrect.c:26 if (flag_c) h = ((a = h) += 8);
    jp   nc, l3004
    ld   a, h
    add  8
    ld   h, a
    ; base/fillrect.c:27 } while(flag_nz --ixl);
l3004:
    dec  ixl
    jp   nz, l3000
l3001:
    ; base/fillrect.c:28 }
    ret
    ; base/fillrect.c:29 
