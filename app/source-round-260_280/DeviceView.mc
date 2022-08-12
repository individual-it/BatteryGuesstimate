import Toybox.Lang;
import Toybox.Graphics;

class DeviceView {
    var Y_ZERO_LINE as Integer = 190;
    var X_MARGIN_LEFT as Integer = 80;
    var STATS_FONT as Graphics.FontDefinition = Graphics.FONT_TINY;
    var STATS_X_ALLINGMENT as Integer  = 170;
    var STATS_ICON_X_ALLINGMENT as Integer  = 80;
    var STATS_Y_START as Integer  = 8;
    var STATS_LINE_HIGHT as Integer  = 22;
    var STATS_GROUP_PADDING as Integer  = 3;
    var STATS_MIN_MAX_ARROW_TOP as Integer = 20;

    function drawButtonHint(dc as Dc) as Void {
        dc.drawText(3, 118, Graphics.FONT_SMALL, "+", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(30, 180, Graphics.FONT_SMALL, "-", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawLine(0, 110, 20, 110);
        dc.drawLine(20, 110, 50, 200);
        dc.drawLine(50, 200, 20, 230);
    }

    function drawTimeText(dc as Dc, timeText as String) as Void {
        dc.drawText(
            dc.getWidth() / 2, dc.getHeight() - 25,
            Graphics.FONT_MEDIUM,
            timeText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawProgressIndicator(dc as Dc, progress as Float) as Void {
        dc.drawArc(dc.getWidth() / 2, dc.getHeight() / 2, dc.getHeight() / 2, Graphics.ARC_CLOCKWISE, 0, progress);
    }
}