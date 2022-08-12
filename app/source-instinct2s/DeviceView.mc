import Toybox.Lang;
import Toybox.Graphics;

class DeviceView {
    var Y_ZERO_LINE as Integer = 125;
    var X_MARGIN_LEFT as Integer = 20;

    var STATS_FONT as Graphics.FontDefinition = Graphics.FONT_XTINY;
    var STATS_X_ALLINGMENT as Integer  = 95;
    var STATS_ICON_X_ALLINGMENT as Integer  = 35;
    var STATS_Y_START as Integer  = -3;
    var STATS_LINE_HIGHT as Integer  = 13;
    var STATS_GROUP_PADDING as Integer  = 1;
    var STATS_MIN_MAX_ARROW_TOP as Integer = 5;

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

    function drawProgressIndicator(dc as Dc, progress as Float) as Void {
        dc.drawArc(136, 27, 27, Graphics.ARC_CLOCKWISE, 0, progress);
    }
}