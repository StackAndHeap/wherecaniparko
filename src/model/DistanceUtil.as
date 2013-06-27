package model {
public class DistanceUtil {

    private static const EARTH_RADIUS:int = 6371;

    public function DistanceUtil() {
    }

    public static function calculateDistance(from:Location, to:Location):Number {
        var dLat = degreesToRadians(to.latitude - from.latitude);
        var dLon = degreesToRadians(to.longitude - from.longitude);
        var lat1 = degreesToRadians(from.latitude);
        var lat2 = degreesToRadians(to.latitude);

        var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.sin(dLon / 2) * Math.sin(dLon / 2) * Math.cos(lat1) * Math.cos(lat2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        var result = EARTH_RADIUS * c;

        return result;
    }


    public static function degreesToRadians(degrees:Number):Number {
        return degrees * Math.PI / 180;
    }

    public static function radiansToDegrees(radians:Number):Number {
        return radians * 180 / Math.PI;
    }

}
}
