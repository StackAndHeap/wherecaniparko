package model {
	import mx.collections.ArrayCollection;

	public class Session {

		[Bindable]
		public static var parkings:ArrayCollection = new ArrayCollection();

		[Bindable]
		public static var onlyShowFree:Boolean = false;

		[Bindable]
		public static var location:Location;

		[Bindable]
		public static var showParkings:Boolean = true;

		[Bindable]
		public static var showShopAndGo:Boolean = true;

		public function Session() {
		}
	}
}
