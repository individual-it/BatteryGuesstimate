import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.System;
import Toybox.Time;
import Toybox.Math;

(:background)
const SIZE_CIRCULAR_BUFFER = 97; // 24h + 1 (so that we can actually calculate over 24h)
const MAX_STEPS_TO_CALC = 96; // 24h
const MINUTES_IN_ONE_DAY = 1440;

(:background :glance)
class BatteryGuesstimateApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
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


   function getGlanceView() {
     return [ new BatteryGuesstimateGlanceView() ];
   }

    //! Return the initial view for the app
    //! @return Array Pair [View, Delegate]
    public function getInitialView() as Array<Views or InputDelegates>? {
        var view = new $.BatteryGuesstimateView();
        var delegate = new $.BatteryGuesstimateDelegate(view);
        return [view, delegate] as Array<Views or InputDelegates>;
    }

    public function getServiceDelegate() as Array<ServiceDelegate>{
        return [new $.MyServiceDelegate()] as Array<ServiceDelegate>;
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
        circularBufferPosition = Storage.getValue("circular buffer last position");
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
        Storage.setValue("circular buffer " + circularBufferPosition, systemStats.battery);
        System.println("circular buffer " + circularBufferPosition + " => " + systemStats.battery);
        Storage.setValue("circular buffer last position", circularBufferPosition);
        Background.exit(true);
    }
    

}

(:glance)
public function getBattChangeInPercent(stepsOfHistory as Integer) {
    var circularBufferPosition;
    var lastBatValue;
    var startCalculationBatValue;
    var result as Float;

    if (stepsOfHistory > MAX_STEPS_TO_CALC) {
        return null;
    }
    System.println("calculating over " + stepsOfHistory);
    circularBufferPosition = Storage.getValue("circular buffer last position");
    System.println("   till position " + circularBufferPosition);

    if (circularBufferPosition == null) {
        return null;
    }
    lastBatValue = Storage.getValue("circular buffer " + circularBufferPosition);
    if (lastBatValue == null) {
        return null;
    }
    circularBufferPosition = circularBufferPosition - stepsOfHistory;
    if (circularBufferPosition < 0) {
        circularBufferPosition = SIZE_CIRCULAR_BUFFER + circularBufferPosition;
    }
    System.println("   from position " + circularBufferPosition);
    startCalculationBatValue = Storage.getValue("circular buffer " + circularBufferPosition);
    if (startCalculationBatValue == null) {
        return null;
    }
    return lastBatValue - startCalculationBatValue;
}

(:glance)
public function formatOutput(batteryChangeInPercent as Float) {
    if (batteryChangeInPercent == null) {
        return "no data";
    }
    return batteryChangeInPercent.format("%+0.2f") + "%";
}

(:glance)
public function guesstimate(percentChange as Float, minutes as Integer) {
    if (percentChange == null || percentChange >= 0) {
        return null;
    }
    percentChange = percentChange * -1;
    return (System.getSystemStats().battery / percentChange * minutes).toNumber();
}

(:glance)
public function guesstimateFormat(minutes as Integer) {
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