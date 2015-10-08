package com.lakeview  {
	import com.components.CustomScroll;
	import com.components.newComponent.CustomScrollNew;
	import com.config.AppConfig;
	import com.controller.AppController;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import flash.automation.MouseAutomationAction;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.events.Event;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	import com.utils.Utils;
	import com.utils.AddPopUps;
	
	import com.events.RemoveOtherFishes;
	
	import com.Fish;
	import com.model.FishSolvedModel;
	import flash.display.DisplayObjectContainer;
	import com.events.RemoveFishes;
	import com.events.AddPopUp;
	import fl.controls.List; 
	import fl.data.DataProvider; 
	import flash.text.TextField; 
	import fl.controls.TextArea; 
	import fl.controls.UIScrollBar;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class LakeView extends MovieClip {
		
		private var fishArray:Array = ["com.fishes.angryFishes.SmallFish_1", 
									   "com.fishes.angryFishes.AngryFish_2", 
									   "com.fishes.angryFishes.AngryFish_3", 
									   "com.fishes.angryFishes.AngryFish_4", 
									   "com.fishes.angryFishes.AngryFish_5"];
		
		private var myFishArray:Array = ["com.fishes.myFishes.MySmallFish_1", 
									  	 "com.fishes.myFishes.MyAngryFish_2", 
									  	 "com.fishes.myFishes.MyAngryFish_3", 
									   	 "com.fishes.myFishes.MyAngryFish_4", 
									     "com.fishes.myFishes.MyAngryFish_5"];
		
		private var mainStage:MovieClip;
		private var currentlyHatchedEgg:MovieClip;
		private var newFishCount:Number = 0;
		private var fishToBeRemoved:MovieClip;
		private var newX:Number;
		private var newY:Number;
		private var currentLevel:Number;
		private var nextLevel:Number;
		private var maxLevel:Number = 5;
		private var newFishBirth : MovieClip;
		private var solvedFishes:FishSolvedModel;
		private var chkFishArr:Array;
		private var fishNewLevel:MovieClip;
		private var scaleCount:Number = 0;
		private var addPopUp:AddPopUps;
		private var newFishCat:String = "";
		private var detailTxt:String = "";
		private var newFish:MovieClip;
		private var lakeList:Array;
		private var fishModel:FishSolvedModel = FishSolvedModel.getInstance();
		private var controller:AppController;
		private var model:AppModel;
		
		public function LakeView(mc:MovieClip) 
		{
			mainStage = mc;
			solvedFishes = FishSolvedModel.getInstance();
			
			FishSolvedModel.getInstance().lakeMc = this;
			lakeList = solvedFishes.lakeArray;
			
			configureLake();
		}
		
		private function configureLake():void
		{
			controller = new AppController();
			controller.doAction(AppConfig.GET_FISHES_FOR_LAKE, this);
			controller.addEventListener(ApplicationEvent.LAKE_FISHES_UPDATE_EVENT, onLakeView);
			controller.addEventListener(ApplicationEvent.EXTRACTED_FISHES_FROM_FEED_EVENT, putFishes);
			controller.addEventListener(ApplicationEvent.SEARCHED_FISHES_EVENT, putSearchFishes);
			
			this.addEventListener(ApplicationEvent.REMOVE_NEW_FISH_BOX_EVENT, removeNewFishBox);
			
			//this.addEventListener(RemoveFishes.DELETE_MY_FISHES, deleteMyFishes);
			
			mainStage.addEventListener(ApplicationEvent.HIDE_COMMENTS_EVENT, hideComments);
			prepareLakeView();
			
			
		}
		
		public function refreshLake():void
		{
			configureLake();
		}
		
		private var feedsArray:Array;
		public function sortFeeds():void
		{
			controller.doAction(AppConfig.GET_SORTED_FISH, this);
		}
		
		public function putSortedFishInLake():void
		{
			solvedFishes.fishArr = new Array();
			var arr:Array = model.sortedFishesInLake;
			for(var n:Number=0; n<arr.length; n++)
			{
				var fish:MovieClip;
				fish = Utils.addMovieFromLibrary(arr[n], this);
				solvedFishes.fishArr.push(fish);
				
				var index:String = (fish.valueOf().toString()).split("_")[1].split("]")[0];
				fish.useHandCursor = true;
				fish.buttonMode = true;
				
				var catIndex:int = model.fishesArray.indexOf(model.sortedFishArray[n]);
				fish.name = "newFish_" + (index) + "_" + String(catIndex);
					
				addListnersToFish(fish);
			}
		}
		
		public function filterCategory(catStr:String):void
		{
			if (FishSolvedModel.getInstance().catMcToBeRemoved)
			{
				Utils.removePopUpsFromLake(FishSolvedModel.getInstance().catMcToBeRemoved, mainStage);
				FishSolvedModel.getInstance().catMcToBeRemoved = null;
			}
			
			solvedFishes.fishArr = new Array();
			var noFishPopUp:MovieClip;
			
			if (model.fishesArray.length > 0)
			{
				var arr:Array = model.fishesInLakeArray;
				
				for(var n:Number=0; n<arr.length; n++)
				{
					if (model.fishesArray[n].categoryName == catStr)
					{
						var fish:MovieClip;
						fish = Utils.addMovieFromLibrary(arr[n], this);
						solvedFishes.fishArr.push(fish);
						
						var index:String = (fish.valueOf().toString()).split("_")[1].split("]")[0];
						fish.useHandCursor = true;
						fish.buttonMode = true;
					
						if(!(model.fishesArray[n].isOwner))
							fish.name = "level_" + (index) + "_" + n;
						else	
							fish.name = "newFish_" + (index) + "_" + n;
							
						addListnersToFish(fish);
					}
				}
			}
			
			if (catStr == "ALL")
			{
				if(model.fishesArray.length > 0)
					addFishesToLake(model.fishesInLakeArray);
				else	
					Utils.addNoFishPopUp(mainStage, AppConfig.NO_FISH_AFTER_CAT);
			}
			
			if (solvedFishes.fishArr.length < 1 )
			{
				Utils.addNoFishPopUp(mainStage, AppConfig.NO_FISH_AFTER_CAT);
			}
		}
		
		public function filterMyFishes():void
		{
			solvedFishes.fishArr = new Array();
			var arr:Array = model.myFishesInlake;
			for(var n:Number=0; n<arr.length; n++)
			{
				var fish:MovieClip;
				fish = Utils.addMovieFromLibrary(arr[n], this);
				solvedFishes.fishArr.push(fish);
				
				var index:String = (fish.valueOf().toString()).split("_")[1].split("]")[0];
				fish.useHandCursor = true;
				fish.buttonMode = true;
				
				var catIndex:int = model.fishesArray.indexOf(model.myFishesArray[n]);
				fish.name = "newFish_" + (index) + "_" + String(catIndex);
					
				addListnersToFish(fish);
			}
			
		}
		
		private var array:Array;
		public function onLakeView(e:ApplicationEvent=null):void
		{
			mainStage.dispatchEvent(new ApplicationEvent(ApplicationEvent.STARTUP_UPDATE));
			
			model = AppModel.getInstance();
			array = model.fishesArray;
			var fishArrLen:Number = array.length;
			
			var fishesToBeAdded:Array = new Array();
			
			if(model.isAquariumAvailable)
				mainStage.navigationMc.visible = true;
			else
				mainStage.navigationMc.visible = false;
			
			//ExternalInterface.call('alert', 'fishArrLen: '+fishArrLen);
			if (fishArrLen > 0)
			{
				trace("Fishes are there");
				controller.doAction(AppConfig.EXTRACT_FISHES_FROM_FEEDS_PER, this);
			}
			else
			{
				trace("No Fishes are there");
				mainStage.totalMask.visible = false;
				mainStage.loadingMc.visible = false;
				Utils.removeNoFishPopUp(mainStage);
				Utils.addNoFishPopUp(mainStage, AppConfig.NO_FISH_TOP_PROB_SEARCH);
			}
		}
		
		public function putFishes(e:ApplicationEvent=null):void
		{
			mainStage.loadingMc.visible = false;
			addFishesToLake(model.fishesInLakeArray);
		}
		
		public function putSearchFishes(e:ApplicationEvent=null):void
		{
			mainStage.loadingMc.visible = false;
			
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_COMMENTS_EVENT));
			var arrLen:Number = FishSolvedModel.getInstance().allPopuUps.length;
			
			if(arrLen > 0)
			{
				for(var i:Number=0; i<arrLen; i++)
				{
					//this.removeChild(FishSolvedModel.getInstance().allPopuUps[i]);
					FishSolvedModel.getInstance().allPopuUps.pop();
				}
			}
			
			solvedFishes.fishArr = new Array();
			var arr:Array = model.fishesInLakeAfterSearch;
				
			
			for(var n:Number=0; n<arr.length; n++)
			{				
				var fish:MovieClip;
				fish = Utils.addMovieFromLibrary(arr[n], this);
				solvedFishes.fishArr.push(fish);
				
				var index:String = (fish.valueOf().toString()).split("_")[1].split("]")[0];
				fish.useHandCursor = true;
				fish.buttonMode = true;
				
				var catIndex:int = model.fishesArray.indexOf(model.searchedFishesInLake[n]);
				fish.name = "newFish_" + (index) + "_" + String(catIndex);
					
				addListnersToFish(fish);
			}
		}
		
		private var defaultFish:MovieClip;
		private function addFishesToLake(arr:Array):void
		{
			solvedFishes.fishArr = new Array();
			trace(arr.length,"Hi..");
			
			for(var n:Number=0; n<arr.length; n++)
			{
				var fish:MovieClip;
				fish = Utils.addMovieFromLibrary(arr[n], this);
				solvedFishes.fishArr.push(fish);
				
				var index:String = (fish.valueOf().toString()).split("_")[1].split("]")[0];
				fish.useHandCursor = true;
				fish.buttonMode = true;
				
				if(!(model.fishesArray[n].isOwner))
					fish.name = "level_" + (index) + "_" + n;
				else	
					fish.name = "newFish_" + (index) + "_" + n;
				
				addListnersToFish(fish);
				
				if (model.lakeType == "1")
				{
					if (model.problemIDPrimary == model.fishesArray[n].problemID)
					{
						defaultFish = fish;
					}
				}
				
			}
			
			mainStage.totalMask.visible = false;
			if (defaultFish && model.lakeType == "1")
			{
				intimateFishesAboutAction("INACTIVE_THIS_FISH");
				Utils.moveToTop(defaultFish);
				addDefaultPopUp(defaultFish);
			}
				
		}
		
		private function prepareLakeView():void
		{
			mainStage.egg_1.gotoAndStop(1);
			mainStage.egg_1.myEgg.addEventListener(MouseEvent.CLICK, onEggHatch);
			mainStage.egg_1.myEgg.addEventListener(MouseEvent.MOUSE_OVER, onEggOver);
			mainStage.egg_1.myEgg.addEventListener(MouseEvent.MOUSE_OUT, onEggOut);
		}
		
		private function removeEggListeners():void
		{
			mainStage.egg_1.myEgg.removeEventListener(MouseEvent.CLICK, onEggHatch);
		}
		
		private var newPop:MovieClip;
		private function onEggOver(e:MouseEvent):void
		{
			newPop = Utils.addMovieFromLibrary("EggPopUp", mainStage);
			Utils.animateMC(newPop);
			
			newPop.x = 95;
			newPop.y = 550;
			
		}
		
		private function onEggOut(e:MouseEvent):void
		{
			mainStage.removeChild(newPop);
		}
		
		private function addDefaultPopUp(fish:MovieClip):void
		{
			if(FishSolvedModel.getInstance().catMcToBeRemoved)
				Utils.removePopUpsFromLake(FishSolvedModel.getInstance().catMcToBeRemoved, mainStage)
			
			mainStage.searchTxt.alpha = 0.5;
			mainStage.searchTxt.text = "Keywords or description";
			
			addPopUp = new AddPopUps(fish, this);
			addPopUp.addEventListener(ApplicationEvent.SHOW_COMMENTS_EVENT, showComments);
			addPopUp.addEventListener(ApplicationEvent.HIDE_COMMENTS_EVENT, hideComments);
			addPopUp.addEventListener(ApplicationEvent.SOLVE_PROBLEM_EVENT, solveProblem);
			addPopUp.addEventListener(ApplicationEvent.REMOVE_SOLVE_PROB_POPUP_EVENT, closeSolvePopup);
			addPopUp.addEventListener(RemoveFishes.DELETE_MY_FISHES, deleteMyFishes);
		}
		
		private function addListnersToFish(fish:MovieClip):void
		{
			fish.addEventListener(AddPopUp.ADD_POPUP, addPopUps);
			fish.addEventListener(RemoveOtherFishes.REMOVE_OTHER_FISHES, removeFishes);
			fish.addEventListener(RemoveFishes.REMOVE_FISHES, fishRemoved);
			fish.addEventListener(ApplicationEvent.HIDE_COMMENTS_EVENT, hideComments);
			fish.addEventListener(ApplicationEvent.REMOVE_SOLVE_PROB_POPUP_EVENT, closeSolvePopup);
			fish.addEventListener(ApplicationEvent.ADD_POPUP_LISTENER_EVENT, addPopUpListener);
		}
		
		private function addPopUpListener(e:ApplicationEvent):void
		{
			enableAllFishes();
		}
		
		private function enableAllFishes():void
		{
			var angryFishLen:Number = model.fishesArray.length;
			
			if(angryFishLen > 0)
			{
				for(var j:Number=0; j<angryFishLen; j++)
				{
					solvedFishes.fishArr[j].addEventListener(AddPopUp.ADD_POPUP, addPopUps);
					solvedFishes.fishArr[j].mouseEnabled = true;
				}
			}
			
		}
		
		private var popUps:Array = new Array
		private function addPopUps(e:Event):void
		{
			(e.target as MovieClip).mouseEnabled = false;
			(e.target as MovieClip).removeEventListener(AddPopUp.ADD_POPUP, addPopUps);
			
			if(FishSolvedModel.getInstance().catMcToBeRemoved)
				Utils.removePopUpsFromLake(FishSolvedModel.getInstance().catMcToBeRemoved, mainStage)
			
			mainStage.searchTxt.alpha = 0.5;
			mainStage.searchTxt.text = "Keywords or description";
			
			Utils.moveToTop(e.target as MovieClip);
			
			addPopUp = new AddPopUps((e.target as MovieClip), this);
			addPopUp.addEventListener(ApplicationEvent.SHOW_COMMENTS_EVENT, showComments);
			addPopUp.addEventListener(ApplicationEvent.HIDE_COMMENTS_EVENT, hideComments);
			addPopUp.addEventListener(ApplicationEvent.SOLVE_PROBLEM_EVENT, solveProblem);
			addPopUp.addEventListener(ApplicationEvent.REMOVE_SOLVE_PROB_POPUP_EVENT, closeSolvePopup);
			addPopUp.addEventListener(RemoveFishes.DELETE_MY_FISHES, deleteMyFishes);
		}
		
		private var removeFishEvent:RemoveFishes;
		private var deleteFishPopUp:MovieClip;
		private function deleteMyFishes(e:RemoveFishes):void
		{
			removeFishEvent = e;
			
			mainStage.deleteFishPopUp.visible = true;
			mainStage.deleteFishPopUp.deleteTxt.text = "Do you really want to delete me?";
			mainStage.swapChildren(mainStage.deleteFishPopUp, this);
			Utils.moveToTop(mainStage.deleteFishPopUp);
			
			mainStage.deleteFishPopUp.yesDeleteBtn.addEventListener(MouseEvent.CLICK, onYesDelete);
			mainStage.deleteFishPopUp.noDeleteBtn.addEventListener(MouseEvent.CLICK, onNoDelete);
			mainStage.deleteFishPopUp.closeMe.addEventListener(MouseEvent.CLICK, closeDeletepopup);
		}
		
		private var solveProb:MovieClip;
		private var solvedFishTarget:MovieClip;
		private var solvedFishpopup:MovieClip;
		private var fishDetailPopUp:MovieClip;
		private function solveProblem(e:ApplicationEvent):void
		{
			addPopUp.removeEventListener(ApplicationEvent.SOLVE_PROBLEM_EVENT, solveProblem);
			
			solveProb = Utils.addMovieFromLibrary("com.lakeview.SolveProblem", this);
			solveProb.x = e.solveProbPopUpX;
			solveProb.y = e.solveProbPopUpY;
			solvedFishTarget = e.solveProbPopUpTargetFish;
			solvedFishpopup = solveProb;
			fishDetailPopUp = e.fishDetailPopUpInLake;
			
			solveProb.solveProblemBtn.addEventListener(MouseEvent.CLICK, solveThisProblem);
			solveProb.closeMe.addEventListener(MouseEvent.CLICK, closeSolvePopup);
		}
		
		private function solveThisProblem(e:MouseEvent):void
		{
			if (solveProb.solTxt.text != "")
			{
				model.solutionComments = solveProb.solTxt.text;
				
				controller = new AppController();
				controller.doAction(AppConfig.SOLVE_THIS_PROBLEM, this);
				controller.addEventListener(ApplicationEvent.PROBLEM_SOLVED_EVENT, problemSolved);
			}
		}
		
		private function problemSolved(e:ApplicationEvent):void
		{	
			if (!model.isSolved)
			{
				removeSolvedFish();
			}
		}
		
		private function removeSolvedFish(e:ApplicationEvent=null):void
		{	
			addPopUp.removeEventListener(ApplicationEvent.SOLVE_PROBLEM_EVENT, solveProblem);
			
			var targetFish:MovieClip = solvedFishTarget;
			var popUp:MovieClip = solvedFishpopup;
			
			var catIndex = Number(targetFish.name.split("_")[2]);
			
			this.removeChild(targetFish);
			this.removeChild(popUp);
			
			model.fishesArray.splice(catIndex, 1);
			model.fishesInLakeArray.splice(catIndex, 1);
			solvedFishes.fishArr.splice(catIndex, 1);
			solvedFishes.fishInLakeArray.splice(catIndex, 1);
			
			if (model.fishesArray.length > 0)
			{
				for (var n:Number = 0; n < model.fishesArray.length; n++)
				{
					var index:String  = solvedFishes.fishArr[n].name.split("_")[1];
					
					if (!(model.fishesArray[n].isOwner))
						solvedFishes.fishArr[n].name = "level_" + (index) + "_" + n;
					else
						solvedFishes.fishArr[n].name = "newFish_" + (index) + "_" + n;
				}
			}
			else 
			{
				controller = new AppController();
				controller.doAction(AppConfig.REFRESH_STAGE, this);
			}
			
			mainStage.deleteFishPopUp.visible = false;
			if(model.fishesArray.length > 0)
				intimateFishesAboutAction("ACTIVE_THIS_FISH");
			
			
			
			if(solvedFishes.allPopuUps)
				solvedFishes.allPopuUps.pop();
			
			if (fishDetailPopUp)
			{
				this.removeChild(fishDetailPopUp);
				fishDetailPopUp = null;
			}
			
			if(newComments)
			{
				this.removeChild(newComments);
				newComments = null;
			}
			
			if(solveProb)
			{
				this.removeChild(solveProb);
				newComments = null;
			}
		}
		
		//--------------------------------------------------
		
		private function closeSolvePopup(e:Event):void
		{
			if(solveProb)
			{
				this.removeChild(solveProb);
				solveProb = null;
				
				addPopUp.addEventListener(ApplicationEvent.SOLVE_PROBLEM_EVENT, solveProblem);
			}
		}
		
		private function onYesDelete(e:MouseEvent):void
		{
			mainStage.deleteFishPopUp.visible = false;
			controller.doAction(AppConfig.REMOVE_MY_FISH, this);
		}
		
		private function onNoDelete(e:MouseEvent):void
		{
			mainStage.deleteFishPopUp.visible = false;
			mainStage.swapChildren(this, mainStage.deleteFishPopUp);
		}
		
		private function closeDeletepopup(e:MouseEvent):void
		{
			mainStage.deleteFishPopUp.visible = false;
			mainStage.swapChildren(this, mainStage.deleteFishPopUp);
		}
		
		
		public function removeMyFishFromLake():void
		{
			var targetFish:MovieClip = removeFishEvent.targetFish;
			var popUp:MovieClip = removeFishEvent.popUp;
			var catIndex = Number(targetFish.name.split("_")[2]);
			
			this.removeChild(targetFish);
			this.removeChild(popUp);
			
			model.fishesArray.splice(catIndex, 1);
			model.fishesInLakeArray.splice(catIndex, 1);
			solvedFishes.fishArr.splice(catIndex, 1);
			solvedFishes.fishInLakeArray.splice(catIndex, 1);
			
			for (var n:Number = 0; n < model.fishesArray.length; n++)
			{
				var index:String  = solvedFishes.fishArr[n].name.split("_")[1];
				
				if (!(model.fishesArray[n].isOwner))
					solvedFishes.fishArr[n].name = "level_" + (index) + "_" + n;
				else
					solvedFishes.fishArr[n].name = "newFish_" + (index) + "_" + n;
			}
			
			solvedFishes.allPopuUps.pop();
			if(newComments)
			{
				this.removeChild(newComments);
				newComments = null;
			}
			
			if(solveProb)
			{
				this.removeChild(solveProb);
				newComments = null;
			}
			
			intimateFishesAboutAction("ACTIVE_THIS_FISH");
		}
		
		private var appEvt:ApplicationEvent;
		private function showComments(e:ApplicationEvent):void
		{
			appEvt = e;
			controller.doAction(AppConfig.GET_COMMENTS, this);
			controller.addEventListener(ApplicationEvent.UPDATE_COMMENTS_EVENT, updateComments)
		}
		
		private var newComments:MovieClip;
		public function updateComments(e:ApplicationEvent=null):void
		{
			trace("comments updated")
			addPopUp.removeEventListener(ApplicationEvent.SHOW_COMMENTS_EVENT, showComments);
			
			var commentsArray:Array = new Array();
			var commentsStr:String = "";
			
			if (model.commentsArray.length < 1)
				commentsStr = "No comments";
			
			for (var i:Number = 0; i < model.commentsArray.length; i++ )
			{
				trace(model.commentsArray[i].comments, "SEARCH*************")
				commentsStr += "Comment " + (i + 1) + " \n" + model.commentsArray[i].comments + "\n";
			}
			
			newComments = Utils.addMovieFromLibrary("com.lakeview.Comments", this);
			Utils.animateMC(newComments);
			
			//FishSolvedModel.getInstance().popUps = newComments;
			
			newComments.commentText.text = "Click here to add comment";
			newComments.commentText.addEventListener(MouseEvent.CLICK, blankSearchText);
			
			newComments.commentsTxt.text = commentsStr;
			
			if(newComments.commentsTxt.textHeight > 4)
				newComments.mySb.visible = true;
			else
				newComments.mySb.visible = false;
				
			newComments.sendComments.addEventListener(MouseEvent.CLICK, sendComments);
			
			newComments.clickeMe.addEventListener(MouseEvent.CLICK, hideComments);
			newComments.x = appEvt.commentsX + 190;
			newComments.y = appEvt.commentsY;
			
			Utils.checkPosition(newComments, appEvt.targetFish);
		}
		
		private var commentStrToBeSent:String = "";
		private function formatSearchText(str:String):String
		{			
			var arr:Array = str.replace(/^\s+/, "").replace(/\s+$/, "").split(/\s+/);
			var comments:String = "";
			
			for (var i:Number = 0; i < arr.length; i++ )
			{
				if(i == arr.length - 1)
					comments += arr[i]
				else
					comments += arr[i] + " ";
			}
			
			return comments;
		}
		
		private function blankSearchText(e:MouseEvent):void
		{
			if (newComments.commentText.text == "" || 
				newComments.commentText.text == "Click here to add comment" || 
				newComments.commentText.text == "Please insert some comment.")
					newComments.commentText.text = "";
		}
		
		private function sendComments(e:MouseEvent):void
		{
			var myString:String = formatSearchText(newComments.commentText.text);
			
			if (newComments.commentText.text != "Please insert some comment." && 
				newComments.commentText.text != "" && 
				newComments.commentText.text != "Click here to add comment" &&
				newComments.commentText.text != null)
			{
				model.commentText = myString;
				controller.doAction(AppConfig.SEND_COMMENTS, this);
			}
			else
			{
				newComments.commentText.text = "Please insert some comment.";
			}
		}
		
		public function commentSent():void
		{
			trace(model.isCommentRecorded, "RECORDED---------")
			newComments.commentText.text = "";
			this.removeChild(newComments);
			newComments = null;
			
			addPopUp.addEventListener(ApplicationEvent.SHOW_COMMENTS_EVENT, showComments);
		}
		
		private function hideComments(e:Event):void
		{
			if(addPopUp)
				addPopUp.addEventListener(ApplicationEvent.SHOW_COMMENTS_EVENT, showComments);
			
			if(newComments)
			{
				this.removeChild(newComments);
				newComments = null;
			}
			
		}
		
		private var eggClicked:MovieClip
		private function onEggHatch(e:MouseEvent):void
		{
			controller.doAction(AppConfig.CLOSE_SCORE_CARD, model.myScoreCard);
			
			Utils.removeNoFishPopUp(mainStage);
			Utils.removePopUpsFromLake(FishSolvedModel.getInstance().catMcToBeRemoved, mainStage);
			
			mainStage.searchTxt.alpha = 0.5;
			mainStage.searchTxt.text = "Keywords or description";
			
			eggClicked = e.target as MovieClip;
			mainStage.egg_1.addEventListener(Event.ENTER_FRAME, onHatchComplete);
			
			if(mainStage.egg_1.visible)
				mainStage.egg_1.gotoAndPlay(1);
		}
		
		private function onHatchComplete(e:Event):void
		{
			var egg:MovieClip = e.target as MovieClip;
			if(egg.currentFrame == 31)
			{
				addNewFishPopUp(egg);
			}
		}
		
		private function removeNewFishBox(e:ApplicationEvent):void
		{
			if (newFish)
			{
				this.removeChild(newFish);
				newFish = null;
			}
		}
		
		private var newFishPopUpArr:Array = new Array();
		private function addNewFishPopUp(egg:MovieClip):void
		{	
			newFish = Utils.addMovieFromLibrary("com.lakeview.InsertNewFish", this);
			Utils.animateMC(newFish);
			
			var catsArray:Array = new Array();
			for (var i:Number = 0; i < model.categoriesArray.length; i++ )
			{
				var obj:Object = new Object();
				obj.label = model.categoriesArray[i].categoryName;
				obj.data = model.categoriesArray[i].categoryName;
				
				catsArray.push(obj);
			}
			
			//newFish.catCB.dataProvider = new DataProvider(catsArray); 
			
			FishSolvedModel.getInstance().addPopName = newFish;
			addNewFishPopUpListeners(newFish, egg);
			
			if(newFishPopUpArr.length<4)
			{
				newFishPopUpArr.push(newFish);
			}
			else
			{
				newFishPopUpArr = new Array();
				newFishPopUpArr.push(newFish);
			}
			
			newFish.x = (egg as MovieClip).x + egg.width;
			newFish.y = (egg as MovieClip).y - newFish.height;
		}
		
		private var eggArr:Array = new Array();
		private function addNewFishPopUpListeners(newMc:MovieClip, egg:MovieClip):void
		{
			currentlyHatchedEgg = egg;
			newMc.cancelBirth.buttonMode = true;
			
			newMc.giveBirth.addEventListener(MouseEvent.CLICK, onNewFish);
			newMc.cancelBirth.addEventListener(MouseEvent.CLICK, onCancelFish);
			//newMc.catCB.addEventListener(Event.CHANGE, onCatChange);
			newMc.detailsTxt.addEventListener(Event.CHANGE, onDetailChange);
			newMc.keywordMc.keywordTxt.addEventListener(Event.CHANGE, onKeywordChange);
			newMc.catSelMC.addEventListener(ApplicationEvent.CAT_SELECTED_EVENT, onCatSelected);
		}
		
		function onCatSelected(e:ApplicationEvent):void
		{
			//ExternalInterface.call('alert', e.categoryName + ' :Selected');
			newFishCat = e.categoryName;
			newFish.detailsTxt.text = "";
			detailTxt = "";
			model.problemDescription = "";
		}
		
		private var keywordStr:String = "";
		private function onKeywordChange(evt:Event):void
		{
			keywordStr = evt.target.text;
		}
		
		private var count:Number = 0;
		private function onDetailChange(evt:Event):void
		{
			detailTxt =  evt.target.text;
			Utils.removeNoFishPopUp(mainStage);
			model.problemDescription = detailTxt;
		}
		
		private function onCatChange(evt:Event):void
		{
			newFishCat = evt.target.value;
			newFish.detailsTxt.text = "";
			detailTxt = "";
			model.problemDescription = "";
		}
		
		function destroyMe(object:*):void {
			if(object.parent != null){
				var parent:DisplayObjectContainer = object.parent;
				parent.removeChild(object);
			}
		}
		
		private var mcToDestroy:MovieClip;
		private var clickCount:Number = 0;
		private function onNewFish(e:MouseEvent):void
		{
			clickCount++;
			
			if (clickCount > 1)
			{
				return;
			}
				
			mcToDestroy = e.target.parent as MovieClip;
			
			var rex:RegExp = /[\s\r\n]*/gim; 
			var detailStr:String = detailTxt; 
			detailStr = detailStr.replace(rex, ''); 
			
			if((detailStr != "") && (newFishCat != ""))
			{
				newFish.giveBirth.mouseEnabled  = false;
				model.problemDescriptionStr = detailTxt;
				
				if(keywordStr == "" || keywordStr == null)
					model.keywordsStr = " "; 
				else
					model.keywordsStr = keywordStr;
				
				model.categoryID = Utils.getCategoryID(newFishCat);
				controller.doAction(AppConfig.PUT_NEW_FISH, this); 
				Utils.removeNoFishPopUp(mainStage);
				Utils.addNoFishPopUp(mainStage, AppConfig.NEW_FISH_TAKING_TIME);
			}
			else
			{
				trace("no birth");
				clickCount = 0;
				Utils.addNoFishPopUp(mainStage, AppConfig.NO_NEW_FISH);
			}
		}
		
		public function putNewFish(e:ApplicationEvent=null):void
		{
			controller.doAction(AppConfig.ADD_NEW_FISH_TO_LAKE, this);
		}
		
		public function newFishAdded(e:ApplicationEvent=null):void
		{
			destroyMe(mcToDestroy);
			resumeLake();
			
			var array:Array = model.fishesInLakeArray;
			var arrLen:Number = array.length;
			var fish:MovieClip;
			var arrLens:Number = FishSolvedModel.getInstance().allPopuUps.length;
			
			if (arrLen == 1)
				solvedFishes.fishArr = new Array();
			
			fish = Utils.addMovieFromLibrary(array[arrLen-1], this);
			solvedFishes.fishArr.push(fish);			
			
			var index:String = (fish.valueOf().toString()).split("_")[1].split("]")[0];
			fish.useHandCursor = true;
			fish.buttonMode = true;
			fish.x = (mcToDestroy).x;
			fish.y = (mcToDestroy).y;
			
			if(!(model.fishesArray[arrLen-1].isOwner))
				fish.name = "level_" + (index) + "_" + String(arrLen-1);
			else	
				fish.name = "newFish_" + (index) + "_" + String(arrLen-1);
				
			addListnersToFish(fish);
			Utils.removeNoFishPopUp(mainStage);
			detailTxt = "";
			newFishCat = "";
			resetEgg();
		}
		
		private function resumeLake():void
		{
			var arrLens:Number = FishSolvedModel.getInstance().allPopuUps.length;
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_COMMENTS_EVENT));
			
			if(arrLens > 0)
			{
				for(var i:Number=0; i<arrLens; i++)
				{
					this.removeChild(FishSolvedModel.getInstance().allPopuUps[i]);
					FishSolvedModel.getInstance().allPopuUps.pop();
				}
				
				trace(FishSolvedModel.getInstance().fishInLakeArray.length,"LENGTH----")
				for(var j:Number=0; j < FishSolvedModel.getInstance().fishInLakeArray.length; j++)
				{
					(FishSolvedModel.getInstance().fishInLakeArray[j] as MovieClip).dispatchEvent(new Event("ACTIVE_THIS_FISH"));
				}
			}
		}
		
		private function onCancelFish(e:MouseEvent=null):void
		{
			newFishCat = "";
			detailTxt = "";
			
			newFish.giveBirth.mouseEnabled  = true;
			destroyMe(newFish);
			currentlyHatchedEgg.gotoAndStop(1);
			Utils.removeNoFishPopUp(mainStage);
			prepareLakeView();
		}
		
		private function resetEgg():void
		{
			currentlyHatchedEgg.visible = false;
			mainStage.egg_broken.visible = true;
			prepareLakeView();
			clickCount = 0;
		}
		
		private function fishRemoved(evt:Event):void
		{
			removeChild(evt.target as MovieClip);
			evt.stopImmediatePropagation();
		}
		
		private var currentIndex:Number;
		private var removeEventObj:RemoveOtherFishes;
		private function removeFishes(evt:RemoveOtherFishes):void
		{
			removeEventObj = evt;
			controller.doAction(AppConfig.FEED_FISH, this);
			controller.addEventListener(ApplicationEvent.FISH_FEEDED_EVENT, fishFeeded);
		}
		
		private function fishFeeded(e:ApplicationEvent):void
		{
			if(newComments)
			{
				this.removeChild(newComments);
				newComments = null;
			}
			
			if(solveProb)
			{
				this.removeChild(solveProb);
				newComments = null;
			}
			
			mainStage.dispatchEvent(new ApplicationEvent(ApplicationEvent.STARTUP_UPDATE));
			var evt:RemoveOtherFishes = removeEventObj;
			
			fishToBeRemoved = (evt.target as MovieClip);
			currentLevel = Number(fishToBeRemoved.name.split("_")[1]);
			currentIndex = Number(fishToBeRemoved.name.split("_")[2]);
			
			nextLevel = Number(model.severityLevel)
			
			newX = fishToBeRemoved.x;
			newY = fishToBeRemoved.y;
			
			if (currentLevel == nextLevel)
			{
				intimateFishesAboutAction("ACTIVE_THIS_FISH");
				model.fishesArray[currentIndex].feedCount = Number(model.fishesArray[currentIndex].feedCount) + 1;
				model.fishesArray[currentIndex].fedByMe = true;
				model.fishesArray[currentIndex].fishLevel = nextLevel;
				model.fishesArray[currentIndex].canIFeed = false;
			}
			else 
			{
				removeChild(fishToBeRemoved);
				feedThisFish(evt.mcName, newX, newY, fishToBeRemoved)
			}
		}
		
		private function feedThisFish(mcName:String, newX:Number, newY:Number, mcClip:MovieClip):void
		{
			var fishTransition:MovieClip;
			
			if(currentLevel < maxLevel)
			{
				fishTransition = Utils.addMovieFromLibrary(mcName,this);
				fishTransition.scaleX = mcClip.scaleX;
				fishTransition.scaleY = Utils.fishScaleY;
				fishTransition.x = newX;
				fishTransition.y = newY;
				fishTransition.addEventListener(Event.ENTER_FRAME, onFishTransition);
			}
			else if(nextLevel == currentLevel)
				continueWithSwim(mcClip);
			
			intimateFishesAboutAction("ACTIVE_THIS_FISH");
		}
		
		private function onFishTransition(evt: Event):void
		{
			var fish:MovieClip = evt.target as MovieClip;
			
			if(fish.currentFrame == fish.totalFrames)
			{
				fish.removeEventListener(Event.ENTER_FRAME, onFishTransition);
				removeChild(fish);
				continueWithSwim(fish, evt);
			}
		}
		
		private function continueWithSwim(fish:MovieClip, evt:Event=null):void
		{
			if(currentLevel < maxLevel)
			{
				fishNewLevel = Utils.addMovieFromLibrary(fishArray[nextLevel-1], this);
				fishNewLevel.scaleX = fish.scaleX;
				fishNewLevel.scaleY = Utils.fishScaleY;
			}
			else if(nextLevel == currentLevel)
			{
				fishNewLevel =  Utils.addMovieFromLibrary(fishArray[nextLevel-1], this);
				fishNewLevel.scaleX += scaleFishRatio();
				fishNewLevel.scaleY += scaleFishRatio();
			}
			
			fishNewLevel.x = newX;
			fishNewLevel.y = newY;
			fishNewLevel.useHandCursor = true;
			fishNewLevel.buttonMode = true;
			
			fishNewLevel.name = "level_"+ nextLevel+"_"+currentIndex;
			addListnersToFish(fishNewLevel);
			
			fishModel.fishArr[currentIndex] = fishNewLevel;
			model.fishesInLakeArray[currentIndex] = fishArray[nextLevel-1];
			
			model.fishesArray[currentIndex].feedCount = Number(model.fishesArray[currentIndex].feedCount) + 1;
			model.fishesArray[currentIndex].fedByMe = true;
			model.fishesArray[currentIndex].fishLevel = nextLevel;
			model.fishesArray[currentIndex].canIFeed = false;
			
			intimateFishesAboutAction("ACTIVE_THIS_FISH");
		}
		
		private function intimateFishesAboutAction(action:String):void
		{
			var arrLen:Number = fishModel.fishInLakeArray.length
			for(var i:Number=0; i<arrLen; i++)
			{
				(fishModel.fishInLakeArray[i] as MovieClip).dispatchEvent(new Event(action));
			}
		}
		
		private function scaleFish(mc:MovieClip, scaleRatio:Number):void
		{
			var myTweenScaleX:Tween = new Tween(mc, "scaleX", Regular.easeOut, mc.scaleX, Math.abs(scaleRatio), 3, true);
			var myTweenScaleY:Tween = new Tween(mc, "scaleY", Regular.easeOut, mc.scaleY, Math.abs(scaleRatio), 3, true);
			
			myTweenScaleY.addEventListener(Event.COMPLETE, addActions);
		}
		
		private function scaleFishRatio():Number
		{
			scaleCount +=0.02;
			return scaleCount;
		}
		
		private function addActions(evt:Event):void
		{
			evt.stopImmediatePropagation();
		}

	}
	
}
