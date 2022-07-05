import Toybox.Lang;
import Toybox.Graphics;

var Y_ZERO_LINE as Integer = 125;
var X_MARGIN_LEFT as Integer = 20;

function drawButtonHint(dc as Dc) as Void {
    dc.drawText(3, 70, Graphics.FONT_SMALL, "+", Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(3, 105, Graphics.FONT_SMALL, "-", Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawLine(0, 69, 10, 69);
    dc.drawLine(10, 69, 15, 79);
    dc.drawLine(15, 79, 15, 120);
    dc.drawLine(15, 120, 10, 130);
    dc.drawLine(10, 130, 0, 130);
}