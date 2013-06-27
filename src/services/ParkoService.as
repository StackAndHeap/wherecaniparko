package services {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Dictionary;
import flash.utils.Timer;

import model.AbstractParkingSpot;
import model.Address;
import model.DistanceUtil;
import model.Location;
import model.ParkingSpot;
import model.Session;
import model.ShopAndGoSpot;
import model.SpotState;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;

public class ParkoService {

    private static var SHOP_AND_GO_URL:String = "http://data.drk.be/parko/shopandgo.json";
    private static var BEZETTING_PARKINGS:String = "http://data.drk.be/parko/bezettingparkings.json";

    private static const P_VEEMARKT:String = "P Veemarkt";
    private static const P_TACK:String = "P Tack";
    private static const P_BROELTORENS:String = "P Broeltorens";
    private static const P_SCHOUWBURG:String = "P Schouwburg";

    private var _latitudes:Array = [];
    private var _longitudes:Array = [];
    private var _addresses:Array = [];

    private var _updateTimer:Timer;

    [Bindable]
    public var parkingSpots:ArrayCollection;


    private var _parkingSpotLookup:Dictionary = new Dictionary();


    public function ParkoService() {
        initialize();
    }

    private function startUpdateTimer():void {
        _updateTimer = new Timer(15000);
        _updateTimer.addEventListener(TimerEvent.TIMER, updateTimer_timerHandler);
        _updateTimer.addEventListener(TimerEvent.TIMER_COMPLETE, updateTimer_timerCompleteHandler);
        _updateTimer.start();
    }

    private function initialize():void {
        _addresses[P_VEEMARKT] = Address.getAddress("Belgium", "Kortrijk", "8500", "Veemarkt", "");
        _addresses[P_TACK] = Address.getAddress("Belgium", "Kortrijk", "8500", "Minister Tacklaan", "");
        _addresses[P_BROELTORENS] = Address.getAddress("Belgium", "Kortrijk", "8500", "Damkaai", "");
        _addresses[P_SCHOUWBURG] = Address.getAddress("Belgium", "Kortrijk", "8500", "Schouwburgplein", "");

        _latitudes[P_VEEMARKT] = 50.8312216768968;
        _latitudes[P_TACK] = 50.82365689950371;
        _latitudes[P_BROELTORENS] = 50.8312216768968;
        _latitudes[P_SCHOUWBURG] = 50.82612384626342;

        _longitudes[P_VEEMARKT] = 3.268091527309480;
        _longitudes[P_TACK] = 3.261152652587953;
        _longitudes[P_BROELTORENS] = 3.268091527309480;
        _longitudes[P_SCHOUWBURG] = 3.26671018966681;

        parkingSpots = new ArrayCollection();

        var sort:Sort = new Sort();
        sort.fields = [new SortField("distance", true, false, true)];

        parkingSpots.sort = sort;
        parkingSpots.refresh();

        getRemoteData();
        startUpdateTimer();

        Session.parkings = parkingSpots;
	    Session.parkings.filterFunction = function(item:AbstractParkingSpot):Boolean {
		    if (Session.onlyShowFree) {
			    if (!item.isFree) {
				    return false;
			    }
		    }

		    if ((item is ParkingSpot) && Session.showParkings) {
			    return true;
		    } else if ((item is ShopAndGoSpot) && Session.showShopAndGo) {
			    return true;
		    }

		    return false;
	    }
    }

    private function getRemoteData():void {
        getShopAndGoData();
        getBezettingData();
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
            shopAndGoSpot.location = new Location(convertDegreesToDecimal(object._Lat), convertDegreesToDecimal(object._Long)); // "50 49'32.62"N" Degrees + minutes/60 + seconds/3600
            shopAndGoSpot.bayNumber = object._Parkingbay;
            shopAndGoSpot.isFree = object._State == "Free";

            addOrdUpdateParkingSpot(shopAndGoSpot);
        }
    }

    private function bezettingDataLoader_completeHandler(event:Event):void {
        var parseData:Object = JSON.parse(event.currentTarget.data);

        for each (var object:Object in parseData.bezettingparkings.parking) {
            var parkingSpot:ParkingSpot = new ParkingSpot();
            parkingSpot.name = object.parking;
            parkingSpot.location = new Location(_latitudes[parkingSpot.name], _longitudes[parkingSpot.name]); // "50 49'32.62"N" Degrees + minutes/60 + seconds/3600
            parkingSpot.isFree = (parkingSpot.numFree) ? SpotState.FREE : SpotState.OCCUPIED;
            parkingSpot.numFree = object._vrij;
            parkingSpot.numOccupied = object._bezet;
            parkingSpot.capacity = object._capaciteit;

            parkingSpot.address = _addresses[parkingSpot.name];

            addOrdUpdateParkingSpot(parkingSpot);
        }
    }


    private function addOrdUpdateParkingSpot(parkingSpot:AbstractParkingSpot):void {
        var key:String = createLookupKey(parkingSpot);
        var existingParkingSpot:AbstractParkingSpot = _parkingSpotLookup[key];

        if (existingParkingSpot) {
            existingParkingSpot.isFree = parkingSpot.isFree;

            if (existingParkingSpot is ParkingSpot) {
                ParkingSpot(existingParkingSpot).capacity = ParkingSpot(parkingSpot).capacity;
                ParkingSpot(existingParkingSpot).numFree = ParkingSpot(parkingSpot).numFree;
                ParkingSpot(existingParkingSpot).numOccupied = ParkingSpot(parkingSpot).numOccupied;
            }
        } else {
            parkingSpots.addItem(parkingSpot);
            _parkingSpotLookup[key] = parkingSpot;
        }

        parkingSpot.distance = DistanceUtil.calculateDistance(Session.location, parkingSpot.location);
        parkingSpots.refresh();
    }

    private function createLookupKey(parkingSpot:AbstractParkingSpot):String {
        var result:String = parkingSpot.name;

        if (parkingSpot is ShopAndGoSpot) {
            result += ShopAndGoSpot(parkingSpot).bayNumber;
        }

        return result;
    }

    private function convertDegreesToDecimal(value:String):Number {
        var parts:Array = value.split(" ");

        var degrees:Number = parts[0];
        var minutes:Number = parts[1].split("'")[0];
        var seconds:Number = parts[1].split("'")[1].split("\"")[0];

        return degrees + minutes / 60 + seconds / 3600;
    }

    private function updateTimer_timerHandler(event:TimerEvent):void {
        getRemoteData();
    }

    private function updateTimer_timerCompleteHandler(event:TimerEvent):void {
    }
}
}
