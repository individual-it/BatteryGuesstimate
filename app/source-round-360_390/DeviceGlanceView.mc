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
        _dc.drawText(0, 0,  Graphics.FONT_XTINY, heading, Graphics.TEXT_JUSTIFY_LEFT);
    }
}
