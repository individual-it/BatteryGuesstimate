import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class BatteryGuesstimateDetailsView extends WatchUi.View {
    private var _minutes as Integer;
    private var _battChangeInPercent as Integer;
    private var _guesstimate as Integer;
    private var _stepsOfHistory as Integer;


    //! Constructor
    public function initialize() {
        _minutes = 15;
        _battChangeInPercent = $.getBattChangeInPercent(1);
        _guesstimate = $.guesstimate(_battChangeInPercent, _minutes);
        WatchUi.View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout( $.Rez.Layouts.DetailsLayout( dc ) );
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
    }

    public function setMessage(minutes as Integer, batteryChangeInPercent as Integer, guesstimate as Integer) as Void {
        _minutes = minutes;
        _battChangeInPercent = batteryChangeInPercent;
        _guesstimate = guesstimate;
        WatchUi.requestUpdate();
    }
    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void { 
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        var time as String;
        if (_minutes > 120) {
            time = _minutes / 60 + "h";
        } else {
            time = _minutes + "min";
        }

        dc.drawLine(0, 79, 10, 79);
        dc.drawLine(10, 79, 15, 89);
        dc.drawLine(15, 89, 15, 130);
        dc.drawLine(15, 130, 10, 140);
        dc.drawLine(10, 140, 0, 140);

        dc.drawText(25, 10, Graphics.FONT_LARGE, time, Graphics.TEXT_JUSTIFY_LEFT );
        dc.drawText(100, 87, Graphics.FONT_MEDIUM, $.formatOutput(_battChangeInPercent), Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER );
        dc.drawText(100, 145, Graphics.FONT_MEDIUM, $.guesstimateFormat(_guesstimate), Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER );
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }
}
