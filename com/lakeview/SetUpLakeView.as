package com.lakeview  {
	import flash.display.MovieClip;
	
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	
	import com.*;
	import com.lakeview.LakeView;
	import com.aquariumView.AquariumView;
	import com.utils.Utils;
	import com.serviceLocator.AppServiceLocator;
	
	public class SetUpLakeView extends MovieClip {
		
		private var lake:LakeView;
		private var aqua:AquariumView;
		private var currentView:String;
		private var mainStage:MovieClip;

		public function SetUpLakeView(mc:MovieClip) {
			mainStage = mc;
			
			setStageForLake();
			
			showHidelakeElements(true);
			prepareLakeView();
		}
		
		private function setStageForLake():void
		{
			mainStage.introMc.launchBtn.addEventListener(MouseEvent.CLICK, onLaunch);
			mainStage.instructionsMc.addEventListener(MouseEvent.CLICK, onInstruction);
			mainStage.instructions_mc.closeMe.addEventListener(MouseEvent.CLICK, onCloseMe);
			mainStage.navigationMc.aquariumMc.addEventListener(MouseEvent.CLICK, viewLoad);
			mainStage.navigationMc.lakeMc.addEventListener(MouseEvent.CLICK, viewLoad);
			mainStage.refreshBtn.addEventListener(MouseEvent.CLICK, onRefresh);
			mainStage.categoryBtn.addEventListener(MouseEvent.CLICK, showCategory);
			
			//mainStage.navigationMc.aquariumMc.buttonMode = true;
			//mainStage.navigationMc.lakeMc.buttonMode = true;
			mainStage.introMc.visible = false;
			mainStage.instructions_mc.visible = false;
			mainStage.categoryMC.visible = false;
		}
		
		private function showHidelakeElements(val:Boolean):void
		{
			mainStage.eggContainerMc.visible = val;
			mainStage.instructionsMc.visible = val;
			mainStage.egg_1.visible = val;
			mainStage.egg_2.visible = val;
			mainStage.egg_3.visible = val;
			mainStage.navigationMc.visible = val;
		}
		
		private function onRefresh(e:MouseEvent):void
		{
			trace("refresh...")
		}
		
		private function showCategory(e:MouseEvent):void
		{
			mainStage.categoryMC.visible = true;
			Utils.animateMC(mainStage.categoryMC);
		}
		
		private function onLaunch(evt:MouseEvent):void
		{
			mainStage.introMc.visible = false;
			showHidelakeElements(true);
			prepareLakeView();
		}
		
		private function enableLakeView():void
		{
			mainStage.navigationMc.lakeMc.lakeTxt.textColor = 0xFF0000;
			mainStage.navigationMc.aquariumMc.aquaTxt.textColor = 0x332200;
			
			mainStage.navigationMc.lakeMc.lakeBG.alpha = 1;
			mainStage.navigationMc.lakeMc.enabled = false;
			
			mainStage.navigationMc.aquariumMc.aquaBG.alpha = 0.35;
			mainStage.navigationMc.aquariumMc.enabled = true;
		}
		
		private function enableAquaView():void
		{
			mainStage.navigationMc.lakeMc.lakeTxt.textColor = 0x332200;
			mainStage.navigationMc.aquariumMc.aquaTxt.textColor = 0xFF0000;
			
			mainStage.navigationMc.lakeMc.lakeBG.alpha = 0.35;
			mainStage.navigationMc.lakeMc.enabled = true;
			
			mainStage.navigationMc.aquariumMc.aquaBG.alpha = 1;
			mainStage.navigationMc.aquariumMc.enabled = false;
		}
		
		private function prepareLakeView():void
		{
			lake = new LakeView(mainStage);
			addChild(lake);
			
			enableLakeView();
			mainStage.swapChildren(navigationMc, lake);
			currentView = "lakeMc";
		}
		
		private function prepareAquariumView():void
		{
			aqua = new AquariumView(mainStage);
			addChild(aqua);
			
			enableAquaView();
			mainStage.swapChildren(navigationMc, aqua);
			currentView = "aquariumMc";
		}
		
		private function onInstruction(evt:MouseEvent):void
		{
			mainStage.instructions_mc.visible = true;
			lake.visible = false;
			mainStage.swapChildren(navigationMc, instructions_mc);
		}
		
		private function onCloseMe(evt:MouseEvent):void
		{
			mainStage.instructions_mc.visible = false;
			lake.visible = true;
		}
		
		private function viewLoad(evt:MouseEvent):void
		{
			if(evt.target.parent.name == currentView)
			{
				trace("View already open. Click another view.")
			}
			else
			{
				if(currentView == "lakeMc")
				{
					//Utils.removeChildFromStage(lake);
					lake.visible = false;
					mainStage.instructions_mc.visible = false;
					prepareAquariumView();
				}
				else if(currentView == "aquariumMc")
				{
					Utils.removeChildFromStage(aqua);
					lake.visible = true;
					enableLakeView();
					mainStage.swapChildren(navigationMc, lake);
					mainStage.swapChildren(lake, instructions_mc);
					mainStage.swapChildren(navigationMc, instructions_mc);
					currentView = "lakeMc";
				}
			}
		}

	}
	
}
