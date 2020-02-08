    ; dialog/descr.c:2 
    ; dialog/descr.c:3 #include "common.h"
    ; dialog/descr.c:4 
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
    ; dialog/descr.c:5 uint16_t itemNames[itemsCount] = {
    ; dialog/descr.c:6 "Отвар листьев",
    ; dialog/descr.c:7 "Полное исцеление",
    ; dialog/descr.c:8 "Заклинание 1",
    ; dialog/descr.c:9 "Магические силы",
    ; dialog/descr.c:10 "Каменная кожа",
    ; dialog/descr.c:11 "Огонь бездны",
    ; dialog/descr.c:12 "Порча",
    ; dialog/descr.c:13 "Телепортация"
    ; dialog/descr.c:14 };
itemNames:
    dw s22000
    dw s22001
    dw s22002
    dw s22003
    dw s22004
    dw s22005
    dw s22006
    dw s22007
    ; dialog/descr.c:15 
    ; dialog/descr.c:16 uint16_t lutNames[] = {
    ; dialog/descr.c:17 "Кожа змеи",
    ; dialog/descr.c:18 "Нож хобгоблина",
    ; dialog/descr.c:19 "Ядовитый клык",
    ; dialog/descr.c:20 "Кровь дракона!",
    ; dialog/descr.c:21 "Кислота",
    ; dialog/descr.c:22 "Перья",
    ; dialog/descr.c:23 "Слизь",
    ; dialog/descr.c:24 "Копыта",
    ; dialog/descr.c:25 "Кольчуга",
    ; dialog/descr.c:26 "Изумруд",
    ; dialog/descr.c:27 "Золотое руно",
    ; dialog/descr.c:28 "Майоран"
    ; dialog/descr.c:29 };
lutNames:
    dw s22008
    dw s22009
    dw s22010
    dw s22011
    dw s22012
    dw s22013
    dw s22014
    dw s22015
    dw s22016
    dw s22017
    dw s22018
    dw s22019
    ; dialog/descr.c:30 
    ; dialog/descr.c:31 uint16_t lutPrices[] = {
    ; dialog/descr.c:32 1,
    ; dialog/descr.c:33 2,
    ; dialog/descr.c:34 3
    ; dialog/descr.c:35 };
lutPrices:
    dw 1
    dw 2
    dw 3
    ; dialog/descr.c:36 
    ; dialog/descr.c:37 uint16_t itemInfo[itemsCount] = {
    ; dialog/descr.c:38 "*", //"Восстанавливает 10 единиц здоровья\r",
    ; dialog/descr.c:39 
    ; dialog/descr.c:40 "*", //"Полностью восстанавливает здоровье\r",
    ; dialog/descr.c:41 
    ; dialog/descr.c:42 "*", //"Полностью восстанавливает\n"
    ; dialog/descr.c:43 //"заклинание 1\r",
    ; dialog/descr.c:44 
    ; dialog/descr.c:45 "*", //"Полностью восстанавливает\n"
    ; dialog/descr.c:46 //"все заклинания\r",
    ; dialog/descr.c:47 
    ; dialog/descr.c:48 "Это заклинание делает вашу\n"
    ; dialog/descr.c:49 "плоть твердой как камень.\n"
    ; dialog/descr.c:50 "Пока заклинание активно,\n"
    ; dialog/descr.c:51 "урон уменьшается вдвое.",
    ; dialog/descr.c:52 
    ; dialog/descr.c:53 "*", //"Полностью восстанавливает амулет\r",
    ; dialog/descr.c:54 
    ; dialog/descr.c:55 "*", //"Пока заклинание активно,\n"
    ; dialog/descr.c:56 //"каждая ваша атака наноит в\n"
    ; dialog/descr.c:57 //"два раза больше урона врагу.\r",
    ; dialog/descr.c:58 
    ; dialog/descr.c:59 "*" //"Это заклинание возращает\n"
    ; dialog/descr.c:60 //"Вас в последний посещенный\n"
    ; dialog/descr.c:61 //"вами город.\r"
    ; dialog/descr.c:62 };
itemInfo:
    dw s22020
    dw s22020
    dw s22020
    dw s22020
    dw s22021
    dw s22020
    dw s22020
    dw s22020
    ; dialog/descr.c:63 
    ; dialog/descr.c:64 uint16_t itemPrices[itemsCount] = {
    ; dialog/descr.c:65 10,
    ; dialog/descr.c:66 20,
    ; dialog/descr.c:67 30,
    ; dialog/descr.c:68 40,
    ; dialog/descr.c:69 50,
    ; dialog/descr.c:70 60,
    ; dialog/descr.c:71 70,
    ; dialog/descr.c:72 80
    ; dialog/descr.c:73 };
itemPrices:
    dw 10
    dw 20
    dw 30
    dw 40
    dw 50
    dw 60
    dw 70
    dw 80
    ; dialog/descr.c:74 
    ; strings
s22020 db "*",0
s22002 db "���������� 1",0
s22018 db "������� ����",0
s22017 db "�������",0
s22004 db "�������� ����",0
s22012 db "�������",0
s22008 db "���� ����",0
s22016 db "��������",0
s22015 db "������",0
s22011 db "����� �������!",0
s22003 db "���������� ����",0
s22019 db "�������",0
s22009 db "��� ����������",0
s22005 db "����� ������",0
s22000 db "����� �������",0
s22013 db "�����",0
s22001 db "������ ���������",0
s22006 db "�����",0
s22014 db "�����",0
s22007 db "������������",0
s22021 db "��� ���������� ������ ����",10,"����� ������� ��� ������.",10,"���� ���������� �������,",10,"���� ����������� �����.",0
s22010 db "�������� ����",0
