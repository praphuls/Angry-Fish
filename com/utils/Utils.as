package com.utils {
	import com.aquariumView.HappyFishPopup;
	import com.aquariumView.Solution;
	import com.events.AddPopUp;
	import com.lakeview.Comments;
	import com.lakeview.MyOwnBox;
	import com.lakeview.OthersBox;
	import com.model.AppModel;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	import flash.display.MovieClip;
	import com.lakeview.LakeView;
	import com.model.FishSolvedModel;
	import fl.transitions.*;
	import fl.transitions.easing.Regular;
	import com.lakeview.FishPopUp;
	import flash.text.StyleSheet;
	
	public class Utils extends MovieClip {
		
		public static var fishScaleX:Number = 1;
		public static var fishScaleY:Number = 1;
		public static var associateCount:Number = 5;
		private static var model:AppModel = AppModel.getInstance();
		
		public function Utils() 
		{
		}
		
		public static function addMovieFromLibrary(mcIName:String, mc:MovieClip):MovieClip
		{
			var tMC:Class = getDefinitionByName(mcIName) as Class;
			var newMc:MovieClip = new tMC() as MovieClip;
			mc.addChild(newMc);
				
			return newMc;
		}
		
		public static function removePopUpsFromLake(mcToRemove:MovieClip, parentMc:MovieClip):void
		{
			if(mcToRemove)
			{
				parentMc.removeChild(mcToRemove);
				mcToRemove = null;
				
				if(FishSolvedModel.getInstance().catMcToBeRemoved)
					FishSolvedModel.getInstance().catMcToBeRemoved = null;
			}
		}
		
		
		public static function removeChildFromStage(nameOfContainer:MovieClip):void
		{
			while(nameOfContainer.numChildren > 0)
       			nameOfContainer.removeChildAt(0);
		}
		
		public static function incrementAssociateCount():Number
		{
			return associateCount++;
		}
		
		private static var targetMc:MovieClip;
		private static var parentTargetMc:MovieClip;
		public static function animateMC(mc:MovieClip, parentMC:MovieClip=null):void
		{
			targetMc = mc;
			var mWidth:Number;
			var mHeight:Number;
			
			if (parentMC != null)
				parentTargetMc = parentMC;
			
			if (targetMc.valueOf() is Comments || 
				targetMc.valueOf() is MyOwnBox || 
				targetMc.valueOf() is OthersBox || 
				targetMc.valueOf() is HappyFishPopup || 
				targetMc.valueOf() is com.aquariumView.Comments ||
				targetMc.valueOf() is Solution)
			{
				mWidth = 191.35
				mHeight = 257
			}
			else 
			{
				mWidth = mc.width;
				mHeight = mc.height;
			}
			
			
			var myTweenScaleX:Tween = new Tween(mc, "width", Regular.easeOut, 0, mWidth, 0.25, true);
			var myTweenScaleY:Tween = new Tween(mc, "height", Regular.easeOut, 0, mHeight, 0.25, true);
			
			myTweenScaleX.addEventListener(TweenEvent.MOTION_FINISH, onTweenComplete);
		}
		
		private static function onTweenComplete(e:Event):void
		{	
			if (targetMc.valueOf() is FishPopUp)
				checkPosition(targetMc, parentTargetMc);
				
			if (targetMc.valueOf() is MyOwnBox || targetMc.valueOf() is OthersBox || targetMc.valueOf() is Comments)
				parentTargetMc.dispatchEvent(new AddPopUp(AddPopUp.ALIGN_POPUP, targetMc));
			
		}
		
		public static function moveToTop( clip:DisplayObject ):void
		{
			clip.parent.setChildIndex(clip, clip.parent.numChildren - 1);
		}
		
		public static function createProblemDecStr(str:String): String
		{
			var theContent:String = str;
			theContent = theContent.split(" ").join("+");

			return(theContent);
		}
		
		public static function createKeywordStr(str:String): String
		{
			if (str != null)
			{
				var theContent:String = str;
				theContent = theContent.split(", ").join("+");
			}

			return(theContent);
		}
		
		public static function getCategoryID(str:String):String
		{
			var theContent:String;
			
			for (var i:Number = 0; i < model.categoriesArray.length; i++ )
			{
				if (model.categoriesArray[i].categoryName == str)
					theContent = model.categoriesArray[i].categoryID;
				else if (str == "ALL")
					theContent = "0";
			}
			
			return theContent;
		}
		
		public static function getTodaysDate():String
		{
			var myDate:Date = new Date();
			var dateOfBirth:String;
			var date:String;
			var month:String;
			var year:String;
			
			if(myDate.getDate() < 10)
				date = "0" + myDate.getDate();
			else
				date = myDate.getDate().toString();
				
			if(myDate.getMonth() < 10)
				month = "0" + (myDate.getMonth() + 1);
			else
				month = (myDate.getMonth() + 1).toString();
				
			year = myDate.getFullYear().toString();
				
			dateOfBirth = date + "/" + month + "/" + year;
			
			return dateOfBirth;
		}
		
		private static var popUpMc:MovieClip;
		public static function addNoFishPopUp(mc:MovieClip, mcName:String):void
		{
			if (model.noFishPopUp)
				return;
				
			popUpMc = mc;
			
			var _noFishPopUp:MovieClip = Utils.addMovieFromLibrary(mcName, mc);
			Utils.moveToTop(_noFishPopUp);
			
			_noFishPopUp.closeMe.addEventListener(MouseEvent.CLICK, onPopupClose);
			
			model.noFishPopUp = _noFishPopUp;
			
			_noFishPopUp.x = 482;
			_noFishPopUp.y = 300;
			
		}
		
		public static function removeNoFishPopUp(mc:MovieClip):void
		{
			if (model.noFishPopUp)
			{
				mc.removeChild(model.noFishPopUp);
				model.noFishPopUp = null;
			}
		}
		
		private static function onPopupClose(e:MouseEvent):void
		{
			removeNoFishPopUp(popUpMc);
		}
		
		public static function disableButton(btn:*):void
		{
			btn.enabled = false;
		}
		
		public static function enableButton(btn:*):void
		{
			btn.enabled = true;
		}
		
		public static function checkPosition(mc:MovieClip, targetFish:MovieClip):void
		{
			mc.x = targetFish.x;
			mc.y = targetFish.y;
			
			if((mc.x + (mc.width) > 900))
			{
				mc.x = 950 - mc.width;
				targetFish.x = mc.x - mc.width;
			}
			
			if((mc.x - (mc.width) < 0))
			{
				mc.x = 5;
				targetFish.x = mc.x + mc.width;
			}
		}
		
		public static function setStylesToLinks():StyleSheet
		{
			var style:StyleSheet = new StyleSheet();
			
			var hover:Object = new Object();
			hover.color = "#00FF00";
			
			var link:Object = new Object();
			link.color = "#FFFFFF";
			
			var active:Object = new Object();
			active.color = "#FF0000";

			style.setStyle("a:link", link);
			style.setStyle("a:hover", hover);
			style.setStyle("a:active", active);
			
			return style;
		}
	}
	
}
