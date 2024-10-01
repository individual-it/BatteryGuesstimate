import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class DeviceView {
    var Y_ZERO_LINE as Integer = 320;
    var X_MARGIN_LEFT as Integer = 80;
    var GRAPH_WIDTH_MULTIPLIER as Integer = 2;

    var STATS_FONT as Graphics.FontDefinition = Graphics.FONT_TINY;
    var STATS_X_ALLINGMENT as Integer  = 300;
    var STATS_ICON_X_ALLINGMENT as Integer  = 120;
    var STATS_Y_START as Integer  = 15;
    var STATS_LINE_HIGHT as Integer  = 30;
    var STATS_GROUP_PADDING as Integer  = 5;
    var STATS_MIN_MAX_ARROW_TOP as Integer = 34;

    function drawButtonHint(dc as Dc) as Void {
        dc.drawText(10, 200, Graphics.FONT_MEDIUM, "+", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(34, 280, Graphics.FONT_MEDIUM, "-", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawLine(0, 180, 60, 230);
        dc.drawLine(60, 230, 60, 320);
        dc.drawLine(60, 320, 44, 350);
    }

    function drawExportButtonHint(dc as Dc) as Void {
        var exportIcon = Application.loadResource(Rez.Drawables.ExportIcon) as WatchUi.BitmapResource;
        var x = dc.getWidth()*0.75;
        var y = 80;
        dc.fillCircle(x+31, y+31, 31);
        dc.drawBitmap(x+8,y+12, exportIcon);
    }

    function drawTimeText(dc as Dc, timeText as String) as Void {
        dc.drawText(
            dc.getWidth() / 2, dc.getHeight() - 35,
            Graphics.FONT_MEDIUM,
            timeText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawProgressIndicator(dc as Dc, progress as Float, parentView as View) as Void {
        dc.drawArc(dc.getWidth() / 2, dc.getHeight() / 2, dc.getHeight() / 2, Graphics.ARC_CLOCKWISE, 0, progress);
    }
}