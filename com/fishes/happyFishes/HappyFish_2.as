package com.fishes.happyFishes  {
	
	import com.model.AppModel;
	import flash.display.MovieClip;
	import com.Fish;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.utils.Utils;
	import com.model.FishSolvedModel;
	
	
	public class HappyFish_2 extends Fish 
	{
		
		
		public function HappyFish_2() 
		{
			super(this);
			
			this.addEventListener("INACTIVE_THIS_FISH", inactiveMe);
			this.addEventListener("ACTIVE_THIS_FISH", activeMe);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onOut);
		}		
		
		private function inactiveMe(e:Event):void
		{
			trace("hi..")
			removeActionsFromFish(this);
			this.removeEventListener(MouseEvent.ROLL_OVER, onOver);
			this.removeEventListener(MouseEvent.ROLL_OUT, onOut);
		}
		
		private function activeMe(e:Event):void
		{
			addActionsToTheFish(this);
			
			this.addEventListener(MouseEvent.ROLL_OVER, onOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onOut);
		}
		
		private function onOver(e:MouseEvent):void
		{
			removeActionsFromFish(this);
		}
		
		private function onOut(e:MouseEvent):void
		{
			addActionsToTheFish(this);
		}
	}
	
}
