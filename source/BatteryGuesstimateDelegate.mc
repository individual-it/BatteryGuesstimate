import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

//! Creates a web request on menu / select events
class BatteryGuesstimateDelegate extends WatchUi.BehaviorDelegate {
    private var _view as BatteryGuesstimateView;
    private var _stepsOfHistory = 1;

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
        
        var message as String;
        if (_stepsOfHistory >= 24) {
            _stepsOfHistory = _stepsOfHistory + 12;
        } else if (_stepsOfHistory >= 8) {
            _stepsOfHistory = _stepsOfHistory + 4;
        } else {
            _stepsOfHistory = _stepsOfHistory + 1;
        }
        
        if (_stepsOfHistory > 96){
            _stepsOfHistory = 1;
        }
        var minutes = _stepsOfHistory * 15;
        if (minutes > 120) {
            message = _stepsOfHistory / 4 + "h";
        } else {
            message = minutes + "min";
        }

        _view.setMessage(message + " batt change\n" + $.guesstimate(_stepsOfHistory));
        return true;
    }
}