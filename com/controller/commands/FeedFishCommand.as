package com.controller.commands
{
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.FeedFishServiceLocator;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FeedFishCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function FeedFishCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:FeedFishServiceLocator = new FeedFishServiceLocator(this, ServiceConfig.FEED_FISH_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(obj, "---")
			
			var arr:Array = obj as Array ;	
			model.startUpArray = new Array();
			
			for(var ob:Object in arr)
			{
				//ExternalInterface.call("alert", arr[ob].SeverityLevel);
				model.severityLevel = arr[ob].SeverityLevel;
				var availableEggs:Number = arr[ob].AvailableEggs;
				model.startUpArray.push(availableEggs)
			}
			
			callBackObj.notifyUpdate(new ApplicationEvent(ApplicationEvent.FISH_FEEDED_EVENT));
		}
	}
	
}