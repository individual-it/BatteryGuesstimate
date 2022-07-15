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

function drawTimeText(dc as Dc, timeText as String) as Void {
    dc.drawText(
        dc.getWidth() / 2, dc.getHeight() - 15,
        Graphics.FONT_MEDIUM,
        timeText,
        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
    );
}