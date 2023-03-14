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
      try {
        timeFrameStepsToShow = Properties.getValue("glance-timeframe-" + i) as Integer;
         // getValue might still return a String
         // see https://forums.garmin.com/developer/connect-iq/f/discussion/327089/unhandled-exception-in-a-simple-if-statement/1587695#1587695
        timeFrameStepsToShow = timeFrameStepsToShow.toNumber();
        if (timeFrameStepsToShow == null) { // happens if the string is not convertable to number, what really should not happen for us
          timeFrameStepsToShow = i;
        }
      } catch (e) {
        // key does not exist, set it to 15 / 30 min
        timeFrameStepsToShow = i;
      }

      batteryChange = $.getBattChangeInPercent(timeFrameStepsToShow);
      if (batteryChange == null) {
        batteryChange = 0.0;
      }
      minutes = timeFrameStepsToShow * 15;
      timeString = $.timePeriodFormat(minutes, false);
      guesstimate = $.guesstimate(batteryChange, minutes);
      if (deviceSpecificView has :drawDetails) {
        deviceSpecificView.drawDetails(i+1, timeString, $.formatOutput(batteryChange), $.guesstimateFormat(guesstimate));
      } else {
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
}