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
	public class GetMyScoreCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		private var fishModel:FishSolvedModel;
		private var lake:MovieClip;
		
		public function GetMyScoreCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:GetMyScoreServiceLocator = new GetMyScoreServiceLocator(this, ServiceConfig.GET_MY_SCORECARD_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(obj,"+++");
			//trace(scoreCard[key].CurrentCreditCount, scoreCard[key].AvailableEggs, scoreCard[key].RequiredCreditCount, "---")
			
			var scoreCard:Array = obj as Array;
			
			for (var key:Object in scoreCard) 
			{
				model.currentCreditCount = scoreCard[key].CurrentCreditCount;
				model.availableEggsInScoreCard = scoreCard[key].AvailableEggs;
				model.requiredCreditCount = scoreCard[key].RequiredCreditCount;
				model.showFlag = scoreCard[key].ShowFlag;
			}
			
			callBackObj.notifyUpdate(new ApplicationEvent(ApplicationEvent.GET_MY_SCORE_EVENT));
		}
	}
	
}