using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System;
using Toybox.Application.Properties;
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
    var timeFrameStepsToShow  = 0;
    var batteryChange;
    var guesstimate;
    var minutes = 0;
    var timeString;
    for (var i=0; i<2; i++) {
      timeFrameStepsToShow = Properties.getValue("glance-timeframe-" + i) as Integer;
      batteryChange = $.getBattChangeInPercent(timeFrameStepsToShow);
      if (batteryChange == null) {
        batteryChange = 0.0;
      }
      minutes = timeFrameStepsToShow * 15;
      timeString = $.timePeriodFormat(minutes, false);
      guesstimate = $.guesstimate(batteryChange, minutes);
      dc.drawText(
        0,
        (i+1)*20,
        Graphics.FONT_XTINY,
        timeString + ":" + $.formatOutput(batteryChange) + " -> " + $.guesstimateFormat(guesstimate),
        Graphics.TEXT_JUSTIFY_LEFT
      );
    }
  }
}