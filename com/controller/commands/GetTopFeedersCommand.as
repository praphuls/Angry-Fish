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
	public class GetTopFeedersCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function GetTopFeedersCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			//var service:AppServiceLocator = new AppServiceLocator(this, ServiceConfig.TOP_FEEDERS_SERVICE);
			getTopFeeders();
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(model.topFeedersArray,"top_feeders..")
			callBackObj.showFeeders();
		}
		
		private function getTopFeeders():void
		{
			model.topFeedersArray = new Array();
			
			var users:Array = model.JSONModel.TopFeeders;
	
			for (var key:Object in users) 
			{
				var topFeedersObj:Object = new Object();
				
				topFeedersObj.associateId = users[key].AssociateId;		
				topFeedersObj.associateName = users[key].AssociateName;
				topFeedersObj.type = users[key].UserType;
				topFeedersObj.feedCount = users[key].Count;		
				
				model.topFeedersArray.push(topFeedersObj);
			}
			
			callBackCommand(null)
		}
		
	}
	
}