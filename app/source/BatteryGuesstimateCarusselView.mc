using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System;
import Toybox.Lang;

class BatteryGuesstimateCarusselView extends WatchUi.View {

  var _heading as String = "BATTERY\nGUESSTIMATE";

  function initialize() {
    WatchUi.View.initialize();
  }


  function onUpdate(dc) {
    View.onUpdate(dc);
    dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
    dc.drawText(dc.getWidth() / 2, 20 , Graphics.FONT_SMALL, _heading, Graphics.TEXT_JUSTIFY_CENTER);
    for (var steps = 1; steps <=3; steps++) {
      var batteryChange = $.getBattChangeInPercent(steps);
      var minutes = steps * 15;
      if (batteryChange == null) {
        batteryChange = 0.0;
      }
      var guesstimate = $.guesstimate(batteryChange, minutes);
      dc.drawText(10, 80 + steps * 25, Graphics.FONT_TINY, minutes + "m:" + $.formatOutput(batteryChange) + " -> " + $.guesstimateFormat(guesstimate), Graphics.TEXT_JUSTIFY_LEFT);
    }
  }
}