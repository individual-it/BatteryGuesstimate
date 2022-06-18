import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.System;
import Toybox.Time;

(:background)
const SIZE_CIRCULAR_BUFFER = 96;


(:background :glance)
class BatteryGuesstimateApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
        System.println("App initialize");
        Background.registerForTemporalEvent(new Time.Duration(15 * 60));
        System.println("registerForTemporalEvent");
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
     System.println("System.ServiceDelegate.initialize");
    }

    (:background_method)
    public function onTemporalEvent() as Void {
        System.println("onTemporalEvent");
        var circularBufferPosition;
        circularBufferPosition = Storage.getValue("circular buffer last position");
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
        System.println("circular buffer last position => " + circularBufferPosition);
        System.println( circularBufferPosition );
        Background.exit(true);
    }
    

}

(:glance)
public function guesstimate(stepsOfHistory as Integer) {
    var circularBufferPosition;
    var lastBatValue;
    var startCalculationBatValue;
    var result as Float;

    if (stepsOfHistory > SIZE_CIRCULAR_BUFFER) {
        return "no data";
    }
    circularBufferPosition = Storage.getValue("circular buffer last position");
    if (circularBufferPosition == null) {
        return "no data";
    }
    lastBatValue = Storage.getValue("circular buffer " + circularBufferPosition);
    if (lastBatValue == null) {
        return "no data";
    }
    circularBufferPosition = circularBufferPosition - stepsOfHistory;
    if (circularBufferPosition < 0) {
        circularBufferPosition = SIZE_CIRCULAR_BUFFER + circularBufferPosition;
    }
    startCalculationBatValue = Storage.getValue("circular buffer " + circularBufferPosition);
    if (startCalculationBatValue == null) {
        return "no data";
    }
    result = lastBatValue - startCalculationBatValue;
    return result.format("%+0.2f") + "%";
}
