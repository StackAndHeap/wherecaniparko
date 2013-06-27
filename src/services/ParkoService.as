package services {
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.collections.ArrayCollection;

public class ParkoService {

    private static var SHOP_AND_GO_URL:String = "http://data.drk.be/parko/shopandgo.json";

    public var parkingSpots:ArrayCollection;

    public function ParkoService() {
        getParkoData();
    }

    private function getParkoData():void {
        var loader:URLLoader = new URLLoader(new URLRequest(SHOP_AND_GO_URL));
        loader.addEventListener(Event.COMPLETE, loader_completeHandler);
    }

    private function loader_completeHandler(event:Event):void {
        var result:* = event.currentTarget.data;
        
        var parseData:Object = JSON.parse(result);

        for each (var object:Object in parseData) {

        }
    }
}
}
