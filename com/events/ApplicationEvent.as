package com.events
{
	import flash.events.Event;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ApplicationEvent extends Event
	{
		public static var STARTUP_UPDATE:String = "startUp_Update";
		public static var LAKE_FISHES_UPDATE_EVENT:String = "lakeFishesUpdate";
		public static var EXTRACTED_FISHES_FROM_FEED_EVENT:String = "extractedFishes";
		public static var SHOW_COMMENTS_EVENT:String = "showComments";
		public static var HIDE_COMMENTS_EVENT:String = "removeComments";
		public static var ADJUST_SCROLL_EVENT:String = "adjustscroll";
		public static var TOP_FEEDERS_EVENT:String = "top_feedes";
		public static var TOP_HATCHERS_EVENT:String = "_top_Hatchers";
		public static var TOP_PROBLEMS_EVENT:String = "top_problems";
		public static var GET_CATEGORIES_EVENT:String = "getCat";
		public static var FISH_FEEDED_EVENT:String = "getCat";
		public static var PUT_NEW_FISH_EVENT:String = "putNew";
		public static var ADDED_FISH_TO_LAKE_EVENT:String = "putNew";
		public static var SEARCHED_FISHES_EVENT:String = "putNew";
		public static var UPDATE_COMMENTS_EVENT:String = "updateCommnets";
		public static var RECORD_CLICK_EVENT:String = "recordClick";
		public static var NEW_FISH_ADDED_EVENT:String = "newFishAdded";
		public static var GET_MY_SCORE_EVENT:String = "getMyScore";
		public static var CLOSE_SCORE_CARD_EVENT:String = "closeMyScore";
		public static var SOLVE_PROBLEM_EVENT:String = "solveProblemEvent";
		public static var REMOVE_SOLVE_PROB_POPUP_EVENT:String = "removeSolveProblem";
		public static var AQUARIUM_STARTUP_EVENT:String = "aquaStartUpEvent";
		public static var SHOW_SOLUTION_EVENT:String = "showSolEvent";
		public static var HIDE_SOLUTION_EVENT:String = "hideSolEvent";
		public static var SHOW_COMMENTS_AQUA_EVENT:String = "showComAquaEvent";
		public static var HIDE_COMMENTS_AQUA_EVENT:String = "showComAquaEvent";
		public static var PROBLEM_SOLVED_EVENT:String = "probSolvedEvent";
		public static var REMOVE_SOLVED_FISH_EVENT:String = "removeSolvedFishEvent";
		public static var REMOVE_NEW_FISH_BOX_EVENT:String = "removeNewFishEvent";
		public static var ADD_HELP_ON_LAUNCH:String = "addHelp";
		public static var IS_HELP_DATA_EVENT:String = "isHelp";
		public static var ADD_POPUP_LISTENER_EVENT:String = "addPopUpListener";
		public static var CAT_SELECTED_EVENT:String = "catSelEvent";
		
		public var commentsX:Number;
		public var commentsY:Number;
		public var targetFish:MovieClip;
		
		public var solveProbPopUpX:Number;
		public var solveProbPopUpY:Number
		public var solveProbPopUpTargetFish:MovieClip;
		
		public var fishDetailPopUpInLake:MovieClip;
		
		public var categoryName:String;
		
		
		public function ApplicationEvent(type:String, bubbles:Boolean=true, cancelable:Boolean=false)  
		{
			super(type, bubbles, cancelable);
		}
		
	}
	
}