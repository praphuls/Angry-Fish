package com.controller.commands
{
	import com.config.AppConfig;
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.lakeview.LakeView;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.DeleteMyFishServiceLocator;
	import com.serviceLocator.FeedFishServiceLocator;
	import com.serviceLocator.SearchServiceLocator;
	import com.utils.Utils;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RemoveFishFromLakeCommand extends MovieClip implements ICommand
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
		
		public function RemoveFishFromLakeCommand(obj:MovieClip):void
		{
			callBackObj = obj;
			
			fishModel = FishSolvedModel.getInstance();
			lake = fishModel.lakeMc;
		}
		
		public function execute():void
		{
			var service:DeleteMyFishServiceLocator = new DeleteMyFishServiceLocator(this, ServiceConfig.DELETE_MY_FISH_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			trace(obj, "---")
//			ExternalInterface.call("alert", obj);
			
			if(obj as Boolean)
				removeFishFromeLake();
		}
		
		private function cleanLake(target_mc:MovieClip):void
		{
			var fishesArrLen:Number = fishModel.fishArr.length;
			var fishArr:Array = fishModel.fishArr;
			for (var j:Number = 0; j < fishesArrLen; j++ )
			{
				(lake as LakeView).removeChild(fishArr[j]);
			}
			
			for (var i:uint = 0; i < target_mc.numChildren; i++)
			{
				trace (i + '.\t name:' + target_mc.getChildAt(i).name + '\t type:' + typeof (target_mc.getChildAt(i)) + '\t' + target_mc.getChildAt(i));
				target_mc.removeChild(target_mc.getChildAt(i));
			}
			
		}
		
		private function removeFishFromeLake():void
		{	
			callBack(lake as LakeView);
		}	
		
		private function callBack(obj:Object):void
		{
			obj.removeMyFishFromLake();
		}
	}
	
}