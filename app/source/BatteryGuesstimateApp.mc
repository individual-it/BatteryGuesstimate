import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.System;
import Toybox.Time;
import Toybox.Math;
import Toybox.Communications;
using Toybox.Application.Properties;

(:glance)
const MAX_STEPS_TO_CALC = 24*4*14; // 14days
(:background :glance)
const SIZE_CIRCULAR_BUFFER = MAX_STEPS_TO_CALC+1; // 14days + 1 (so that we can actually calculate over 14days)
(:glance)
const MINUTES_IN_ONE_DAY = 1440;
(:background :glance)
const CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V1 = "circular buffer last position";
(:background :glance)
const CIRCULAR_BUFFER_STORAGE_NAME_PREFIX_V1 = "circular buffer ";
(:background :glance)
const CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V2 = "cBlP";

(:background :glance :typecheck([disableBackgroundCheck, disableGlanceCheck]))
class BatteryGuesstimateApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
        $.databaseMigration();
        Background.registerForTemporalEvent(new Time.Duration(15 * 60));
    }

    //! Handle app startup
    //! @param state Startup arguments
    public function onStart(state as Dictionary?) as Void {

    }

    //! Handle app shutdown
    //! @param state Shutdown arguments
    public function onStop(state as Dictionary?) as Void {
    }


   function getGlanceView(){
     return [ new $.BatteryGuesstimateGlanceView() ];
   }

    //! Return the initial view for the app
    //! @return Array Pair [View, Delegate]
    public function getInitialView() {
        var view;
        var delegate;
        if (System.getDeviceSettings().isGlanceModeEnabled == true) {
            view = new $.BatteryGuesstimateDetailsView();
            delegate = new $.BatteryGuesstimateDetailsDelegate(view);
        } else {
            view = new $.BatteryGuesstimateCarusellView();
            delegate =  new $.BatteryGuesstimateCarusellDelegate();
        }
        return [view, delegate];
    }

    public function getServiceDelegate() {
        return [new $.MyServiceDelegate()];
    }
}



// Your service delegate has to be marked as background
// so it can handle your service callbacks
(:background)
class MyServiceDelegate extends System.ServiceDelegate {

    (:background_method)
    public function initialize() {
     System.ServiceDelegate.initialize();
    }

    (:background_method)
    public function onTemporalEvent() as Void {
        System.println("onTemporalEvent");
        var circularBufferPosition;
        circularBufferPosition = Storage.getValue(CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V2) as Integer;
        System.println("circular buffer last position => " + circularBufferPosition);
        if (circularBufferPosition == null) {
            circularBufferPosition = 0;
        } else {
            circularBufferPosition = circularBufferPosition+1;
        }
        if (circularBufferPosition >= SIZE_CIRCULAR_BUFFER) {
            circularBufferPosition = 0;
        }
        var systemStats = System.getSystemStats();
        Storage.setValue(circularBufferPosition, systemStats.battery);
        System.println("circular buffer " + circularBufferPosition + " => " + systemStats.battery);
        Storage.setValue(CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V2, circularBufferPosition);

        var chargeNotification = 0;
        try {
            chargeNotification = Properties.getValue("charge-notification") as Integer;
        } catch (e) {
            // the key does not exist, nothing to do, the default is already 0
        }
        // getValue might still return a String
        // see https://forums.garmin.com/developer/connect-iq/f/discussion/327089/unhandled-exception-in-a-simple-if-statement/1587695#1587695
        chargeNotification = chargeNotification.toNumber();
        // toNumber might return null, see https://developer.garmin.com/connect-iq/api-docs/Toybox/Lang/String.html#toNumber-instance_function
        if (chargeNotification == null) {
            chargeNotification = 0;
        }

        if (systemStats.charging == true && chargeNotification > 0 && systemStats.battery >= chargeNotification) {
            Communications.openWebPage(
                    "http://battery-level-reached.garmin",
                {},
                {}
            );
        }
        Background.exit(true);
    }
    

}

