using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System;
import Toybox.Lang;

(:glance)
class BatteryGuesstimateGlanceView extends WatchUi.GlanceView {

  var _heading as String = "BATT GUESSTIMATE";

  function initialize() {
    GlanceView.initialize();
  }


  function onUpdate(dc) {
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    var deviceSpecificView = new DeviceGlanceView(dc);
    deviceSpecificView.drawHeading(_heading);
    var batteryChange = $.getBattChangeInPercent(1);
    var output;
    if (batteryChange instanceof String) {
      output = batteryChange;
    } else {
      var guesstimate = $.guesstimate(batteryChange, 15);
      output = $.formatOutput(batteryChange) + " -> " + $.guesstimateFormat(guesstimate);
    }
    
    dc.drawText(0, 20, Graphics.FONT_XTINY, "15m:" + output, Graphics.TEXT_JUSTIFY_LEFT);
    batteryChange = $.getBattChangeInPercent(2);
    if (batteryChange instanceof String) {
      output = batteryChange;
    } else {
      var guesstimate = $.guesstimate(batteryChange, 30);
      output = $.formatOutput(batteryChange) + " -> " + $.guesstimateFormat(guesstimate);
    }
    dc.drawText(0, 40, Graphics.FONT_XTINY, "30m:" + output, Graphics.TEXT_JUSTIFY_LEFT);
  }
}