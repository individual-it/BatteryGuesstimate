import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class DeviceView {
    var Y_ZERO_LINE as Integer = 160;
    var X_MARGIN_LEFT as Integer = 20;
    var GRAPH_WIDTH_MULTIPLIER as Integer = 1;

    var STATS_FONT as Graphics.FontDefinition = Graphics.FONT_XTINY;
    var STATS_X_ALLINGMENT as Integer  = 140;
    var STATS_ICON_X_ALLINGMENT as Integer  = 80;
    var STATS_Y_START as Integer  = -2;
    var STATS_LINE_HIGHT as Integer  = 13;
    var STATS_GROUP_PADDING as Integer  = 1;
    var STATS_MIN_MAX_ARROW_TOP as Integer = 5;

    function drawButtonHint(dc as Dc) as Void {
        dc.drawText(3, 80, Graphics.FONT_SMALL, "+", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(3, 118, Graphics.FONT_SMALL, "-", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawLine(0, 79, 10, 79);
        dc.drawLine(10, 79, 15, 89);
        dc.drawLine(15, 89, 15, 130);
        dc.drawLine(15, 130, 10, 140);
        dc.drawLine(10, 140, 0, 140);
    }

    function drawExportButtonHint(dc as Dc) as Void {
        dc.drawLine(145, 1, 145, 60);
        dc.drawLine(145, 60, 175, 60);
        dc.drawText(150, 30, Graphics.FONT_MEDIUM, "=>", Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawTimeText(dc as Dc, timeText as String) as Void {
        dc.drawText(
            45, 30,
            Graphics.FONT_MEDIUM,
            timeText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawProgressIndicator(dc as Dc, progress as Float, parentView as View) as Void {
        parentView.setClockHandPosition(
            {
                :clockState => WatchUi.ANALOG_CLOCK_STATE_HOLDING,
                :hour => 90,
                :minute => 90+progress as Integer
            }
        );
    }
}