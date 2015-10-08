package com.utils  {

	import com.components.CustomScroll;
	import com.config.AppConfig;
	import com.controller.AppController;
	import com.events.AddPopUp;
	import com.events.ApplicationEvent;
	import com.lakeview.Comments;
	import com.model.AppModel;
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.external.ExternalInterface;
	
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import com.events.RemoveOtherFishes;
	import com.utils.Utils;
	
	import com.Fish;
	import com.model.FishSolvedModel;

	import com.fishes.myFishes.MySmallFish_1;
	import com.events.RemoveFishes;
	import com.events.AddActions;
	
	public class AddPopUps extends MovieClip {
		
		private var myPopUp:MovieClip;
	    private var yourPopUp:MovieClip;
		private var fishName:String;
		private var targetFishes:MovieClip
		private var fishCategory:String;
		private var holderMovieClip:MovieClip;
		private var catArr:Array = ["Admin", "HR", "NSS", "EAS", "Academy", "Others"];
		private var countAssociates:Number = Utils.associateCount;
		private var fishModel:FishSolvedModel = FishSolvedModel.getInstance();
		private var model:AppModel = AppModel.getInstance();
		private var catIndex:Number;
		private var controller:AppController;
		private var index:Number;
		
		public function AddPopUps(targetFish:MovieClip=null, holderMC:MovieClip=null) 
		{
			targetFishes = targetFish;
			holderMovieClip = holderMC;
			addPopUp(targetFish);
			
		}
		
		private function addPopUp(targetFish:MovieClip):void
		{
			fishName = targetFish.name.split("_")[0];
			fishCategory = targetFish.name.split("_")[1];
			catIndex = Number(targetFish.name.split("_")[2]);
			
			index = Number(targetFish.name.split("_")[1]);
			var problemID:String;
			
			if (model.fishesArray[catIndex].problemID != null)
			{
				problemID = model.fishesArray[catIndex].problemID;
				trace(model.fishesArray[catIndex].problemID, "PROBLEM ID")
			}
			//trace("problemID: ", problemID)
			model.problemIDForFeed = problemID;
			model.fishCurrentLevel = model.fishesArray[catIndex].fishLevel;
			
			this.addEventListener(AddPopUp.ALIGN_POPUP, tweenCallback);
			
			controller = new AppController();
			controller.doAction(AppConfig.RECORD_CLICKS, FishSolvedModel.getInstance().mainStage);
			
			if(model.fishesArray[catIndex].isOwner)
			{
				var detailStr:String = targetFish.name.split("_")[2];
				
				myPopUp = Utils.addMovieFromLibrary("com.lakeview.MyOwnBox", holderMovieClip);
				Utils.animateMC(myPopUp, this);
				Utils.moveToTop(myPopUp);
				
				if (Number(model.fishesArray[catIndex].feedCount) < 1)
				{
					myPopUp.deleteBtn.visible = true;
					myPopUp.deleteBtn.addEventListener(MouseEvent.CLICK, deleteFish);
				}
				else
					myPopUp.deleteBtn.visible = false;
				
				
				myPopUp.closeMe.addEventListener(MouseEvent.CLICK, closed);
				myPopUp.closeMe.buttonMode = true;
				FishSolvedModel.getInstance().popUps = myPopUp;
				
				myPopUp.commentsBtn.addEventListener(MouseEvent.CLICK, showComments);
				
				checkPosition(myPopUp, targetFish);				
				
				if(model.fishesArray[catIndex].categoryName != undefined)
					myPopUp.categoryTxt.text = model.fishesArray[catIndex].categoryName;
				
				if (model.fishesArray[catIndex].problemDesc != undefined)
				{
					myPopUp.fishDetailTxt.text = model.fishesArray[catIndex].problemDesc;
					
					if(myPopUp.fishDetailTxt.textHeight > 5)
						myPopUp.mySb.visible = true;
					else
						myPopUp.mySb.visible = false;
				}
					
				if(model.fishesArray[catIndex].dob != undefined)
					myPopUp.dobTxt.text = " " + model.fishesArray[catIndex].dob
				
				if (model.fishesArray[catIndex].feedCount != undefined)
				{
					if(Number(model.fishesArray[catIndex].feedCount) < 2)
						myPopUp.associateCountTxt.text = model.fishesArray[catIndex].feedCount  + " Feed";
					else
						myPopUp.associateCountTxt.text = model.fishesArray[catIndex].feedCount  + " Feeds";
				}
			}
			else
			{
				yourPopUp = Utils.addMovieFromLibrary("com.lakeview.OthersBox", holderMovieClip);
				Utils.animateMC(yourPopUp, this);
				Utils.moveToTop(yourPopUp);
				
				FishSolvedModel.getInstance().popUps = yourPopUp;
				
				yourPopUp.commentsBtn.addEventListener(MouseEvent.CLICK, showComments);
				
				if (model.fishesArray[catIndex].problemDesc != undefined)
					model.problemDescriptionToFeed = model.fishesArray[catIndex].problemDesc;
				
				yourPopUp.closeMe.addEventListener(MouseEvent.CLICK, closed);
				yourPopUp.closeMe.buttonMode = true;
				
				trace(model.fishesArray[catIndex].isSolver, "IS SOLVER...")
				
				if (model.fishesArray[catIndex].isSolver)
				{
					yourPopUp.solveBtn.visible = true;
					yourPopUp.solveBtn.addEventListener(MouseEvent.CLICK, solveProblem);
				}
				else
					yourPopUp.solveBtn.visible = false;
				
				if (model.fishesArray[catIndex].canIFeed)
				{
					yourPopUp.feedMeMc.visible = true;
					yourPopUp.feedMeMc.addEventListener(MouseEvent.CLICK, feeded);
				}
				else 
					yourPopUp.feedMeMc.visible = false;
				
				yourPopUp.closeMe.addEventListener(MouseEvent.CLICK, closed);
				yourPopUp.closeMe.buttonMode = true;
				
				checkPosition(yourPopUp, targetFish);
				
				if(model.fishesArray[catIndex].categoryName != undefined)
					yourPopUp.categoryTxt.text = model.fishesArray[catIndex].categoryName;
					
				if (model.fishesArray[catIndex].problemDesc != undefined)
				{
					yourPopUp.fishDetailTxt.text = model.fishesArray[catIndex].problemDesc;
					model.problemDescriptionToSolve = model.fishesArray[catIndex].problemDesc;
					
					if(yourPopUp.fishDetailTxt.textHeight > 5)
						yourPopUp.mySb.visible = true;
					else
						yourPopUp.mySb.visible = false;
				}
					
				if(model.fishesArray[catIndex].dob != undefined)
					yourPopUp.dobTxt.text = " " + model.fishesArray[catIndex].dob
				
				if(model.fishesArray[catIndex].feedCount != undefined)
				{
					if(Number(model.fishesArray[catIndex].feedCount) < 2)
						yourPopUp.associateCountTxt.text = model.fishesArray[catIndex].feedCount + " Feed";
					else
						yourPopUp.associateCountTxt.text = model.fishesArray[catIndex].feedCount + " Feeds";
				}
			}
		}
		
		private function deleteFish(e:MouseEvent):void
		{
			this.dispatchEvent(new RemoveFishes(RemoveFishes.DELETE_MY_FISHES, targetFishes, myPopUp));
		}
		
		
		private function showComments(e:MouseEvent):void
		{
			var evt:ApplicationEvent = new ApplicationEvent(ApplicationEvent.SHOW_COMMENTS_EVENT);
			
			evt.commentsX = e.target.parent.x - e.target.parent.width;
			evt.commentsY = e.target.parent.y;
			evt.targetFish = targetFishes;
			
			this.dispatchEvent(evt);
		}
		
		private function solveProblem(e:MouseEvent):void
		{
			var evt:ApplicationEvent = new ApplicationEvent(ApplicationEvent.SOLVE_PROBLEM_EVENT);
			
			evt.solveProbPopUpX = e.target.parent.x + e.target.parent.width;
			evt.solveProbPopUpY = e.target.parent.y;
			evt.solveProbPopUpTargetFish = targetFishes;
			evt.fishDetailPopUpInLake = yourPopUp;
			
			trace(evt.solveProbPopUpX);
			
			this.dispatchEvent(evt);
		}
		
		private function tweenCallback(e:AddPopUp):void
		{
			if(!(e.popupType is Comments))
				checkPosition(e.popupType, targetFishes);
		}
		
		public function checkPosition(mc:MovieClip, targetFish:MovieClip):void
		{
			mc.x = targetFish.x;
			mc.y = targetFish.y;
			
			if((mc.x - mc.width/2) < 0) 
			{
				mc.x = mc.x + (mc.width/2);
				targetFish.x = mc.x;
			}
			if((mc.x + (mc.width * 1.5)) > 900)
			{
				mc.x = 900 - (192*2);
				targetFish.x = mc.x;
			}
			
			if(mc.y < 150)
			{
				mc.y = 150;
				targetFish.y = mc.y;
			}
			if((mc.y + 160) > 400)
			{
				mc.y = 450-160;
				targetFish.y = mc.y;
			}
		}
		
		private function problemSubmitted(evt:MouseEvent):void
		{
			var solvedFishes:FishSolvedModel = FishSolvedModel.getInstance();
			solvedFishes.solvedFishes = targetFishes.name;
			
			holderMovieClip.removeChild(yourPopUp);
			targetFishes.dispatchEvent(new RemoveFishes(RemoveFishes.REMOVE_FISHES));
		}
		
		private var count:Number = 0;
		private function feeded(evt:MouseEvent):void
		{
			model.fishesArray[catIndex].isSolver = false;
			model.fishesArray[catIndex].canIFeed = false;
			
			yourPopUp.solveBtn.visible = false;			
			yourPopUp.feedMeMc.visible = false;
			
			holderMovieClip.removeChild(yourPopUp);
			
			countAssociates = Utils.incrementAssociateCount();
			
			switch(fishCategory)
			{
				case "1":
				{
					feedTheFish("Fish_1to2");
					break;
				}
				case "2":
				{
					feedTheFish("Fish_2to3");
					break;
				}
				case "3":
				{
					feedTheFish("Fish_3to4");
					break;
				}
				case "4":
				{
					feedTheFish("Fish_4to5");
					break;
				}
				case "5":
				{
					feedTheFish("Fish_4to5");
					break;
				}
			}
		}
		
		private function feedTheFish(mcName:String):void
		{
			var evt:RemoveOtherFishes = new RemoveOtherFishes(RemoveOtherFishes.REMOVE_OTHER_FISHES, mcName, targetFishes)
			targetFishes.dispatchEvent(evt);
			fishModel.allPopuUps.pop();
		}
		
		
		private function removed(evt:MouseEvent):void
		{
			if(model.fishesArray[catIndex].isOwner)
				holderMovieClip.removeChild(myPopUp);
			
			targetFishes.dispatchEvent(new RemoveFishes(RemoveFishes.REMOVE_FISHES));
		}
		
		private function closed(evt:MouseEvent):void
		{
			if(model.fishesArray[catIndex].isOwner)
			{
				holderMovieClip.removeChild(myPopUp);
			}
			else
			{
				holderMovieClip.removeChild(yourPopUp);
			}
				
			evt.stopImmediatePropagation();
			
			targetFishes.dispatchEvent(new AddActions(AddActions.ADD_ACTIONS_TO_FISHES));
			
			var addPopUpList:ApplicationEvent = new ApplicationEvent(ApplicationEvent.ADD_POPUP_LISTENER_EVENT);
			targetFishes.dispatchEvent(addPopUpList);
			
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_COMMENTS_EVENT));
			
			var appEvt:ApplicationEvent = new ApplicationEvent(ApplicationEvent.REMOVE_SOLVE_PROB_POPUP_EVENT);
			this.dispatchEvent(appEvt);
			
			fishModel.allPopuUps.pop();
		}
		
		private function takeFishToCenterOfLake(selectedFish:MovieClip, targetX:Number, targetY:Number):void
		{
			var myTweenX:Tween = new Tween(selectedFish, "x", Strong.easeOut, selectedFish.x, stage.stageWidth/2, 3, true);
			var myTweenY:Tween = new Tween(selectedFish, "y", Strong.easeOut, selectedFish.y, stage.stageHeight/2, 3, true);
		}

	}
	
}
