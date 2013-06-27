package model {
	import mx.collections.ArrayCollection;

	public class Session {

		[Bindable]
		public static var parkings:ArrayCollection;

		[Bindable]
		public static var onlyShowFree:Boolean = false;

		[Bindable]
		public static var location:Location;

		public function Session() {
		}
	}
}
