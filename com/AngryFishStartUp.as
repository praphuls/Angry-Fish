package com  {
	
	import com.config.AppConfig;
	import com.config.ServiceConfig;
	import com.controller.AppController;
	import com.events.ApplicationEvent;
	import com.lakeview.ContextHelper;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.DisplayObject;
	
	import com.*;
	import com.lakeview.LakeView;
	import com.aquariumView.AquariumView;
	import com.utils.Utils;
	import com.serviceLocator.AppServiceLocator;
	import flash.external.ExternalInterface;
	import flash.ui.Keyboard;
	
	import flash.text.StyleSheet;
	import flash.events.TextEvent;
	import flash.net.navigateToURL
	
	import flash.events.KeyboardEvent; 
	
	public class AngryFishStartUp extends MovieClip {
		
		private var lake:MovieClip = FishSolvedModel.getInstance().lakeMc;
		private var aqua:AquariumView;
		private var currentView:String;
		private var controller:AppController;
		private var model:AppModel = AppModel.getInstance();
		private var searchKeyword:String;
		private var contextHelper:ContextHelper = ContextHelper.getInstance();
		private var helpIndex:Number;
		
		public function AngryFishStartUp() 
		{
			totalMask.visible = true;
			FishSolvedModel.getInstance().mainStage = this;
			model.isAppLaunched = false;
			
			getPrimaryData();
			showHidelakeElements(false);
			hideAssetsOnStage();
			addListenersToStage();
			
			getIsHelpValue();
		}
		
		private function getIsHelpValue():void
		{
			controller = new AppController();
			controller.doAction(AppConfig.IS_HELP_DATA, this);	
			controller.addEventListener(ApplicationEvent.IS_HELP_DATA_EVENT, showIsHelp);
		}
		
		private function showIsHelp(e:ApplicationEvent):void
		{
			//ExternalInterface.call('alert', 'Hi...');
			showHelp();
		}
		
		private function getPrimaryData():void
		{
			if (ExternalInterface.available) 
			{
				var retData:Object = ExternalInterface.call("GetPrimaryData");
				
				if (retData != null) 
				{
					model.assocaiteID = retData.associateId.toString();
					model.associateName = retData.associateName.toString();
					model.lakeType = retData.LakeType.toString();
					model.problemIDPrimary = retData.ProblemId.toString();
					model.aquariumIdPrimary = retData.AquariumId.toString();				  
					model.aquariumName = retData.AquariumName.toString();				  
				}
				else 
				{
				  setDafaultPrimaryData();
				}
			} 
			else
			{
				setDafaultPrimaryData();
				trace("External Interface not available");
			}
		}
		
		private function setDafaultPrimaryData():void
		{
			model.assocaiteID = '121138'//"298161";//298093
			model.associateName = "Vishal Haibatpure";
			model.lakeType = "1";
			model.problemIDPrimary = "33";
			model.aquariumIdPrimary = "121138";
			model.aquariumName = "Yuvraaj Pingle";
		}
		
		
		private function hideAssetsOnStage():void
		{
			egg_1.visible = false;
			egg_broken.visible = false;
			instructions_mc.visible = false;
			searchTxt.alpha = 0.5;
			loadingMc.visible = false;
			deleteFishPopUp.visible = false;
			aquaView.visible = false;
			leadersMc.visible = false;
		}
		
		private function showHelp():void
		{
			if (model.isShowHelp as Boolean)
			{
				onAppLaunch();
			}
			else
			{
				setViewBasedOnLakeType();
			}
		}
		
		private function setViewBasedOnLakeType():void
		{
			switch(model.lakeType)
			{
				case "0":
				case "1":
					{
						configureLakeView();
						prepareLakeView();
						break;
					}
					
				case "2":
					{
						configureAquariumFromNotification();						
						break;
					}
			}
		}
		
		private function configureLakeView():void
		{
			controller = new AppController();
			this.addEventListener(ApplicationEvent.STARTUP_UPDATE, onStartUp);
		}
		
		private function setEggToHatch(e:ApplicationEvent=null):void
		{
			var array:Array = model.startUpArray;
			var avialableEggToHatch:Number = model.startUpArray[0];
			
			if (avialableEggToHatch > 0)
			{
				egg_1.gotoAndStop(1);
				egg_1.visible = true;
				egg_broken.visible = false;
			}
			else 
			{
				egg_1.visible = false;
				egg_broken.visible = true;
			}
			
			if (!model.isContextHelpShown)
			{
				contextHelper.startContextHelper(this);
				model.isContextHelpShown = true;
			}
		}		
		
		
		private function onStartUp(e:Event):void
		{
			controller.doAction(AppConfig.GET_CATEGORY, categoryMC);
			controller.addEventListener(ApplicationEvent.GET_CATEGORIES_EVENT, getCategories);
			this.addEventListener(ApplicationEvent.RECORD_CLICK_EVENT, setEggToHatch);
			
			setStageForLake();
			showHidelakeElements(true);
			setEggToHatch();
		}
		
		private function setStageForLake():void
		{
			this.instructions_mc.visible = false;
		}
		
		private function addListenersToStage():void
		{
			for (var i:Number = 0; i < 9; i++ )
			{
				this.instructions_mc.addEventListener("STEP_CHANGED_"+i, onInstructionStepChange);
			}
			
			this.instructionsMc.addEventListener(MouseEvent.CLICK, onInstruction);
			this.instructions_mc.closeMe.addEventListener(MouseEvent.CLICK, onCloseMe);
			this.navigationMc.aquariumMc.addEventListener(MouseEvent.CLICK, aquaViewLoad);
			this.navigationMc.lakeMc.addEventListener(MouseEvent.CLICK, lakeViewLoad);
			this.refreshBtn.addEventListener(MouseEvent.CLICK, onRefresh);
			this.categoryBtn.addEventListener(MouseEvent.CLICK, showCategory);
			this.myFishesBtn.addEventListener(MouseEvent.CLICK, filterMyFishes);
			this.topProblemsBtn.addEventListener(MouseEvent.CLICK, showTopProblems);
			this.searchBtn.addEventListener(MouseEvent.CLICK, searchKeywords);
			this.searchTxt.addEventListener(KeyboardEvent.KEY_DOWN, enterkeyHandler);
			this.searchTxt.addEventListener(MouseEvent.CLICK, searchKeywordsChange);
			this.leadersBtn.addEventListener(MouseEvent.CLICK, showLeaders);
			stage.addEventListener(MouseEvent.CLICK, searchKeywordsChange);
			
			this.addEventListener(ApplicationEvent.ADD_HELP_ON_LAUNCH, onAppLaunch);
			
			this.egg_broken.addEventListener(MouseEvent.ROLL_OVER, brokenEggMouseRoll);
			this.egg_broken.addEventListener(MouseEvent.ROLL_OUT, brokenEggMouseRoll);
			
			this.instructions_mc.nextBtn.addEventListener(MouseEvent.CLICK, nextHelp);
			this.instructions_mc.backBtn.addEventListener(MouseEvent.CLICK, backHelp);
			this.instructions_mc.playBtn.addEventListener(MouseEvent.CLICK, playGame);
		}
		
		private function onAppLaunch(): void
		{
			if (!model.isAppLaunched)
			{
				this.instructions_mc.visible = true;
				this.instructions_mc.detailsMC.gotoAndPlay('ins_0');
				Utils.moveToTop(this.instructions_mc);
			}
		}
		
		private var brokenEggPopUp:MovieClip;
		private function brokenEggMouseRoll(e:MouseEvent):void
		{
			searchTxt.alpha = 0.5;
			searchTxt.text = "Keywords or description";
			
			switch(e.type.toString())
			{
				case "rollOver":
					{
						brokenEggPopUp = Utils.addMovieFromLibrary("BrokenEggPopUp", this);
						Utils.animateMC(brokenEggPopUp);
						
						brokenEggPopUp.x = e.target.x;
						brokenEggPopUp.y = e.target.y;
						break;
					}
				case "rollOut":
					{
						this.removeChild(brokenEggPopUp);
						break;
					}
			}
		}
		
		private function showHidelakeElements(val:Boolean):void
		{
			eggContainerMc.visible = val;
			instructionsMc.visible = val;
			refreshBtn.visible = val;
		}
		
		private function searchKeywordsChange(event:MouseEvent):void
		{
			switch(event.target)
            {
                case searchTxt:
					{
						searchTxt.alpha = 1;
						searchTxt.text = "";
						break;
					}

                case stage:
					{
						searchTxt.alpha = 0.5;
						searchTxt.text = "Keywords or description";
						break;
					}
            }
		}
		
		private function enterkeyHandler(event : KeyboardEvent) : void
		{
			if (!loadingMc.visible)
			{
				if (event.keyCode == Keyboard.ENTER)
					searchItems();
			}
		}
		
		private function searchKeywords(e:MouseEvent):void
		{
			if (!loadingMc.visible)
				searchItems();
		}
		
		private function searchItems():void
		{
			controller.doAction(AppConfig.CLOSE_SCORE_CARD, model.myScoreCard);
			
			if (FishSolvedModel.getInstance().catMcToBeRemoved)
				Utils.removePopUpsFromLake(categoryMC, this);
			
			if (searchTxt.text != "Keywords or description" && searchTxt.text != "Please enter some text" && searchTxt.text != "")
			{
				Utils.removeNoFishPopUp(this);
				loadingMc.visible = true;
				model.searchKeywords = searchTxt.text;
				controller.doAction(AppConfig.SEARCH_KEYWORDS, this);
			}
			else
			{
				searchTxt.alpha = 1;
				searchTxt.text = "Please enter some text";
			}
		}
		
		private var isTopHatchersReady:Boolean = false;
		private var isTopFeedersReady:Boolean = false;
		private var isTopResolversReady:Boolean = false;
		private function showLeaders(e:MouseEvent):void
		{
			controller.doAction(AppConfig.CLOSE_SCORE_CARD, model.myScoreCard);
			
			searchTxt.alpha = 0.5;
			searchTxt.text = "Keywords or description";
			
			Utils.removeNoFishPopUp(this);
			showTopHachers();
		}
		
		private function topLeaders():void
		{
			if(isTopHatchersReady && isTopFeedersReady && isTopResolversReady)
			{
				leadersMc.visible = true;
				Utils.moveToTop(this.leadersMc);
			}
		}
		
		private function showTopHachers(e:MouseEvent=null):void
		{
			controller.doAction(AppConfig.TOP_HATCHERS, this);
		}
		
		public function showHatchers():void
		{
			var topHatchers:String = "";
			
			if (FishSolvedModel.getInstance().catMcToBeRemoved)
				Utils.removePopUpsFromLake(categoryMC, this);
			
			this.leadersMc.topHatchersTxt.styleSheet = Utils.setStylesToLinks();
			
			for (var i:Number = 0; i < model.topHatchersArray.length; i++ )
			{
				if(model.topHatchersArray[i].associateName != undefined || model.topHatchersArray[i].associateName != null)
					topHatchers += (i+1) + ". " + "<a target='blank' href='"+ String(ServiceConfig.HYPER_LINK_URL + model.topHatchersArray[i].associateId) +"'>"+ model.topHatchersArray[i].associateName.split(" ")[0] +"</a>" + "\n" + " " + model.topHatchersArray[i].associateId + "\n" + "\n";
				else	
					topHatchers += "";
			}
			
			if(topHatchers != "")
				this.leadersMc.topHatchersTxt.htmlText = topHatchers;
			else
				this.leadersMc.topHatchersTxt.text = "No Top Hatchers";
			
			isTopHatchersReady = true;
			showTopFeeders();
		}
		
		private function showTopFeeders():void
		{
			controller.doAction(AppConfig.TOP_FEEDERS, this);
		}
		
		public function showFeeders(e:ApplicationEvent=null):void
		{
			var topFeeders:String = "";
			
			if (FishSolvedModel.getInstance().catMcToBeRemoved)
				Utils.removePopUpsFromLake(categoryMC, this);
			
			this.leadersMc.topFeedersTxt.styleSheet = Utils.setStylesToLinks();;
			
			for (var i:Number = 0; i < model.topFeedersArray.length; i++ )
			{
				if(model.topFeedersArray[i].associateName != undefined)
					topFeeders += (i+1) + ". " +  "<a target='blank' href='"+ String(ServiceConfig.HYPER_LINK_URL + model.topFeedersArray[i].associateId) +"'>"+ model.topFeedersArray[i].associateName.split(" ")[0] +"</a>" + "\n" + " " + model.topFeedersArray[i].associateId + "\n" + "\n";
				else	
					topFeeders += "";
			}
			
			if(topFeeders != "")
				this.leadersMc.topFeedersTxt.htmlText = topFeeders;
			else
				this.leadersMc.topFeedersTxt.text = "No Top Feeders";
			
			
			
			isTopFeedersReady = true;
			showTopResolvers();
		}
		
		private function showTopResolvers(e:MouseEvent=null):void
		{
			controller.doAction(AppConfig.TOP_RESOLVER, this);
			
		}
		
		public function showResolvers():void
		{
			var topResolvers:String = "";
			
			if (FishSolvedModel.getInstance().catMcToBeRemoved)
				Utils.removePopUpsFromLake(categoryMC, this);
			
			this.leadersMc.topResolversTxt.styleSheet = Utils.setStylesToLinks();;
			
			for (var i:Number = 0; i < model.topResolversArray.length; i++ )
			{
				if(model.topResolversArray[i].associateName != undefined)
					topResolvers += (i+1) + ". " + "<a target='blank' href='"+ String(ServiceConfig.HYPER_LINK_URL + model.topResolversArray[i].associateId) +"'>"+ model.topResolversArray[i].associateName.split(" ")[0] +"</a>" + "\n" + " " + model.topResolversArray[i].associateId + "\n" + "\n";
				else	
					topResolvers += "";
			}
			
			if(topResolvers != "")
				this.leadersMc.topResolversTxt.htmlText = topResolvers;
			else
				this.leadersMc.topResolversTxt.text = "No Top Resolver";
			
			isTopResolversReady = true;
			topLeaders();
		}
		
		

		
		private function showTopProblems(e:MouseEvent):void
		{
			controller.doAction(AppConfig.CLOSE_SCORE_CARD, model.myScoreCard);
			
			Utils.removeNoFishPopUp(this);
			
			if (FishSolvedModel.getInstance().catMcToBeRemoved)
				Utils.removePopUpsFromLake(categoryMC, this);
				
			searchTxt.alpha = 0.5;
			searchTxt.text = "Keywords or description";
			controller.doAction(AppConfig.TOP_PROBLEMS, this);
		}
		
		
		private function onRefresh(e:MouseEvent=null):void
		{
			model.lakeType = "0";
			
			if (!controller)
				controller = new AppController();
				
			controller.doAction(AppConfig.CLOSE_SCORE_CARD, model.myScoreCard);
			
			Utils.removeNoFishPopUp(this);
			
			if (FishSolvedModel.getInstance().catMcToBeRemoved)
				Utils.removePopUpsFromLake(categoryMC, this);
				
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_COMMENTS_EVENT));
			var arrLen:Number = FishSolvedModel.getInstance().allPopuUps.length;
			if(arrLen > 0)
			{
				for(var i:Number=0; i<arrLen; i++)
				{
					(FishSolvedModel.getInstance().lakeMc).removeChild(FishSolvedModel.getInstance().allPopuUps[i]);
					FishSolvedModel.getInstance().allPopuUps.pop();
				}
			}
				
			
			searchTxt.alpha = 0.5;
			searchTxt.text = "Keywords or description";
			
			if (!loadingMc.visible)
			{
				Utils.removeNoFishPopUp(this);
				configureLakeView();
				
				loadingMc.visible = true;
				controller.doAction(AppConfig.REFRESH_STAGE, this);
			}
		}
		
		private function filterMyFishes(e:MouseEvent):void
		{
			controller.doAction(AppConfig.CLOSE_SCORE_CARD, model.myScoreCard);
			
			Utils.removeNoFishPopUp(this);
			
			if (FishSolvedModel.getInstance().catMcToBeRemoved)
				Utils.removePopUpsFromLake(categoryMC, this);
			
			searchTxt.alpha = 0.5;
			searchTxt.text = "Keywords or description";
			
			controller.doAction(AppConfig.FILTER_MY_FISHES, this);
		}
		
		private var categoryMC:MovieClip;
		private var isCatAvailable:Boolean = false;
		private function showCategory(e:MouseEvent):void
		{
			controller.doAction(AppConfig.CLOSE_SCORE_CARD, model.myScoreCard);
			
			Utils.removeNoFishPopUp(this);
			
			searchTxt.alpha = 0.5;
			searchTxt.text = "Keywords or description";
			
			if (FishSolvedModel.getInstance().catMcToBeRemoved)
				return;
			
			if (isCatAvailable)
			{
				categoryMC = Utils.addMovieFromLibrary("com.components.CategorySelector", this);			
				this.categoryMC.visible = true;
				Utils.animateMC(categoryMC);
				Utils.moveToTop(categoryMC);
				FishSolvedModel.getInstance().catMcToBeRemoved = categoryMC;
				
				categoryMC.x = 123;
				categoryMC.y = 75;
				
				categoryMC.closeMe.addEventListener(MouseEvent.CLICK, closeCategory);
			}
		}
		
		private function getCategories(e:ApplicationEvent):void
		{
			//trace(model.categoriesArray);
			isCatAvailable = true;
		}
		
		private function closeCategory(e:MouseEvent):void
		{
			this.categoryMC.visible = false;
			categoryMC = null;
			FishSolvedModel.getInstance().catMcToBeRemoved = null;
		}
		
		private function onInstructionStepChange(evt:Event):void
		{
			helpIndex = Number(evt.type.split('_')[2]);
			//ExternalInterface.call('alert', helpIndex)
		}
		
		private function onInstruction(evt:MouseEvent=null):void
		{
			controller.doAction(AppConfig.CLOSE_SCORE_CARD, model.myScoreCard);
			
			if (FishSolvedModel.getInstance().catMcToBeRemoved)
				Utils.removePopUpsFromLake(categoryMC, this);
			Utils.removeNoFishPopUp(this);
				
			searchTxt.alpha = 0.5;
			searchTxt.text = "Keywords or description";
			
			lake.visible = false;
			this.instructions_mc.visible = true;//ins_0
			this.instructions_mc.detailsMC.gotoAndPlay('ins_0');
			Utils.moveToTop(this.instructions_mc);
			
			this.instructions_mc.nextBtn.addEventListener(MouseEvent.CLICK, nextHelp);
			this.instructions_mc.backBtn.addEventListener(MouseEvent.CLICK, backHelp);
			this.instructions_mc.playBtn.addEventListener(MouseEvent.CLICK, playGame);
		}
		
		
		private function nextHelp(e:MouseEvent):void
		{
			if (helpIndex < 8)
				this.instructions_mc.detailsMC.gotoAndPlay('ins_' + ++helpIndex);
			else
				this.instructions_mc.detailsMC.gotoAndPlay('ins_7');
			
			//ExternalInterface.call('alert', 'ins_' + ++helpIndex);
		}
		
		private function backHelp(e:MouseEvent):void
		{
			//ExternalInterface.call('alert', 'ins_' + --helpIndex);
			
			if(helpIndex > 0)
				this.instructions_mc.detailsMC.gotoAndPlay('ins_' + --helpIndex);
			else
				this.instructions_mc.detailsMC.gotoAndPlay('ins_0');
			
			
		}
		
		private function playGame(e:MouseEvent):void
		{
			this.instructions_mc.detailsMC.gotoAndStop('ins_0');
			instructions_mc.visible = false;
			
			if (!model.isAppLaunched)
			{
				setViewBasedOnLakeType();
				model.isAppLaunched = true;
			}
			else
				lake.visible = true;
			
			this.instructions_mc.nextBtn.removeEventListener(MouseEvent.CLICK, nextHelp);
			this.instructions_mc.backBtn.removeEventListener(MouseEvent.CLICK, backHelp);
			this.instructions_mc.playBtn.removeEventListener(MouseEvent.CLICK, playGame);
		}
		
		private function onCloseMe(evt:MouseEvent):void
		{
			this.instructions_mc.detailsMC.gotoAndStop('ins_0');
			instructions_mc.visible = false;
			
			if (!model.isAppLaunched)
			{
				setViewBasedOnLakeType();
				model.isAppLaunched = true;
			}
			else
				lake.visible = true;
			
			this.instructions_mc.nextBtn.removeEventListener(MouseEvent.CLICK, nextHelp);
			this.instructions_mc.backBtn.removeEventListener(MouseEvent.CLICK, backHelp);
			this.instructions_mc.playBtn.removeEventListener(MouseEvent.CLICK, playGame);
		}
		
		private function onLaunch(evt:MouseEvent):void
		{
			showHidelakeElements(true);
			prepareLakeView();
		}
		
		private function enableLakeView():void
		{
			navigationMc.lakeMc.alpha = 0.35;
			navigationMc.lakeMc.enabled = false;
			
			navigationMc.aquariumMc.alpha = 1;
			navigationMc.aquariumMc.enabled = true;
			
			this.lakeBubbles.visible = true;
		}
		
		private function enableAquaView():void
		{
			this.lakeBubbles.visible = false;
			loadingMc.visible = false;
			
			navigationMc.lakeMc.alpha = 1;
			navigationMc.lakeMc.enabled = true;
			
			navigationMc.aquariumMc.alpha = 0.35;
			navigationMc.aquariumMc.enabled = false;
		}
		
		private function prepareLakeView():void
		{
			enableLakeView();
			
			loadingMc.visible = false;
			
			if(aquaView)
				aquaView.visible = false;
			
			if (!lake)
			{
				lake = new LakeView(this);
				addChild(lake);
				
				aquaView.visible = false;
			}
			
			lake.visible = true;
		}
		
		private function configureAquariumFromNotification():void
		{
			controller = new AppController();
			controller.doAction(AppConfig.GET_AQUARIUM_FROM_NOTIFICATION, this);
			controller.addEventListener(ApplicationEvent.AQUARIUM_STARTUP_EVENT, onAquaStartUp);
		}
		
		private function configureAquariumView():void
		{
			controller = new AppController();
			controller.doAction(AppConfig.GET_AQUARIUM, this);
			controller.addEventListener(ApplicationEvent.AQUARIUM_STARTUP_EVENT, onAquaStartUp);
		}
		
		private function onAquaStartUp(e:ApplicationEvent):void
		{
			trace("Aqua.." + model.aquaFishArray.length)
			
			if(lake)
				lake.visible = false;
				
			totalMask.visible = false;
			loadingMc.visible = false;
			instructionsMc.visible = true;
			navigationMc.visible = true;
			
			prepareAquariumView();
		}
		
		private function prepareAquariumView():void
		{
			enableAquaView();
			
			if(!aqua)
			{
				aqua = new AquariumView(this.aquaView);
				addChild(aqua);
			}
			
			aquaView.visible = true;
		}
		
		
		
		private function lakeViewLoad(evt:MouseEvent):void
		{
			if (aqua)
			{
				if (model.aquaPopUp)
				{
					Utils.removePopUpsFromLake(model.aquaPopUp, model.aquarium);
					model.aquaPopUp = null;
				}
			
				this.removeChild(aqua);
				aqua = null;
			}
			
			model.lakeType = "0";
			
			configureLakeView();
			prepareLakeView();
			
			controller = new AppController();
			controller.doAction(AppConfig.REFRESH_STAGE, this);
			
			loadingMc.visible = true;
			Utils.moveToTop(loadingMc)
		}
		
		private function aquaViewLoad(evt:MouseEvent):void
		{	
			lake.dispatchEvent(new ApplicationEvent(ApplicationEvent.REMOVE_NEW_FISH_BOX_EVENT));
			
			if(model.noFishPopUp)
				model.noFishPopUp.visible = false;
			
			if(categoryMC)
				this.categoryMC.visible = false;
			
			if (FishSolvedModel.getInstance().popUps)
				FishSolvedModel.getInstance().popUps = null;
			
			contextHelper.hideContext();
				
			loadingMc.visible = true;
			Utils.moveToTop(loadingMc);
				
			configureAquariumView();
		}
	}
	
}