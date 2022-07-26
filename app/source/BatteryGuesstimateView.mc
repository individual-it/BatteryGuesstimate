import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Application.Storage;
import Toybox.Math;


const GRAPH_WIDTH = 96; // maximum amount of data points we can show in the graph
const DATA_POS_START = GRAPH_WIDTH-1;
class BatteryGuesstimateView extends WatchUi.View {
    var _stepsToShowInGraph as Integer = GRAPH_WIDTH;
    private var _drawingDone as Boolean = false;
    private var _graphData as Array = new [GRAPH_WIDTH];
    private var _dataPos as Integer = DATA_POS_START;
    private var _circularBufferPosition as Integer = 0;

    private function resetValues() as Void {
        _circularBufferPosition = Storage.getValue($.CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V2) as Integer;
        _drawingDone = false;
        _dataPos = DATA_POS_START;
    }
    //! Constructor
    public function initialize() {
        WatchUi.View.initialize();
    }

    //! Load your resources here
    //! @param dc Device context
    public function onLayout(dc as Dc) as Void {
        setLayout( $.Rez.Layouts.ChartLayout( dc ) );
    }

    //! Restore the state of the app and prepare the view to be shown
    public function onShow() as Void {
        resetValues();
    }

    public function getStepsToShowInGraph() as Integer {
        return _stepsToShowInGraph;
    }

    public function setStepsToShowInGraph(steps as Integer) as Void {
        if (steps < GRAPH_WIDTH) {
            _stepsToShowInGraph = GRAPH_WIDTH;
        } else if (steps > $.MAX_STEPS_TO_CALC) {
            _stepsToShowInGraph = $.MAX_STEPS_TO_CALC;
        } else {
            _stepsToShowInGraph = steps;
        }
        resetValues();
        WatchUi.requestUpdate();
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        if (_circularBufferPosition == null) {
            dc.drawText(
                dc.getWidth() / 2, (dc.getHeight() / 2) + 10,
                Graphics.FONT_MEDIUM,
                "no data",
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
            return;

        }
        if (_dataPos >= 0) {
            dc.setPenWidth(20);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.clear();
            dc.drawText(
                dc.getWidth() / 2, (dc.getHeight() / 2) + 10,
                Graphics.FONT_LARGE,
                "loading ...",
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
            var progress = 360.0/GRAPH_WIDTH*(GRAPH_WIDTH-_dataPos)*-1;
            dc.drawArc(144, 31, 31, Graphics.ARC_CLOCKWISE, 0, progress);

            _graphData[_dataPos] = getGraphData(_stepsToShowInGraph, _dataPos);
            _dataPos -= 1;
            WatchUi.requestUpdate();

            return;
        } else if (_drawingDone == false ) {
            dc.setPenWidth(1);
            var deviceSpecificView = new DeviceView();
            var timeText = "24h";
            View.onUpdate(dc);

            deviceSpecificView.drawButtonHint(dc);
            var x;

            for (var i = GRAPH_WIDTH-1; i >= 0; i -= 1) {
                x = i+deviceSpecificView.X_MARGIN_LEFT;
                var graphData = Math.round(_graphData[i] as Float / 2);
                dc.drawLine(x, deviceSpecificView.Y_ZERO_LINE, x, deviceSpecificView.Y_ZERO_LINE-graphData  as Float);
            }
            _drawingDone = true;

            if (_stepsToShowInGraph > 96) {
                timeText = (_stepsToShowInGraph / 96) + "days";
            }

            deviceSpecificView.drawTimeText(dc, timeText);
        }

    }

    // placed in a seperate function to make it testable
    public function getGraphData(stepsToShowInGraph as Integer, x as Integer) as Float? {
        var batteryValue = 0;

        var stepsPerPixelX = stepsToShowInGraph / GRAPH_WIDTH; // for now it must be dividable by 96

        batteryValue = 0;
        for (var avarageI = stepsPerPixelX; avarageI > 0; avarageI = avarageI-1) {
            var storageValue = Storage.getValue(_circularBufferPosition as Integer) as Integer;

            if (storageValue == null) {
                storageValue = 0;
            }
            batteryValue = batteryValue + storageValue;
            _circularBufferPosition = _circularBufferPosition - 1;
            if (_circularBufferPosition < 0) {
                _circularBufferPosition = $.MAX_STEPS_TO_CALC;
            }
        }
        return (batteryValue / stepsPerPixelX) as Float;

    }
    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }
}
