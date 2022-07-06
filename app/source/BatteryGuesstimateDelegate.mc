import Toybox.Lang;
import Toybox.WatchUi;

class BatteryGuesstimateDelegate extends WatchUi.BehaviorDelegate {
    var _view as BatteryGuesstimateView;
    public function initialize(view as BatteryGuesstimateView) {
        _view = view;
        WatchUi.BehaviorDelegate.initialize();
    }

    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        var stepsToShowInGraph = _view.getStepsToShowInGraph();
        switch (stepsToShowInGraph) {
            case 96:
                stepsToShowInGraph = 192;
                break;
            case 192:
                stepsToShowInGraph = 672;
                break;
            case 672:
                stepsToShowInGraph = 1344;
                break;
            default:
                stepsToShowInGraph = 96;
        }
        _view.setStepsToShowInGraph(stepsToShowInGraph);
        return true;
    }

    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        var stepsToShowInGraph = _view.getStepsToShowInGraph();
        switch (stepsToShowInGraph) {
            case 192:
                stepsToShowInGraph = 96;
                break;
            case 672:
                stepsToShowInGraph = 192;
                break;
            case 1344:
                stepsToShowInGraph = 672;
                break;
            default:
                stepsToShowInGraph = 1344;
        }
        _view.setStepsToShowInGraph(stepsToShowInGraph);
        return true;
    }

    //! @return true if handled, false otherwise
    public function onSelect() as Boolean {
        var view = new BatteryGuesstimateDetailsView();
        WatchUi.pushView(view, new BatteryGuesstimateDetailsDelegate(view), WatchUi.SLIDE_UP);

        return true;
    }
}