package com.controller.commands
{
	import com.config.AppConfig;
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.lakeview.LakeView;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.DeleteMyFishServiceLocator;
	import com.serviceLocator.FeedFishServiceLocator;
	import com.serviceLocator.GetMyScoreServiceLocator;
	import com.serviceLocator.SearchServiceLocator;
	import com.utils.Utils;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CloseScoreCardCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function CloseScoreCardCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			callBackCommand(null)
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace("in close command","+++");
			callBackObj.dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE_SCORE_CARD_EVENT));
		}
	}
	
}