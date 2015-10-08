package com.controller.commands
{
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.CreateNewFishServiceLocator;
	import com.serviceLocator.FeedFishServiceLocator;
	import com.utils.Utils;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class PutNewFishFishCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function PutNewFishFishCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:CreateNewFishServiceLocator = new CreateNewFishServiceLocator(this, ServiceConfig.CREATE_NEW_FISH_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(Number(obj), "---")
			
			var newFishObj:Object = new Object();
			var arr:Array = obj as Array;
				
			newFishObj.dob = Utils.getTodaysDate();		
			newFishObj.categoryID = model.categoryID;
			newFishObj.categoryName = model.categoriesArray[Number(model.categoryID) - 1].categoryName;
			newFishObj.fedByMe = true;
			newFishObj.feedCount = 0;
			newFishObj.fishLevel = 1;
			newFishObj.isOwner = true;
			newFishObj.problemDesc = model.problemDescription;
			newFishObj.problemID = arr[0].RecentProblemId;
			newFishObj.canIFeed = false;
			
			model.fishesArray.push(newFishObj);
			trace(newFishObj.problemID, "ProbID");
			
			(FishSolvedModel.getInstance().lakeMc).putNewFish();
		}
	}
	
}