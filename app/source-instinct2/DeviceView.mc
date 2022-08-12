import Toybox.Lang;
import Toybox.Graphics;

class DeviceView {
    var Y_ZERO_LINE as Integer = 140;
    var X_MARGIN_LEFT as Integer = 20;

    var STATS_FONT as Graphics.FontDefinition = Graphics.FONT_XTINY;
    var STATS_X_ALLINGMENT as Integer  = 98;
    var STATS_ICON_X_ALLINGMENT as Integer  = 30;
    var STATS_Y_START as Integer  = -2;
    var STATS_LINE_HIGHT as Integer  = 16;
    var STATS_GROUP_PADDING as Integer  = 2;
    var STATS_MIN_MAX_ARROW_TOP as Integer = 7;

    function drawButtonHint(dc as Dc) as Void {
        dc.drawText(3, 80, Graphics.FONT_SMALL, "+", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(3, 118, Graphics.FONT_SMALL, "-", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawLine(0, 79, 10, 79);
        dc.drawLine(10, 79, 15, 89);
        dc.drawLine(15, 89, 15, 130);
        dc.drawLine(15, 130, 10, 140);
        dc.drawLine(10, 140, 0, 140);
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
        dc.drawArc(144, 31, 31, Graphics.ARC_CLOCKWISE, 0, progress);
    }
}