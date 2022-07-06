import Toybox.Test;
import Toybox.Math;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;

(:test)
function getGraphDataOneDay(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    Storage.setValue("cBlP", 100);
    for (var i = 0; i<=100; i++) {
        Storage.setValue(i, i+0.123);
    }
    var graphData = view.getGraphData(96);
    Test.assertEqualMessage(graphData.size(), 96, "getGraphData should return an array of 96 values");
    for (var i = 0; i<96; i++) {
        var expected = i + 5.123 as Float;
        assertEqualFloat(logger, graphData[i], expected);
    }
    
    return true;
}

(:test)
function getGraphDataTwoWeeks(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    Storage.setValue("cBlP", 1344);
    for (var i = 0; i<SIZE_CIRCULAR_BUFFER; i++) {
        Storage.setValue(i, i.toFloat()/15);
    }
    var graphData = view.getGraphData(1344);
    Test.assertEqualMessage(graphData.size(), 96, "getGraphData should return an array of 96 values");
    assertEqualFloat(logger, graphData[95], 89.166672);
    assertEqualFloat(logger, graphData[0], 0.50);
    
    return true;
}

(:test)
function getGraphDataRollingOverBufferEnd(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    Storage.setValue("cBlP", 500);
    for (var i = 0; i<SIZE_CIRCULAR_BUFFER; i++) {
        Storage.setValue(i, i.toFloat()/15);
    }
    var graphData = view.getGraphData(1344);
    Test.assertEqualMessage(graphData.size(), 96, "getGraphData should return an array of 96 values");
    assertEqualFloat(logger, graphData[95], 32.9);
    assertEqualFloat(logger, graphData[0], 33.899998);

    return true;
}

(:test)
function getGraphDataNoData(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    var graphData = view.getGraphData(1344);
    if (graphData != null) {
        logger.error("getGraphData should return null");
        return false;
    }

    return true;
}

(:test)
function getGraphDataNotEnoughData(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    Storage.setValue("cBlP", 5);
    for (var i = 0; i<=5; i++) {
        Storage.setValue(i, 15.0);
    }
    var graphData = view.getGraphData(96);
    assertEqualFloat(logger, graphData[95], 15.0);
    assertEqualFloat(logger, graphData[94], 15.0);
    assertEqualFloat(logger, graphData[90], 15.0);
    assertEqualFloat(logger, graphData[89], 0.0);
    assertEqualFloat(logger, graphData[0], 0.0);

    graphData = view.getGraphData(384);
    assertEqualFloat(logger, graphData[95], 15.0);
    assertEqualFloat(logger, graphData[94], 7.50);
    assertEqualFloat(logger, graphData[93], 0.0);

    return true;
}