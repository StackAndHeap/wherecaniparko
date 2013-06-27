package model {
public class SpotState {

    public static const FREE:SpotState = new SpotState("Vrij");
    public static const OCCUPIED:SpotState = new SpotState("Bezet");

    private var _name:String;

    public function SpotState(name:String) {
        _name = name;
    }
}
}
