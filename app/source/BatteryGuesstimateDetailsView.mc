import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class BatteryGuesstimateDetailsView extends WatchUi.View {
    private var _minutes as Integer;
    private var _battChangeInPercent as Float;
    private var _guesstimate as Integer?;

    //! Constructor
    public function initialize() {
        _minutes = 15;
        var battChangeInPercent = $.getBattChangeInPercent(1);
        if (battChangeInPercent == null) {
            _battChangeInPercent = 0.0;
        } else {
            _battChangeInPercent = battChangeInPercent;
        }
        _guesstimate = $.guesstimate(_battChangeInPercent, _minutes);
        WatchUi.View.initialize();
        if (Toybox.WatchUi.View has :setClockHandPosition) {
            self.setClockHandPosition(
                {
                    :clockState => WatchUi.ANALOG_CLOCK_STATE_HOLDING, :hour => 90, :minute => 90}
                );
        }
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout( $.Rez.Layouts.DetailsLayout( dc ) );
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
    }

    public function setMessage(minutes as Integer, batteryChangeInPercent as Float, guesstimate as Integer?) as Void {
        _minutes = minutes;
        _battChangeInPercent = batteryChangeInPercent;
        _guesstimate = guesstimate;
        WatchUi.requestUpdate();
    }
    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void { 
        var deviceSpecificView = new DeviceView();
        dc.clear();
        dc.setPenWidth(1);
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        var time;
        time = $.timePeriodFormat(_minutes, true);

        deviceSpecificView.drawButtonHint(dc);

        var deviceSpecificDetailsView = new DeviceDetailsView();
        dc.drawText(
            deviceSpecificDetailsView.X_POS_TIME,
            deviceSpecificDetailsView.Y_POS_TIME,
            Graphics.FONT_LARGE, time, Graphics.TEXT_JUSTIFY_LEFT
        );

        dc.drawText(
            deviceSpecificDetailsView.X_POS_DATA,
            deviceSpecificDetailsView.Y_POS_BATT_CHANGE_IN_PERCENT,
            Graphics.FONT_MEDIUM,
            $.formatOutput(_battChangeInPercent),
            Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.drawText(
            deviceSpecificDetailsView.X_POS_DATA,
            deviceSpecificDetailsView.Y_POS_BATT_GUESSTIMATE,
            Graphics.FONT_MEDIUM,
            $.guesstimateFormat(_guesstimate),
            Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER
        );
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }
}
