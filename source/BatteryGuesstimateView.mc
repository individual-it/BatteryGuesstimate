import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Application.Storage;
import Toybox.Math;


class BatteryGuesstimateView extends WatchUi.View {
    private var _message as String = "";

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
    }

    public function setMessage(message as String) as Void {
        _message = message;
        WatchUi.requestUpdate();
    }
    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void { 
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        var batteryValue as Float;
        var y as Integer;
        var yZeroLine = 140;
        var xMarginLeft = 20;
        var circularBufferPosition = Storage.getValue("circular buffer last position");
        if (circularBufferPosition == null) {
            dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2) + 10, Graphics.FONT_MEDIUM, "no data", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
            return;
        }

        for (var x = $.SIZE_CIRCULAR_BUFFER+xMarginLeft; x > xMarginLeft; x -= 1) {
            batteryValue = Storage.getValue("circular buffer " + circularBufferPosition);

            if (batteryValue == null) {
                batteryValue = -5;
            } else {
                batteryValue = batteryValue / 2;
                batteryValue = Math.round(batteryValue);
            }

            dc.drawLine(x, yZeroLine, x, yZeroLine-batteryValue);
            circularBufferPosition = circularBufferPosition - 1;
            if (circularBufferPosition < 0) {
                circularBufferPosition = $.SIZE_CIRCULAR_BUFFER;
            }
        }
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }
}
