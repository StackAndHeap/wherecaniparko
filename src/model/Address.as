package model {

[Bindable]
public class Address {

    public var country:String;
    public var city:String;
    public var postalCode:String;
    public var street:String;
    public var number:String;

    public function Address() {
    }

    public static function getAddress(country:String, city:String, postalCode, street:String, number):Address {
        var result:Address = new Address();

        result.city = city;
        result.country = country;
        result.number = number;
        result.postalCode = postalCode;
        result.street = street;

        return result;
    }

    public function toString():String {
        return street + " " + number + ", " + postalCode + " " + city;
    }
}
}
