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
	public class GetTopResolversCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function GetTopResolversCommand(obj:MovieClip):void
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
			callBackObj.showResolvers();
		}
		
		private function getTopHatchers():void
		{
			model.topResolversArray = new Array();
			
			var users:Array = model.JSONModel.TopResolvers;
			
			for (var key:Object in users) 
			{
				var topResolversObj:Object = new Object();
				
				topResolversObj.associateId = users[key].AssociateId;		
				topResolversObj.associateName = users[key].AssociateName;
				topResolversObj.type = users[key].UserType;
				topResolversObj.feedCount = users[key].Count;		
				
				model.topResolversArray.push(topResolversObj);
			}
			
			callBackCommand(null)
		}
	}
	
}