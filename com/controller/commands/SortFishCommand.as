package com.controller.commands
{
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SortFishCommand extends MovieClip implements ICommand
	{
		private var fishArray:Array = ["com.fishes.angryFishes.SmallFish_1", 
									   "com.fishes.angryFishes.AngryFish_2", 
									   "com.fishes.angryFishes.AngryFish_3", 
									   "com.fishes.angryFishes.AngryFish_4", 
									   "com.fishes.angryFishes.AngryFish_5"];
		
		private var myFishArray:Array = ["com.fishes.myFishes.MySmallFish_1", 
									  	 "com.fishes.myFishes.MyAngryFish_2", 
									  	 "com.fishes.myFishes.MyAngryFish_3", 
									   	 "com.fishes.myFishes.MyAngryFish_4", 
									     "com.fishes.myFishes.MyAngryFish_5"];
		
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function SortFishCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			extractFishes();
		}
		
		public function callBackCommand(obj:Object):void
		{
			FishSolvedModel.getInstance().lakeMc.putSortedFishInLake();
		}
		
		private function extractFishes():void
		{
			var array:Array = model.sortedFishArray;
			var fishArrLen:Number = array.length;

			model.sortedFishesInLake = new Array();
			
			for (var i:Number = 0; i < fishArrLen; i++)
			{
				var fishLevel:Number = array[i].fishLevel as Number;

				var type:Boolean = array[i].isOwner as Boolean;
				
				if(!type)
					model.sortedFishesInLake.push(fishArray[fishLevel-1]);
				else
					model.sortedFishesInLake.push(myFishArray[fishLevel-1]);
			}
			callBackCommand(null)
		}	
	}
	
}