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

    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        if (_stepsOfHistory >= 24) {
            _stepsOfHistory = _stepsOfHistory + 12;
        } else if (_stepsOfHistory >= 8) {
            _stepsOfHistory = _stepsOfHistory + 4;
        } else {
            _stepsOfHistory = _stepsOfHistory + 1;
        }

        if (_stepsOfHistory > $.SIZE_CIRCULAR_BUFFER){
            _stepsOfHistory = 1;
        }
        setMessage();
        return true;
    }

    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        if (_stepsOfHistory <= 8) {
            _stepsOfHistory = _stepsOfHistory - 1;
        } else if (_stepsOfHistory <= 24) {
            _stepsOfHistory = _stepsOfHistory - 4;
        } else {
            _stepsOfHistory = _stepsOfHistory - 12;
        }

        if (_stepsOfHistory < 1){
            _stepsOfHistory = $.SIZE_CIRCULAR_BUFFER;
        }
        setMessage();
        return true;
    }

    private function setMessage() {
        var minutes = _stepsOfHistory * 15;
        var batteryChange = $.getBattChangeInPercent(_stepsOfHistory);
        var guesstimate = $.guesstimate(batteryChange, minutes);
        _view.setMessage(minutes, batteryChange, guesstimate);
    }
}