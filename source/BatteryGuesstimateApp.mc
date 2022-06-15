import Toybox.Application;
import Toybox.Application.Storage;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Background;
import Toybox.System;
import Toybox.Time;

(:background)
const SIZE_CIRCULAR_BUFFER = 5;


(:background)
class BatteryGuesstimateApp extends Application.AppBase {

    //! Constructor
    public function initialize() {
        AppBase.initialize();
        if(Background.getTemporalEventRegisteredTime() != null) {
            Background.registerForTemporalEvent(new Time.Duration(15 * 60));
        }
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
        Storage.setValue("circular buffer last position", circularBufferPosition);
        System.println( circularBufferPosition );
        Background.exit(true);
    }
    

}

(:glance)
public function guesstimate() {
    var circularBufferPosition;
    var lastBatValue;
    var startCalculationBatValue;
    var result as Float;

    circularBufferPosition = Storage.getValue("circular buffer last position");
    if (circularBufferPosition == null) {
        return "no data";
    }
    lastBatValue = Storage.getValue("circular buffer " + circularBufferPosition);
    if (lastBatValue == null) {
        return "no data";
    }
    circularBufferPosition = circularBufferPosition - 1;
    if (circularBufferPosition < 0) {
        circularBufferPosition = SIZE_CIRCULAR_BUFFER;
    }
    startCalculationBatValue = Storage.getValue("circular buffer " + circularBufferPosition);
    if (startCalculationBatValue == null) {
        return "no data";
    }
    result = lastBatValue - startCalculationBatValue;
    if (result > 0) {
        return "+" + result + "%";
    } else {
        return result.toString() + "%";
    }
}
