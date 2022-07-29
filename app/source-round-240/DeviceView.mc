import Toybox.Lang;
import Toybox.Graphics;

class DeviceView {
    var Y_ZERO_LINE as Integer = 190;
    var X_MARGIN_LEFT as Integer = 70;

    function drawButtonHint(dc as Dc) as Void {
        dc.drawText(3, 108, Graphics.FONT_SMALL, "+", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(30, 170, Graphics.FONT_SMALL, "-", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawLine(0, 100, 20, 100);
        dc.drawLine(20, 100, 50, 190);
        dc.drawLine(50, 190, 20, 220);
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