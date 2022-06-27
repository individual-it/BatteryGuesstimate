import Toybox.Lang;
import Toybox.Graphics;

var X_POS_DATA as Integer = 100;

function drawButtonHintBorder(dc as Dc) as Void {
    dc.drawLine(0, 79, 10, 79);
    dc.drawLine(10, 79, 15, 89);
    dc.drawLine(15, 89, 15, 130);
    dc.drawLine(15, 130, 10, 140);
    dc.drawLine(10, 140, 0, 140);
}