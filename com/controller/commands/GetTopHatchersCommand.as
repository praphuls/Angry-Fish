package com.controller.commands 
{
	import com.config.AppConfig;
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import flash.display.MovieClip;
	import com.utils.Utils;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GetTopHatchersCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function GetTopHatchersCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			//var service:AppServiceLocator = new AppServiceLocator(this, ServiceConfig.TOP_FEEDERS_SERVICE);
			getTopHatchers();
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(obj,"---")
			callBackObj.showHatchers();
		}
		
		private function getTopHatchers():void
		{
			model.topHatchersArray = new Array();
			
			var users:Array = model.JSONModel.TopHatchers;
			
			for (var key:Object in users) 
			{
				var topHachersObj:Object = new Object();
				
				topHachersObj.associateId = users[key].AssociateId;		
				topHachersObj.associateName = users[key].AssociateName;
				topHachersObj.type = users[key].UserType;
				topHachersObj.feedCount = users[key].Count;		
				
				model.topHatchersArray.push(topHachersObj);
			}
			
			callBackCommand(null)
		}
	}
	
}