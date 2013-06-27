package services {
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;

import model.Address;
import model.ParkingSpot;
import model.ShopAndGoSpot;
import model.SpotState;

import mx.collections.ArrayCollection;

public class ParkoService {

    private static var SHOP_AND_GO_URL:String = "http://data.drk.be/parko/shopandgo.json";
    private static var BEZETTING_PARKINGS:String = "http://data.drk.be/parko/bezettingparkings.json";

    private static const P_VEEMARKT:String = "P Veemarkt";
    private static const P_TACK:String = "P Tack";
    private static const P_BROELTORENS:String = "P Broeltorens";
    private static const P_SCHOUWBURG:String = "P Schouwburg";

    private var _lattitudes:Array = [];
    private var _longitudes:Array = [];
    private var _addresses:Array = [];

    [Bindable]
    public var parkingSpots:ArrayCollection = new ArrayCollection();


    public function ParkoService() {
        getShopAndGoData();
        getBezettingData();

        _addresses[P_VEEMARKT] = Address.getAddress("Belgium", "Kortrijk", "8500", "Veemarkt", "");
        _addresses[P_TACK] = Address.getAddress("Belgium", "Kortrijk", "8500", "Minister Tacklaan", "");
        _addresses[P_BROELTORENS] = Address.getAddress("Belgium", "Kortrijk", "8500", "Damkaai", "");
        _addresses[P_SCHOUWBURG] = Address.getAddress("Belgium", "Kortrijk", "8500", "Schouwburgplein", "");

        _lattitudes[P_VEEMARKT] = 50.8312216768968;
        _lattitudes[P_TACK] = 50.82365689950371;
        _lattitudes[P_BROELTORENS] = 50.8312216768968;
        _lattitudes[P_SCHOUWBURG] = 50.82612384626342;

        _longitudes[P_VEEMARKT] = 3.268091527309480;
        _longitudes[P_TACK] = 3.261152652587953;
        _longitudes[P_BROELTORENS] = 3.268091527309480;
        _longitudes[P_SCHOUWBURG] = 3.26671018966681;
    }

    private function getBezettingData():void {
        var bezettingDataLoader:URLLoader = new URLLoader(new URLRequest(BEZETTING_PARKINGS));
        bezettingDataLoader.addEventListener(Event.COMPLETE, bezettingDataLoader_completeHandler);
    }

    private function getShopAndGoData():void {
        var shopAndGoDataLoader:URLLoader = new URLLoader(new URLRequest(SHOP_AND_GO_URL));
        shopAndGoDataLoader.addEventListener(Event.COMPLETE, shopAndGoDataLoader_completeHandler);
    }

    private function shopAndGoDataLoader_completeHandler(event:Event):void {
        var parseData:Object = JSON.parse(event.currentTarget.data);

        for each (var object:Object in parseData.shopandgo.Sensor) {
            var shopAndGoSpot:ShopAndGoSpot = new ShopAndGoSpot();
            shopAndGoSpot.name = object._Street;
            shopAndGoSpot.lat = convertDegreesToDecimal(object._Lat); // "50 49'32.62"N" Degrees + minutes/60 + seconds/3600
            shopAndGoSpot.long = convertDegreesToDecimal(object._Long); // "3 15'41.83"O"
            shopAndGoSpot.bayNumber = object._Parkingbay;
            shopAndGoSpot.isFree = object._State == "Free";

            parkingSpots.addItem(shopAndGoSpot);
        }
    }

    private function convertDegreesToDecimal(value:String):Number {
        var parts:Array = value.split(" ");

        var degrees:Number = parts[0];
        var minutes:Number = parts[1].split("'")[0];
        var seconds:Number = parts[1].split("'")[1].split("\"")[0];

        return degrees + minutes / 60 + seconds / 3600;
    }

    private function bezettingDataLoader_completeHandler(event:Event):void {
        var parseData:Object = JSON.parse(event.currentTarget.data);

        for each (var object:Object in parseData.bezettingparkings.parking) {
            var parkingSpot:ParkingSpot = new ParkingSpot();
            parkingSpot.name = object.parking;
            parkingSpot.lat = _lattitudes[parkingSpot.name];
            parkingSpot.long = _longitudes[parkingSpot.name];
            parkingSpot.isFree = (parkingSpot.numFree) ? SpotState.FREE : SpotState.OCCUPIED;
            parkingSpot.numFree = object._vrij;
            parkingSpot.numOccupied = object._bezet;
            parkingSpot.capacity = object._capaciteit;

            parkingSpot.address = _addresses[parkingSpot.name];

            parkingSpots.addItem(parkingSpot);
        }
    }
}
}
