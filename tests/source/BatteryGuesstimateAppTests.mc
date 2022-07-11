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
        [2, [ [1341, 9.2], [1342, 10.2], [1343, 11.2], [2, 8.200] ], 5, -2.0],  // over the end of the buffer
        [1345, [ [1344, 9.2], [1345, 10.2], ], 1, 1.0],
        [2, [ [1, 4.2], [2, 3.2], [1251, 0.2], ], 96, 3.0], // 24h
        [2, [ [1, 4.2], [2, 3.2], [3, 0.2], ], 1344, 3.0], // 14days

    ];
    var change;
    var result;
    for (var testCaseNo = 0; testCaseNo < testCases.size(); testCaseNo++) {
        logger.debug("case " + (testCaseNo+1) + " of " + testCases.size());
        Storage.setValue("cBlP", testCases[testCaseNo][0]);
        for (var i = 0; i < testCases[testCaseNo][1].size(); i++) {
            Storage.setValue(testCases[testCaseNo][1][i][0], testCases[testCaseNo][1][i][1]);
        }
        change = getBattChangeInPercent(testCases[testCaseNo][2]);
        assertEqualFloat(logger, change, testCases[testCaseNo][3]);
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
function databaseMigrationMigrationDone(logger as Logger) as Boolean {
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
    Storage.setValue("circular buffer 9", 9.90923);
    Storage.setValue("circular buffer 10", 10.90923);
    Storage.setValue("circular buffer 11", 11.90923);
    Storage.setValue("circular buffer 95", 95.90923);
    Storage.setValue("circular buffer 96", 96.90923);
    Storage.setValue("circular buffer 97", 97.90923);


    $.databaseMigration();
    var circularBuffer0 = Storage.getValue(0) as Float;
    var circularBuffer9 = Storage.getValue(9) as Float;
    var circularBuffer10 = Storage.getValue(10) as Float;
    var circularBuffer11 = Storage.getValue(11) as Float?;
    var circularBuffer95 = Storage.getValue(95) as Float?;
    var circularBuffer96 = Storage.getValue(96) as Float?;
    var circularBuffer97 = Storage.getValue(97) as Float?;
    var circularBuffer1259 = Storage.getValue(1259) as Float;
    var circularBuffer1343 = Storage.getValue(1343) as Float;
    var circularBuffer1344 = Storage.getValue(1344) as Float;
    var circularBuffer1345 = Storage.getValue(1345) as Float;

    assertEqualFloat(logger, circularBuffer0, 0.90923);
    assertEqualFloat(logger, circularBuffer9, 9.90923);
    assertEqualFloat(logger, circularBuffer10, 10.90923);
    assertEqualFloat(logger, circularBuffer1259, 11.90923);
    assertEqualFloat(logger, circularBuffer1343, 95.90923);
    assertEqualFloat(logger, circularBuffer1344, 96.90923);
    assertEqualFloat(logger, circularBuffer1345, 97.90923);
    if (
        circularBuffer11 == null &&
        circularBuffer95 == null &&
        circularBuffer96 == null &&
        circularBuffer97 == null
        
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
    var circularBuffer0 = Storage.getValue(0) as Float;
    var circularBuffer10 = Storage.getValue(10) as Float;
    var circularBuffer97 = Storage.getValue(97) as Float;

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
        Test.assertMessage(false, "expected " + expected + " actual " + actual);
    }
    return true;
}

function assertEqualFloat(logger as Logger, actual as Float, expected as Float) as Boolean {
    if (actual == null or expected == null) {
        logger.error("Float expected, null given");
    }
    var result = actual - expected;
    if ( result > 0.00001 || result < -0.00001 ) {
        Test.assertMessage(false, "expected " + expected + " actual " + actual);
    }
    return true;
}

// just run all tests and at the end there is a nice data set created for next manual tests
(:test)
function randomBattery(logger as Logger) as Boolean {
    var circularBufferPosition = 0;
    var fakeBatteryValue = 10.2123433;
    var rand;
    var rand2;
    var RAND_MAX = 2147483647.0;
    for (var i = 0; i <= SIZE_CIRCULAR_BUFFER; i++) {
        circularBufferPosition = Storage.getValue("cBlP") as Integer;
        if (circularBufferPosition == null) {
            circularBufferPosition = 0;
        } else {
            circularBufferPosition = circularBufferPosition+1;
        }
        if (circularBufferPosition >= SIZE_CIRCULAR_BUFFER) {
            circularBufferPosition = 0;
        }
        

        rand = Math.rand() / (RAND_MAX/5.0);
        rand2 = Math.rand() / (RAND_MAX/0.2);
        if ((fakeBatteryValue < 90 && i < 100) || (fakeBatteryValue < 80 && rand > 4.2 && i > 800 && i < 1000)) {
            fakeBatteryValue = fakeBatteryValue + rand;
        } else {
            fakeBatteryValue = fakeBatteryValue - rand2;
        }

        if (fakeBatteryValue > 100) {
            fakeBatteryValue = 100;
        }
        if (fakeBatteryValue < 10) {
            fakeBatteryValue = rand;
        }
        System.println("i " + i);
        System.println("rand " + rand);
        System.println("rand2 " + rand2);
        System.println("fakeBatteryValue " + fakeBatteryValue);
        Storage.setValue(circularBufferPosition, fakeBatteryValue);
        Storage.setValue("cBlP", circularBufferPosition);
    }
    return true;
}