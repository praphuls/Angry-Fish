package com.events  {
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class RemoveOtherFishes extends Event {
		
		public static var REMOVE_OTHER_FISHES:String = "removeOtherFishes";
		public var mcName:String;
		public var targetFish:MovieClip;
		
		public function RemoveOtherFishes(type:String,
										  mcName:String, 
										  targetFish:MovieClip=null, 
										  bubbles:Boolean=true, 
										  cancelable:Boolean=false) 
		{
			super(type,bubbles,cancelable);
			
			this.mcName = mcName;
			this.targetFish = targetFish;
		}

	}
	
}
