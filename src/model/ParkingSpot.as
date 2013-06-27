package model {

[Bindable]
public class ParkingSpot extends AbstractParkingSpot {

    public var numOccupied:int;
    public var numFree:int;
    public var capacity:int;

    public var address:Address;

    public function ParkingSpot() {
    }
}
}
