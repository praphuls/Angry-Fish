package com.controller.commands
{
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.AquariumServiceLocator;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AquariumStartUpCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function AquariumStartUpCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:AquariumServiceLocator = new AquariumServiceLocator(this, ServiceConfig.AQUARIUM_STARTUP_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			if(model.aquaFishArray)
				clearAquarium(model.aquarium);
			
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
		
		private function clearAquarium(target_mc:MovieClip):void
		{
			trace(target_mc.numChildren, "In Clean Aqua");
			
			for (var i:uint = 0; i < target_mc.numChildren; i++){
				trace (i + '.\t name:' + target_mc.getChildAt(i).name + '\t type:' + typeof (target_mc.getChildAt(i)) + '\t' + target_mc.getChildAt(i),"REFERSH...");
				target_mc.removeChild(target_mc.getChildAt(i));
			}
		}
		
	}
	
}