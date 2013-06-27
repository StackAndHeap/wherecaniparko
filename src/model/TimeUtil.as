package model {
public class TimeUtil {

    public static function convertToHHMMSS(seconds:uint):String {
        var hours:uint = Math.floor(seconds / 3600);
        var minutes:uint = (seconds - (hours * 3600)) / 60;
        var seconds:uint = seconds - (hours * 3600) - (minutes * 60);

        var hourStr:String = (hours == 0) ? "" : doubleDigitFormat(hours) + ":";
        var minuteStr:String = doubleDigitFormat(minutes) + ":";
        var secondsStr:String = doubleDigitFormat(seconds);

        return hourStr + minuteStr + secondsStr;
    }

    private static function doubleDigitFormat(value:uint):String {
        if (value < 10) {
            return ("0" + value);
        }
        return String(value);
    }
}
}
