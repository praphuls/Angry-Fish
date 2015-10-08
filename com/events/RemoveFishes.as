package com.events {
	
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class RemoveFishes extends Event {
		
		public static var REMOVE_FISHES:String = "removeFishes";
		public static var DELETE_MY_FISHES:String = "deleteFishes";
		
		public var targetFish:MovieClip;
		public var popUp:MovieClip;
		
		public function RemoveFishes( type:String, targetFish:MovieClip=null, popUp:MovieClip=null,
									  bubbles:Boolean=true, 
									  cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			this.targetFish = targetFish;
			this.popUp = popUp;
		}

	}
	
}
