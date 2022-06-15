using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System;

(:glance)
class BatteryGuesstimateGlanceView extends WatchUi.GlanceView {

  var _heading = "BATT GUESSTIMATE";

  function initialize() {
    GlanceView.initialize();
  }


  function onUpdate(dc) {
    var changeInPercent = $.guesstimate();
    var message as String;
    message = "15m -> " + changeInPercent;
    
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    dc.drawText(0, 0, Graphics.FONT_TINY, _heading, Graphics.TEXT_JUSTIFY_LEFT);
    dc.drawText(0, 20, Graphics.FONT_XTINY, message, Graphics.TEXT_JUSTIFY_LEFT);
  }
}