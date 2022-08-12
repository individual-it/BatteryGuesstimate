import Toybox.Test;
import Toybox.Math;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;
using Toybox.Graphics;

function getDc() as Graphics.Dc {
    var buffer = new Graphics.BufferedBitmap({:width=>162, :height=>162});
    return buffer.getDc();
}

(:test)
function onUpdateTestOneDay(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    Storage.setValue("cBlP", 100);
    for (var i = 0; i<=100; i++) {
        Storage.setValue(i, i+0.123);
    }
    view.onShow();
    // simulate what WatchUi.requestUpdate() will hopefully do
    for (var i = 0; i<96; i++) {
        view.onUpdate(getDc());
    }
    var graphData = view.getGraphData();
    Test.assertEqualMessage(graphData.size(), 96, "getGraphData should return an array of 96 values");
    for (var i = 0; i<96; i++) {
        var expected = i + 5.123 as Float;
        assertEqualFloat(logger, graphData[i] as Float, expected);
    }
    assertEqualFloat(logger, view.getMinBattValue(), 5.123);
    assertEqualFloat(logger, view.getMaxBattValue(), 100.123);
    assertEqualFloat(logger, view.getCumulatedDischarge(), 0.0);
    assertEqualFloat(logger, view.getCumulatedCharge(), 95.0);
    return true;
}

(:test)
function onUpdateTestOneDayDischarge(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    Storage.setValue("cBlP", 100);
    for (var i = 0; i<=100; i++) {
        Storage.setValue(i, 100-i+0.23);
    }
    view.onShow();
    // simulate what WatchUi.requestUpdate() will hopefully do
    for (var i = 0; i<96; i++) {
        view.onUpdate(getDc());
    }
    var graphData = view.getGraphData();
    Test.assertEqualMessage(graphData.size(), 96, "getGraphData should return an array of 96 values");
    for (var i = 0; i<96; i++) {
        var expected = 95.23-i as Float;
        assertEqualFloat(logger, graphData[i] as Float, expected);
    }
    assertEqualFloat(logger, view.getMinBattValue(), 0.23);
    assertEqualFloat(logger, view.getMaxBattValue(), 95.23);
    assertEqualFloat(logger, view.getCumulatedDischarge(), 95.0);
    assertEqualFloat(logger, view.getCumulatedCharge(), 0.0);
    return true;
}

(:test)
function onUpdateTestTwoWeeks(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    Storage.setValue("cBlP", 1344);
    for (var i = 0; i<SIZE_CIRCULAR_BUFFER; i++) {
        Storage.setValue(i, i.toFloat()/15);
    }
    view.onShow();
    view.setStepsToShowInGraph(1344);
    // simulate what WatchUi.requestUpdate() will hopefully do
    for (var i = 0; i<96; i++) {
        view.onUpdate(getDc());
    }
    var graphData = view.getGraphData();
    Test.assertEqualMessage(graphData.size(), 96, "getGraphData should return an array of 96 values");
    assertEqualFloat(logger, graphData[95] as Float, 89.166672);
    assertEqualFloat(logger, graphData[0] as Float, 0.50);
    assertEqualFloat(logger, view.getMinBattValue(), 0.50);
    assertEqualFloat(logger, view.getMaxBattValue(), 89.166672);
    return true;
}

(:test)
function onUpdateTestRollingOverBufferEnd(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    Storage.setValue("cBlP", 500);
    for (var i = 0; i<SIZE_CIRCULAR_BUFFER; i++) {
        Storage.setValue(i, i.toFloat()/15);
    }
    view.onShow();
    view.setStepsToShowInGraph(1344);
    // simulate what WatchUi.requestUpdate() will hopefully do
    for (var i = 0; i<96; i++) {
        view.onUpdate(getDc());
    }
    var graphData = view.getGraphData();
    Test.assertEqualMessage(graphData.size(), 96, "getGraphData should return an array of 96 values");
    assertEqualFloat(logger, graphData[95] as Float, 32.9);
    assertEqualFloat(logger, graphData[0] as Float, 33.899998);
    return true;
}

(:test)
function onUpdateTestNoData(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    view.onShow();
    view.setStepsToShowInGraph(1344);
    view.onUpdate(getDc());
    var graphData = view.getGraphData();
    Test.assertEqualMessage(graphData.size(), 96, "getGraphData should return an array of 96 values");
    if (graphData[0] != null || graphData[95] != null) {
        logger.error("content of graphData should return null");
        return false;
    }
    return true;
}

(:test)
function onUpdateTestNotEnoughData(logger as Logger) as Boolean {
    var view = new BatteryGuesstimateView();
    Storage.clearValues();
    Storage.setValue("cBlP", 5);
    for (var i = 0; i<=5; i++) {
        Storage.setValue(i, 15.0);
    }
    view.onShow();
    view.setStepsToShowInGraph(96);
    // simulate what WatchUi.requestUpdate() will hopefully do
    for (var i = 0; i<96; i++) {
        view.onUpdate(getDc());
    }
    var graphData = view.getGraphData();
    assertEqualFloat(logger, graphData[95] as Float, 15.0);
    assertEqualFloat(logger, graphData[94] as Float, 15.0);
    assertEqualFloat(logger, graphData[90] as Float, 15.0);
    assertEqualFloat(logger, graphData[89] as Float, 0.0);
    assertEqualFloat(logger, graphData[0] as Float, 0.0);

    view.setStepsToShowInGraph(384);
    for (var i = 0; i<96; i++) {
        view.onUpdate(getDc());
    }
    graphData = view.getGraphData();
    assertEqualFloat(logger, graphData[95] as Float, 15.0);
    assertEqualFloat(logger, graphData[94] as Float, 7.50);
    assertEqualFloat(logger, graphData[93] as Float, 0.0);
    return true;
}