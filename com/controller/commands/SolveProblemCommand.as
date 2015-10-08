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
	import com.serviceLocator.GetCommentsForAquariumServiceLocator;
	import com.serviceLocator.GetCommentsServiceLocator;
	import com.serviceLocator.SearchServiceLocator;
	import com.serviceLocator.SolveProblemServiceLocator;
	import com.utils.Utils;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SolveProblemCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function SolveProblemCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:SolveProblemServiceLocator = new SolveProblemServiceLocator(this, ServiceConfig.SOLVE_PROBLEM_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(obj,"---")
			model.isSolved = obj as Boolean;
			//ExternalInterface.call("alert", model.isSolved + " :isSolved");
			callBackObj.notifyUpdate(new ApplicationEvent(ApplicationEvent.PROBLEM_SOLVED_EVENT));
		}
	}
	
}