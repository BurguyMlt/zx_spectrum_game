;romAddr        = 0
;screenAddr     = 4000h
;cacheAddr      = 5B00h

irqTableAddr      = 5F00h
irqAddr           = 6060h
stackBeginAddr    = 6001h
stackEndAddr      = 605Fh
baseAddr          = 6063h
moduleLoadAddr    = 7000h
moverAddr         = 8000h

gEnd = baseAddr

; Функции
gDrawText         = gEnd
gEnd = gEnd + 3
gDrawTextCenter   = gEnd
gEnd = gEnd + 3
gDrawTextEx       = gEnd
gEnd = gEnd + 3
gClearScreen      = gEnd
gEnd = gEnd + 3
gDrawImage        = gEnd
gEnd = gEnd + 3
gMeasureText      = gEnd
gEnd = gEnd + 3
gCalcCoords       = gEnd
gEnd = gEnd + 3
gDrawCharSub      = gEnd
gEnd = gEnd + 3
gExec             = gEnd
gEnd = gEnd + 3
gLoadFile         = gEnd
gEnd = gEnd + 3
gFarCall          = gEnd
gEnd = gEnd + 3
gIrqHandler       = gEnd
gEnd = gEnd + 3
gDrawPanel        = gEnd
gEnd = gEnd + 3
gBeginDraw        = gEnd
gEnd = gEnd + 3
gEndDraw          = gEnd
gEnd = gEnd + 3
gCopyVideoPage    = gEnd
gEnd = gEnd + 3
gPanelRedraw      = gEnd
gEnd = gEnd + 3
gCopyPanel        = gEnd
gEnd = gEnd + 3
gStringBuffer     = gEnd
gStringBufferSize = 32
gEnd = gEnd + gStringBufferSize

; Переменные
gFrame            = gEnd
gEnd = gEnd + 1
gVideoPage        = gEnd
gEnd = gEnd + 1
gSystemPage       = gEnd
gEnd = gEnd + 1
gKeyTrigger       = gEnd
gEnd = gEnd + 1
gKeyPressed       = gEnd
gEnd = gEnd + 1
gPlayerMoney      = gEnd
gEnd = gEnd + 2
gPlayerLut        = gEnd
playerLutMax = 12
gEnd = gEnd + 2 * playerLutMax
gPlayerLutCount   = gEnd
gEnd = gEnd + 1
gPlayerItems      = gEnd
playerItemsMax = 5
gEnd = gEnd + playerItemsMax
gPlayerItemsCount = gEnd
gEnd = gEnd + 1
gPanelChangedA    = gEnd
gEnd = gEnd + 1
gPanelChangedB    = gEnd
gEnd = gEnd + 1
gPlayerSecondWeaponCount = gEnd
gEnd = gEnd + 1
gPlayerSecondWeaponCounters = gEnd
secondWeaponMax = 9
gEnd = gEnd + secondWeaponMax
gPlayerSecondWeaponSel = gEnd
gEnd = gEnd + 1

; Другие модули
gPanelgraphPage = 6
gPanelgraph = 0C003h
gPanelX = 0
gPanelY = 20

