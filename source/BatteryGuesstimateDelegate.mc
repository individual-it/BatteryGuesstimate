import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

//! Creates a web request on menu / select events
class BatteryGuesstimateDelegate extends WatchUi.BehaviorDelegate {
    private var _view as BatteryGuesstimateView;

    //! Set up the callback to the view
    //! @param handler Callback method for when data is received
    public function initialize(view as BatteryGuesstimateView) {
        WatchUi.BehaviorDelegate.initialize();
        _view = view;
    }

    //! On a menu event, make a web request
    //! @return true if handled, false otherwise
    public function onMenu() as Boolean {
        return true;
    }

    //! On a select event, make a web request
    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        return true;
    }
}