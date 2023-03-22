import Toybox.Lang;
import Toybox.System;
import Toybox.Graphics;

(:glance)
class DeviceGlanceView {
    var _dc as Dc;
    function initialize(dc as Dc) {
        _dc = dc;
    }
    function drawHeading(heading as String) as Void {
        _dc.drawText(0, 0,  Graphics.FONT_TINY, heading, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawDetails(num as Integer, timeString as String, batteryChange as String, guesstimate as String) as Void {
        _dc.drawText(
            0,
            num*20, // calculating the text height works on most watches, but on the instinct it returns 23, but the good values is 20 here
            Graphics.FONT_XTINY,
            timeString + ":" + batteryChange + " -> " + guesstimate,
            Graphics.TEXT_JUSTIFY_LEFT
      );
    }
}
