package com.controller.commands
{
	import com.AngryFishStartUp;
	import com.config.AppConfig;
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.lakeview.LakeView;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.FeedFishServiceLocator;
	import com.serviceLocator.GetCommentsServiceLocator;
	import com.serviceLocator.RecordClickServiceLocator;
	import com.serviceLocator.SearchServiceLocator;
	import com.serviceLocator.SetCommentsServiceLocator;
	import com.utils.Utils;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RecordClickCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		private var fishModel:FishSolvedModel;
		private var lake:MovieClip;
		
		public function RecordClickCommand(obj:MovieClip):void
		{
			callBackObj = obj;
			
			fishModel = FishSolvedModel.getInstance();
			lake = fishModel.lakeMc;
		}
		
		public function execute():void
		{
			var service:RecordClickServiceLocator = new RecordClickServiceLocator(this, ServiceConfig.RECORD_CLICK_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace((obj as Array)[0].AvailableEggs,"---")
			
			model.startUpArray = new Array();
			
			var availableEgg:Number = Number((obj as Array)[0].AvailableEggs);	
			model.startUpArray.push(availableEgg);
			model.availableEggAfterRecordClick = availableEgg
			
			//trace(availableEgg,"---")
			
			callBackObj.dispatchEvent(new ApplicationEvent(ApplicationEvent.RECORD_CLICK_EVENT));
		}
	}
	
}