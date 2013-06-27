package model {
public class SpotState {

    public static const FREE:SpotState = new SpotState("Free");
    public static const OCCUPIED:SpotState = new SpotState("Occupied");

    private var _name:String;

    public function SpotState(name:String) {
        _name = name;
    }

    public static function fromName(name:String):SpotState {
        return (name == FREE._name) ? FREE : OCCUPIED;
    }
}
}
