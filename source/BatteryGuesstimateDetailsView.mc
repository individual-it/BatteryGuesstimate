import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

//! Shows the web request result
class BatteryGuesstimateDetailsView extends WatchUi.View {
    private var _message as String = "";

    //! Constructor
    public function initialize() {
        var batteryChange = $.getBattChangeInPercent(1);
        _message = "15min batt change\n" + $.formatOutput(batteryChange);
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
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2) + 10, Graphics.FONT_MEDIUM, _message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }
}
