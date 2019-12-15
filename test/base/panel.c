#counter 6000

const int gPanelChangedMoney = 0x01;
const int gPanelChangedPlace = 0x02;

const int panelMoneyX = 4;
const int panelMoneyY = 22;
const int panelMoneyW = 3;
const int panelMoneyH = 1;
const int panelMoneyColor = 0x4E;

const int panelPlaceX = 4;
const int panelPlaceY = 20;
const int panelPlaceW = 3;
const int panelPlaceH = 1;
const int panelPlaceColor = 0x4E;

void panelRedraw()
{
    // Нужно ли перерисовать?
    hl = &gPanelChangedA;
    if ((a = gVideoPage) & 0x80) hl++;
    a = *hl;
    if (flag_z a |= a) return;
    *hl = 0;

    // Надо перерисовать деньги
    if (a & gPanelChangedMoney)
    {
        push(a)
        {
            numberToString16(hl = &gStringBuffer, de = gPlayerMoney);

            hl = &gStringBuffer;
            while()
            {
                (a = *hl) -= [48 - 22];
                if (flag_c) break;
                *hl = a; hl++;
            }
            hl++; *hl = 2;

            gCalcCoords(hl = [panelMoneyY * 8 * 256 + panelMoneyX * 8]);
            fillRect(hl, bc = [panelMoneyH * 256 + panelMoneyW]);

            gCalcCoords(hl = [(panelMoneyY * 8 + 2) * 256 + panelMoneyX * 8]);
            gDrawText(hl, c = 0, de = &gStringBuffer, a = panelMoneyColor);
        }
    }
    /*

    if (a & gPanelChangedPlace)
    {
        push(a)
        {
            gCalcCoords(hl = [panelPlaceY * 8 * 256 + panelPlaceX * 8]);
            push(hl);
            fillRect(hl, bc = [panelPlaceH * 256 + panelPlaceW]);
            pop(hl);
            gDrawText(hl, c = 0, de = "Утеха", a = panelPlaceColor);
        }
    }
    */
}
