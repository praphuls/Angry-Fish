package com.utils  {

	import com.components.CustomScroll;
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
	
	public class AddPopUpToAquarium extends MovieClip {
		
	    private var happyPopUp:MovieClip;
		private var fishName:String;
		private var targetFishes:MovieClip
		private var fishCategory:String;
		private var holderMovieClip:MovieClip;
		private var catArr:Array = ["Admin", "HR", "NSS", "EAS", "Academy", "Others"];
		private var countAssociates:Number = Utils.associateCount;
		private var fishModel:FishSolvedModel = FishSolvedModel.getInstance();
		private var model:AppModel = AppModel.getInstance();
		private var catIndex:Number;
		
		public function AddPopUpToAquarium(targetFish:MovieClip=null, holderMC:MovieClip=null) 
		{
			targetFishes = targetFish;
			holderMovieClip = holderMC;
			
			addPopUp(targetFish);
			
		}
		
		private function addPopUp(targetFish:MovieClip):void
		{
			var index:Number = Number(targetFish.name.split("-")[1]);
			
			happyPopUp = Utils.addMovieFromLibrary("com.aquariumView.HappyFishPopup", holderMovieClip);
			model.aquaPopUp = happyPopUp;
			
			Utils.animateMC(happyPopUp);
			Utils.moveToTop(happyPopUp);
			
			AppModel.getInstance().aquaPopUp = happyPopUp;
			
			if(model.aquaFishArray[index].resolvingDateTime)
				model.resolvedDate = model.aquaFishArray[index].resolvingDateTime;
				
			if(model.aquaFishArray[index].resolvingComments)
				model.resolvedComments = model.aquaFishArray[index].resolvingComments;
			
			if(model.aquaFishArray[index].categoryName)
				happyPopUp.categoryTxt.text = model.aquaFishArray[index].categoryName;
			
			if(model.aquaFishArray[index].feedCount)
			{
				if(Number(model.aquaFishArray[index].feedCount) < 2)
					happyPopUp.associateCountTxt.text = model.aquaFishArray[index].feedCount + " Feed";
				else
					happyPopUp.associateCountTxt.text = model.aquaFishArray[index].feedCount + " Feeds";
			}
			
			if (model.aquaFishArray[index].problemDesc)
			{
				happyPopUp.fishDetailTxt.text = model.aquaFishArray[index].problemDesc;
				model.problemDescriptionHappyFish = model.aquaFishArray[index].problemDesc;
				
				if(happyPopUp.fishDetailTxt.textHeight > 20)
					happyPopUp.mySb.visible = true;
				else
					happyPopUp.mySb.visible = false;
			}
			
			if(model.aquaFishArray[index].reportedDate)
				happyPopUp.dobTxt.text = " " + model.aquaFishArray[index].reportedDate
				
			if (model.aquaFishArray[index].problemID)
				model.problemIDHappyFish = model.aquaFishArray[index].problemID;
			
			
			happyPopUp.closeMe.addEventListener(MouseEvent.CLICK, closed);
			happyPopUp.commentsBtn.addEventListener(MouseEvent.CLICK, addComments);
			happyPopUp.solutionBtn.addEventListener(MouseEvent.CLICK, addSolution);
			
			//checkPosition(happyPopUp, targetFish);
			setPopUpPosition(happyPopUp, targetFish);
			
		}
		
		private function addComments(e:MouseEvent):void
		{
			trace("in commmms")
			var evt:ApplicationEvent = new ApplicationEvent(ApplicationEvent.UPDATE_COMMENTS_EVENT);
			
			evt.commentsX = e.target.parent.x - e.target.parent.width;
			evt.commentsY = e.target.parent.y;
			evt.targetFish = targetFishes;
			
			this.dispatchEvent(evt);
		}
		
		private function addSolution(e:MouseEvent):void
		{
			trace("in solssss")
			
			var evt:ApplicationEvent = new ApplicationEvent(ApplicationEvent.SHOW_SOLUTION_EVENT);
			
			evt.solveProbPopUpX = e.target.parent.x + e.target.parent.width;
			evt.solveProbPopUpY = e.target.parent.y;
			evt.solveProbPopUpTargetFish = targetFishes;
			
			
			this.dispatchEvent(evt);
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
			
			if(mc.y < 350)
			{
				mc.y = 350;
				targetFish.y = mc.y;
			}
			if((mc.y + 120) > 490)
			{
				mc.y = 490-120;
				targetFish.y = mc.y;
			}
		}
		
		private function setPopUpPosition(popUp:MovieClip, targetFish:MovieClip):void
		{
			var popUpWidth:Number = 195;
			var popUpHeight:Number = 257;
			
			if((targetFish.x - (targetFish.width/2) - popUpWidth) < 50)
			{
				
				targetFish.x = 65 + popUpWidth;
				popUp.x = targetFish.x;
			}
			
			if((targetFish.x + (targetFish.width/2) + (popUpWidth*2)) > 900)
			{
				
				targetFish.x = 950 - popUpWidth*2;
				popUp.x = targetFish.x;
			}
			
			checkPosition(popUp, targetFish)
		}
		
		
		private function closed(evt:MouseEvent):void
		{	
			if (happyPopUp) 
			{
				holderMovieClip.removeChild(happyPopUp);
				model.aquaPopUp = null;
			}
			
			evt.stopImmediatePropagation();
			
			targetFishes.dispatchEvent(new AddActions(AddActions.ADD_ACTIONS_TO_FISHES));
			
			var addPopUpList:ApplicationEvent = new ApplicationEvent(ApplicationEvent.ADD_POPUP_LISTENER_EVENT);
			targetFishes.dispatchEvent(addPopUpList);
			
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_COMMENTS_AQUA_EVENT));
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_SOLUTION_EVENT));
		}
		

	}
	
}
