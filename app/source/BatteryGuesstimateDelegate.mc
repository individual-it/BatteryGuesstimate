import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

class BatteryGuesstimateDelegate extends WatchUi.BehaviorDelegate {
    private var _view as BatteryGuesstimateView;
    private var _stepsOfHistory = 1;

    //! Set up the callback to the view
    //! @param handler Callback method for when data is received
    public function initialize(view as BatteryGuesstimateView) {
        WatchUi.BehaviorDelegate.initialize();
        _view = view;
    }

    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        return true;
    }

    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        var view = new BatteryGuesstimateDetailsView();
        WatchUi.pushView(view, new BatteryGuesstimateDetailsDelegate(view), WatchUi.SLIDE_UP);

        return true;
    }
}