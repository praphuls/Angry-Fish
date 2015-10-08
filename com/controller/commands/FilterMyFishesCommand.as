package com.controller.commands
{
	import com.config.AppConfig;
	import com.lakeview.LakeView;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import com.utils.Utils;
	import flash.display.MovieClip;
	import flash.text.ime.CompositionAttributeRange;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FilterMyFishesCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		private var fishModel:FishSolvedModel;
		private var lake:MovieClip;
		
		private var myFishArray:Array = ["com.fishes.myFishes.MySmallFish_1", 
									  	 "com.fishes.myFishes.MyAngryFish_2", 
									  	 "com.fishes.myFishes.MyAngryFish_3", 
									   	 "com.fishes.myFishes.MyAngryFish_4", 
									     "com.fishes.myFishes.MyAngryFish_5"];
		
		public function FilterMyFishesCommand(obj:MovieClip):void
		{
			callBackObj = obj;
			
			fishModel = FishSolvedModel.getInstance();
			lake = fishModel.lakeMc;
		}
		
		public function execute():void
		{
			extractFishes();
		}
		
		private function cleanLake(target_mc:MovieClip):void
		{
			var fishesArrLen:Number = fishModel.fishArr.length;
			var fishArr:Array = fishModel.fishArr;
			
			for (var j:Number = 0; j < fishesArrLen; j++ )
			{
				(lake as LakeView).removeChild(fishArr[j]);
			}
			
			if(fishModel.allPopuUps.length > 0)
				fishModel.allPopuUps.pop();
			
			for (var i:uint = 0; i < target_mc.numChildren; i++){
				trace (i + '.\t name:' + target_mc.getChildAt(i).name + '\t type:' + typeof (target_mc.getChildAt(i)) + '\t' + target_mc.getChildAt(i));
				target_mc.removeChild(target_mc.getChildAt(i));
			}
		}
		
		public function extractFishes():void
		{
			var array:Array = model.fishesArray;
			var fishArrLen:Number = array.length;

			model.myFishesArray = new Array();
			
			for (var i:Number = 0; i < fishArrLen; i++)
			{
				var fishLevel:Number = array[i].fishLevel as Number;
				
				if (model.fishesArray[i].isOwner)
				{
					model.myFishesArray.push(model.fishesArray[i]);
					
				}
				//trace(model.myFishesArray[i].problemDesc,"ProblemDesc")
			}
			trace(model.myFishesArray.length, "LENGTH...")
			
			if (model.myFishesArray.length > 0)
			{
				cleanLake(lake as LakeView);
				putMyFishesInLake();
			}
			else
				Utils.addNoFishPopUp(callBackObj, AppConfig.NO_FISH_IN_MYFISH);
		}
		
		private function putMyFishesInLake():void 
		{
			var array:Array = model.myFishesArray;
			var fishArrLen:Number = array.length;
			
			model.myFishesInlake = new Array();
			
			for (var i:Number = 0; i < fishArrLen; i++)
			{
				var fishLevel:Number = array[i].fishLevel as Number;

				var type:Boolean = array[i].isOwner as Boolean;
				
				if(type)
					model.myFishesInlake.push(myFishArray[fishLevel - 1]);
			}
			
			callBackCommand(lake as LakeView);
		}
		
		public function callBackCommand(obj:Object):void
		{
			obj.filterMyFishes();
		}
	}
	
}