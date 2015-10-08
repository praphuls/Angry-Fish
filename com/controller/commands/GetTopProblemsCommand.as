package com.controller.commands
{
	import com.config.AppConfig;
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import com.utils.Utils;
	import flash.display.MovieClip;
	
	import com.lakeview.LakeView;
	import com.model.FishSolvedModel;
	import flash.text.ime.CompositionAttributeRange;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GetTopProblemsCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;

		private var fishModel:FishSolvedModel;
		private var lake:MovieClip;
		
		public function GetTopProblemsCommand(obj:MovieClip):void
		{
			callBackObj = obj;
			
			fishModel = FishSolvedModel.getInstance();
			lake = fishModel.lakeMc;
		}
		
		public function execute():void
		{
			model.sortedFishArray = new Array();
			
			model.fishesArray.sortOn("feedCount", Array.NUMERIC | Array.DESCENDING);	
			
			for(var i:int=0; i<5 && i<model.fishesArray.length; i++)
			{
				model.sortedFishArray.push(model.fishesArray[i]);
			}
			
			if (model.sortedFishArray.length > 0)
			{
				cleanLake(lake as LakeView);
				callBackCommand(lake as LakeView);
			}
			else
			{
				Utils.addNoFishPopUp(callBackObj, AppConfig.NO_FISH_TOP_PROB_SEARCH);
			}
		}
		
		public function callBackCommand(obj:Object):void
		{
			obj.sortFeeds();
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
	}
	
}