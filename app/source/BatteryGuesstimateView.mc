import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Application.Storage;
import Toybox.Math;

class BatteryGuesstimateView extends WatchUi.View {
    private var _drawingDone as Boolean = false;
    //! Constructor
    public function initialize() {
        WatchUi.View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout( $.Rez.Layouts.ChartLayout( dc ) );
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
        _drawingDone = false;
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void { 
        if (_drawingDone == false) {
            View.onUpdate(dc);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            var batteryValue;
            var y;
            var circularBufferPosition = Storage.getValue($.CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V2) as Integer;
            if (circularBufferPosition == null) {
                dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2) + 10, Graphics.FONT_MEDIUM, "no data", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                return;
            }

            for (var x = $.MAX_STEPS_TO_CALC+$.X_MARGIN_LEFT; x >= $.X_MARGIN_LEFT; x -= 1) {
                batteryValue = Storage.getValue($.CIRCULAR_BUFFER_STORAGE_NAME_PREFIX_V2 + circularBufferPosition) as Integer;

                if (batteryValue == null) {
                    batteryValue = -5;
                } else {
                    batteryValue = batteryValue / 2;
                    batteryValue = Math.round(batteryValue);
                }

                dc.drawLine(x, $.Y_ZERO_LINE, x, $.Y_ZERO_LINE-batteryValue);
                circularBufferPosition = circularBufferPosition - 1;
                if (circularBufferPosition < 0) {
                    circularBufferPosition = $.MAX_STEPS_TO_CALC;
                }
            }
            _drawingDone = true;
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }
}
