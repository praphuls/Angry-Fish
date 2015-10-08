package com.events  {
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class AddPopUp extends Event{

		public static var ADD_POPUP:String = "addpopup";
		public static var ALIGN_POPUP:String = "alignpopup";
		
		public var popupType:MovieClip;
		public function AddPopUp( 	type:String,
									popUpType:MovieClip=null,
									bubbles:Boolean=true, 
									cancelable:Boolean=false)  
		{
			super(type, bubbles, cancelable);
			popupType = popUpType;
		}

	}
	
}
