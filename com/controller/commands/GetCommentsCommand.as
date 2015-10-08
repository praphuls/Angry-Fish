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
	import com.utils.Utils;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GetCommentsCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function GetCommentsCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:GetCommentsServiceLocator = new GetCommentsServiceLocator(this, ServiceConfig.GET_COMMENTS_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(obj,"---")
			model.commentsArray = new Array();
			var commentsArr:Array = obj as Array;
			
			for(var obj:Object in commentsArr)
			{
				var commentsObj:Object = new Object();
				
				commentsObj.associateName = commentsArr[obj].Associate_Name;
				commentsObj.associateId = commentsArr[obj].Associate_ID;
				commentsObj.comments = commentsArr[obj].CommentText;
				
				model.commentsArray.push(commentsObj);
			}
			
			callBackObj.updateComments();
		}
	}
	
}