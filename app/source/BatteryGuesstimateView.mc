import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Application.Storage;
import Toybox.Math;

const GRAPH_WIDTH = 96; // maximum amount of data points we can show in the graph
class BatteryGuesstimateView extends WatchUi.View {
    private var _drawingDone as Boolean = false;
    var _stepsToShowInGraph as Integer = GRAPH_WIDTH;
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
        _drawingDone = false;
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
        _drawingDone = false;
        WatchUi.requestUpdate();
    }

    //! Update the view
    //! @param dc Device Context
    public function onUpdate(dc as Dc) as Void {
        if (_drawingDone == false) {
            var timeText = "24h";
            View.onUpdate(dc);
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            $.drawButtonHint(dc);
            var graphData = getGraphData(_stepsToShowInGraph);
            var x;
            if (graphData == null) {
                dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2) + 10, Graphics.FONT_MEDIUM, "no data", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
                return;
            }

            for (var i = GRAPH_WIDTH-1; i >= 0; i -= 1) {
                x = i+$.X_MARGIN_LEFT;
                graphData[i] = Math.round(graphData[i] as Float / 2);
                dc.drawLine(x, $.Y_ZERO_LINE, x, $.Y_ZERO_LINE-graphData[i]  as Float);
            }
            _drawingDone = true;

            if (_stepsToShowInGraph > 96) {
                timeText = (_stepsToShowInGraph / 96) + "days";
            }

            $.drawTimeText(dc, timeText);
        }

    }

    // placed in a seperate function to make it testable
    public function getGraphData(stepsToShowInGraph as Integer) as Array? {
        var dataAarray = new [GRAPH_WIDTH];
        var batteryValue = 0;
        var circularBufferPosition = Storage.getValue($.CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V2) as Integer;
        if (circularBufferPosition == null) {
            return null;
        }
        var stepsPerPixelX = stepsToShowInGraph / GRAPH_WIDTH; // for now it must be dividable by 96

        for (var x = GRAPH_WIDTH-1; x >= 0; x -= 1) {
            batteryValue = 0;
            for (var avarageI = stepsPerPixelX; avarageI > 0; avarageI = avarageI-1) {
                var storageValue = Storage.getValue(circularBufferPosition) as Integer;

                if (storageValue == null) {
                    storageValue = 0;
                }
                batteryValue = batteryValue + storageValue;
                circularBufferPosition = circularBufferPosition - 1;
                if (circularBufferPosition < 0) {
                    circularBufferPosition = $.MAX_STEPS_TO_CALC;
                }
            }
            batteryValue = batteryValue / stepsPerPixelX;
            dataAarray[x] = batteryValue;
        }

        return dataAarray;
    }
    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    public function onHide() as Void {
    }
}
