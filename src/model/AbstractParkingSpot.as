package model {

[Bindable]
public class AbstractParkingSpot {

    public var name:String;
    public var isFree:Boolean;
    public var location:Location;

    public var distance:Number;

    public function AbstractParkingSpot() {
    }
}
}
