// Кол-во типов преметов
const int itemsCount = 8;

// Размер глобального строкового буфера
const int gStringBufferSize = 32;

// Флаги для переменных gPanelChangedA, gPanelChangedB
const int gPanelChangedMoney = 0x01;
const int gPanelChangedPlace = 0x02;
//const int gPanelChangedImages = 0x04;
const int gPanelChanedSecondWeaponCount = 0x08;
const int gPanelChanedArmorCount = 0x10;

// Максимальное кол-во символов (не учитывая терминатор строки), которое возращает функция numberToString16
const int numberToString16max = 5;

// Максимальное кол-во предметов у игрока
const int playerItemsMax = 5;

// Максимальное кол-во типов лута у игрока (кол-во отображаемых строк в инвентаре)
const int playerLutMax = 12;

// Максимальное кол-во лута у игрока (сумма)
const int playerLutMaxCountInLine = 99;

const int secondWeaponMax = 9;

// Флаги клавиш для переменные gKeyPressed, gKeyTrigger
const int KEY_UP = 1;
const int KEY_DOWN = 2;
const int KEY_LEFT = 4;
const int KEY_RIGHT = 8;
const int KEY_FIRE = 16;
const int KEY_MENU = 32;

// Стандартные адреса ZX Spectrum
const int screenBw0 = 0x4000;
const int screenAttr0 = 0x5800;

// Размеры экрана
const int screenWidthTails = 32;
const int panelHeightTails = 4;
const int tailHeight = 8;
const int tailWidth = 8;
const int playfieldHeightTails = 20;

// Используется при упаковке координат X, Y в регистровую пару
const int bpl = 256;

// Точки входа
const int gPanelRedrawImagesPage = 6;
const int gPanelRedrawImages = 0xC006;
const int gInventPage = 6;
const int gInvent = 0xC000;

// Параметр для drawText
const int smallFontFlag = 0x80;
