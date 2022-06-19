import Toybox.Communications;
import Toybox.Lang;
import Toybox.WatchUi;

class BatteryGuesstimateDetailsDelegate extends WatchUi.BehaviorDelegate {
    private var _view as BatteryGuesstimateDetailsView;
    private var _stepsOfHistory = 1;

    public function initialize(view as BatteryGuesstimateDetailsView) {
        WatchUi.BehaviorDelegate.initialize();
        _view = view;
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
        var batteryChange = $.getBattChangeInPercent(_stepsOfHistory);

        _view.setMessage(message + " batt change\n" + $.formatOutput(batteryChange));
        return true;
    }
}