(:glance)
public function getBattChangeInPercent(stepsOfHistory as Integer) as Float? {
    var circularBufferPosition;
    var lastBatValue;
    var startCalculationBatValue;

    if (stepsOfHistory > MAX_STEPS_TO_CALC) {
        return null;
    }
    System.println("calculating over " + stepsOfHistory);
    circularBufferPosition = Storage.getValue(CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V2) as Integer;
    System.println("   till position " + circularBufferPosition);

    if (circularBufferPosition == null) {
        return null;
    }
    lastBatValue = Storage.getValue(circularBufferPosition) as Float;
    if (lastBatValue == null) {
        return null;
    }
    circularBufferPosition = circularBufferPosition - stepsOfHistory;
    if (circularBufferPosition < 0) {
        circularBufferPosition = SIZE_CIRCULAR_BUFFER + circularBufferPosition;
    }
    System.println("   from position " + circularBufferPosition);
    startCalculationBatValue = Storage.getValue(circularBufferPosition) as Float;
    if (startCalculationBatValue == null) {
        return null;
    }
    return lastBatValue - startCalculationBatValue;
}

(:glance)
public function formatOutput(batteryChangeInPercent as Float) as String {
    if (batteryChangeInPercent == null) {
        return "no data";
    }
    return batteryChangeInPercent.format("%+0.2f") + "%";
}

(:glance)
public function guesstimate(percentChange as Float, minutes as Integer) as Integer? {
    if (percentChange == null || percentChange >= 0) {
        return null;
    }
    percentChange = percentChange * -1;
    return (System.getSystemStats().battery / percentChange * minutes).toNumber();
}

(:glance)
public function guesstimateFormat(minutes as Integer?) as String{
    if (minutes == null) {
        return "-";
    }

    if (minutes < 60) {
        return minutes + "m";
    } else if (minutes < MINUTES_IN_ONE_DAY * 3) {
        return Math.floor(minutes / 60) + "h";
    } else {
        return Math.floor(minutes / MINUTES_IN_ONE_DAY) + "d";
    }
}

(:glance)
public function timePeriodFormat(minutes as Integer, longFormat as Boolean) as String {
    var timeString = "";
    if (minutes > 1440) {
        timeString = minutes / 1440;
        if (longFormat) {
            timeString += "days";
        } else {
            timeString += "d";
        }
    } else if (minutes > 120) {
        timeString = minutes / 60;
        if (longFormat) {
            timeString += "hours";
        } else {
            timeString += "h";
        }
    } else {
        timeString = minutes + "min";
    }

    return timeString;
}

(:background :glance)
public function databaseMigration() as Boolean {
    var lastPosition = Storage.getValue(CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V1);
    if (lastPosition == null) {
        // nothing to do
        return true;
    }
    System.println("Migration of DB");
    System.println("   last position");

    // change keys of circular buffer
    Storage.setValue(CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V2, lastPosition);
    Storage.deleteValue(CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V1);
    var value;
    for (var x = 0; x <= $.SIZE_CIRCULAR_BUFFER; x++) {
        value = Storage.getValue(CIRCULAR_BUFFER_STORAGE_NAME_PREFIX_V1 + x);
        if (value != null) {
            System.println("   data " + x);
            Storage.setValue(x, value);
            Storage.deleteValue(CIRCULAR_BUFFER_STORAGE_NAME_PREFIX_V1 + x);
        }
    }

    // move data to new position of the circular buffer
    lastPosition = Storage.getValue(CIRCULAR_BUFFER_LAST_POSITION_STORAGE_NAME_V2) as Integer;
    for (var x = lastPosition + 1; x <= 97; x++) {
        var newPosition = x + 1248;
        System.println("   move data from position " + x + " to " + newPosition );
        value = Storage.getValue(x);
        Storage.setValue(newPosition, value);
        Storage.deleteValue(x);
    }
    return true;
}