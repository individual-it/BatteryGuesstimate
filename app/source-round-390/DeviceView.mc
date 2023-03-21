import Toybox.Lang;
import Toybox.Graphics;
import Toybox.WatchUi;

class DeviceView {
    var Y_ZERO_LINE as Integer = 290;
    var X_MARGIN_LEFT as Integer = 80;
    var STATS_FONT as Graphics.FontDefinition = Graphics.FONT_TINY;
    var STATS_X_ALLINGMENT as Integer  = 170;
    var STATS_ICON_X_ALLINGMENT as Integer  = 70;
    var STATS_Y_START as Integer  = 8;
    var STATS_LINE_HIGHT as Integer  = 22;
    var STATS_GROUP_PADDING as Integer  = 3;
    var STATS_MIN_MAX_ARROW_TOP as Integer = 20;

    function drawButtonHint(dc as Dc) as Void {
        dc.drawText(15, 170, Graphics.FONT_MEDIUM, "+", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(39, 250, Graphics.FONT_MEDIUM, "-", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawLine(0, 150, 60, 200);
        dc.drawLine(60, 200, 60, 290);
        dc.drawLine(60, 290, 44, 320);
    }

    function drawExportButtonHint(dc as Dc) as Void {
        var exportIcon = Application.loadResource(Rez.Drawables.ExportIcon) as WatchUi.BitmapResource;
        var x = dc.getWidth()*0.75;
        var y = 50;
        dc.fillCircle(x+31, y+31, 31);
        dc.drawBitmap(x+8,y+12, exportIcon);
    }

    function drawTimeText(dc as Dc, timeText as String) as Void {
        dc.drawText(
            dc.getWidth() / 2, dc.getHeight() - 25,
            Graphics.FONT_MEDIUM,
            timeText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    function drawProgressIndicator(dc as Dc, progress as Float, parentView as View) as Void {
        dc.drawArc(dc.getWidth() / 2, dc.getHeight() / 2, dc.getHeight() / 2, Graphics.ARC_CLOCKWISE, 0, progress);
    }
}