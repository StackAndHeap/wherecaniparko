package model {
import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;

public class Session {

    [Bindable]
    public static var parkings:ArrayCollection = new ArrayCollection();

    [Bindable]
    public static var onlyShowFree:Boolean = false;

    [Bindable]
    public static var location:Location = new Location(50.827219, 3.254292);

    [Bindable]
    public static var showParkings:Boolean = true;

    [Bindable]
    public static var showShopAndGo:Boolean = true;

    public function Session() {
    }

}
}
