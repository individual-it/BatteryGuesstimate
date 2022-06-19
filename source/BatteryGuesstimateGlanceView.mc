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
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    dc.drawText(0, 0, Graphics.FONT_TINY, _heading, Graphics.TEXT_JUSTIFY_LEFT);
    var batteryChange = $.getBattChangeInPercent(1);
    var guesstimate = $.guesstimate(batteryChange, 15);
    dc.drawText(0, 20, Graphics.FONT_XTINY, "15m:" + $.formatOutput(batteryChange) + " -> " + $.guesstimateFormat(guesstimate), Graphics.TEXT_JUSTIFY_LEFT);
    batteryChange = $.getBattChangeInPercent(2);
    guesstimate = $.guesstimate(batteryChange, 15);
    dc.drawText(0, 40, Graphics.FONT_XTINY, "30m:" + $.formatOutput(batteryChange)+ " -> " + $.guesstimateFormat(guesstimate), Graphics.TEXT_JUSTIFY_LEFT);
  }
}