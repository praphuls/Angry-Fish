package com.controller.commands
{
	import com.events.ApplicationEvent;
	import com.lakeview.LakeView;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AddNewFishToLakeCommand extends MovieClip implements ICommand
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
		private var fishModel:FishSolvedModel;
		private var lake:MovieClip;
		
		public function AddNewFishToLakeCommand(obj:MovieClip):void
		{
			callBackObj = obj;
			
			fishModel = FishSolvedModel.getInstance();
			lake = fishModel.lakeMc;
		}
		
		public function execute():void
		{
			extractFishes();
		}
		
		public function callBackCommand(obj:Object):void
		{
			obj.newFishAdded();
		}
		
		public function extractFishes():void
		{
			trace(model.fishesInLakeArray,"BEFORE")
			var array:Array = model.fishesArray;
			var fishArrLen:Number = array.length;
			
			if (fishArrLen == 1)
				model.fishesInLakeArray = new Array();
				
			var fishLevel:Number = array[fishArrLen-1].fishLevel as Number;

			var type:Boolean = array[fishArrLen-1].isOwner as Boolean;
			
			if(!type)
				model.fishesInLakeArray.push(fishArray[fishLevel-1]);
			else
				model.fishesInLakeArray.push(myFishArray[fishLevel-1]);
			
			trace(model.fishesInLakeArray.length,"AFTER")
			callBackCommand(lake as LakeView)
		}
	}
	
}