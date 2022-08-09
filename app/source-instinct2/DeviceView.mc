import Toybox.Lang;
import Toybox.Graphics;

class DeviceView {
    var Y_ZERO_LINE as Integer = 140;
    var X_MARGIN_LEFT as Integer = 20;

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

    function drawStats(dc as Dc, minBattValue as Float, maxBattValue as Float, cumulatedCharge as Float, cumulatedDischarge as Float) as Void {
        dc.drawLine(40, 5, 40, 30);
        dc.drawLine(37, 8, 40, 2);
        dc.drawLine(43, 8, 40, 2);
        dc.drawLine(37, 24, 40, 34);
        dc.drawLine(43, 24, 40, 34);
        dc.drawText(
            45, -5,
            Graphics.FONT_XTINY,
            maxBattValue.format("%0.2f") + "%",
            Graphics.TEXT_JUSTIFY_LEFT
        );
        dc.drawText(
            45, 15,
            Graphics.FONT_XTINY,
            minBattValue.format("%0.2f") + "%",
            Graphics.TEXT_JUSTIFY_LEFT
        );
        dc.drawText(
            10, 35,
            Graphics.FONT_XTINY,
            cumulatedCharge.format("%0.2f") + "%",
            Graphics.TEXT_JUSTIFY_LEFT
        );
        dc.drawText(
            10, 55,
            Graphics.FONT_XTINY,
            cumulatedDischarge.format("%0.2f") + "%",
            Graphics.TEXT_JUSTIFY_LEFT
        );
    }
}