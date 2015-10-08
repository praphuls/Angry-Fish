package com.fishes.angryFishes  {
	
	import com.lakeview.LakeView;
	import flash.display.MovieClip;
	import com.Fish;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.utils.Utils;
	import com.model.FishSolvedModel;
	
	
	public class SmallFish_1 extends Fish {
		
		
		public function SmallFish_1() {
			// constructor code
			super(this);
			this.addEventListener("INACTIVE_THIS_FISH", inactiveMe);
			this.addEventListener("ACTIVE_THIS_FISH", activeMe);
			
			addRollListeners();
		}
		
		private function addRollListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, rollOn);
			this.addEventListener(MouseEvent.MOUSE_OUT, rolloff);
		}
		
		private function removeRollListeners():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, rollOn);
			this.removeEventListener(MouseEvent.MOUSE_OUT, rolloff);
		}
		
		private var newPop:MovieClip;
		private var lake:MovieClip = FishSolvedModel.getInstance().lakeMc;
		private function addToolTip():void
		{
			newPop = Utils.addMovieFromLibrary("FishPopUp", lake);
			Utils.animateMC(newPop, this);
			
			newPop.x = this.x;
			newPop.y = this.y;
		}
		
		private function removeToolTip():void
		{
			if (newPop)
			{
				lake.removeChild(newPop);
				newPop = null;
			}
		}
		
		private function rollOn(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, rollOn);
			addToolTip();
			
			removeActionsFromFish(this);
		}
		
		private function rolloff(e:MouseEvent=null):void
		{
			removeToolTip();
				
			addActionsToTheFish(this);
			addRollListeners();
		}
		
		private var inActivated:Boolean = false;
		private function inactiveMe(e:Event):void
		{
			removeActionsFromFish(this);
			removeRollListeners();
			
			removeToolTip();
		}
		
		private function activeMe(e:Event):void
		{
			addActionsToTheFish(this);
			addRollListeners();
		}
	}
	
}
