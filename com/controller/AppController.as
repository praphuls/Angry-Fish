package com.controller
{
	import com.config.AppConfig;
	import com.controller.commands.AddNewFishToLakeCommand;
	import com.controller.commands.AquariumStartUpCommand;
	import com.controller.commands.AquariumStartUpOnNotificationCommand;
	import com.controller.commands.CategorySelectorCommand;
	import com.controller.commands.CloseScoreCardCommand;
	import com.controller.commands.FeedFishCommand;
	import com.controller.commands.FeeFishCommand;
	import com.controller.commands.FilterMyFishesCommand;
	import com.controller.commands.GetCategoriesCommand;
	import com.controller.commands.GetCommentsCommand;
	import com.controller.commands.GetCommentsForAquariumCommand;
	import com.controller.commands.GetFishesForLakeCommand;
	import com.controller.commands.GetFishesFromFeedPercentCommand;
	import com.controller.commands.GetIsHelpCommmand;
	import com.controller.commands.GetMyScoreCommand;
	import com.controller.commands.GetTopFeedersCommand;
	import com.controller.commands.GetTopHatchersCommand;
	import com.controller.commands.GetTopProblemsCommand;
	import com.controller.commands.GetTopResolversCommand;
	import com.controller.commands.PutNewFishFishCommand;
	import com.controller.commands.RecordClickCommand;
	import com.controller.commands.RefreshStageCommand;
	import com.controller.commands.RemoveFishFromLakeCommand;
	import com.controller.commands.RemoveSolvedFishFromLakeCommand;
	import com.controller.commands.SearchCommand;
	import com.controller.commands.SendCommentsCommand;
	import com.controller.commands.SolveProblemCommand;
	import com.controller.commands.SortFishCommand;
	import com.controller.commands.StartUpCommand;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AquariumOnNotificationServiceLocator;
	import com.serviceLocator.RecordClickServiceLocator;
	import com.utils.display.BusyCursor;
	import com.utils.Utils;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class  AppController extends MovieClip
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function AppController():void
		{
		}
		
		public function notifyUpdate(e:Event):void
		{
			this.dispatchEvent(e as ApplicationEvent);
		}
		
		public function doAction(action:String, obj:*=null):void
		{
			callBackObj = obj as MovieClip;
			
			switch(action)
			{
				case AppConfig.STARTUP:
					{
						var startUpCommand:StartUpCommand = new StartUpCommand(this);
						startUpCommand.execute();
						break;
					}
				
				case AppConfig.GET_FISHES_FOR_LAKE:
					{
						var getLakeFishesCommand:GetFishesForLakeCommand = new GetFishesForLakeCommand(this);
						getLakeFishesCommand.execute();
						break;
					}
					
				case AppConfig.EXTRACT_FISHES_FROM_FEEDS_PER:
					{
						var getFishesCommand:GetFishesFromFeedPercentCommand = new GetFishesFromFeedPercentCommand(this);
						getFishesCommand.execute();
						break;
					}
					
				case AppConfig.REFRESH_STAGE:
					{
						var refreshStageCommand:RefreshStageCommand = new RefreshStageCommand(callBackObj);
						refreshStageCommand.execute();
						
						break;
					}
				
				case AppConfig.FILTER_MY_FISHES:
					{
						var filterMyFishes:FilterMyFishesCommand = new FilterMyFishesCommand(callBackObj);
						filterMyFishes.execute();
						break;
					}
				
				case AppConfig.TOP_FEEDERS:
					{
						var topFeeders:GetTopFeedersCommand = new GetTopFeedersCommand(callBackObj);
						topFeeders.execute();
						break;
					}
					
				case AppConfig.TOP_HATCHERS:
					{
						var topHatchers:GetTopHatchersCommand = new GetTopHatchersCommand(callBackObj);
						topHatchers.execute();
						break;
					}
				
				case AppConfig.TOP_PROBLEMS:
					{
						var topProblems:GetTopProblemsCommand = new GetTopProblemsCommand(callBackObj);
						topProblems.execute();
						break;
					}
					
				case AppConfig.TOP_RESOLVER:
					{
						var topResolver:GetTopResolversCommand = new GetTopResolversCommand(callBackObj);
						topResolver.execute();
						break;
					}
					
				case AppConfig.CATEGORY_SELECETOR:
					{
						var cats:CategorySelectorCommand = new CategorySelectorCommand(callBackObj);
						cats.execute();
						break;
					}
				
				case AppConfig.GET_CATEGORY:
					{
						var getCats:GetCategoriesCommand = new GetCategoriesCommand(this);
						getCats.execute();
						break;
					}
					
				case AppConfig.FEED_FISH:
					{
						var feedFish:FeedFishCommand = new FeedFishCommand(this);
						feedFish.execute();
						break;
					}
					
				case AppConfig.GET_SORTED_FISH:
					{
						var sortedFish:SortFishCommand = new SortFishCommand(this);
						sortedFish.execute();
						break;
					}
					
				case AppConfig.PUT_NEW_FISH:
					{
						var putNewFish:PutNewFishFishCommand = new PutNewFishFishCommand(this);
						putNewFish.execute();
						break;
					}
					
				case AppConfig.ADD_NEW_FISH_TO_LAKE:
					{
						var putNewFishToLake:AddNewFishToLakeCommand = new AddNewFishToLakeCommand(this);
						putNewFishToLake.execute();
						break;
					}
					
				case AppConfig.SEARCH_KEYWORDS:
					{
						var search:SearchCommand = new SearchCommand(callBackObj);
						search.execute();
						break;
					}
					
				case AppConfig.GET_COMMENTS:
					{
						var getComemnts:GetCommentsCommand = new GetCommentsCommand(callBackObj);
						getComemnts.execute();
						break;
					}
					
				case AppConfig.SEND_COMMENTS:
					{
						var setComemnts:SendCommentsCommand = new SendCommentsCommand(callBackObj);
						setComemnts.execute();
						break;
					}
					
				case AppConfig.RECORD_CLICKS:
					{
						var recordClicks:RecordClickCommand = new RecordClickCommand(callBackObj);
						recordClicks.execute();
						break;
					}
					
				case AppConfig.REMOVE_MY_FISH:
					{
						var removeMyFish:RemoveFishFromLakeCommand = new RemoveFishFromLakeCommand(callBackObj);
						removeMyFish.execute();
						break;
					}
				
				case AppConfig.GET_MY_SCORE:
					{
						var getMyScore:GetMyScoreCommand = new GetMyScoreCommand(this);
						getMyScore.execute();
						break;
					}
					
				case AppConfig.CLOSE_SCORE_CARD:
					{
						var closeScoreCard:CloseScoreCardCommand = new CloseScoreCardCommand(callBackObj);
						closeScoreCard.execute();
						break;
					}
					
				//-----------------------------------------------------------------------------------------
				
				case AppConfig.GET_AQUARIUM:
					{
						var aqua:AquariumStartUpCommand = new AquariumStartUpCommand(this);
						aqua.execute();
						break;
					}
					
				case AppConfig.GET_AQUARIUM_FROM_NOTIFICATION:
					{
						var aquaNotification:AquariumStartUpOnNotificationCommand = new AquariumStartUpOnNotificationCommand(this);
						aquaNotification.execute();
						break;
					}
					
				case AppConfig.GET_COMMENTS_FOR_AQUARIUM:
					{
						var getAquaComemnts:GetCommentsForAquariumCommand = new GetCommentsForAquariumCommand(this);
						getAquaComemnts.execute();
						break;
					}
					
				case AppConfig.SOLVE_THIS_PROBLEM:
					{
						var solveThisProb:SolveProblemCommand = new SolveProblemCommand(this);
						solveThisProb.execute();
						break;
					}
					
				case AppConfig.REMOVE_SOLVED_FISH:
					{
						var solvedFish:RemoveSolvedFishFromLakeCommand = new RemoveSolvedFishFromLakeCommand(this);
						solvedFish.execute();
						break;
					}
					
				case AppConfig.IS_HELP_DATA:
					{
						var isHelp:GetIsHelpCommmand = new GetIsHelpCommmand(this);
						isHelp.execute();
						break;
					}
			}
		}
	}
	
}