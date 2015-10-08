package com.controller.commands
{
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.FeedFishServiceLocator;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FeeFishCommand extends MovieClip implements ICommand
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
			trace(obj,"---")
			
			model.fishFeedArray = new Array();
			model.severityLevel = 2//obj.SeverityLevel;
			trace(obj.SeverityLevel, "from JSON")
			
			model.startUpArray = new Array();
			var availableEgg:Number = Number(obj.AvailableEggs);
			trace(availableEgg,"from JSON")
			model.startUpArray.push(availableEgg);
		
			//trace(model.topFeedersArray,"top_feeders..")
			callBackObj.notifyUpdate(new ApplicationEvent(ApplicationEvent.FISH_FEEDED_EVENT));
		}
	}
	
}