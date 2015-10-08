package com.controller.commands
{
	import com.config.AppConfig;
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.lakeview.LakeView;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.FeedFishServiceLocator;
	import com.serviceLocator.GetCommentsServiceLocator;
	import com.serviceLocator.SearchServiceLocator;
	import com.serviceLocator.SetCommentsServiceLocator;
	import com.utils.Utils;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendCommentsCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function SendCommentsCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:SetCommentsServiceLocator = new SetCommentsServiceLocator(this, ServiceConfig.SET_COMMENTS_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(obj,"---")
			model.isCommentRecorded = obj as Boolean;
			callBackObj.commentSent();
		}
	}
	
}