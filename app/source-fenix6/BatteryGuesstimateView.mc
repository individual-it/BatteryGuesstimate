import Toybox.Lang;
import Toybox.Graphics;

var Y_ZERO_LINE as Integer = 140;
var X_MARGIN_LEFT as Integer = 20;

function drawButtonHint(dc as Dc) as Void {
    dc.drawText(3, 80, Graphics.FONT_SMALL, "+", Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(3, 118, Graphics.FONT_SMALL, "-", Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawLine(0, 79, 10, 79);
    dc.drawLine(10, 79, 15, 89);
    dc.drawLine(15, 89, 15, 130);
    dc.drawLine(15, 130, 10, 140);
    dc.drawLine(10, 140, 0, 140);
}