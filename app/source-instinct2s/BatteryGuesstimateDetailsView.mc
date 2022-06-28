import Toybox.Lang;
import Toybox.Graphics;

var X_POS_DATA as Integer = 87;

function drawButtonHintBorder(dc as Dc) as Void {
    dc.drawLine(0, 69, 10, 69);
    dc.drawLine(10, 69, 15, 79);
    dc.drawLine(15, 79, 15, 120);
    dc.drawLine(15, 120, 10, 130);
    dc.drawLine(10, 130, 0, 130);
}