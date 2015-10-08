package com.events  {
	import flash.events.Event;
	
	public class AddActions extends Event {
		
		public static var ADD_ACTIONS_TO_FISHES:String = "addActionsToFishes";
		public static var ADD_COMMENTS_TO_AQUA:String = "addcommnetsToAqua";
		
		public function AddActions( type:String,
									  bubbles:Boolean=true, 
									  cancelable:Boolean=false)  
		{
			super(type,bubbles,cancelable);
		}

	}
	
}
