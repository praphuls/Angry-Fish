package com.model
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class AppModel
	{
		//----------- SINGLETON - start -----------------------
		
		private static var _instance:AppModel = new AppModel();
		
		public function AppModel() 
		{
			if(_instance)
				throw new Error("Singleton Class");
		}
		
		public static function getInstance():AppModel
		{
			return _instance;
		}
		
		//----------- SINGLETON - over -----------------------
		
		public var assocaiteID:String;
		public var JSONModel:Object;
		public var categoryText:String;
		public var startUpArray:Array;
		public var fishesArray:Array;
		public var fishesInLakeArray:Array;
		public var topFeedersArray:Array;
		public var topHatchersArray:Array;
		public var topProblemsArray:Array;
		public var categoriesArray:Array;
		public var problemIDForFeed:String;
		public var fishFeedArray:Array;
		public var severityLevel:Number;
		public var eggAvailableAfterFeed:String;
		public var sortedFishArray:Array;
		public var categoryID:String;
		public var categoryName:String;
		public var problemDescriptionStr:String;
		public var problemDescription:String;
		public var keywordsStr:String;
		public var isFishCreated:Boolean;
		public var myFishesArray:Array;
		public var searchKeywords:String;
		public var searchReturnedProblemIdArray:Array;
		public var fishesInLakeAfterSearch:Array;
		public var commentsArray:Array;
		public var commentText:String;
		public var isCommentRecorded:Boolean;
		public var availableEggCount:Number;
		public var myScoreCard:MovieClip;
		
		//-------------------------
		
		public var loader:MovieClip;
		public var noFishPopUp:MovieClip;
		public var myFishesInlake:Array;
		public var sortedFishesInLake:Array;
		public var searchedFishesInLake:Array;
		public var availableEggAfterRecordClick:Number;
		public var requiredCredits:Number;
		public var requiredCreditCount:Number;
		public var currentCreditCount:Number;
		public var availableEggsInScoreCard:Number;
		public var showFlag:Number;
		public var isContextHelpShown:Boolean = false;
		
		//------------------------ MVP 2--------------------------
		
		public var isAquariumAvailable:Boolean;
		public var topResolversArray:Array;
		public var associateName:String;
		public var lakeType:String;
		public var problemIDPrimary:String;
		public var problemIDHappyFish:String;
		public var aquariumIdPrimary:String;
		public var problemDescriptionToFeed:String;
		public var aquaJSONModel:Object;
		public var aquaStartUpArray:Array;
		public var aquaFishArray:Array;
		public var aquaHappyFishArray:Array;
		public var aquaFishNotificationArray:Array;
		public var aquarium:MovieClip;
		public var aquaPopUp:MovieClip;
		public var solutionComments:String;
		public var isSolved:Boolean;
		public var problemDescriptionToSolve:String;
		public var problemDescriptionHappyFish:String;
		public var fishCurrentLevel:String;
		public var resolvedComments:String;
		public var resolvedDate:String;
		public var aquariumName:String;
		public var isAppLaunched:Boolean;
		public var isShowHelp:Boolean;
		
	}
	
}