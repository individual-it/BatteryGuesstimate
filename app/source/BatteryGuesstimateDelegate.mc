import Toybox.Lang;
import Toybox.WatchUi;

class BatteryGuesstimateDelegate extends WatchUi.BehaviorDelegate {
    public function initialize() {
        WatchUi.BehaviorDelegate.initialize();
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