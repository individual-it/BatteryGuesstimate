import Toybox.Test;
import Toybox.Math;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.System;

(:test)
function getBattChangeInPercentTest(logger as Logger) as Boolean {
    Storage.clearValues();
    var testCases = 
    [ 
        // 0 => circular buffer last position
        // 1 => array of circular buffer [position, value]
        // 2 => steps to calculate
        // 3 => expected result
        [1, [ [0, 10.123], [1, 9.100] ], 1, -1.023000],
        [1, [ [0, 10.123], [1, 12.123] ], 1, 2.0], // charging
        [2, [ [93, 9.2], [94, 10.2], [95, 11.2], [2, 8.200] ], 5, -2.0],  // over the end of the buffer
        [97, [ [96, 9.2], [97, 10.2], ], 1, 1.0],
        [2, [ [1, 4.2], [2, 3.2], [3, 0.2], ], 96, 3.0], // 24h

    ];
    var change;
    var result;
    for (var testCaseNo = 0; testCaseNo < testCases.size(); testCaseNo++) {
        logger.debug("case " + (testCaseNo+1) + " of " + testCases.size());
        Storage.setValue("cBlP", testCases[testCaseNo][0]);
        for (var i = 0; i < testCases[testCaseNo][1].size(); i++) {
            Storage.setValue("cB" + testCases[testCaseNo][1][i][0], testCases[testCaseNo][1][i][1]);
        }
        change = getBattChangeInPercent(testCases[testCaseNo][2]);
        if (assertEqualFloat(logger, change, testCases[testCaseNo][3]) == false) {
            return false;
        }
    }
    return true;

}

(:test)
function databaseMigrationLastPosition(logger as Logger) as Boolean {
    Storage.clearValues();
    Storage.setValue("circular buffer last position", 10);
    $.databaseMigration();
    var circularBufferPosition = Storage.getValue("cBlP") as Integer;
    return assertEqual(logger, circularBufferPosition, 10);
}

(:test)
function databaseMigrationLastPositionNoMigration(logger as Logger) as Boolean {
    Storage.clearValues();
    Storage.setValue("cBlP", 13);
    $.databaseMigration();
    var circularBufferPosition = Storage.getValue("cBlP") as Integer;
    return assertEqual(logger, circularBufferPosition, 13);
}

(:test)
function databaseMigrationDataMigration(logger as Logger) as Boolean {
    Storage.clearValues();
    Storage.setValue("circular buffer last position", 10);
    Storage.setValue("circular buffer 0", 0.90923);
    Storage.setValue("circular buffer 10", 10.90923);
    Storage.setValue("circular buffer 97", 97.90923);

    $.databaseMigration();
    var circularBuffer0 = Storage.getValue("cB0") as Float;
    var circularBuffer10 = Storage.getValue("cB10") as Float;
    var circularBuffer97 = Storage.getValue("cB97") as Float;

    if (
        assertEqualFloat(logger, circularBuffer0, 0.90923) &&
        assertEqualFloat(logger, circularBuffer10, 10.90923) &&
        assertEqualFloat(logger, circularBuffer97, 97.90923)
    ) {
        return true;
    }
    return false;
}


(:test)
function databaseMigrationOldDataClearing(logger as Logger) as Boolean {
    Storage.clearValues();
    Storage.setValue("circular buffer last position", 10);
    Storage.setValue("circular buffer 0", 0.90923);
    Storage.setValue("circular buffer 10", 10.90923);
    Storage.setValue("circular buffer 97", 97.90923);

    $.databaseMigration();
    var circularBuffer0 = Storage.getValue("cB0") as Float;
    var circularBuffer10 = Storage.getValue("cB10") as Float;
    var circularBuffer97 = Storage.getValue("cB97") as Float;

    if (Storage.getValue("circular buffer last position") != null) {
        logger.error("circular buffer last position is not cleared");
        return false;
    }
    if (
        Storage.getValue("circular buffer 0") != null ||
        Storage.getValue("circular buffer 10") != null ||
        Storage.getValue("circular buffer 97") != null
    ) {
        logger.error("circular buffer data is not cleared");
        return false;
    }
    return true;
}

function assertEqual(logger as Logger, actual as Integer?, expected as Integer?) as Boolean {
    if ( actual != expected ) {
        logger.error("expected " + expected + " actual " + actual);
        return false;
    }
    return true;
}

function assertEqualFloat(logger as Logger, actual as Float, expected as Float) as Boolean {
    if (actual == null or expected == null) {
        logger.error("Float expected, null given");
    }
    var result = actual - expected;
    if ( result > 0.00001 || result < -0.00001 ) {
        logger.error("expected " + expected + " actual " + actual);
        return false;
    }
    return true;
}

// just run all tests and at the end there is a nice data set created for next manual tests
(:test)
function randomBattery(logger as Logger) as Boolean {
    var circularBufferPosition = 0;
    var fakeBatteryValue = 10.2123433;
    var rand;
    var RAND_MAX = 2147483647.0;
    for (var i = 0; i <= SIZE_CIRCULAR_BUFFER; i++) {
        circularBufferPosition = Storage.getValue("circular buffer last position") as Integer;
        if (circularBufferPosition == null) {
            circularBufferPosition = 0;
        } else {
            circularBufferPosition = circularBufferPosition+1;
        }
        if (circularBufferPosition >= SIZE_CIRCULAR_BUFFER) {
            circularBufferPosition = 0;
        }
        
        Storage.setValue("circular buffer " + circularBufferPosition, fakeBatteryValue);
        Storage.setValue("circular buffer last position", circularBufferPosition);
        rand = Math.rand() / (RAND_MAX/3.0);
        if (fakeBatteryValue < 90 && i < 20) {
            fakeBatteryValue = fakeBatteryValue + (rand * 10);
        } else {
            fakeBatteryValue = fakeBatteryValue - (rand / 2);
        }
    }
    return true;
}