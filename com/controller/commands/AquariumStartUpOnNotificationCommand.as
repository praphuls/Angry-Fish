package com.controller.commands
{
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.AquariumOnNotificationServiceLocator;
	import com.serviceLocator.AquariumServiceLocator;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AquariumStartUpOnNotificationCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function AquariumStartUpOnNotificationCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:AquariumOnNotificationServiceLocator = new AquariumOnNotificationServiceLocator(this, ServiceConfig.AQUARIUM_START_ON_NOTIFICATION_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			model.aquaJSONModel = obj;
			model.aquaStartUpArray = new Array();
			model.aquaFishArray = new Array();
			
			var fishes:Array = obj as Array;
			
			for (var key:Object in fishes) 
			{
				var fishObj:Object = new Object();
				
				fishObj.problemID = fishes[key].Problem_Id;
				fishObj.problemDesc = fishes[key].ProblemDescription ;
				fishObj.reportedBy = fishes[key].ReportedBy ;
				fishObj.reportedDate = fishes[key].ReportedDate ;
				fishObj.categoryID = fishes[key].Category_Id;
				fishObj.categoryName = fishes[key].Category_Name;
				fishObj.resolutionId = fishes[key].ResolutionId;
				fishObj.resolvingComments = fishes[key].ResolvingComments;
				fishObj.resolvingDateTime = fishes[key].ResolvingDate;
				fishObj.feedCount = fishes[key].Feedcount;
				
				model.aquaFishArray.push(fishObj);
			}

			callBackObj.notifyUpdate(new ApplicationEvent(ApplicationEvent.AQUARIUM_STARTUP_EVENT));
		}
	}
	
}