import Toybox.Lang;
import Toybox.WatchUi;
using Toybox.Application.Properties;

class BatteryGuesstimateDelegate extends WatchUi.BehaviorDelegate {
    var _view as BatteryGuesstimateView;
    public function initialize(view as BatteryGuesstimateView) {
        _view = view;
        WatchUi.BehaviorDelegate.initialize();
    }

    //! @return true if handled, false otherwise
    public function onNextPage() as Boolean {
        var stepsToShowInGraph = _view.getStepsToShowInGraph();
        switch (stepsToShowInGraph) {
            case 96:
                stepsToShowInGraph = 192;
                break;
            case 192:
                stepsToShowInGraph = 672;
                break;
            case 672:
                stepsToShowInGraph = 1344;
                break;
            default:
                stepsToShowInGraph = 96;
        }
        _view.setStepsToShowInGraph(stepsToShowInGraph);
        return true;
    }

    //! @return true if handled, false otherwise
    public function onPreviousPage() as Boolean {
        var stepsToShowInGraph = _view.getStepsToShowInGraph();
        switch (stepsToShowInGraph) {
            case 192:
                stepsToShowInGraph = 96;
                break;
            case 672:
                stepsToShowInGraph = 192;
                break;
            case 1344:
                stepsToShowInGraph = 672;
                break;
            default:
                stepsToShowInGraph = 1344;
        }
        _view.setStepsToShowInGraph(stepsToShowInGraph);
        return true;
    }

    public function onSelect() as Boolean {
        makeRequest();
        return true;
    }

    // set up the response callback function
    public function onReceive(responseCode as Number, data as Dictionary or String or Null) as Void{
        if (responseCode >= 200 && responseCode < 299) {
            _view.setMessage("Done!");
        } else {
            _view.setMessage("ERROR\n'" + responseCode + "'");
            Communications.openWebPage("https://github.com/individual-it/BatteryGuesstimate/#export", null, null);
        }
        WatchUi.requestUpdate();
    }

    private function makeRequest() as Void {
        var url = "";
        var username = "";
        var password = "";
        try {
            url = Properties.getValue("export-url") as String;
        } catch (e) {
            // the key does not exist, nothing to do, the default is already ""
        }
        try {
            username = Properties.getValue("export-username") as String;
        } catch (e) {
            // the key does not exist, nothing to do, the default is already ""
        }
        try {
            password = Properties.getValue("export-password") as String;
        } catch (e) {
            // the key does not exist, nothing to do, the default is already ""
        }
        if (!url.equals("")) {
            var protocol = url.substring(0,8);
            if (protocol == null || !protocol.equals("https://")) {
                _view.setMessage("URL must start with\n'https://'");
                WatchUi.requestUpdate();
                return;
            }
            var headers = {"Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON};

            if (username != "" || password != "") {
                headers.put("Authorization", "Basic " + Toybox.StringUtil.encodeBase64(username + ":" + password));
            }
            var params = {"battery-history" => _view.getPartOfStorageBuffer(_view.getStepsToShowInGraph())};
            var options = {
                :method => Communications.HTTP_REQUEST_METHOD_PUT,
                :headers => headers,
            };
            _view.setMessage("sending...");
            WatchUi.requestUpdate();
            Communications.makeWebRequest(url, params, options, method(:onReceive));
        }
    }
}