package com.controller.commands
{
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GetFishesForLakeCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function GetFishesForLakeCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:AppServiceLocator = new AppServiceLocator(this, ServiceConfig.GETLAKE_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(obj,"---")
			model.JSONModel = obj;
			model.fishesArray = new Array();
			model.startUpArray = new Array();
			
			var fishes:Array = obj.Fishes;
			
			for (var key:Object in fishes) 
			{
				var fishObj:Object = new Object();
				
				fishObj.dob = fishes[key].BirthDate;		
				fishObj.categoryID = fishes[key].CategoryId;
				fishObj.categoryName = fishes[key].CategoryName;
				fishObj.fedByMe = fishes[key].FedByMe;
				fishObj.feedCount = fishes[key].FeedCount;
				fishObj.fishLevel = fishes[key].FishLevel;
				fishObj.isOwner = fishes[key].IsOwner;
				fishObj.problemDesc = fishes[key].ProblemDescription ;
				fishObj.problemID = fishes[key].ProblemId;
				fishObj.canIFeed = fishes[key].CanIFeed;
				fishObj.isSolver = fishes[key].IsSolver;
				
				model.fishesArray.push(fishObj);
			}
			
			var availableEgg:Number = Number(obj.AvailableEggs);	
			model.startUpArray.push(availableEgg);
			model.availableEggCount = availableEgg;
			model.requiredCredits = Number(obj.RequiredCredits);
			model.isAquariumAvailable = obj.AquariumFlag as Boolean;
			
			

			callBackObj.notifyUpdate(new ApplicationEvent(ApplicationEvent.LAKE_FISHES_UPDATE_EVENT));
		}
	}
	
}