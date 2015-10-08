package com.aquariumView  {
	import com.config.AppConfig;
	import com.controller.AppController;
	import com.events.AddActions;
	import com.events.AddPopUp;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.utils.AddPopUpToAquarium;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import com.model.FishSolvedModel;
	
	import com.utils.Utils;
	
	public class AquariumView extends MovieClip {
		
		private var solvedFishes:FishSolvedModel;
		private var mainMC:MovieClip;
		private var aquaMc:MovieClip;
		private var model:AppModel = AppModel.getInstance();
		private var popUp:AddPopUpToAquarium;
		private var controller:AppController;
		private var solPopUp:MovieClip;
		private var namePlateText:String;
		private var targetHappyFish:MovieClip;
		
		private var happyFishArray:Array = ["com.fishes.happyFishes.HappyFish_1",
											"com.fishes.happyFishes.HappyFish_2",
											"com.fishes.happyFishes.HappyFish_3",
											"com.fishes.happyFishes.HappyFish_4",
											"com.fishes.happyFishes.HappyFish_5"];
		
		public function AquariumView(mainMovie:MovieClip) 
		{
			mainMC = mainMovie;
			aquaMc = this;
			model.aquarium = this;
			controller = new AppController();
			
			setAquariumName();
			addAquarium();
		}
		
		private function setAquariumName():void
		{
			if (model.lakeType == "2")
			{
				namePlateText = model.aquariumName + "'s Aquarium";
				mainMC.namePlateMc.nameTxt.text = namePlateText;
			}
			else
				mainMC.namePlateMc.visible = false;
			
			
		}
		
		private function addAquarium():void
		{
			trace(model.aquaFishArray.length);
			addFishes(model.aquaFishArray.length);
		}
		
		private function addFishes(fishNum:Number):void
		{
			model.aquaHappyFishArray = new Array();
			var happyFish:MovieClip
			
			if(fishNum > 0)
			{
				for(var i:Number=0; i<fishNum; i++)
				{
					happyFish = Utils.addMovieFromLibrary(happyFishArray[1], aquaMc);
					happyFish.name = "level_1-" + i;
					happyFish.buttonMode = true;
					
					model.aquaHappyFishArray.push(happyFish);
					addListnersToFish(happyFish);
					
					if (model.lakeType == "2")
					{
						if (model.aquaFishArray[i].problemID == model.problemIDPrimary)
							targetHappyFish = happyFish;
					}
					else
						targetHappyFish = null;
				}
			}
			
			if (model.lakeType == "2" && targetHappyFish)
			{
				intimateFishesAboutAction("INACTIVE_THIS_FISH");
				Utils.moveToTop(targetHappyFish);
				addDefaultPopUps(targetHappyFish);
			}
		}
		
		private function intimateFishesAboutAction(action:String):void
		{
			var arrLen:Number = model.aquaHappyFishArray.length
			for(var i:Number=0; i<arrLen; i++)
			{
				(model.aquaHappyFishArray[i] as MovieClip).dispatchEvent(new Event(action));
			}
		}
		
		private function addListnersToFish(fish:MovieClip):void
		{			
			fish.addEventListener(AddPopUp.ADD_POPUP, addPopUps);
			fish.addEventListener(ApplicationEvent.HIDE_COMMENTS_AQUA_EVENT, hideComments);
			fish.addEventListener(ApplicationEvent.HIDE_SOLUTION_EVENT, closeSolvePopup);
			fish.addEventListener(ApplicationEvent.ADD_POPUP_LISTENER_EVENT, addPopUpListener);
		}
		
		private function addPopUpListener(e:ApplicationEvent):void
		{
			enableAllFishes();
		}
		
		private function enableAllFishes():void
		{
			var happyFishLen:Number = model.aquaHappyFishArray.length;
			
			if(happyFishLen > 0)
			{
				for(var j:Number=0; j<happyFishLen; j++)
				{
					model.aquaHappyFishArray[j].addEventListener(AddPopUp.ADD_POPUP, addPopUps);
					model.aquaHappyFishArray[j].mouseEnabled = true;
				}
			}
			
		}
		
		private function addPopUps(e:AddPopUp):void
		{
			(e.target as MovieClip).mouseEnabled = false;
			(e.target as MovieClip).removeEventListener(AddPopUp.ADD_POPUP, addPopUps);
			
			//if (model.aquaPopUp)
			//{
				//Utils.removePopUpsFromLake(model.aquaPopUp, this);
			//}
			
			popUp = new AddPopUpToAquarium((e.target as MovieClip), this);
			addListenersToPopUp(popUp)
			setCommentsPosition(e.target as MovieClip);
		}
		
		private function addDefaultPopUps(targetHappyFish:MovieClip):void
		{
			if (model.aquaPopUp)
			{
				Utils.removePopUpsFromLake(model.aquaPopUp, this);
			}
			
			var popUpDefault = new AddPopUpToAquarium(targetHappyFish, this);
			addListenersToPopUp(popUpDefault)
			setCommentsPosition(targetHappyFish);
			popUp = popUpDefault;
		}
		
		private function addListenersToPopUp(popUps:MovieClip):void
		{
			popUps.addEventListener(ApplicationEvent.UPDATE_COMMENTS_EVENT, addCommnetsPopUps);
			popUps.addEventListener(ApplicationEvent.SHOW_SOLUTION_EVENT, addSolutionPopUps);
			popUps.addEventListener(ApplicationEvent.HIDE_COMMENTS_AQUA_EVENT, hideComments);
			popUps.addEventListener(ApplicationEvent.HIDE_SOLUTION_EVENT, closeSolvePopup);
		}
			
		private var appEvt:ApplicationEvent;
		private function addCommnetsPopUps(e:ApplicationEvent):void
		{
			appEvt = e;
			controller.doAction(AppConfig.GET_COMMENTS_FOR_AQUARIUM, this);
			controller.addEventListener(ApplicationEvent.SHOW_COMMENTS_AQUA_EVENT, updateComments);
			
			popUp.removeEventListener(ApplicationEvent.UPDATE_COMMENTS_EVENT, addCommnetsPopUps);
		}
		
		private var newComments:MovieClip;
		private function updateComments(e:ApplicationEvent):void
		{
			trace("comments updated")
			
			var commentsArray:Array = new Array();
			var commentsStr:String = "";
			
			if (model.commentsArray.length < 1)
			{
				commentsStr = "No comments";
			}
			
			for (var i:Number = 0; i < model.commentsArray.length; i++ )
			{
				trace(model.commentsArray[i].comments, "SEARCH*************")
				commentsStr += "Comment " + (i + 1) + " \n" + model.commentsArray[i].comments + "\n";
			}
			
			newComments = Utils.addMovieFromLibrary("com.aquariumView.Comments", this);
			Utils.animateMC(newComments);
			Utils.moveToTop(newComments);
			
			newComments.commentsTxt.text = commentsStr;
			newComments.clickeMe.addEventListener(MouseEvent.CLICK, hideComments);
			
			if(newComments.commentsTxt.textHeight > 6)
				newComments.mySb.visible = true;
			else
				newComments.mySb.visible = false;
			
			newComments.x = appEvt.commentsX + 190;
			newComments.y = appEvt.commentsY;
		}
		
		private function hideComments(e:Event=null):void
		{
			if(newComments)
			{
				this.removeChild(newComments);
				newComments = null;
				
				popUp.addEventListener(ApplicationEvent.UPDATE_COMMENTS_EVENT, addCommnetsPopUps);
			}
		}
		
		private function addSolutionPopUps(e:ApplicationEvent):void
		{	
			popUp.removeEventListener(ApplicationEvent.SHOW_SOLUTION_EVENT, addSolutionPopUps);
			
			solPopUp = Utils.addMovieFromLibrary("com.aquariumView.Solution", this);
			Utils.animateMC(solPopUp);
			Utils.moveToTop(solPopUp);
			
			if(model.resolvedComments)
				solPopUp.solTxt.text = model.resolvedComments;
			
			if(model.resolvedDate)
				solPopUp.dateTxt.text = model.resolvedDate;
			
			solPopUp.x = e.solveProbPopUpX;
			solPopUp.y = e.solveProbPopUpY;
			
			setSolutionPosition(e.solveProbPopUpTargetFish);
			
			if(solPopUp.solTxt.textHeight > 6)
				solPopUp.mySb.visible = true;
			else
				solPopUp.mySb.visible = false;
			
			solPopUp.clickeMe.addEventListener(MouseEvent.CLICK, closeSolvePopup);
			
			
		}
		
		private function closeSolvePopup(e:Event=null):void
		{
			if(solPopUp)
			{
				this.removeChild(solPopUp);
				solPopUp = null;
				
				popUp.addEventListener(ApplicationEvent.SHOW_SOLUTION_EVENT, addSolutionPopUps);
			}
		}
		
		private function setCommentsPosition(targetFish:MovieClip):void
		{
			var popUpWidth:Number = 195;
			var popUpHeight:Number = 257;
			
			if((targetFish.x - (targetFish.width/2) - popUpWidth) < 50)
			{
				
				targetFish.x = 65 + popUpWidth;
				
				if (popUp)
				{
					model.aquaPopUp.x = targetFish.x;
				}
					
				if (solPopUp)
					solPopUp.x = model.aquaPopUp.x + (model.aquaPopUp.width);
					
				if (newComments)
					newComments.x = targetFish.x - 10;
			}
			
			if((targetFish.x + (targetFish.width/2) + (popUpWidth*2)) > 900)
			{
				
				targetFish.x = 950 - popUpWidth*2;
				
				if (popUp)
				{
					model.aquaPopUp.x = targetFish.x;
				}
					
				if (solPopUp)
					solPopUp.x = model.aquaPopUp.x + (model.aquaPopUp.width);
					
				if (newComments)
					newComments.x = targetFish.x - 10;
			}
		}
		
		private function setSolutionPosition(targetFish:MovieClip):void
		{
			var popUpWidth:Number = 195;
			var popUpHeight:Number = 257;
			
			if((targetFish.x + (targetFish.width/2) + (popUpWidth*2)) > 900)
			{
				
				targetFish.x = 950 - popUpWidth*2;
				
				if (popUp)
				{
					model.aquaPopUp.x = targetFish.x;
				}
					
				if (solPopUp)
					solPopUp.x = model.aquaPopUp.x + (model.aquaPopUp.width);
					
				if (newComments)
					newComments.x = targetFish.x - 10;
			}
		}
		
		//-----------------------------------------
		
		public function refreshAqarium():void
		{
			setAquariumName();
			addFishes(model.aquaFishArray.length);
		}
		
		public function clearAquarium():void
		{
			var target_mc:MovieClip = this;
			
			trace(target_mc.numChildren, "In Clean Aqua");
			
			for (var i:uint = 0; i < target_mc.numChildren; i++){
				trace (i + '.\t name:' + target_mc.getChildAt(i).name + '\t type:' + typeof (target_mc.getChildAt(i)) + '\t' + target_mc.getChildAt(i),"REFERSH...");
				target_mc.removeChild(target_mc.getChildAt(i));
			}
		}

	}
	
}
