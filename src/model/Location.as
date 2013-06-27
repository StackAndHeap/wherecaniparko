package model {
public class Location {

    public var longitude:Number;
    public var latitude:Number;

    public function Location(latitude:Number, longitude:Number) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

	public function toString():String {
		return "Location(" + latitude + ", " + longitude + ")";
	}

}
}
