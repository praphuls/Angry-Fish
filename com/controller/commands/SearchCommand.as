package com.controller.commands
{
	import com.config.AppConfig;
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.lakeview.LakeView;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.FeedFishServiceLocator;
	import com.serviceLocator.SearchServiceLocator;
	import com.utils.Utils;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SearchCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		private var fishModel:FishSolvedModel;
		private var lake:MovieClip;
		
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
		
		public function SearchCommand(obj:MovieClip):void
		{
			callBackObj = obj;
			
			fishModel = FishSolvedModel.getInstance();
			lake = fishModel.lakeMc;
		}
		
		public function execute():void
		{
			var service:SearchServiceLocator = new SearchServiceLocator(this, ServiceConfig.SEARCH_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(obj, "---")
			
			var arr:Array = obj as Array ;	
			trace(arr.length, "LENGHT....")
			model.searchReturnedProblemIdArray = new Array();
			
			for(var obj:Object in arr)
			{
				var probId:Number = arr[obj].Problem_Id;
				model.searchReturnedProblemIdArray.push(probId);
			}
			
			if (arr.length > 0)
			{
				if(model.fishesArray.length > 0)
					cleanLake(lake as LakeView);
					
				extractFishes();
			}
			else
			{
				callBackObj.loadingMc.visible = false;
				Utils.addNoFishPopUp(callBackObj, AppConfig.NO_FISH_AFTER_SEARCH);
			}
			
			
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
			
			for (var i:uint = 0; i < target_mc.numChildren; i++)
			{
				trace (i + '.\t name:' + target_mc.getChildAt(i).name + '\t type:' + typeof (target_mc.getChildAt(i)) + '\t' + target_mc.getChildAt(i));
				target_mc.removeChild(target_mc.getChildAt(i));
			}
			
		}
		
		private function extractFishes():void
		{
			var array:Array = model.searchReturnedProblemIdArray;
			var fishArrLen:Number = model.fishesArray.length;

			model.fishesInLakeAfterSearch = new Array();
			model.searchedFishesInLake = new Array();
			
			for (var i:Number = 0; i < fishArrLen; i++)
			{
				var fishprobId:Number = model.fishesArray[i].problemID as Number;
				trace(model.fishesArray[i].problemID, "ID's")
				
				for (var j:Number = 0; j < array.length; j++)
				{
					if (model.fishesArray[i].problemID == array[j])
					{
						model.searchedFishesInLake.push(model.fishesArray[i]);
						
						var fishLevel:Number = model.fishesArray[i].fishLevel as Number;

						var type:Boolean = model.fishesArray[i].isOwner as Boolean;
						
						if(!type)
							model.fishesInLakeAfterSearch.push(fishArray[fishLevel-1]);
						else
							model.fishesInLakeAfterSearch.push(myFishArray[fishLevel - 1]);
					}
				}
			}
			
			callBack(lake as LakeView);
		}	
		
		private function callBack(obj:Object):void
		{
			obj.putSearchFishes();
		}
	}
	
}